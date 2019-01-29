/*
	Description: 	Capture government building
	Author:			qbt
*/

daylight_bActionBusy = true;

sleep 0.5;

[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;


// Localize
["Capturing government building..", 1] call daylight_fnc_progressBarCreate;

_iInitialMoveTime = daylight_iLastMoveTime;

_bMoved = false;

_iLoops = 0;
for "_i" from 0 to (daylight_cfg_iEndMissionGovBuildingHoldTime * 10) do {
	if ((vehicle player) != player) exitWith {
		_bMoved = true;
	};

	if (!alive player) exitWith {
		_bMoved = true;
	};

	if (daylight_iStunValue > 0) exitWith {
		_bMoved = true
	};

	if (!daylight_bGovBuildingCaptureable) then {
		_bMoved = true;
	};

	if (_iInitialMoveTime == daylight_iLastMoveTime) then {
		[_i / (daylight_cfg_iEndMissionGovBuildingHoldTime * 10), 0.1] call daylight_fnc_progressBarSetProgress;

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
	["You captured the government building..", 1] call daylight_fnc_showActionMsg;

	daylight_bEndMissionComplete = true;
	publicVariable "daylight_bEndMissionComplete";
} else {
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

1 call daylight_fnc_progressBarClose;

[player, ""] call daylight_fnc_networkSwitchMove;

daylight_bActionBusy = false;

if (true) exitWith {};