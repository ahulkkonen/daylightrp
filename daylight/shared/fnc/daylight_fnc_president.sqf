/*
	Description:	president functions
	Author:			qbt
*/

if ((isNil "daylight_arrCustomLaws") && (isNil "daylight_arrPresidentInfo") && (isNil "daylight_iPresidentTax")) then {
	daylight_arrCustomLaws = ["", "", "", ""];
	daylight_arrPresidentInfo = ["", ""];

	daylight_iPresidentTax = 0;
};

daylight_bPresidentVoted = false;
daylight_iPresidentRulingTimeStarted = -999999;

daylight_fnc_presidentLoopServer = {
	daylight_arrVotes = [];

	_bNotify = true;

	while {true} do {
		if (_bNotify) then {
			format["Voting for new president has started. New president will be elected in %1 minutes.", (daylight_cfg_iPresidentVotingTime call daylight_fnc_secondsToMinutesAndSeconds) select 0] call daylight_fnc_networkChatNotification;

			daylight_iPresidentRulingTimeStarted = -999999;
			publicVariable "daylight_iPresidentRulingTimeStarted";
		};

		sleep daylight_cfg_iPresidentVotingTime;

		daylight_arrPresidentInfo = ["", ""];
		publicVariable "daylight_arrPresidentInfo";

		if ((count daylight_arrVotes) != 0) then {
			_bNotify = true;

			_iMax = -1;
			_strUIDWinner = "";

			{
				_iCurrentVotes = (_x select 1);

				if (_iCurrentVotes > _iMax) then {
					_iMax = _iCurrentVotes;

					_strUIDWinner = (_x select 0);
				};
			} forEach daylight_arrVotes;

			_vehUnit = _strUIDWinner call daylight_fnc_playerUIDtoPlayerObject;

			if (!(isNull _vehUnit) && ((side _vehUnit) == civilian)) then {
				daylight_arrPresidentInfo = [_strUIDWinner, name _vehUnit];
				publicVariable "daylight_arrPresidentInfo";

				_iTimesNull = 0;
				for "_i" from 0 to (daylight_cfg_iPresidentRulingTime / 5) do {
					_vehPresident = _strUIDWinner call daylight_fnc_playerUIDtoPlayerObject;

					_iJailTimeFromBounty = 0;

					if (!(isNull _vehPresident)) then {
						_iBounty = [player, format["iBounty%1", _vehPresident call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
						
						_iJailTimeFromBounty = floor(_iBounty * daylight_cfg_iOneBountyInSeconds);
					} else {
						_iTimesNull = _iTimesNull + 1;
					};

					// Jailtime too long, vote for new president
					if (_iJailTimeFromBounty > 120) exitWith {};

					// Away for too long, vote for new president
					if (_iTimesNull == 180) exitWith {};

					sleep 5;
				};
			};

			/*daylight_arrPresidentInfo = ["", ""];
			publicVariable "daylight_arrPresidentInfo";*/

			daylight_arrVotes = [];
		} else {
			format ["Not enough votes were given and no president has been elected. New voting time has started and the president will be elected in %1 minutes.", (daylight_cfg_iPresidentVotingTime call daylight_fnc_secondsToMinutesAndSeconds) select 0] call daylight_fnc_networkChatNotification;
			
			daylight_iPresidentRulingTimeStarted = -999999;
			publicVariable "daylight_iPresidentRulingTimeStarted";

			_bNotify = false;
		};
	};
};

daylight_fnc_presidentSpawnVoteUnit = {
	daylight_arrVoteUnits = [];

	_grpMerchants = createGroup civilian;

	{
		_untVoteUnit = _grpMerchants createUnit [(_x select 0) select 0, [0, 0, 0], [], 0, "NONE"];

		_untVoteUnit setVariable ["daylight_arrInitialPos", (_x select 3)];

		_untVoteUnit enableSimulation false;
		_untVoteUnit allowDamage false;

		_untVoteUnit addEventHandler ["HandleDamage", {
			(_this select 0) setVelocity [0, 0, 0];

			_arrPos = (_this select 0) getVariable "daylight_arrInitialPos";

			if (((_this select 0) distance _arrPos) > 5) then {
				(_this select 0) setPosATL ((_this select 0) getVariable "daylight_arrInitialPos");
			};

			(_this select 0) switchMove "";
		}];

		{_untVoteUnit disableAI _x} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		_untVoteUnit setSkill 0;

		removeBackpack _untVoteUnit;

		_untVoteUnit setFace ((_x select 0) select 1);
		_untVoteUnit addHeadgear ((_x select 0) select 2);
		_untVoteUnit addGoggles ((_x select 0) select 3);
		_untVoteUnit addUniform ((_x select 0) select 4);
		_untVoteUnit addVest ((_x select 0) select 5);

		_untVoteUnit switchMove "";

		_untVoteUnit setPosATL (_x select 2);
		_untVoteUnit setDir (_x select 3);

		daylight_arrVoteUnits set [count daylight_arrVoteUnits, _untVoteUnit];
	} forEach daylight_cfg_arrVoteUnits;

	publicVariable "daylight_arrVoteUnits";
};

daylight_fnc_presidentAddVoteOpenUI = {
	if (!dialog && ((side player) == civilian) /*&& ((daylight_arrPresidentInfo select 0) == "")*/) then {
		if (!daylight_bPresidentVoted) then {
			if ((time - daylight_iPresidentRulingTimeStarted) >= daylight_cfg_iPresidentRulingTime) then {
				createDialog "VoteForPlayer";

				_iX = 0;
				{
					if ((side _x) == civilian) then {
						lbAdd [1500, name _x];

						lbSetData [1500, _iX, str (playableUnits find _x)];

						_iX = _iX + 1;
					};
				} forEach playableUnits;

				if (lbSize 1500 == 0) then {
					ctrlEnable [1700, false];

					lbAdd [1500, "No players to show."];
					ctrlEnable [1500, false];
				};

				while {lbCurSel 1500 == -1} do {
					lbSetCurSel [1500, 0];
				};
			} else {
				[localize "STR_PRESIDENTVOTING_TITLE", localize "STR_PRESIDENTVOTING_NOVOTING", true] call daylight_fnc_showHint;
			};
		} else {
			[localize "STR_PRESIDENTVOTING_TITLE", localize "STR_PRESIDENTVOTING_ALREADYVOTED", true] call daylight_fnc_showHint;
		};
	};
};

daylight_fnc_presidentAddVoteClient = {
	closeDialog 0;

	_strUID = getPlayerUID (playableUnits select _this);

	daylight_bPresidentVoted = true;

	_strUID call daylight_fnc_networkVoteForPresident;

	[localize "STR_PRESIDENTVOTING_TITLE", format[localize "STR_PRESIDENTVOTING_VOTED", name (playableUnits select _this)], true] call daylight_fnc_showHint;
};

daylight_fnc_presidentAddVoteServer = {
	_iPosInVotes = [daylight_arrVotes, _this] call daylight_fnc_findVariableInNestedArray;

	if (_iPosInVotes != -1) then {
		daylight_arrVotes set [_iPosInVotes, [_this, ((daylight_arrVotes select _iPosInVotes) select 1) + 1]];
	} else {
		daylight_arrVotes set [count daylight_arrVotes, [_this, 1]];
	};
};

daylight_fnc_presidentMenuOpenUI = {
	if (!dialog) then {
		if ((getPlayerUID player) == (daylight_arrPresidentInfo select 0)) then {
			createDialog "PresidentMenu";

			ctrlSetText [1003, format["General tax: %1%2", round(daylight_iPresidentTax * 100), "%"]];

			ctrlSetText [1400, daylight_arrCustomLaws select 0];
			ctrlSetText [1401, daylight_arrCustomLaws select 1];
			ctrlSetText [1402, daylight_arrCustomLaws select 2];
			ctrlSetText [1403, daylight_arrCustomLaws select 3];

			sliderSetRange [1900, 0, daylight_cfg_iPresidentMaxTaxLevel];
			sliderSetPosition [1900, daylight_iPresidentTax];
		} else {
			[localize "STR_PRESIDENTMENU_TITLE", localize "STR_PRESIDENTMENU_ERROR", true] call daylight_fnc_showHint;
		};
	};
};

daylight_fnc_presidentMenuUpdateUI = {
	ctrlSetText [1003, format["General tax: %1%2", round ((_this select 1) * 100), "%"]];
};

daylight_fnc_presidentUpdateSave = {
	closeDialog 0;

	_arrCustomLaws = [
		_this select 0,
		_this select 1,
		_this select 2,
		_this select 3
	];

	if (!(daylight_arrCustomLaws isEqualTo _arrCustomLaws)) then {
		daylight_arrCustomLaws = _arrCustomLaws;

		publicVariable "daylight_arrCustomLaws";

		systemChat "** Laws have been updated by the president of Altis. Check the new laws in the status menu.";
	};

	_iNewTax = _this select 4;

	if (daylight_iPresidentTax != _iNewTax) then {
		daylight_iPresidentTax = _this select 4;
		publicVariable "daylight_iPresidentTax";

		systemChat format["** General tax level have been updated by the president of Altis to %1%2.", round(daylight_iPresidentTax * 100), "%"];
	};
};

if (isServer) then {
	call daylight_fnc_presidentSpawnVoteUnit;

	[] spawn daylight_fnc_presidentLoopServer;
};