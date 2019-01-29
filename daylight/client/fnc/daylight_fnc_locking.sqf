/*
	Description:	Vehicle locking/unlocking functions
	Author:			qbt
*/
/*
	Description:	Toggle vehicle locked status (no keys check)
	Args:			obj vehicle
	Return:			nothing
*/
daylight_fnc_toggleVehicleLock = {
	_vehTarget = _this;

	if ((!(isNull _vehTarget) || ((vehicle player) != player))) then {
		if ((vehicle player) != player) then {
			_vehTarget = vehicle player;
		};

		// Make sure target is a vehicle and not a class of "Man"
		if ((_vehTarget isKindOf "AllVehicles") && !(_vehTarget isKindOf "Man") && (alive _vehTarget) && ((player distance _vehTarget) <= 7.5)) then {
			// Check if player has keys for vehicle
			if ([player, _vehTarget] call daylight_fnc_hasKeysFor) then {
				// If yes, toggle lock status
				[_vehTarget, _vehTarget call daylight_fnc_toggledVehicleLockedNumber] call daylight_fnc_networkLockVehicle;

				if ((_vehTarget call daylight_fnc_toggledVehicleLockedNumber) == 0) then {
					[format [localize "STR_ACTION_KEYS_LOCKED", getText(configFile >> "CfgVehicles" >> typeOf _vehTarget >> "displayName")]] call daylight_fnc_showActionMsg;

					if ((vehicle player) != player) then {
						[player, 12, false] call daylight_fnc_networkSay3D;
						playSound "119828_kbnevel_car_powerdoorlock_local";
					};

					if (_vehTarget != (vehicle player)) then {
						[player, 43, false] call daylight_fnc_networkSay3D;
					};
				} else {
					[format [localize "STR_ACTION_KEYS_UNLOCKED", getText(configFile >> "CfgVehicles" >> typeOf _vehTarget >> "displayName")]] call daylight_fnc_showActionMsg;

					if ((vehicle player) != player) then {
						[player, 13, false] call daylight_fnc_networkSay3D;
						playSound "119828_kbnevel_car_powerdoorlock_1_local";
					};

					if (_vehTarget != (vehicle player)) then {
						[player, 44, false] call daylight_fnc_networkSay3D;
					};
				};
			} else {
				// Show info about having no keys
				[localize "STR_ACTION_NO_KEYS"] call daylight_fnc_showActionMsg;
			};
		};
	};

	daylight_iLastLockTime = time;
};

