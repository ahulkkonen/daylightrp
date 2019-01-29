/*
	Description: 	Interrogate drug trafficker
	Author:			qbt
*/

if (daylight_bActionBusy) exitWith {};

daylight_bActionBusy = true;

// Localize
["Interrogating..", 1] call daylight_fnc_progressBarCreate;

_iInitialMoveTime = daylight_iLastMoveTime;

_bMoved = false;

_iLoops = 0;
for "_i" from 0 to 50 do {
	if ((vehicle player) != player) exitWith {
		_bMoved = true;
	};

	if (!alive player) exitWith {
		_bMoved = true;
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
	["You have interrogated drug trafficker..", 1] call daylight_fnc_showActionMsg;

	(daylight_arrMerchantsAutoBounty find (_this select 0)) call daylight_fnc_networkAddSoldItemsBounty;
} else {
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

1 call daylight_fnc_progressBarClose;

daylight_bActionBusy = false;

if (true) exitWith {};