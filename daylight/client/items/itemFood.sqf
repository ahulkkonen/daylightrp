/*
	Description: 	Food
	Author:			qbt
*/

daylight_bActionBusy = true;

// Calculate decrease of hunger
_iDecreaseOfHunger = 0;

switch (_this select 0) do {
	case 20002 : {
		_iDecreaseOfHunger = 0.01;
	};

	case 20003 : {
		_iDecreaseOfHunger = 0.01;
	};

	case 20004 : {
		_iDecreaseOfHunger = 0.01;
	};

	case 20005 : {
		_iDecreaseOfHunger = 0.01;
	};

	case 20006 : {
		_iDecreaseOfHunger = 0.05;
	};

	case 20007 : {
		_iDecreaseOfHunger = 0.25;
	};

	case 20008 : {
		_iDecreaseOfHunger = 0.1;
	};

	case 20009 : {
		_iDecreaseOfHunger = 0.1;
	};

	case 20010 : {
		_iDecreaseOfHunger = 0.2;
	};
};

_iDecreaseOfHunger = _iDecreaseOfHunger * (_this select 1);

_strItemName = ((_this select 0) call daylight_fnc_invIDToStr) select 0;

// Localize
[format["Eating %1..", _strItemName], 1] call daylight_fnc_progressBarCreate;

_iInitialMoveTime = daylight_iLastMoveTime;

_bMoved = false;

[player, 39, false] call daylight_fnc_networkSay3D;
playSound "48933_fresco_eating_chips_by_fresco_local";

_iLoops = 0;
for "_i" from 0 to 50 do {
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
		[_i / 50, 0.1] call daylight_fnc_progressBarSetProgress;

		sleep 0.1;
	} else {
		_bMoved = true;

		if (true) exitWith {};
	};

	_iLoops = _iLoops + 1;
};

if (!_bMoved) then {
	[format["You ate a %1..", _strItemName], 1] call daylight_fnc_showActionMsg;

	daylight_iHunger = daylight_iHunger - _iDecreaseOfHunger;

	if (daylight_iHunger < 0) then {
		daylight_iHunger = 0;
	};

	[(_this select 0), (_this select 1)] call daylight_fnc_invRemoveItem;
} else {
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

1 call daylight_fnc_progressBarClose;

[player, ""] call daylight_fnc_networkSwitchMove;

daylight_bActionBusy = false;

if (true) exitWith {};