/*
	Description:	Check if player has keys for vehicle
	Args:			arr [obj player, obj vehicle]
	Return:			bool
*/
daylight_fnc_hasKeysFor = {
	_bHasKeys = false;

	_arrKeys = [(_this select 0), format["arrKeys%1", (_this select 0) call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

	if ((_this select 1) in _arrKeys) then {
		_bHasKeys = true;
	};

	_bHasKeys
};

/*
	Description:	Return toggled vehicle locked status number
	Args:			obj vehicle
	Return:			int lock-status
*/
daylight_fnc_toggledVehicleLockedNumber = {
	_iReturn = 0;

	if ((locked _this) != 2) then {
		_iReturn = 2;
	};

	_iReturn
};

/*
	Description:	Keychain dialog
	Args:			obj vehicle
	Return:			nothing
*/
daylight_fnc_keychainOpenUI = {
	createDialog "Keychain";

	ctrlEnable [1700, false];
	ctrlEnable [1701, false];

	// Play sound
	[player, 10, false] call daylight_fnc_networkSay3D;
	playSound "85455_jasonelrod_keys_local";

	_arrKeys = [player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;
	_iCount = count _arrKeys;

	// Delete non existing vehicles
	for "_i" from 0 to ((count _arrKeys) - 1) do {
		_vehVehicle = _arrKeys select _i;

		if ((isNull _vehVehicle) || !(alive _vehVehicle)) then {
			_arrKeys set [_i, -1];
		};
	};

	_arrKeys = _arrKeys - [-1];

	if (_iCount != (count _arrKeys)) then {
		[player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], _arrKeys] call daylight_fnc_saveVar;
	};

	// Populate cars list
	for "_i" from 0 to ((count _arrKeys) - 1) do {

		// Get car text
		_strText = getText(configFile >> "CfgVehicles" >> typeOf (_arrKeys select _i) >> "displayName");

		// Add item to list
		lbAdd [1500, _strText];
	};

	if ((count _arrKeys) == 0) then {
		lbAdd [1500, "No vehicles to show"];

		daylight_bKeychainVehiclesEmpty = true;
	} else {
		daylight_bKeychainVehiclesEmpty = false;

		ctrlEnable [1701, true];
	};

	lbSetCurSel [1500, 0];

	// Populate player list
	// Clear (or create) near players global array that will be used later if items are given to other players
	daylight_arrInventoryNearPlayers = [];

	// Get list of near Man-entities
	//_arrNearPlayers = (getPosATL player) nearEntities ["CAManBase", daylight_cfg_iInvMaxGiveDistance];
	_arrNearPlayers = playableUnits;

	// Populate player list
	for "_i" from 0 to (count(_arrNearPlayers) - 1) do {
		// Check if entity is a player and is not the player itself
		if ((isPlayer (_arrNearPlayers select _i)) && ((_arrNearPlayers select _i) != player) && ((player distance (_arrNearPlayers select _i)) <= daylight_cfg_iInvMaxGiveDistance) && !(lineIntersects [eyePos player, eyePos (_arrNearPlayers select _i), vehicle player, vehicle (_arrNearPlayers select _i)]) && (playerSide == side (_arrNearPlayers select _i))) then {
			// Get players name
			_strName = name (_arrNearPlayers select _i);

			// Add to near players global array
			daylight_arrInventoryNearPlayers set [count daylight_arrInventoryNearPlayers, _arrNearPlayers select _i];

			// Add entry and data to listbox
			lbAdd [2100, _strName];
			lbSetData [2100, _i, str(_i)];
		};
	};

	// If empty disable button & list
	if ((count daylight_arrInventoryNearPlayers) == 0) then {
		lbAdd [2100, "No players to show"];

		daylight_bKeychainNearEmpty = true;
	} else {
		daylight_bKeychainNearEmpty = false;

		ctrlEnable [1700, true];
	};

	lbSetCurSel [2100, 0];

	[] call daylight_fnc_keychainUpdateUI;
};

/*
	Description:	Update Keychain dialog
	Args:			arr lbCurSel
	Return:			nothing
*/
daylight_fnc_keychainUpdateUI = {
	if (!daylight_bKeychainVehiclesEmpty && !daylight_bKeychainNearEmpty) then {
		_iLbCurSel = 0;
		_iLbCurSel2 = 0;

		if ((lbCurSel 1500) != -1) then {
			_iLbCurSel = lbCurSel 1500;
		};

		if ((lbCurSel 2100) != -1) then {
			_iLbCurSel2 = lbCurSel 2100;
		};

		// Check if target player already has keys for this vehicle
		_vehCurrentVehicle = ([player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar) select _iLbCurSel;
		_vehTarget = daylight_arrInventoryNearPlayers select _iLbCurSel2;
		_arrKeysTarget = [_vehTarget, format["arrKeys%1", _vehTarget call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

		if ((_arrKeysTarget find _vehCurrentVehicle) != -1) then {
			ctrlEnable [1700, false];
		} else {
			ctrlEnable [1700, true];
		};
	} else {
		ctrlEnable [1700, false];
	};
};

/*
	Description:	Keychain send key
	Args:			arr [obj target, veh vehicle]
	Return:			nothing
*/
daylight_fnc_keychainSendKey = {
	daylight_iLastGiveTime = time;

	while {dialog} do {
		closeDialog 0;
	};

	// Play sound
	playSound "85455_jasonelrod_keys_2";

	// Show progress bar
	// Localize
	[format ["Giving keys to %1..", name (_this select 0)], 0.5] call daylight_fnc_progressBarCreate;
	[1, 1.5] call daylight_fnc_progressBarSetProgress;

	sleep 1.5;

	1 call daylight_fnc_progressBarClose;

	sleep 0.1;

	[(_this select 0), player, (_this select 1)] call daylight_fnc_networkGiveKeys;

	[format["You gave keys of %1 to %2", getText(configFile >> "CfgVehicles" >> typeOf (_this select 1) >> "displayName"), name (_this select 0)]] call daylight_fnc_showActionMsg;

	if (true) exitWith {};
};

/*
	Description:	Keychain receive key
	Args:			arr [obj sender, veh vehicle]
	Return:			nothing
*/
daylight_fnc_keychainReceiveKey = {
	_arrKeys = [player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

	_arrKeys set [count _arrKeys, (_this select 1)];

	[player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], _arrKeys] call daylight_fnc_saveVar;

	// Play sound
	playSound "85455_jasonelrod_keys_2";

	[format["You received keys for %1 from %2", getText(configFile >> "CfgVehicles" >> typeOf (_this select 1) >> "displayName"), name (_this select 0)]] call daylight_fnc_showActionMsg;
};

/*
	Description:	Keychain destroy key
	Args:			veh vehicle
	Return:			nothing
*/
daylight_fnc_keychainDestroyKey = {
	daylight_iLastDropTime = time;

	while {dialog} do {
		closeDialog 0;
	};

	// Show progress bar
	// Localize
	[format ["Destroying keys for %1..", getText(configFile >> "CfgVehicles" >> typeOf _this >> "displayName")], 0.5] call daylight_fnc_progressBarCreate;
	[1, 1] call daylight_fnc_progressBarSetProgress;

	sleep 1;

	1 call daylight_fnc_progressBarClose;

	sleep 0.1;

	_arrKeys = [player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

	_arrKeys = _arrKeys - [_this];

	[player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], _arrKeys] call daylight_fnc_saveVar;

	[player, _this] call daylight_fnc_networkDestroyKey;

	[format["You permanently destroyed the keys for %1", getText(configFile >> "CfgVehicles" >> typeOf _this >> "displayName")]] call daylight_fnc_showActionMsg;

	if (true) exitWith {};
};

/*
	Description:	Inform others that keys have been destroyed
	Args:			arr [obj player, veh vehicle]
	Return:			nothing
*/
daylight_fnc_keychainInformPlayersOfKeyDestruction = {
	if ((player distance (_this select 0)) <= daylight_cfg_iMaxKeysDestructionChatNotificationDistance) then {
		// Play sound
		(_this select 0) say3D "22971_andre_rocha_nascimento_keys_chaves03_drop";

		systemChat format[localize "STR_KEYREMOVED", name (_this select 0), getText(configFile >> "CfgVehicles" >> typeOf (_this select 1) >> "displayName")];
	};
};