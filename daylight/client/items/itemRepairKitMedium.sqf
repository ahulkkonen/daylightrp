/*
	Description: 	Repair kit (medium)
	Author:			qbt
*/

_vehVehicle = cursorTarget;

_arrTrucks = [
	"C_Van_01_transport_F",
	"C_Van_01_fuel_F",
	"C_Van_01_box_F",
	"C_Van_01_fuel_F",
	"I_G_Van_01_fuel_F",
	"I_G_Van_01_transport_F",
	"B_G_Van_01_transport_F",
	"O_G_Van_01_transport_F",
	"B_G_Van_01_fuel_F",
	"O_G_Van_01_fuel_F"
];

if ((_vehVehicle isKindOf "AllVehicles") && !(_vehVehicle isKindOf "Air") && !(_vehVehicle in _arrTrucks) && !(_vehVehicle isKindOf "Man")) then {
	daylight_bActionBusy = true;

	_arrVehicleInitialPos = getPosATL _vehVehicle;

	sleep 0.5;

	[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

	// Localize
	[format ["Repairing %1..", getText(configFile >> "CfgVehicles" >> typeOf _vehVehicle >> "displayName")], 1] call daylight_fnc_progressBarCreate;

	_iInitialMoveTime = daylight_iLastMoveTime;

	_bMoved = false;

	_iLoops = 0;
	for "_i" from 0 to 150 do {
		if ((vehicle player) != player) exitWith {
			_bMoved = true;
		};

		if (daylight_iStunValue > 0) exitWith {
			_bMoved = true
		};
	
		if ((count (crew _vehVehicle)) != 0) exitWith {
			_bMoved = true;

		};

		if ((_arrVehicleInitialPos distance (getPosATL _vehVehicle)) > 2.5) exitWith {
			_bMoved = true;
		};

		if (!alive player) exitWith {
			_bMoved = true;
		};

		if (_iInitialMoveTime == daylight_iLastMoveTime) then {
			[_i / 150, 0.1] call daylight_fnc_progressBarSetProgress;

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
		[format ["You successfully repaired %1..", getText(configFile >> "CfgVehicles" >> typeOf _vehVehicle >> "displayName")], 1] call daylight_fnc_showActionMsg;

		_vehVehicle setDamage 0;

		[(_this select 0), 1] call daylight_fnc_invRemoveItem;
	} else {
		"Action cancelled.." call daylight_fnc_progressBarSetText;
	};

	1 call daylight_fnc_progressBarClose;

	[player, ""] call daylight_fnc_networkSwitchMove;

	daylight_bActionBusy = false;
} else {
	[((_this select 0) call daylight_fnc_invIDToStr) select 0, localize "STR_ITEM_VEHICLE_ERROR", true] call daylight_fnc_showHint;
};