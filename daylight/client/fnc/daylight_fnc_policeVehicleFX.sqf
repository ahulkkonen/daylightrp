/*
	Description:	Police vehicle lights & sfx
	Author:			qbt
*/

daylight_fnc_policeVehicleFX = {
	// Find vehicle in cfg array
	_iPos = [daylight_cfg_arrPoliceVehicleLights, typeOf _this] call daylight_fnc_findVariableInNestedArray;
	_arrCur = (daylight_cfg_arrPoliceVehicleLights select _iPos) select 1;

	// Create lights
	_vehLights = [];

	{
		_vehLight = "#lightpoint" createVehicleLocal [0, 0, 0];
		_vehLight attachTo [_this, _x select 0];

		_arrColor = (_x select 1);

		_vehLight setLightColor _arrColor;
		_vehLight setLightAmbient _arrColor;

		_vehLight setLightUseFlare true;
		_vehLight setLightFlareSize (_x select 2);
		_vehLight setLightFlareMaxDistance (_x select 3);
		_vehLight setLightDaylight (_x select 4);

		_vehLights set [count _vehLights, _vehLight];
	} forEach _arrCur;

	//systemChat str _vehLights;

	//if (true) exitWith {};

	// Initialize variables
	_iBrightness = 1.5;
	_iBrightnessCurrent = 0;

	_iLightSwitchTime = 0.4;
	_iLightSwitchTimeLast = -_iLightSwitchTime;

	_iLightIndex = 0;

	_iSirenTime = 0;
	_iSirenTimeLast = -999;

	while {!(isNull _this) && (alive _this)} do {
		_iSpeed = speed _this;

		// Get siren status
		_arrSirenStatus = _this getVariable ["daylight_arrSirenStatus", [0, 0]];

		// Sirens
		if ((_arrSirenStatus select 0) == 1) then {
			// Determine which siren
			_iSiren = 0;

			if (_iSpeed >= 75) then {
				_iSiren = 1;
			};

			// Play siren sound
			if ((time - _iSirenTimeLast) >= _iSirenTime) then {
				// Dont play if no player
				if (!(isNull (driver _this))) then {
					_this say3D ((daylight_cfg_arrPoliceVehicleSFXSamples select _iSiren) select 0);

					_iSirenTime = ((daylight_cfg_arrPoliceVehicleSFXSamples select _iSiren) select 1);

					_iSirenTimeLast = time;
				};
			};
		};

		// Lights
		if ((_arrSirenStatus select 1) == 1) then {
			if ((time - _iLightSwitchTimeLast) >= _iLightSwitchTime) then {
				_iLightSwitchTimeLast = time;

				{
					_x setLightBrightness 0;
				} forEach _vehLights;

				(_vehLights select _iLightIndex) setLightBrightness _iBrightness;

				_iLightIndex = _iLightIndex + 1;

				if (_iLightIndex == (count _vehLights)) then {
					_iLightIndex = 0;
				};
			};
		} else {
			{
				_x setLightBrightness 0;
			} forEach _vehLights;
		};

		sleep 0.05;
	};

	{
		deleteVehicle _x;
	} forEach _vehLights;

	if (true) exitWith {};
};

daylight_fnc_policeVehicleHandleSirenStatus = {
	if ((driver (vehicle player)) != player) exitWith {};

	_iSide = (vehicle player) getVariable ["daylight_iVehicleSide", -1];

	if (_iSide == 0) then {
		_arrSirenStatus = (vehicle player) getVariable ["daylight_arrSirenStatus", [0, 0]];

		if (_this == 0) then {
			if ((_arrSirenStatus select 0) == 0) then {
				(vehicle player) setVariable ["daylight_arrSirenStatus", [1, 1], true];
			} else {
				(vehicle player) setVariable ["daylight_arrSirenStatus", [0, 0], true];
			};
		};

		if (_this == 1) then {
			if ((_arrSirenStatus select 1) == 0) then {
				(vehicle player) setVariable ["daylight_arrSirenStatus", [_arrSirenStatus select 0, 1], true];
			} else {
				(vehicle player) setVariable ["daylight_arrSirenStatus", [_arrSirenStatus select 0, 0], true];
			};
		};

		playSound "ecfike_click_2";
	};
};

daylight_fnc_policeVehicleAddFXLoop = {
	_arrVehiclesAdded = [];

	while {true} do {
		{
			if (!((vehicle _x) in _arrVehiclesAdded)) then {
				if ((vehicle _x) isKindOf "Car") then {
					_iSide = (vehicle _x) getVariable ["daylight_iVehicleSide", -1];

					if (_iSide == 0) then {
						(vehicle _x) spawn daylight_fnc_policeVehicleFX;

						_arrVehiclesAdded set [count _arrVehiclesAdded, (vehicle _x)];
					};
				};
			};

			sleep 0.05;
		} forEach vehicles;

		sleep 2.5;
	};
};

if (!isDedicated) then {
	[] spawn daylight_fnc_policeVehicleAddFXLoop;
};