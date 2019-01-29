/*
	Description:	Objects
	Author:			qbt
*/

daylight_fnc_objectsSpawn = {
	_arrObjects = call compile preprocessFile "daylight\cfg\dlobjects.objects";

	{
		_arrCur = _x;

		_vehVehicle = objNull;

		if ((_x select 0) in daylight_cfg_arrSpawnGlobal) then {
			if (isServer) then {
				_vehVehicle = createVehicle [(_x select 0), [0, 0, 0], [], 0, "NONE"];
			};
		} else {
			_vehVehicle = (_x select 0) createVehicleLocal [0, 0, 0];
		};

		if (!(isNull _vehVehicle)) then {
			if (!((typeOf _vehVehicle) in daylight_cfg_arrSimulationEnabled)) then {
				// Checking flags with isKindOf is buggy, we need to do this manually
				if (!(_vehVehicle isKindOf "FlagCarrierCore")) then {
					_vehVehicle enableSimulation false;
				};
			};

			_vehVehicle setPosASL (_x select 1);
			_vehVehicle setDir (_x select 2);
			_vehVehicle setDir (_x select 2);
			_vehVehicle setVectorUp (_x select 3);
			_vehVehicle setVectorDir (_x select 4);

			// Smoke to smokestacks of diesel factory
			if (typeOf _vehVehicle == "Land_dp_mainFactory_F") then {
				_vehSmoke_1 = "test_EmptyObjectForSmoke" createVehicleLocal [0, 0, 0];
				_vehSmoke_2 = "test_EmptyObjectForSmoke" createVehicleLocal [0, 0, 0];

				_vehSmoke_1 setPosATL (_vehVehicle modelToWorld [17, -3.3, 13]);
				_vehSmoke_2 setPosATL (_vehVehicle modelToWorld [17, 0.4, 13]);
			};

			if (typeOf _vehVehicle == "Land_New_WiredFence_5m_F") then {
				_vehVehicle setPosATL [getPosATL _vehVehicle select 0, getPosATL _vehVehicle select 1, 0];
			};
		};
	} forEach _arrObjects;
};

if (!isDedicated) then {
	call daylight_fnc_objectsSpawn;
};