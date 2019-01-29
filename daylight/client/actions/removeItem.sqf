/*
	Description: 	Remove item
	Author:			qbt
*/

daylight_bActionBusy = true;

_vehItem = (_this select 0);
_iBuildTime = _vehItem getVariable ["daylight_iBuildTime", -1];

if (_iBuildTime == -1) exitWith {};

_bMoved = false;

[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

[format ["Removing %1..", getText(configFile >> "CfgVehicles" >> typeOf _vehItem >> "displayName")], 1] call daylight_fnc_progressBarCreate;

if ((time - _iBuildTime) > daylight_cfg_iBuildLockTime) then {
	// Delay
	_bAddItem = false;

	_iLoops = 0;

	_iInitialMoveTime = daylight_iLastMoveTime;

	// Chat notification
	[player, format ["%1 started removing %2.", name player, getText(configFile >> "CfgVehicles" >> typeOf _vehItem >> "displayName")]] call daylight_fnc_networkChatNotificationNear;

	for "_i" from 0 to (daylight_cfg_iBuildRemoveTime * 10) do {
		if ((vehicle player) != player) exitWith {
			_bMoved = true;
		};

		if (!alive player) exitWith {
			_bMoved = true;
		};

		if (_iInitialMoveTime == daylight_iLastMoveTime) then {
			[_i / (daylight_cfg_iBuildRemoveTime * 10), 0.1] call daylight_fnc_progressBarSetProgress;

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

	[player, format ["%1 finished removing %2.", name player, getText(configFile >> "CfgVehicles" >> typeOf _vehItem >> "displayName")]] call daylight_fnc_networkChatNotificationNear;
} else {
	[1, 4] call daylight_fnc_progressBarSetProgress;

	sleep 4;
};

1 call daylight_fnc_progressBarClose;

[player, ""] call daylight_fnc_networkSwitchMove;

if (!_bMoved) then {
	if (!(isNull _vehItem)) then {
		deleteVehicle _vehItem;

		_iID = (typeOf _vehItem) call daylight_fnc_buildItemClassNameToID;

		[_iID, 1] call daylight_fnc_invAddItem;
	};

	[format ["You removed %1", getText(configFile >> "CfgVehicles" >> typeOf _vehItem >> "displayName")], 1] call daylight_fnc_showActionMsg;
} else {
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

daylight_bActionBusy = false;

if (true) exitWith {};