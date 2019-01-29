/*	
	Description: 	Jail, wanted and bounty functions
	Author:			qbt
*/

/*
	Description:	Handle bounty
	Args:			arr [veh player, i bounty modifier]
	Return:			nothing
*/
daylight_fnc_jailHandleBounty = {
	_strVariable = format["iBounty%1", (_this select 0) call daylight_fnc_returnSideStringForSavedVariables];

	_iCurrentBounty = [(_this select 0), _strVariable, 0] call daylight_fnc_loadVar;
	_iNewBounty = _iCurrentBounty + (_this select 1);

	// Make sure value is correct
	if (_iNewBounty < 0) then {
		_iNewBounty = 0;
	} else {
		if (_iNewBounty > daylight_cfg_iMaxIntValue) then {
			_iNewBounty = daylight_cfg_iMaxIntValue;
		};
	};

	// Save new value
	[(_this select 0), _strVariable, _iNewBounty] call daylight_fnc_saveVar;
};

/*
	Description:	Return is wanted
	Args:			veh player
	Return:			nothing
*/
daylight_fnc_jailPlayerIsWanted = {
	_bReturn = false;

	_arrWanted = [_this, format["arrWanted%1", _this call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

	if (count _arrWanted > 0) then {
		_bReturn = true;
	};

	_bReturn
};

/*
	Description:	Jail player local
	Args:			arr [veh jailer, i time]
	Return:			nothing
*/
daylight_fnc_jailJailPlayerLocal = {
	_iJailTimePolice = (_this select 1) * 60;

	// Calculate jail time from bounty, if its bigger than time cop gave we use time from bounty
	_iBounty = [player, format["iBounty%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
	_iJailTimeFromBounty = floor(_iBounty * daylight_cfg_iOneBountyInSeconds);

	_iJailTime = _iJailTimePolice;
	if (_iJailTimePolice < _iJailTimeFromBounty) then {
		_iJailTime = _iJailTimeFromBounty;
	};

	// Check if jail time more than max, if it is reset it to max
	if (_iJailTime > (daylight_cfg_iMaxJailTime * 60)) then {
		_iJailTime = daylight_cfg_iMaxJailTime * 60;
	};

	[(_this select 0), _iJailTime] spawn daylight_fnc_jailJailedMonitor;
	[] spawn daylight_fnc_jailBountyMonitor;
};

/*
	Description:	Jail player
	Args:			arr [veh to jail, i time]
	Return:			nothing
*/
daylight_fnc_jailJailPlayer = {
	daylight_iLastJailPlayerTime = time;

	[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_JAIL_MESSAGE_JAILPLAYER", name (_this select 0), _this select 1], true] call daylight_fnc_showHint;

	_iBounty = [(_this select 0), format["iBounty%1", (_this select 0) call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
	_iBounty call daylight_fnc_jailShareMoneyBLUFOR;

	_this call daylight_fnc_networkJailPlayer;
};

/*
	Description:	Jailed monitor
	Args:			[veh jailer, i jailtime]
	Return:			nothing
*/
daylight_fnc_jailJailedMonitor = {
	player allowDamage false;

	if (!daylight_bJailed) then {
		_vehJailer = (_this select 0);
		_iJailTime = (_this select 1);

		daylight_bJailed = true;
		[player, format["iJailTime%1", player call daylight_fnc_returnSideStringForSavedVariables], _iJailTime] call daylight_fnc_saveVar;
		[player, [0, 0, 1]] call daylight_fnc_handlePlayerState;
		daylight_bSurrendered = false;
		daylight_bRestrained = false;

		daylight_iStunValue = 0;
		
		daylight_strHolsteredWeapon = "";
		daylight_strHolsterMagazine = "";
		daylight_iHolsterMagazineAmmo = 0;

		player switchMove "";
		[player, ""] call daylight_fnc_networkSwitchMove;

		// Teleport to jail
		player setDir daylight_cfg_iJailDir;
		player setPosATL daylight_cfg_arrJailPosition;

		_bLoop = true;
		_bEscaped = false;
		_iLoops = 0;

		//_strJailerICName = ([_vehJailer, format["arrCharacterData%1", _vehJailer call daylight_fnc_returnSideStringForSavedVariables], ["", ""]] call daylight_fnc_loadVar) select 0;
		_strJailerName = name(_vehJailer);

		while {_bLoop} do {
			if (_iLoops != 0) then {
				_iJailTime = _iJailTime - 1;
			};

			// Update jailtime global variable for player every 60s
			if ((_iLoops != 0) && ((_iLoops % 60) == 0)) then {
				[player, format["iJailTime%1", player call daylight_fnc_returnSideStringForSavedVariables], _iJailTime] call daylight_fnc_saveVar;
			};

			// Show hint
			_arrTimeLeftInMinutesAndSeconds = _iJailTime call daylight_fnc_secondsToMinutesAndSeconds;

			// Show only if still jailed (we dont want this to overwrite the "released"-hint)
			if (((player getVariable "daylight_arrState") select 2) != 0) then {
				if (!(isNull _vehJailer)) then {
					[localize "STR_JAIL_MESSAGE_TITLE", format[localize "STR_JAIL_MESSAGE_JAILED", _strJailerName, _arrTimeLeftInMinutesAndSeconds select 0, _arrTimeLeftInMinutesAndSeconds select 1], false] call daylight_fnc_showHint;
				} else {
					[localize "STR_JAIL_MESSAGE_TITLE", format[localize "STR_JAIL_MESSAGE_JAILED_ALT", _arrTimeLeftInMinutesAndSeconds select 0, _arrTimeLeftInMinutesAndSeconds select 1], false] call daylight_fnc_showHint;
				};
			};

			// If bounty == 0 OR state not jailed, break loop
			if ((_iJailTime == 1) || (((player getVariable "daylight_arrState") select 2) == 0)) then {
				_bLoop = false;
			};

			// Check player distance from jail center, if too far teleport back
			if ((vehicle player) isKindOf "Air") then {
				if ((player distance daylight_cfg_arrJailPosition) > daylight_cfg_iJailRadius) then {
					// Jail escape
					_bLoop = false;
					_bEscaped = true;
				};
			} else {
				if ((player distance daylight_cfg_arrJailPosition) > daylight_cfg_iJailRadius) then {
					player setDir daylight_cfg_iJailDir;
					player setPosATL daylight_cfg_arrJailPosition;
				};
			};

			_iLoops = _iLoops + 1;

			sleep 1;
		};

		daylight_bJailed = false;

		player allowDamage true;

		if (_bEscaped) then {
			// Escaped from jail
			[localize "STR_JAIL_MESSAGE_TITLE", localize "STR_JAIL_MESSAGE_ESCAPED", true] call daylight_fnc_showHint;
			format["%1 has escaped from jail!", name player] call daylight_fnc_networkChatNotification;

			[player, "Escaping from jail", daylight_cfg_iJailEscapeBounty] call daylight_fnc_jailSetWanted;
		} else {
			[player, format["iJailTime%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_saveVar;

			// Teleport to release position
			player setDir daylight_cfg_iJailReleaseDir;
			player setPosATL daylight_cfg_arrJailReleasePosition;

			// Release from jail
			[localize "STR_JAIL_MESSAGE_TITLE", localize "STR_JAIL_MESSAGE_RELEASED", true] call daylight_fnc_showHint;
		};
	};

	if (true) exitWith {};
};

/*
	Description:	Jail bounty monitor
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_jailBountyMonitor = {
	while {daylight_bJailed} do {
		sleep 60;

		// Minus from total bounty
		[player, -(daylight_cfg_iBountyMinusPerMinute)] call daylight_fnc_jailHandleBounty;
	};

	// Reset bounty after released from jail
	[player, format["iBounty%1", (_this select 0) call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_saveVar;

	if (true) exitWith {};
};

/*
	Description:	Set wanted
	Args:			arr [veh to set wanted, str reason, i bounty]
	Return:			nothing
*/
daylight_fnc_jailSetWanted = {
	_strVariable = format["arrWanted%1", (_this select 0) call daylight_fnc_returnSideStringForSavedVariables];

	_arrWanted = [(_this select 0), _strVariable, []] call daylight_fnc_loadVar;

	_arrWanted set [count _arrWanted, [(_this select 1), (_this select 2)]];

	// Update variable
	[(_this select 0), _strVariable, _arrWanted] call daylight_fnc_saveVar;

	// Update bounty
	if ((_this select 2) > 0) then {
		[(_this select 0), (_this select 2)] call daylight_fnc_jailHandleBounty;
	};
};

/*
	Description:	Set unwanted
	Args:			arr [veh to set unwanted, i index]
	Return:			nothing
*/
daylight_fnc_jailSetUnwanted = {
	_strVariable = format["arrWanted%1", (_this select 0) call daylight_fnc_returnSideStringForSavedVariables];

	_arrWanted = [(_this select 0), _strVariable, []] call daylight_fnc_loadVar;

	// Update bounty
	if (((_arrWanted select (_this select 1)) select 2) > 0) then {
		[(_this select 0), (_arrWanted select (_this select 1)) select 2] call daylight_fnc_jailHandleBounty;
	};

	_arrWanted set [(_this select 1), -1];

	_arrWanted = _arrWanted - [-1];

	// Update variable
	[(_this select 0), _strVariable, _arrWanted] call daylight_fnc_saveVar;
};

/*
	Description:	Share bounty / ticket money
	Args:			i amount
	Return:			nothing
*/
daylight_fnc_jailShareMoneyBLUFOR = {
	{
		if ((side _x) == blufor) then {
			// Get current money amount
			_iMoneyBank = [_x, format["iMoneyBank%1", _x call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;

			_iAmountToSave = _iMoneyBank + ((_this) / ({side _x == blufor} count playableUnits));

			// Save bank variable
			[_x, format["iMoneyBank%1", _x call daylight_fnc_returnSideStringForSavedVariables], _iAmountToSave] call daylight_fnc_saveVar;
		};
	} forEach playableUnits;
};

/*
	Description:	Open WantUnwantRelease-dialog
	Args:			nothing
	Return:			nothing
*/
/*daylight_fnc_jailWantUnwantReleaseOpenUI = {
	//if (playerSide == blufor) then {
		createDialog "WantUnwantRelease";

		ctrlEnable [1700, false];
		ctrlEnable [1701, false];
		ctrlEnable [1702, false];

		ctrlEnable [1401, false];

		// If there are no civilians, dont add anything to the list
		if (({(side _x) == civilian} count playableUnits) != 0) then {
			// Populate player list
			for "_i" from 0 to (count(playableUnits) - 1) do {
				_vehTarget = playableUnits select _i;

				if ((side _vehTarget) == civilian) then {
					lbAdd [2100, name(_vehTarget)];
					lbSetData [2100, _i, str _i];
				};
			};

			while {(lbCurSel 2100) == -1} do {
				lbSetCurSel [2100, 0];
			};
		};
	//};
};*/

/*
	Description:	Update WantUnwantRelease-dialog
	Args:			int lbCurSel
	Return:			nothing
*/
/*daylight_fnc_jailWantUnwantUpdateOpenUI = {
	daylight_vehWantUnwantReleaseCurrentTarget = playableUnits select (abs parseNumber(lbData [2100, lbCurSel 2100]));

	// Enable buttons
	ctrlEnable [1700, true];
	ctrlEnable [1701, true];

	// Check if player is even jailed
	if (((daylight_vehWantUnwantReleaseCurrentTarget getVariable "daylight_arrState") select 0) == 1) then {
		ctrlEnable [1702, true];

		ctrlEnable [1401, true];
	};

	// Get wanted history
	_arrWanted = [daylight_vehWantUnwantReleaseCurrentTarget, format["arrWanted%1", daylight_vehWantUnwantReleaseCurrentTarget call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

	// Add wanted history
	lbClear 2101;

	if ((count _arrWanted) != 0) then {
		for "_i" from 0 to ((count _arrWanted) - 1) do {
			lbAdd [2101, format["%1 (%2%3)", (_arrWanted select _i) select 0, (_arrWanted select _i) select 1, localize "STR_CURRENCY"]];
			lbSetData [2101, _i, str _i];
		};

		while {lbCurSel 2101 == -1} do {
			lbSetCurSel [2101, 0];
		};
	} else {
		ctrlEnable [1701, false];
	};
};*/