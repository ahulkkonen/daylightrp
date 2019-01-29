/*
	Description:	Handle Killed-EH
	Author:			qbt
*/

/*
	Description:	Handle Killed-EH for players, clientside.
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_handleKilledPlayer = {
	daylight_bRespawning = true;
	daylight_bReadyToRespawn = false;

	disableSerialization;

	// Handle simulation and adding "Study body"-actions
	player spawn daylight_fnc_handleKilledPlayerSimulationAndActions;

	// If BLUFOR, remove weapons
	if (playerSide == blufor) then {
		removeAllWeapons player;
	};

	_untKiller = (_this select 1);

	if (!(isNull _untKiller) && ((name _untKiller) != "Error: No unit")) then {
		if (_untKiller != player) then {
			if (((driver _untKiller) != (vehicle _untKiller)) && !(isNull (driver _untKiller))) then {
				[_untKiller, "Vehicle deathmatching", daylight_cfg_iMurderVehicleBounty] call daylight_fnc_jailSetWanted;

				format["%1 killed %2 with a vehicle! %1 is now wanted.", name _untKiller, name player] call daylight_fnc_networkChatNotification;
			} else {
				if (((playerSide) == blufor) && ((side _untKiller) == civilian)) then {
					[_untKiller, "Murder of police officer", daylight_cfg_iMurderPoliceBounty] call daylight_fnc_jailSetWanted;

					format["Officer %2 was murdered by %1! %1 is now wanted.", name _untKiller, name player] call daylight_fnc_networkChatNotification;
				};

				if (((playerSide) == civilian) && ((side _untKiller) == civilian)) then {
					[_untKiller, "Murder", daylight_cfg_iMurderBounty] call daylight_fnc_jailSetWanted;

					format["%2 was murdered by %1! %1 is now wanted.", name _untKiller, name player] call daylight_fnc_networkChatNotification;
				};
			};
		};
	};

	// Remove all other effects from screen
	titleText ["", "PLAIN", 0.001];
	cutText ["", "PLAIN", 0.001];

	// Draw death message
	1500 cutRsc ["GeneralMsg", "PLAIN", 0.001];

	// Fade out sound fx
	[5, 0] call daylight_fnc_setMasterVolume;
	enableEnvironment false;

	// Check if player is in a city
	/*_bInCity = false;
	_arrNearLocations = nearestLocations [getPosATL player, ["nameCity", "nameCityCapital", "nameVillage"], 1000];

	if ((count _arrNearLocations) > 0) then {
		if ((getPosATL player) in (_arrNearLocations select 0)) then {
			_bInCity = true;
		};
	};

	if (_bInCity) then {
		//
	};*/

	// Remove EH's
	player removeAllEventHandlers "Killed";
	player removeAllEventHandlers "HandleDamage";

	resetCamShake;
	daylight_ppDrugDynamicBlur ppEffectAdjust [0];
	daylight_ppDrugDynamicBlur ppEffectCommit 0;

	// Dump inventory and reset inventory variable
	{
		_iItemID = _x select 0;
		_iAmount = round(_x select 1);

		// Create object in world and add action
		_strClassname = "";

		// If item is special, use defined model
		_iIndex = [daylight_cfg_arrSpecialItems, _iItemID] call daylight_fnc_findVariableInNestedArray;
		if (_iIndex != -1) then {
			_strClassname = ((daylight_cfg_arrSpecialItems select _iIndex) select 1);
		} else {
			_strClassname = daylight_cfg_strDefaultItemClassName;
		};

		// Add action
		_iSpread = 1.5;
		_arrPos = player modelToWorld [(random _iSpread) - (random _iSpread), 1 + (random _iSpread) - (random _iSpread), 0];

		[_strClassname, _arrPos, getDir player, _iItemID, _iAmount] call daylight_fnc_networkDropItem;
	} forEach daylight_arrInventory;

	daylight_arrInventory = [];

	// Reset values
	daylight_iStunValue = 0;
	daylight_iDrugAlcoholLevel = 0;
	daylight_iDrugHeroinLevel = 0;
	daylight_iDrugAmphetamineLevel = 0;
	daylight_iDrugCannabisLevel = 0;
	daylight_iHunger = 0;
	daylight_iInventoryWeight = 0;
	daylight_bActionBusy = false;

	// Calculate respawn time from amount of kills
	_iRespawnTime = daylight_cfg_iRespawnTimeMin;
	_arrKills = [player, "arrKills", 0] call daylight_fnc_loadVar;

	_iRespawnTime = _iRespawnTime + ((_arrKills select 0) * (daylight_cfg_arrRespawnTimeAddedPerKillPerSide select 0)) + ((_arrKills select 1) * (daylight_cfg_arrRespawnTimeAddedPerKillPerSide select 1));

	// Reset killcount after calculation is done
	[player, "arrKills", [0, 0]] call daylight_fnc_saveVar;

	_strVariable = format["arrWanted%1", (_this select 0) call daylight_fnc_returnSideStringForSavedVariables];

	// Update variable
	[(_this select 0), _strVariable, []] call daylight_fnc_saveVar;

	// Determine how player got killed
	if (isNull (_this select 1)) then {
		// Player got killed by collision damage, fire, etc.
	} else {
		// Killed by other player:
		// Add to other players killcount depending on player side
		_arrKillerKills = [(_this select 1), "arrKills", [0, 0]] call daylight_fnc_loadVar;
		if (playerSide == blufor) then {
			[(_this select 1), "arrKills", [_arrKillerKills select 0, (_arrKillerKills select 1) + 1]] call daylight_fnc_saveVar;
		} else {
			[(_this select 1), "arrKills", [(_arrKillerKills select 0) + 1, _arrKillerKills select 1]] call daylight_fnc_saveVar;
		};
	};

	// Get variables set in RscTitles.hpp so we can use them
	_dDisplay = ((uiNamespace getVariable "daylight_arrRscGeneralMsg") select 0);
	_iIDC = ((uiNamespace getVariable "daylight_arrRscGeneralMsg") select 1);
	_cControl = _dDisplay displayCtrl _iIDC;

	_strText = "";
	for "_i" from 0 to (_iRespawnTime - 1) do {
		_iTimeLeft = _iRespawnTime - _i;

		_strText = format[format["%1%2", localize "STR_RESPAWN", localize "STR_RESPAWN_IN"], _iTimeLeft];

		_cControl ctrlSetStructuredText parseText(_strText);

		sleep 1;
	};

	daylight_bReadyToRespawn = true;

	// Set "ready"-text
	_cControl ctrlSetStructuredText parseText(format["%1%2", localize "STR_RESPAWN", localize "STR_RESPAWN_READY"]);
};

