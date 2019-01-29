/*
	Description: 	Lockpick
	Author:			qbt
*/

_vehVehicle = cursorTarget;

if (!(_vehVehicle isKindOf "AllVehicles") || (_vehVehicle isKindOf "Man")) exitWith {
	if (daylight_vehBankVault == _vehVehicle) then {
		cursorTarget execVM "daylight\client\items\itemLockpickBank.sqf";
	} else {
		[localize "STR_LOCKPICK_TITLE", localize "STR_LOCKPICK_ERROR", true] call daylight_fnc_showHint;
	};
};

daylight_bActionBusy = true;

_arrVehicleInitialPos = getPosATL _vehVehicle;

sleep 0.5;

[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

// Localize
[format ["Picking the lock of %1..", getText(configFile >> "CfgVehicles" >> typeOf _vehVehicle >> "displayName")], 1] call daylight_fnc_progressBarCreate;

_iInitialMoveTime = daylight_iLastMoveTime;
_iRiskOfFailure = 0.05;

_bMoved = false;
_bBroke = false;
_iLoops = 0;
for "_i" from 0 to 450 do {
	/*if ((animationState player) != "amovpknlmstpsnonwnondnon") then {
		_bMoved = true;

		if (true) exitWith {};
	};*/

	if ((vehicle player) != player) exitWith {
		_bMoved = true;
	};

	if ((count (crew _vehVehicle)) != 0) exitWith {
		_bMoved = true;
	};

	if (daylight_iStunValue > 0) exitWith {
		_bMoved = true
	};
	
	if ((_arrVehicleInitialPos distance (getPosATL _vehVehicle)) > 2.5) exitWith {
		_bMoved = true;
	};

	if (!alive player) exitWith {
		_bMoved = true;
	};

	if (_iInitialMoveTime == daylight_iLastMoveTime) then {
		[_i / 450, 0.1] call daylight_fnc_progressBarSetProgress;

		if (_iLoops % 65 == 0) then {
			[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

			_iRandom = random 1;

			if (_iRandom <= _iRiskOfFailure) exitWith {
				[format ["You failed to pick the lock of %1..", getText(configFile >> "CfgVehicles" >> typeOf _vehVehicle >> "displayName")]] call daylight_fnc_progressBarSetText;

				_bMoved = true;
				_bBroke = true;
			};
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

if (!_bMoved) then {
	[_vehVehicle, 12, false] call daylight_fnc_networkSay3D;

	[_vehVehicle, 0] call daylight_fnc_networkLockVehicle;

	[format ["You picked the lock of %1..", getText(configFile >> "CfgVehicles" >> typeOf _vehVehicle >> "displayName")], 1] call daylight_fnc_showActionMsg;

	[player, "Vehicle theft", daylight_cfg_iLockpickBounty] call daylight_fnc_jailSetWanted;

	for "_i" from 0 to 2 do {
		[_vehVehicle, 33, true] call daylight_fnc_networkSay3D;

		sleep 10.75;
	};
} else {
	if (!_bBroke) then {
		// You moved text
		"Action cancelled.." call daylight_fnc_progressBarSetText;
	} else {
		[(_this select 0), 1] call daylight_fnc_invRemoveItem;

		[player, "Vehicle theft", daylight_cfg_iLockpickBounty] call daylight_fnc_jailSetWanted;
	};
};

daylight_bActionBusy = false;