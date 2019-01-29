/*
	Description: 	Capture gang area
	Author:			qbt
*/

_strGang = [player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_loadVar;

if (_strGang == "") exitWith {
	// No gang
	[localize "STR_GANGAREA_TITLE", localize "STR_GANGAREA_NOGANG", true] call daylight_fnc_showHint;
};

if (currentWeapon player == "") exitWith {
	// No weapon
	[localize "STR_GANGAREA_TITLE", localize "STR_GANGAREA_NOWEAPON", true] call daylight_fnc_showHint;
};

_vehFlag = _this select 0;

_strGangAreaOwner = _vehFlag getVariable ["daylight_strGangAreaOwner", ""];

if (_strGang == _strGangAreaOwner) exitWith {
	// Already owned
	[localize "STR_GANGAREA_TITLE", localize "STR_GANGAREA_ALREADYCAPTURED", true] call daylight_fnc_showHint;
};

daylight_bActionBusy = true;

sleep 0.5;

[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

if (_strGangAreaOwner == "") then {
	["Capturing gang area..", 1] call daylight_fnc_progressBarCreate;
} else {
	daylight_strOldGang = _strGangAreaOwner;

	["Neutralizing gang area..", 1] call daylight_fnc_progressBarCreate;
};

_iInitialMoveTime = daylight_iLastMoveTime;

_bMoved = false;
_iLoops = 0;
for "_i" from 0 to ((daylight_cfg_iGangCaptureTime) * 10) do {
	if ((vehicle player) != player) exitWith {
		_bMoved = true;
	};

	if (!alive player) exitWith {
		_bMoved = true;
	};

	if (_iInitialMoveTime == daylight_iLastMoveTime) then {
		[_i / ((daylight_cfg_iGangCaptureTime) * 10), 0.1] call daylight_fnc_progressBarSetProgress;

		if (_iLoops % 65 == 0) then {
			[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

			_iRandom = random 1;
		};

		sleep 0.1;
	} else {
		_bMoved = true;

		if (true) exitWith {};
	};

	_iLoops = _iLoops + 1;
};

1 call daylight_fnc_progressBarClose;

[player, ""] call daylight_fnc_networkSwitchMove;

// Determine which gang area
_strMarker = [player, daylight_cfg_arrGangAreas] call daylight_fnc_getNearestMarker;
_iGangAreaNumber = parseNumber ([_strMarker, 12, 13] call BIS_fnc_trimString);

if (!_bMoved) then {
	if (_strGangAreaOwner == "") then {
		[_vehFlag, (daylight_cfg_arrGangFlagTextures select 1)] call daylight_fnc_networkSetFlagTexture;

		_vehFlag setVariable ["daylight_strGangAreaOwner", _strGang, true];

		[_strGang, daylight_strOldGang, _iGangAreaNumber, 1] call daylight_fnc_networkCaptureGangArea;
	} else {
		[_vehFlag, (daylight_cfg_arrGangFlagTextures select 0)] call daylight_fnc_networkSetFlagTexture;

		_vehFlag setVariable ["daylight_strGangAreaOwner", "", true];

		[_strGang, daylight_strOldGang, _iGangAreaNumber, 0] call daylight_fnc_networkCaptureGangArea;
	};
} else {
	// You moved text
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

daylight_bActionBusy = false;