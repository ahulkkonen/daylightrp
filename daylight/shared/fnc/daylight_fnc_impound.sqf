/*
	Description:	Impound functions
	Author:			qbt
*/

// Synced variable of impounded vehicles
if (isServer) then {
	daylight_arrImpoundedVehicles = [];
	publicVariable "daylight_arrImpoundedVehicles";
};

/*
	Description:	Spawn impound officers
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_impoundSpawnImpoundOfficers = {
	daylight_arrImpoundOfficers = [];

	_grpImpoundOfficers = createGroup civilian;

	{
		_untImpoundOfficer = _grpImpoundOfficers createUnit [(_x select 0) select 0, [0, 0, 0], [], 0, "NONE"];

		_untImpoundOfficer setVariable ["daylight_arrInitialPos", (_x select 3)];

		_untImpoundOfficer enableSimulation false;
		_untImpoundOfficer allowDamage false;

		_untImpoundOfficer addEventHandler ["HandleDamage", {
			(_this select 0) setVelocity [0, 0, 0];

			_arrPos = (_this select 0) getVariable "daylight_arrInitialPos";

			if (((_this select 0) distance _arrPos) > 5) then {
				(_this select 0) setPosATL ((_this select 0) getVariable "daylight_arrInitialPos");
			};

			(_this select 0) switchMove "";
		}];

		{_untImpoundOfficer disableAI _x} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		_untImpoundOfficer setSkill 0;

		_untImpoundOfficer setFace ((_x select 0) select 1);
		_untImpoundOfficer addHeadgear ((_x select 0) select 2);
		_untImpoundOfficer addGoggles ((_x select 0) select 3);
		_untImpoundOfficer addUniform ((_x select 0) select 4);
		_untImpoundOfficer addVest ((_x select 0) select 5);

		_untImpoundOfficer switchMove "";

		_untImpoundOfficer setPos (_x select 1);
		_untImpoundOfficer setDir (_x select 2);

		_untImpoundOfficer setVariable ["daylight_arrImpoundOfficerInfo", [_x select 3, _x select 4], true];

		daylight_arrImpoundOfficers set [count daylight_arrImpoundOfficers, _untImpoundOfficer];
	} forEach daylight_cfg_arrImpoundOfficers;

	publicVariable "daylight_arrImpoundOfficers";
};

/*
	Description:	Impound vehicle
	Args:			veh vehicle to impound
	Return:			nothing
*/
daylight_fnc_impoundImpoundVehicle = {
	[_this, false] call daylight_fnc_networkEnableSimulation;

	// Make car invulnerable
	[_this, false] call daylight_fnc_networkAllowDamage;

	// Move car to impound location
	_this setPosATL daylight_cfg_arrImpoundStoreLocation;

	// Reset damage
	_this setDamage 0;
	
	_iSide = (vehicle player) getVariable ["daylight_iVehicleSide", -1];

	if (_iSide == 0) then {
		(vehicle player) setVariable ["daylight_arrSirenStatus", [0, 0], true];
	};

	// Lock vehicle
	[_this, 2] call daylight_fnc_networkLockVehicle;

	// Add to impounded cars list
	daylight_arrImpoundedVehicles set [count daylight_arrImpoundedVehicles, _this];
	publicVariable "daylight_arrImpoundedVehicles";
};

/*
	Description:	Return impounded vehicle
	Args:			arr [veh vehicle to impound, arr return pos, i return dir]
	Return:			nothing
*/
daylight_fnc_impoundReturnVehicle = {
	// Make vehicle take damage again
	[(_this select 0), true] call daylight_fnc_networkEnableSimulation;
	[(_this select 0), true] call daylight_fnc_networkAllowDamage;

	// Return vehicle
	(_this select 0) setDir (_this select 2);
	(_this select 0) setPosATL (_this select 1);

	// Remove from impounded cars list
	_iIndex = daylight_arrImpoundedVehicles find (_this select 0);
	daylight_arrImpoundedVehicles set [_iIndex, -1];
	daylight_arrImpoundedVehicles = daylight_arrImpoundedVehicles - [-1];

	publicVariable "daylight_arrImpoundedVehicles";
};

