/*
	Description: 	Lockpick
	Author:			qbt
*/

_vehVehicle = _this;

if (daylight_vehBankVault != _vehVehicle) exitWith {
	[localize "STR_LOCKPICK_TITLE", localize "STR_LOCKPICK_ERROR", true] call daylight_fnc_showHint;
};

if (currentWeapon player == "") exitWith {
	[localize "STR_LOCKPICK_TITLE", localize "STR_LOCKPICK_NEEDWEAPON", true] call daylight_fnc_showHint;
};

_iLastRobTime = daylight_vehBankVault getVariable ["daylight_iLastRobTime", -999999];

if ((time - daylight_cfg_iBankRobberyCooldown) < _iLastRobTime) exitWith {
	[localize "STR_LOCKPICK_TITLE", localize "STR_LOCKPICK_BANKRECENTLYROBBED", true] call daylight_fnc_showHint;
};

daylight_bActionBusy = true;

sleep 0.5;

[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

// Localize
["Robbing the bank..", 1] call daylight_fnc_progressBarCreate;

_iInitialMoveTime = daylight_iLastMoveTime;

_bMoved = false;

[90006, 1] call daylight_fnc_invRemoveItem;

_iLoops = 0;
for "_i" from 0 to 3000 do {
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
		[_i / 3000, 0.1] call daylight_fnc_progressBarSetProgress;

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

[player, ""] call daylight_fnc_networkSwitchMove;

if (!_bMoved) then {
	_iMoneyAmount = round (((daylight_cfg_iBankRobberyAmount + (random daylight_cfg_iBankRobberyAmountRandom)) / 100) * 100);

	"The central bank of Altis has been robbed!" call daylight_fnc_networkChatNotification;

	[format["You robbed the central bank of Altis and got %1%2..", _iMoneyAmount, localize "STR_CURRENCY"], 1] call daylight_fnc_showActionMsg;

	daylight_vehBankVault say3D "72757_benboncan_fire_alarm_2";
	[daylight_vehBankVault, 41, false] call daylight_fnc_networkSay3D;

	[player, "Bank robbery", _iMoneyAmount] call daylight_fnc_jailSetWanted;

	[90007, _iMoneyAmount] call daylight_fnc_invAddItemWithWeight;

	daylight_vehBankVault setVariable ["daylight_iLastRobTime", time, true];
} else {
	// You moved text
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

daylight_bActionBusy = false;