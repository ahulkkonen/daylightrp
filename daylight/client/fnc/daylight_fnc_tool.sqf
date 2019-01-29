/*
	Description:	Use tool
	Author:			qbt
*/

daylight_fnc_toolUseInit = {
	if (!daylight_bActionBusy) then {
		daylight_bUsingTool = false;
		daylight_bActionBusy = true;
		daylight_bUsingToolCantClose = false;

		daylight_strToolName = _this select 0;
		daylight_strToolMarker = _this select 1;
		daylight_iToolItemID = _this select 2;
		daylight_strSound = _this select 3;
		daylight_iSound = _this select 4;

		player forceWalk true;

		// Wait until main display becomes active
		waitUntil {!(isNull (findDisplay 46))};

		// Add UI-EH's
		daylight_iToolEHIDButtonDown = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", "_this call daylight_fnc_toolHandleMouseButtonDown"];

		// Show tutorial hint
		[_strName, format[localize "STR_TOOL_TEXT", toLower _strName], true] call daylight_fnc_showHint;

		_bError = false;
		while {daylight_bActionBusy} do {
			[_strName, format[localize "STR_TOOL_TEXT", toLower _strName], false] call daylight_fnc_showHint;

			if ((player distance (getMarkerPos daylight_strToolMarker)) > daylight_cfg_iMaxToolUseDistance) then {
				_bError = true;

				[_strName, localize "STR_TOOL_ERROR", true] call daylight_fnc_showHint;

				daylight_bActionBusy = false;
			};

			sleep 0.1;
		};

		if (!_bError) then {
			hintSilent "";
		};

		player forceWalk false;

		(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", daylight_iToolEHIDButtonDown];
	};
};

daylight_fnc_toolUse = {
	[format ["Using %1..", toLower daylight_strToolName], 1] call daylight_fnc_progressBarCreate;

	playSound daylight_strSound;
	[player, daylight_iSound, false] call daylight_fnc_networkSay3D;

	[1, 5] call daylight_fnc_progressBarSetProgress;

	[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

	sleep 5;

	daylight_bUsingToolCantClose = false;

	[format["You got 1x %1", (daylight_iToolItemID call daylight_fnc_invIDToStr) select 0], 1] call daylight_fnc_showActionMsg;

	[daylight_iToolItemID, 1] call daylight_fnc_invAddItemWithWeight;

	[player, ""] call daylight_fnc_networkSwitchMove;

	1 call daylight_fnc_progressBarClose;

	sleep 3 + (random 0.5);

	daylight_bUsingTool = false;
};

daylight_fnc_toolHandleMouseButtonDown = {
	switch (_this select 1) do {
		case 0 : {
			if (!daylight_bUsingTool) then {
				daylight_bUsingTool = true;
				daylight_bUsingToolCantClose = true;

				[] spawn daylight_fnc_toolUse;
			};
		};

		case 1 : {
			if (!daylight_bUsingToolCantClose) then {
				daylight_bActionBusy = false;
			};
		};
	};
};