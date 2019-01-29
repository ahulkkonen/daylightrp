/*	
	Description: 	Disables damage and simulation of near buildings and objects. This will help in MP performance as broken buildings / objects wont need to be synced on client connect.
	Author:			qbt
*/

while {true} do {
	_arrNearestObjects = nearestObjects [vehicle(player), ["Static"], 250];
	{
		_x allowDamage false;

		if (!((typeOf _x) in daylight_cfg_arrSimulationEnabled)) then {
			// Checking flags with isKindOf is buggy, we need to do this manually
			if (!(_x isKindOf "FlagCarrierCore")) then {
				_x enableSimulation false;
			};
		};

		if ((damage _x) > 0.9) then {
			_x setDamage 0;
		};

		sleep 0.01;
	} forEach _arrNearestObjects;

	sleep 5;
};

if (true) exitWith {};