/*
	Description: 	First Aid Kit
	Author:			qbt
*/

daylight_bActionBusy = true;

sleep 0.5;

[player, "AinvPknlMstpSlayWrflDnon_medic"] call daylight_fnc_networkSwitchMove;

// Localize
["Using first aid kit..", 1] call daylight_fnc_progressBarCreate;

_iInitialMoveTime = daylight_iLastMoveTime;

_bMoved = false;

_iLoops = 0;
for "_i" from 0 to 300 do {
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
		[_i / 300, 0.1] call daylight_fnc_progressBarSetProgress;

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
	["You treated yourself..", 1] call daylight_fnc_showActionMsg;

	player setDamage 0;

	[(_this select 0), 1] call daylight_fnc_invRemoveItem;
} else {
	"Action cancelled.." call daylight_fnc_progressBarSetText;
};

1 call daylight_fnc_progressBarClose;

[player, ""] call daylight_fnc_networkSwitchMove;

daylight_bActionBusy = false;

if (true) exitWith {};