/*
	Description:	Handle damage
	Author:			qbt
*/

/*
	Description:	Handle damage for players
	Args:			arr HandleDamage-EH
	Return:			int damage return value
*/
daylight_iLastStunTime = diag_tickTime;

daylight_fnc_handleDamagePlayer = {
	_untPlayer = _this select 0;
	_strSelection = _this select 1;
	_iDamage = _this select 2;
	_iReturnDamage = _iDamage;

	_objSource = _this select 3;
	_strProjectile = _this select 4;

	// Check if stun enabled on shooter
	_iStun = _objSource getVariable ["daylight_iStun", 0];

	if (_iStun == 1) then {
		// Stun
		_iReturnDamage = 0;

		if ((diag_tickTime - daylight_iLastStunTime) > 0.2) then {
			_objSource call daylight_fnc_stunApplyStun;

			daylight_iLastStunTime = diag_tickTime;
		};
	};

	// Check if collision damage
	if (_objSource == (vehicle player)) then {
		_iReturnDamage = _iDamage * daylight_cfg_iPlayerCollisionDamageMultiplier;
	};

	if ((_objSource != player) && (isPlayer _objSource) && (_strProjectile == "")) then {
		_iReturnDamage = _iDamage * daylight_cfg_iPlayerCollisionDamageMultiplierRemote;
	};

	(abs _iReturnDamage)
};

/*
	Description:	Handle damage for land vehicles
	Args:			arr HandleDamage-EH
	Return:			int damage return value
*/
daylight_fnc_handleDamageVehicleLand = {
	if ((vehicle player) != _vehVehicle) exitWith {};

	_vehVehicle = _this select 0;
	_strSelection = _this select 1;
	_iDamage = _this select 2;
	_iReturnDamage = _iDamage;

	_objSource = _this select 3;
	_strProjectile = _this select 4;

	// Check if collision damage
	if (isNull _objSource) then {
		if (_strSelection in daylight_cfg_arrStrLandMotors) then {
			_iReturnDamage = _iDamage * daylight_cfg_iLandMotorCollisionDamageMultiplier;
		} else {
			if ((daylight_cfg_arrLandWheels find _strSelection) != -1) then {
				_iReturnDamage = _iDamage * daylight_cfg_iLandWheelCollisionDamageMultiplier;
			};
		};
	};

	/*if ((_vehVehicle getHitPointDamage "hitEngine") >= 0.8) then {
		if (((time - (_vehVehicle getVariable ["daylight_iSmokeStartTime", 0])) >= 45) || ((_vehVehicle getVariable ["daylight_iSmokeStartTime", 0]) == 0)) then {
			_vehVehicle call daylight_fnc_handleDamageVehicleLandSmokeFX;

			_vehVehicle setVariable ["daylight_iSmokeStartTime", time];
		};

		_vehVehicle setHitPointDamage ["hitEngine", 1];
		_vehVehicle setHit ["motor", 1];
	};

	if ((damage _vehVehicle) > 0.9) then {
		_iReturnDamage = 0;

		_vehVehicle setHitPointDamage ["hitEngine", 1];
		_vehVehicle setHit ["motor", 1];
	};*/

	if (daylight_bJailed || daylight_bPlayerGodMode) then {
		_iReturnDamage = 0;
	};

	_iReturnDamage
};

/*
	Description:	Car smoke effect when engine is broken
	Args:			obj vehicle
	Return:			nothing
*/
daylight_fnc_handleDamageVehicleLandSmokeFX = {
	[[0, 0, 0], 45, [_this, [0, 2, -0.2]], 0, 10, 3] call daylight_fnc_networkEffectSmoke;
};