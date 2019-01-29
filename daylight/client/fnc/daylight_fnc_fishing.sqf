/*
	Description:	Fishing functions
	Author:			qbt
*/

daylight_fnc_fishingFish = {
	// Check if we are already fishing
	if (daylight_bFishing) exitWith {};

	_iDepth = (getPosATL player select 2) - (getPosASL player select 2);

	// Check if we are capable of fishing
	if (
		!((vehicle player) isKindOf "Ship")
		||
		(isEngineOn (vehicle player))
		||
		(_iDepth <= 40)
	) exitWith {
		[localize "STR_FISHING_TITLE", localize "STR_FISHING_ERROR", true] call daylight_fnc_showHint;
	};

	// We're fishing
	daylight_bFishing = true;
	daylight_bActionBusy = true;

	// Show tutorial hint
	[localize "STR_FISHING_TITLE", localize "STR_FISHING_TEXT", true] call daylight_fnc_showHint;

	sleep 1;

	// Show casting lure text
	["Casting lure..", 1] call daylight_fnc_showActionMsg;

	sleep 1.5;

	// Check if we are still fishing
	if (daylight_bFishing) then {
		// Play sound
		_iSound = ([26, 27, 28, 29] call BIS_fnc_selectRandom);

		[player, _iSound, false] call daylight_fnc_networkSay3D;
		playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select _iSound));
	};

	sleep 7.5 + (random 5);

	while {daylight_bFishing && ((vehicle player) isKindOf "Ship") && !(isEngineOn (vehicle player))} do {
		// Show tutorial
		[localize "STR_FISHING_TITLE", localize "STR_FISHING_TEXT", false] call daylight_fnc_showHint;

		// Determine if we got fish
		_iRandom = random 1;

		// Placeholder
		_iProbability = 0.25;

		if (_iRandom <= _iProbability) then {
			// We got fish
			// Play sound
			_iSound = ([30, 31] call BIS_fnc_selectRandom);

			[player, _iSound, false] call daylight_fnc_networkSay3D;
			playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select _iSound));

			// Use fx
			addCamShake [5, 1, 25];
			cutText ["", "WHITE IN", 1];
			["<t color=""#ffcb00"">Fish on!</t>", 0.15] call daylight_fnc_showActionMsg;

			// Check if player responds quickly enough
			_bBreak = false;
			_bGotFish = false;
			_iStartTime = time;

			while {!_bBreak} do {
				if ((time - _iStartTime) > daylight_iFishingResponseTime) then {_bBreak = true};

				if ((time - daylight_iLastMouse1InputTime) <= daylight_iFishingResponseTime) then {
					_bGotFish = true;
					_bBreak = true;
				};

				sleep 0.1;
			};

			if (_bGotFish) then {
				// Is illegal or not?
				_arrArray = [];

				if (_this) then {
					_arrArray = daylight_cfg_arrFishLegal;
				} else {
					_arrArray = daylight_cfg_arrFishIllegal;
				};

				_iRandom = random ((count _arrArray) - 1);
				_iRandom = round _iRandom;

				_iFishID = (_arrArray select _iRandom);
				_strFish = (_iFishID call daylight_fnc_invIDToStr) select 0;

				[format["<t color=""#00cb00"">You've got 1x %1!</t>", _strFish]] call daylight_fnc_showActionMsg;

				[_iFishID, 1] call daylight_fnc_invAddItemWithWeight;
			} else {
				["<t color=""#cb0000"">The fish managed to escape!</t>"] call daylight_fnc_showActionMsg;
			};

			if (!((vehicle player) isKindOf "Ship") || (isEngineOn (vehicle player))) exitWith {
				[localize "STR_FISHING_TITLE", localize "STR_FISHING_ERROR", true] call daylight_fnc_showHint;
			};

			sleep 4;

			if (!((vehicle player) isKindOf "Ship") || (isEngineOn (vehicle player))) exitWith {
				[localize "STR_FISHING_TITLE", localize "STR_FISHING_ERROR", true] call daylight_fnc_showHint;
			};

			// Show casting lure text
			if (daylight_bFishing) then {
				["Casting lure..", 1] call daylight_fnc_showActionMsg;
			};

			sleep 1.5;

			if (!((vehicle player) isKindOf "Ship") || (isEngineOn (vehicle player))) exitWith {
				[localize "STR_FISHING_TITLE", localize "STR_FISHING_ERROR", true] call daylight_fnc_showHint;
			};

			// Check if we are still fishing
			if (daylight_bFishing) then {
				// Play sound
				_iSound = ([26, 27, 28, 29] call BIS_fnc_selectRandom);

				[player, _iSound, false] call daylight_fnc_networkSay3D;
				playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select _iSound));
			};

			sleep 2.5 + (random 2.5);
		};

		sleep 1;
	};

	if (!((vehicle player) isKindOf "Ship") || (isEngineOn (vehicle player))) then {
		[localize "STR_FISHING_TITLE", localize "STR_FISHING_ERROR", true] call daylight_fnc_showHint;
	} else {
		hintSilent "";
	};

	daylight_bFishing = false;
	daylight_bActionBusy = false;
};