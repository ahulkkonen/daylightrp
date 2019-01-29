/*
	Description: 	Repair end mission location
	Author:			qbt
*/

daylight_bActionBusy = true;

sleep 0.5;

[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

_strNearestMarker = [player, daylight_cfg_arrEndMissionLocationsMarkers] call daylight_fnc_getNearestMarker;

_strName = (daylight_cfg_arrEndMissionLocations select (daylight_cfg_arrEndMissionLocationsMarkers find _strNearestMarker)) select 0;

// Localize
[format["Repairing %1..", _strName], 1] call daylight_fnc_progressBarCreate;

_iInitialMoveTime = daylight_iLastMoveTime;

_bMoved = false;

_iLoops = 0;
for "_i" from 0 to 600 do {
	if ((vehicle player) != player) exitWith {
		_bMoved = true;
	};

	if (!alive player) exitWith {
		_bMoved = true;
	};

	if (daylight_iStunValue > 0) exitWith {
		_bMoved = true
	};

	if (_iInitialMoveTime == daylight_iLastMoveTime) then {
		[_i / 600, 0.1] call daylight_fnc_progressBarSetProgress;

		if (_iLoops % 65 == 0) then {
			[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;
		};

		sleep 0.1;
	} else {
		_bMoved = true;

		if (true) exitWith {};
	};

	_iLoops = _iLoops + 1;
};

if (!_bMoved) then {
	[format["You repaired %1..", _strName], 1] call daylight_fnc_showActionMsg;

	_arrNearSmokes = nearestObjects [getMarkerPos _strNearestMarker, ["test_EmptyObjectForSmoke"], 25];

	{
		_x setPosATL [0, 0, 0];

		sleep 0.25;

		deleteVehicle _x;
	} forEach _arrNearSmokes;
} else {
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

1 call daylight_fnc_progressBarClose;

[player, ""] call daylight_fnc_networkSwitchMove;

daylight_bActionBusy = false;

if (true) exitWith {};