/*
	Description: 	Food
	Author:			qbt
*/

daylight_bActionBusy = true;

_strItemName = ((_this select 0) call daylight_fnc_invIDToStr) select 0;

// Localize
[format["Drinking %1..", _strItemName], 1] call daylight_fnc_progressBarCreate;

_iInitialMoveTime = daylight_iLastMoveTime;

_bMoved = false;

[player, 40, false] call daylight_fnc_networkSay3D;
playSound "20213_modcam_drinking_water_local";

_iLoops = 0;
for "_i" from 0 to 80 do {
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
		[_i / 80, 0.1] call daylight_fnc_progressBarSetProgress;

		sleep 0.1;
	} else {
		_bMoved = true;

		if (true) exitWith {};
	};

	_iLoops = _iLoops + 1;
};

if (!_bMoved) then {
	[format["You drank %1..", _strItemName], 1] call daylight_fnc_showActionMsg;

	daylight_iDrugAlcoholLevel = daylight_iDrugAlcoholLevel + 0.2;

	[(_this select 0), 1] call daylight_fnc_invRemoveItem;
} else {
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

1 call daylight_fnc_progressBarClose;

[player, ""] call daylight_fnc_networkSwitchMove;

daylight_bActionBusy = false;

if (true) exitWith {};