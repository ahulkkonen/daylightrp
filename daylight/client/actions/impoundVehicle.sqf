/*
	Description: 	Impound vehicle
	Author:			qbt
*/

if (daylight_bActionBusy) exitWith {};

closeDialog 0;

daylight_bActionBusy = true;

_arrVehicleInitialPos = getPosATL (_this select 0);

[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

// Show progress bar
sleep 0.1;

// Localize
[format ["Impounding %1..", getText(configFile >> "CfgVehicles" >> typeOf (_this select 0) >> "displayName")], 1] call daylight_fnc_progressBarCreate;

_iInitialMoveTime = daylight_iLastMoveTime;

_iLoops = 0;

_bMoved = false;
for "_i" from 0 to 200 do {
	/*if ((animationState player) != "amovpknlmstpsnonwnondnon") then {
		_bMoved = true;

		if (true) exitWith {};
	};*/

	if ((vehicle player) != player) exitWith {
		_bMoved = true;
	};

	if ((count (crew (_this select 0))) != 0) exitWith {
		_bMoved = true;
	};

	if ((_arrVehicleInitialPos distance (getPosATL (_this select 0))) > 2.5) exitWith {
		_bMoved = true;
	};

	if (!alive player) exitWith {
		_bMoved = true;
	};

	if (_iInitialMoveTime == daylight_iLastMoveTime) then {
		[_i / 200, 0.1] call daylight_fnc_progressBarSetProgress;

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

1 call daylight_fnc_progressBarClose;

if (!_bMoved) then {
	(_this select 0) call daylight_fnc_impoundImpoundVehicle;
} else {
	// You moved text
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

[player, ""] call daylight_fnc_networkSwitchMove;

daylight_bActionBusy = false;

if (true) exitWith {};