/*
	Description:	Return impounded vehicle (from UI)
	Args:			int lbData of lbCurSel
	Return:			nothing
*/
daylight_fnc_impoundReturnVehicleFromUI = {
	// Check if player has enough money in inventory or in bank if not in inv entory
	_bHasMoney = false;

	if (([daylight_cfg_iInvMoneyID, daylight_cfg_iImpoundReturnCost] call daylight_fnc_invCheckAmount) >= daylight_cfg_iImpoundReturnCost) then {
		_bHasMoney = true;

		// Remove money from inventory
		[daylight_cfg_iInvMoneyID, daylight_cfg_iImpoundReturnCost] call daylight_fnc_invRemoveItem;

		[localize "STR_IMPOUND_OFFICER_MESSAGE_TITLE", format[localize "STR_IMPOUND_OFFICER_MESSAGE_PAID", daylight_cfg_iImpoundReturnCost, localize "STR_CURRENCY", localize "STR_PAIDFROMINVENTORY"], true] call daylight_fnc_showHint;
	} else {
		_iMoneyBank = [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
		if (_iMoneyBank >= daylight_cfg_iImpoundReturnCost) then {
			_bHasMoney = true;

			// Minus cost from current amount
			_iMoneyBank = _iMoneyBank - daylight_cfg_iImpoundReturnCost;

			// Update bank money amount
			[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], _iMoneyBank] call daylight_fnc_saveVar;

			[localize "STR_IMPOUND_OFFICER_MESSAGE_TITLE", format[localize "STR_IMPOUND_OFFICER_MESSAGE_PAID", daylight_cfg_iImpoundReturnCost, localize "STR_CURRENCY", localize "STR_PAIDFROMBANK"], true] call daylight_fnc_showHint;
		} else {
			// No money
			[localize "STR_IMPOUND_OFFICER_MESSAGE_TITLE", localize "STR_IMPOUND_OFFICER_MESSAGE_NOMONEY", true] call daylight_fnc_showHint;
		};
	};

	if (_bHasMoney) then {
		_arrImpoundOfficerInfo = daylight_vehCurrentImpoundOfficer getVariable "daylight_arrImpoundOfficerInfo";
		[daylight_arrImpoundedVehicles select _this, _arrImpoundOfficerInfo select 0, _arrImpoundOfficerInfo select 1] call daylight_fnc_impoundReturnVehicle;
	};

	closeDialog 0;
};

/*
	Description:	Impound return vehicle UI
	Args:			veh cursorTarget
	Return:			nothing
*/
daylight_fnc_impoundReturnOpenUI = {
	if (!dialog) then {
		createDialog "ImpoundReturn";

		daylight_vehCurrentImpoundOfficer = _this;

		// Disable buttons temporarily
		ctrlEnable [1700, false];

		_iLastLbIndex = 0;
		for "_i" from 0 to ((count daylight_arrImpoundedVehicles) - 1) do {
			_vehCurrent = daylight_arrImpoundedVehicles select _i;

			if ([player, _vehCurrent] call daylight_fnc_hasKeysFor) then {
				_strVehicleFriendlyName = getText(configFile >> "CfgVehicles" >> typeOf _vehCurrent >> "displayName");

				lbAdd [1500, _strVehicleFriendlyName];
				lbSetData [1500, _iLastLbIndex, str _i];

				_iLastLbIndex = _iLastLbIndex + 1;
			};
		};

		while {((lbCurSel 1500) == -1) && (lbSize 1500 > 0)} do {
			lbSetCurSel [1500, 0];
		};

		if ((lbSize 1500) > 0) then {
			// Enable button
			ctrlEnable [1700, true];
		} else {
			lbAdd [1500, localize "STR_IMPOUND_OFFICER_DIALOG_NOVEHICLES"];
		};
	};
};

// Spawn impound officers
if (isServer) then {
	[] call daylight_fnc_impoundSpawnImpoundOfficers;
};