/*
	Description:	Respawn player (after player pressed spacebar)
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_respawn = {
	daylight_bReadyToRespawn = false;

	// Wait until player actually respawns
	waitUntil {alive player};

	removeAllWeapons player;
	player unassignItem "NVGoggles";
	player removeItem "NVGoggles";

	if ((side player) == blufor) then {
		player addBackpack (daylight_cfg_arrStartGearBLUFORClothing select 3);
	};

	// Reset player state
	player setVariable ["daylight_arrState", [0, 0, 0], true]; // [i hands up, i restrained, i jailed]

	// Add default EH's
	player call daylight_fnc_addDefaultEventHandlers;

	// Set custom recoilCoefficient to player
	player setUnitRecoilCoefficient daylight_cfg_iRecoilCoefficient;

	[player, ""] call daylight_fnc_networkSwitchMove;

	// Set dir to respawn dir and pos to actual respawn pos
	player setDir daylight_iRespawnDir;
	player setPosATL daylight_arrRespawnPos;

	_arrClothing = [player, format["arrClothing%1", player call daylight_fnc_returnSideStringForSavedVariables]] call daylight_fnc_loadVar;

	if ((side player) == civilian) then {
		player addHeadgear (_arrClothing select 0);
		player addGoggles (_arrClothing select 1);
		player addUniform (_arrClothing select 2);
	};

	// Fade back sound
	[0, 1] call daylight_fnc_setMasterVolume;
	enableEnvironment true;

	// Remove death message
	1500 cutRsc ["RscStatic", "PLAIN", 0.001];

	[] spawn {
		sleep 5;

		daylight_bRespawning = false;
	};
};

/*
	Description:	Handle dead player
	Args:			obj player
	Return:			nothing
*/
daylight_fnc_handleKilledPlayerSimulationAndActions = {
	_bLoop = true;
	_iLoops = 0;

	while {_bLoop} do {
		if ((((_this selectionPosition "Neck") select 2) <= 0.3) && ((speed _this) <= 0.25)) then {
			_iLoops = _iLoops + 1;
		};

		if (_iLoops == 10) then {
			_bLoop = false;
		};

		sleep 1;
	};

	[_this, false] call daylight_fnc_networkEnableSimulation;

	if (true) exitWith {};
};