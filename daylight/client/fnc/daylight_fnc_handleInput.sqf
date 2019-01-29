/*
	Description:	Handle keyboard and mouse input
	Author:			qbt
*/

// Initialize last input time variable(s), we can use this to stop unwanted behaviour if key is kept down.
daylight_iLastInputTime = 0;
daylight_iLastLockTime = 0;
daylight_iLastSurrenderTime = 0;

daylight_arrInputWhitelist = toArray daylight_cfg_strInputWhitelist;

// Handle main KeyDown-UI-EH
daylight_fnc_handleKeyDown = {
	_bDisableDefaultAction = false;

	switch (true) do {
		// Catch IngamePause to disable respawn button
		case ((_this select 1) in (actionKeys "IngamePause")) : {
			_bDisableDefaultAction = false;

			if ((time - daylight_iLastInputTime) >= 0.1) then {
				[] spawn daylight_fnc_disableRespawnButton;
			};
		};

		// Disable command mode
		case ((_this select 1) in (actionKeys "ForceCommandingMode")) : {
			_bDisableDefaultAction = true;
		};

		// Disable diary
		case ((_this select 1) in (actionKeys "Diary")) : {
			_bDisableDefaultAction = true;
		};

		// Disable WASD + vaulting if surrendered
		case (
			(
				(_this select 1) in (actionKeys "MoveForward") ||
				(_this select 1) in (actionKeys "MoveFastForward") ||
				(_this select 1) in (actionKeys "MoveSlowForward") ||
				(_this select 1) in (actionKeys "TurnLeft") ||
				(_this select 1) in (actionKeys "TurnRight") ||
				(_this select 1) in (actionKeys "MoveBack") ||
				(_this select 1) in (actionKeys "GetOver")
			)
		) : {
			_bDisableDefaultAction = false;

			if (daylight_bSurrendered || daylight_bRestrained) then {
				_bDisableDefaultAction = true;
			};

			daylight_iLastMoveTime = time;
		};

		case ((_this select 1) in (actionKeys "PersonView")) : {
			_bDisableDefaultAction = false;

			if (!daylight_b3rdPersonEnabled) then {
				_bDisableDefaultAction = true;
			};
		};

		// Disable zoom in/out as best as we can
		case (
			((_this select 1) in (actionKeys "ZoomIn")) ||
			((_this select 1) in (actionKeys "ZoomInToggle")) ||
			((_this select 1) in (actionKeys "ZoomOut")) ||
			((_this select 1) in (actionKeys "ZoomOutToggle"))
		) : {
			_bDisableDefaultAction = true;
		};

		// Disable vault, salute and sit if restrained or surrendered
		case (((_this select 1) in (actionKeys "GetOver")) || ((_this select 1) in (actionKeys "Salute")) || ((_this select 1) in (actionKeys "SitDown"))) : {
			_bDisableDefaultAction = true;

			if (daylight_bRestrained && daylight_bSurrendered) then {
				_bDisableDefaultAction = true;
			};
		};

		// E - Interact
		case ((_this select 1) == 0x12) : {
			if (!daylight_bJailed && daylight_bHUDReady && !daylight_bActionBusy && !daylight_bSurrendered && !daylight_bRestrained) then {
				cursorTarget call daylight_fnc_handleInteractKey;
			};
		};

		// I - Introduce self
		/*case ((_this select 1) == 0x17) : {
			_bDisableDefaultAction = false;

			if ((isPlayer cursorTarget) && (playerSide == civilian) && (alive cursorTarget)) then {
				_bDisableDefaultAction = true;

				if (((time - daylight_iLastInputTime) >= 0.5) && ((cursorTarget distance player) <= 5)) then {
					cursorTarget call daylight_fnc_interactionIntroduceSelf;
				};
			};
		};*/

		// U - Toggle vehicle lock status
		case ((_this select 1) == 0x16) : {
			_bDisableDefaultAction = true;

			if ((time - daylight_iLastLockTime) >= 1.5) then {
				cursorTarget call daylight_fnc_toggleVehicleLock;
			};
		};

		// F - Siren on
		case ((_this select 1) == 0x21) : {
			if ((vehicle player) != player) then {
				0 call daylight_fnc_policeVehicleHandleSirenStatus;
			};
		};

		// G - Lights on
		case ((_this select 1) == 0x22) : {
			if ((vehicle player) != player) then {
				1 call daylight_fnc_policeVehicleHandleSirenStatus;
			};
		};

		// T - Whistle/Trunk
		case ((_this select 1) == 0x14) : {
			_bDisableDefaultAction = true;

			if (((vehicle player) != player) && (driver(vehicle(player)) == player)) then {
				_vehTarget = vehicle player;

				if ([player, _vehTarget] call daylight_fnc_hasKeysFor) then {
					// If yes, open trunk
					if ((time - daylight_iTrunkLastOpenTime) > 1) then {
						_vehTarget call daylight_fnc_trunkOpenUI;

						// Last trunk open time
						daylight_iTrunkLastOpenTime = time;
					};
				} else {
					// Show info about having no keys
					[localize "STR_ACTION_NO_KEYS"] call daylight_fnc_showActionMsg;
				};
			} else {
				// Whistle
				player call daylight_fnc_whistle;
			};
		};

		// Spacebar
		case ((_this select 1) == 0x39) : {
			_bDisableDefaultAction = false;

			if (daylight_bReadyToRespawn) then {
				call daylight_fnc_respawn;
			};
		};

		// TAB - Inventory
		case ((_this select 1) == 0x0F) : {
			_bDisableDefaultAction = true;

			if (!(_this select 2) && daylight_bHUDReady && ((time - daylight_iLastInventoryOpenTime) >= 1.5) && !daylight_bInvDisabled) then {
				[] call daylight_fnc_invOpenUI;

				daylight_iLastInventoryOpenTime = time;
			};
		};

		// F-keys
		case ((_this select 1) == 0x3B) : {
			_bDisableDefaultAction = true;

			if ((side player) == civilian) then {
				call daylight_fnc_presidentMenuOpenUI;
			};

			if ((side player) == blufor) then {
				if (daylight_bPoliceMenuOpen) then {
					closeDialog 0;
				};

				if (!dialog) then {
					call daylight_fnc_policeMenuOpenUI;
				};	
			};
		};

		case ((_this select 1) == 0x3C) : {
			_bDisableDefaultAction = true;

			call daylight_fnc_statusMenuOpenUI;
		};

		case ((_this select 1) == 0x3D) : {
			_bDisableDefaultAction = true;

			true call daylight_fnc_gangsOpenUI;
		};

		case ((_this select 1) == 0x3F) : {
			_bDisableDefaultAction = true;

			call daylight_fnc_adminMenuOpenUI;
		};

		case (([0x3B, 0x3C, 0x3D, 0x3E, 0x3F, 0x40, 0x41, 0x42, 0x43, 0x44, 0x57, 0x58] find (_this select 1)) != -1) : {
			_bDisableDefaultAction = true;
		};

		// 0 - 9
		// 3 - Surrender
		case ((_this select 1) == 0x04) : {
			_bDisableDefaultAction = true;

			if ((time - daylight_iLastSurrenderTime) >= 1.25) then {
				[] call daylight_fnc_interactionSurrenderToggle;

				daylight_iLastSurrenderTime = time;
			};
		};

		case ((_this select 1) == 0x0B) : {
			_bDisableDefaultAction = true;
		};

		case ((_this select 1) == 0x06) : {
			_bDisableDefaultAction = true;

			0 call daylight_fnc_shoutSend;
		};

		case ((_this select 1) == 0x07) : {
			_bDisableDefaultAction = true;

			1 call daylight_fnc_shoutSend;
		};

		case ((_this select 1) == 0x08) : {
			_bDisableDefaultAction = true;

			2 call daylight_fnc_shoutSend;
		};

		case ((_this select 1) == 0x09) : {
			_bDisableDefaultAction = true;

			3 call daylight_fnc_shoutSend;
		};

		case ((_this select 1) == 0x0A) : {
			_bDisableDefaultAction = true;

			4 call daylight_fnc_shoutSend;
		};

		case (([0x02, 0x03, 0x04, 0x05] find (_this select 1)) != -1) : {
			_bDisableDefaultAction = true;
		};
	};

	daylight_iLastInputTime = time;

	_bDisableDefaultAction
};

