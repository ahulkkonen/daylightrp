/*
	Description: 	Refuel can
	Author:			qbt
*/

_vehVehicle = cursorTarget;

if ((_vehVehicle isKindOf "AllVehicles") && !(_vehVehicle isKindOf "Man")) then {
	daylight_bActionBusy = true;

	_arrVehicleInitialPos = getPosATL _vehVehicle;

	sleep 0.5;

	[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

	// Localize
	[format ["Refueling %1..", getText(configFile >> "CfgVehicles" >> typeOf _vehVehicle >> "displayName")], 1] call daylight_fnc_progressBarCreate;

	playSound "69245_dobroide_200903_pouring_01_local";
	[player, 36, false] call daylight_fnc_networkSay3D;

	_iInitialMoveTime = daylight_iLastMoveTime;

	_bMoved = false;

	_iLoops = 0;
	for "_i" from 0 to 150 do {
		if ((vehicle player) != player) exitWith {
			_bMoved = true;
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

		if (daylight_iStunValue > 0) exitWith {
			_bMoved = true
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
		[format ["You successfully refueled %1..", getText(configFile >> "CfgVehicles" >> typeOf _vehVehicle >> "displayName")], 1] call daylight_fnc_showActionMsg;

		_vehVehicle setFuel ((fuel _vehVehicle) + 0.33);

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