/*
	Description:	Handle custom dialog KeyDown-UI-EH to disable user escape from dialog via keyboard
	Args:			arr [(from UIEH)]
	Return:			nothing
*/
daylight_fnc_handleKeyDownDisableDialogExitByKeyboard = {
	_bDisableDefaultAction = false;

	if ((_this select 1) in (actionKeys "IngamePause")) then {
		_bDisableDefaultAction = true;
	};

	_bDisableDefaultAction
};

/*
	Description:	Limit RscEdit str input length
	Args:			arr [ctrl ctrl, int maxlen]
	Return:			nothing
*/
daylight_fnc_limitRscEditInputLen = {
	_arrText = toArray (ctrlText (_this select 0));

	for "_i" from 0 to ((count _arrText) - 1) do {
		if ((daylight_arrInputWhitelist find (_arrText select _i)) == -1) then {
			_arrText set [_i, -1];
		};
	};

	_arrText = _arrText - [-1];
	_strText = toString _arrText;

	if ((_strText call daylight_fnc_strLen) > (_this select 1)) then {
		(_this select 0) ctrlSetText ([_strText, (_this select 1)] call daylight_fnc_strResize);
	} else {
		(_this select 0) ctrlSetText _strText;
	};
};

/*
	Description:	Handle mouse button down
	Args:			arr [(from UIEH)]
	Return:			nothing
*/
daylight_fnc_handleMouseButtonDown = {
	switch (true) do {
		case ((_this select 1) == 0) : {
			daylight_iLastMouse1InputTime = time;
		};

		case ((_this select 1) == 1) : {
			daylight_iLastMouse2InputTime = time;

			// Cancel fishing
			if (daylight_bFishing) then {daylight_bFishing = false; hintSilent ""};
		};

		case ((_this select 1) == 2) : {
			daylight_iLastMouse3InputTime = time;
		};
	};
};

// Spawn code that adds our UI-EH's
[] spawn {
	disableSerialization;

	// Wait until main display becomes active
	waitUntil {!(isNull (findDisplay 46))};

	// Add UI-EH's
	(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call daylight_fnc_handleKeyDown"];
	(findDisplay 46) displayAddEventHandler ["MouseButtonDown", "_this call daylight_fnc_handleMouseButtonDown"];

	if (true) exitWith {};
};

/*
	Description:	Handle inventory exit with TAB key
	Args:			arr [(from UIEH)]
	Return:			nothing
*/
daylight_fnc_handleKeyDownInventoryExit = {
	_bDisableDefaultAction = false;

	if (((_this select 1) == 0x0F) && ((time - daylight_iLastInventoryOpenTime) >= 0.5)) then {
		_bDisableDefaultAction = true;

		closeDialog 0;

		daylight_iLastInventoryOpenTime = time;
	};

	if ((_this select 1) in (actionKeys "IngamePause")) then {
		_bDisableDefaultAction = true;

		if ((time - daylight_iLastInventoryOpenTime) >= 0.5) then {
			closeDialog 0;

			daylight_iLastInventoryOpenTime = time;
		};
	};

	_bDisableDefaultAction
};