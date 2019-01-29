/*
	Description:	Interaction functions
	Author:			qbt
*/

/*
	Description:	Introduce self
	Args:			obj cursorTarget
	Return:			nothing
*/
/*daylight_fnc_interactionIntroduceSelf = {
	// Get current var
	_arrIntroducedPlayerIDs = [player, "arrIntroducedPlayerIDsCivilian", [""]] call daylight_fnc_loadVar;

	// Check if cursorTarget already in authed players
	if (!([player, _this] call daylight_fnc_hasIntroducedTo)) then {
		_arrIntroducedPlayerIDs set [count _arrIntroducedPlayerIDs, getPlayerUID(_this)];

		// Update it
		[player, "arrIntroducedPlayerIDsCivilian", _arrIntroducedPlayerIDs] call daylight_fnc_saveVar;

		// Tell player introduction was successful
		["<t size=""2"">You've introduced yourself!</t>"] call daylight_fnc_showActionMsg; // TO-DO: Localize
	};
};*/

/*
	Description:	Open InteractionMenu UI
	Args:			obj cursorTarget
	Return:			nothing
*/
daylight_fnc_interactionOpenUI = {
	if (!dialog && !daylight_bRestrained && !daylight_bSurrendered && !daylight_bJailed && ((vehicle player) == player)) then {
		createDialog "InteractionMenu";

		daylight_vehInteractionCurrentPlayer = cursorTarget;

		while {(sliderRange 1900 select 1) != daylight_cfg_iMaxJailTimeByPolice} do {
			sliderSetPosition [1900, 1];
			sliderSetRange [1900, 1, daylight_cfg_iMaxJailTimeByPolice];
			sliderSetSpeed [1900, 0, 0];
		};

		// Set jail button text
		(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1704) ctrlSetText format[localize "STR_INTERACTIONMENU_BUTTON_JAILFOR", round(sliderPosition 1900)];

		// Disable buttons that we cant use depending on cursorTarget state
		_arrState = daylight_vehInteractionCurrentPlayer getVariable "daylight_arrState";

		if (((_arrState select 0) == 0) && ((_arrState select 1) == 0) && ((_arrState select 2) == 0) && !daylight_bGiveTicketDialogOpen) then {
			ctrlEnable [1701, false];
			ctrlEnable [1702, false];
			ctrlEnable [1703, false];
			ctrlEnable [1704, false];
			ctrlEnable [1706, false];

			ctrlEnable [1900, false];
		};

		// Monitor dialog and close it if target gets too far away
		[] spawn daylight_fnc_interactionUIMonitor;
	};
};

/*
	Description:	Monitor InteractionMenu UI
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_interactionUIMonitor = {
	while {((player distance daylight_vehInteractionCurrentPlayer) < daylight_cfg_iMaxDistanceFromInteractedUnit) && daylight_bDialogInteractionMenuOpen} do {
		// Disable buttons that we cant use depending on cursorTarget state
		_arrState = daylight_vehInteractionCurrentPlayer getVariable "daylight_arrState";
		_bEnable = false;
		if (((_arrState select 0) == 1) || ((_arrState select 1) == 1) && ((_arrState select 2) == 0)) then {
			_bEnable = true;
		};

		if (daylight_bDialogInteractionMenuOpen && !daylight_bGiveTicketDialogOpen) then {
			ctrlEnable [1701, _bEnable];
			ctrlEnable [1702, _bEnable];
			ctrlEnable [1703, _bEnable];
			ctrlEnable [1704, _bEnable];
			ctrlEnable [1706, _bEnable];

			ctrlEnable [1900, _bEnable];
		};

		sliderSetSpeed [1900, 1, 1];

		sleep 0.25;
	};

	// Show notification
	if (daylight_bDialogInteractionMenuOpen && ((time - daylight_iLastJailPlayerTime) > 1)) then {
		[localize "STR_INTERACTION_MENU_TITLE", localize "STR_INTERACTION_MENU_TARGETTOOFAR", true] call daylight_fnc_showHint;
	};

	// Double close dialog (if player has 2 windows open)
	while {daylight_bDialogInteractionMenuOpen} do {
		closeDialog 0;

		sleep 0.01;
	};

	if (true) exitWith {};
};

/*
	Description:	Body search RETURN
	Args:			arr [obj searched, arr inventory]
	Return:			nothing
*/
daylight_fnc_interactionBodySearchReturn = {
	createDialog "BodySearchReturn";

	// Set title, localize
	ctrlSetText [1000, format["Inventory of %1", name (_this select 0)]];

	lbAdd [1500, "[Items]"];
	// Populate inventory item list from inventory array
	for "_i" from 0 to ((count (_this select 1)) - 1) do {
		// Get item ID and amount from the current array
		_iItemID = ((_this select 1) select _i) select 0;
		_iItemAmount = ((_this select 1) select _i) select 1;

		_strItemText = format["		%1x %2", _iItemAmount, ((_iItemID call daylight_fnc_invIDToStr) select 0)];

		lbAdd [1500, _strItemText];

		// If item is in illegal ID's range, set text color to red
		if ((_iItemID >= (daylight_cfg_arrInvIllegalIDRange select 0)) && (_iItemID <= (daylight_cfg_arrInvIllegalIDRange select 1))) then {
			lbSetColor[1500, _i, [1, 0, 0, 1]];
		};
	};

	if ((count (_this select 1)) == 0) then {
		lbAdd [1500, "	No items to show."];
	};

	_arrLicenses = [daylight_objCurrentPoliceMenuPlayer, format["arrLicenses%1", daylight_objCurrentPoliceMenuPlayer call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

	lbAdd [1500, ""];
	lbAdd [1500, "[Licenses]"];

	if ((count _arrLicenses) > 0) then {
		for "_i" from 0 to ((count _arrLicenses) - 1) do {
			_strLicense = _arrLicenses select _i;

			lbAdd [1500, format["	%1", _strLicense]];
		};
	} else {
		lbAdd [1500, "	No licenses to show."];
	};
};

/*
	Description:	Restrain self
	Args:			obj restrainer
	Return:			nothing
*/
daylight_fnc_interactionRestrainToggle = {
	if (!daylight_bRestrained) then {
		// Set player state as restrained
		[player, [0, 1, -1]] call daylight_fnc_handlePlayerState;
		daylight_bRestrained = true;
		daylight_bSurrendered = false;

		// Play sound
		[player, 6] call daylight_fnc_networkSay3D;
		playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select 8));

		// Reset anim
		player playMoveNow "";
		player switchMove "";
		[player, ""] call daylight_fnc_networkSwitchMove;

		// Show notification
		[localize "STR_INTERACTION_MENU_RESTRAINED_TITLE", format[localize "STR_INTERACTION_MENU_RESTRAINED", name(_this)], true] call daylight_fnc_showHint;

		while {((player distance _this) <= daylight_cfg_iMaxRestrainerDistanceFromRestrainee) && (((player getVariable "daylight_arrState") select 1) == 1)} do {
			player playMove "amovpercmstpsnonwnondnon_ease";

			waitUntil {((animationState player) != "amovpercmstpsnonwnondnon_ease" || (((player getVariable "daylight_arrState") select 1) == 0))};
		};

		player playMoveNow "amovpercmstpsnonwnondnon_easeout";

		if ((player distance _this) > daylight_cfg_iMaxRestrainerDistanceFromRestrainee) then {
			// Set player state as unrestrained
			[player, [0, 0, -1]] call daylight_fnc_handlePlayerState;
			daylight_bRestrained = false;

			// Show notification
			[localize "STR_INTERACTION_MENU_UNRESTRAINED_TITLE", localize "STR_INTERACTION_MENU_UNRESTRAINED_BROKEFREE", true] call daylight_fnc_showHint;
		};
	} else {
		// Set player state as unrestrained
		[player, [0, 0, -1]] call daylight_fnc_handlePlayerState;
		daylight_bRestrained = false;

		// Play sound
		[player, 7] call daylight_fnc_networkSay3D;
		playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select 9));

		// Show notification
		[localize "STR_INTERACTION_MENU_UNRESTRAINED_TITLE", format[localize "STR_INTERACTION_MENU_UNRESTRAINED", name(_this)], true] call daylight_fnc_showHint;
	
		// Add weapons
		if ((count daylight_arrSurrenderWeaponsPlaceholder) > 0) then {
			{if (_x != "") then {player addWeapon _x}} forEach [daylight_arrSurrenderWeaponsPlaceholder select 0, daylight_arrSurrenderWeaponsPlaceholder select 2, daylight_arrSurrenderWeaponsPlaceholder select 4];

			{if (_x != "") then {player addPrimaryWeaponItem _x}} forEach (daylight_arrSurrenderWeaponsPlaceholder select 1);
			{if (_x != "") then {player addHandgunItem _x}} forEach (daylight_arrSurrenderWeaponsPlaceholder select 3);

			player selectWeapon daylight_strSurrenderWeaponsPlaceholderCurrentWeapon;
		};
	};

	if (true) exitWith {};
};

/*
	Description:	Surrender toggle
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_interactionSurrenderToggle = {
	if (!daylight_bRestrained && !daylight_bJailed && ((vehicle player) == player) && (daylight_iStunValue < 4)) then {
		if (!daylight_bSurrendered) then {
			// Set player state as surrendered
			[player, [1, 0, -1]] call daylight_fnc_handlePlayerState;
			daylight_bSurrendered = true;

			// Remove weapons
			daylight_arrSurrenderWeaponsPlaceholder = [
				primaryWeapon player,
				primaryWeaponItems player,
				handgunWeapon player,
				handgunItems player,
				secondaryWeapon player
			];

			{player removeWeapon _x} forEach (weapons player);

			daylight_strSurrenderWeaponsPlaceholderCurrentWeapon = currentWeapon player;

			// Play surrender animation
			[player, "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon"] call daylight_fnc_networkSwitchMove;

			[] spawn {
				sleep 0.25;

				while {daylight_bSurrendered} do {
					if ((["amovpercmstpssurwnondnon", "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon", "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon"] find (animationState player)) == -1) then {
						[player, "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon"] call daylight_fnc_networkSwitchMove;
					};

					sleep 0.5;
				};

				// Play un-surrender animation if in jail
				if (daylight_bJailed) then {
					if ((["amovpercmstpssurwnondnon", "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon", "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon"] find (animationState player)) != -1) then {
						[player, "amovpercmstpssurwnondnon_amovpercmstpsnonwnondnon"] call daylight_fnc_networkSwitchMove;
					};
				};

				if (true) exitWith {};
			};
		} else {
			// Set player state as not surrendered
			[player, [0, 0, -1]] call daylight_fnc_handlePlayerState;
			daylight_bSurrendered = false;

			// Play un-surrender animation
			[player, "amovpercmstpssurwnondnon_amovpercmstpsnonwnondnon"] call daylight_fnc_networkSwitchMove;

			// Add weapons
			if ((count daylight_arrSurrenderWeaponsPlaceholder) > 0) then {
				{if (_x != "") then {player addWeapon _x}} forEach [daylight_arrSurrenderWeaponsPlaceholder select 0, daylight_arrSurrenderWeaponsPlaceholder select 2, daylight_arrSurrenderWeaponsPlaceholder select 4];

				{if (_x != "") then {player addPrimaryWeaponItem _x}} forEach (daylight_arrSurrenderWeaponsPlaceholder select 1);
				{if (_x != "") then {player addHandgunItem _x}} forEach (daylight_arrSurrenderWeaponsPlaceholder select 3);

				player selectWeapon daylight_strSurrenderWeaponsPlaceholderCurrentWeapon;
			};
		};
	};
};

/*
	Description:	Open give ticket UI
	Args:			arr [veh ticketer, i amount, str reason]
	Return:			nothing
*/
daylight_fnc_interactionOpenGiveTicketUI = {
	createDialog "GiveTicket";

	[] spawn daylight_fnc_interactionUpdateGiveTicketUI;

	((uiNamespace getVariable "daylight_dsplActive") displayCtrl 1100) ctrlSetStructuredText (parseText(format[localize "STR_INTERACTION_MENU_GIVETICKET_INFORMATION", name(daylight_vehInteractionCurrentPlayer)]));
};

/*
	Description:	Update give ticket UI 
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_interactionUpdateGiveTicketUI = {
	waitUntil {daylight_bGiveTicketDialogOpen};

	while {daylight_bGiveTicketDialogOpen} do {
		_iAmount = abs(parseNumber(ctrlText 1401));
		_strReason = ctrlText 1400;

		if ((_iAmount == 0) || ((count ((toArray (ctrlText 1400)) - [32])) == 0)) then {
			ctrlEnable [1700, false];
		} else {
			ctrlEnable [1700, true];
		};

		sleep 0.05;
	};

	if (true) exitWith {};
};

/*
	Description:	Open pay ticket UI
	Args:			arr [veh ticketer, i amount, str reason]
	Return:			nothing
*/
daylight_fnc_interactionOpenPayTicketUI = {
	createDialog "PayTicket";

	daylight_vehCurrentTicketer = (_this select 0);
	daylight_iCurrentTicketAmount = (_this select 1);

	// Disable button if not enough cash
	// Check if player has enough money in inventory or in bank if not in inv entory
	_bHasMoney = false;

	if (([daylight_cfg_iInvMoneyID, daylight_iCurrentTicketAmount] call daylight_fnc_invCheckAmount) >= daylight_iCurrentTicketAmount) then {
		_bHasMoney = true;
	} else {
		_iMoneyBank = [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
		
		if (_iMoneyBank >= daylight_iCurrentTicketAmount) then {
			_bHasMoney = true;
		};
	};

	if (!_bHasMoney) then {
		ctrlEnable [1700, false];
	};

	// Set structured text
	((uiNamespace getVariable "daylight_dsplActive") displayCtrl 1100) ctrlSetStructuredText (parseText(format[localize "STR_TICKET_QUESTION_MESSAGE", name((_this select 0)), (_this select 1), localize "STR_CURRENCY", (_this select 2)]));
};

/*
	Description:	Give ticket
	Args:			arr [veh player to give ticket to, i amount, str reason]
	Return:			nothing
*/
daylight_fnc_interactionGiveTicket = {
	[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_INTERACTION_MENU_GAVETICKET", (_this select 1), localize "STR_CURRENCY", name(_this select 0)], true] call daylight_fnc_showHint;

	_this call daylight_fnc_networkGiveTicket;

	format["Officer %1 gave a ticket of %2%3 to %4 (%5).", name player, (_this select 1), localize "STR_CURRENCY", name (_this select 0), (_this select 2)] call daylight_fnc_networkChatNotification;
};

/*
	Description:	Pay ticket
	Args:			bool pay
	Return:			nothing
*/
daylight_fnc_interactionPayTicket = {
	if (_this) then {
		// Check if player has enough money in inventory or in bank if not in inv entory
		if (([daylight_cfg_iInvMoneyID, daylight_iCurrentTicketAmount] call daylight_fnc_invCheckAmount) >= daylight_iCurrentTicketAmount) then {
			// Remove money from inventory
			[daylight_cfg_iInvMoneyID, daylight_iCurrentTicketAmount] call daylight_fnc_invRemoveItem;

			[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_INTERACTION_MENU_PAIDTICKET", daylight_iCurrentTicketAmount, localize "STR_CURRENCY", name(daylight_vehCurrentTicketer)], true] call daylight_fnc_showHint;
		} else {
			_iMoneyBank = [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
			
			// Minus cost from current amount
			_iMoneyBank = _iMoneyBank - daylight_iCurrentTicketAmount;

			// Update bank money amount
			[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], _iMoneyBank] call daylight_fnc_saveVar;

			[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_INTERACTION_MENU_PAIDTICKET_BANK", daylight_iCurrentTicketAmount, localize "STR_CURRENCY", name(daylight_vehCurrentTicketer)], true] call daylight_fnc_showHint;
		};

		daylight_iCurrentTicketAmount call daylight_fnc_jailShareMoneyBLUFOR;

		// Reset bounty
		[player, format["iBounty%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_saveVar;

		_strVariable = format["arrWanted%1", player call daylight_fnc_returnSideStringForSavedVariables];

		// Update variable
		[player, _strVariable, []] call daylight_fnc_saveVar;

		// Show message
		format["%1 paid the ticket of %2%3.", name player, daylight_iCurrentTicketAmount, localize "STR_CURRENCY"] call daylight_fnc_networkChatNotification;
	} else {
		[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_INTERACTION_MENU_DIDNOTPAYTICKET", daylight_iCurrentTicketAmount, localize "STR_CURRENCY", name(daylight_vehCurrentTicketer)], true] call daylight_fnc_showHint;

		format["%1 didn't pay the ticket of %2%3.", name player, daylight_iCurrentTicketAmount, localize "STR_CURRENCY"] call daylight_fnc_networkChatNotification;
	};

	[daylight_vehCurrentTicketer, _this] call daylight_fnc_networkReturnTicket;
};

/*
	Description:	Handle ticket response
	Args:			arr [veh ticketed, b response]
	Return:			nothing
*/
daylight_fnc_interactionHandleTicketResponse = {
	if ((_this select 2)) then {
		[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_INTERACTION_MENU_PAIDTICKET_RESPONSE", name((_this select 0)), daylight_iCurrentTicketAmount, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;
	} else {
		[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_INTERACTION_MENU_DIDNOTPAYTICKET_RESPONSE", name((_this select 0)), daylight_iCurrentTicketAmount, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;
	};
};

/*
	Description:	Remove illegal items
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_interactionRemoveIllegalItems = {
	// Localize
	daylight_bActionBusy = true;

	["Removing illegal items ..", 0.5] call daylight_fnc_progressBarCreate;
	[1, 8.7] call daylight_fnc_progressBarSetProgress;

	// Play sound
	[player, 22, false] call daylight_fnc_networkSay3D;
	//playSound "180686_dapperdaniel_rummaging_through_luggage_0_local";

	sleep 8.7;

	1 call daylight_fnc_progressBarClose;

	daylight_bActionBusy = false;

	sleep 0.1;

	daylight_vehInteractionCurrentPlayer call daylight_fnc_networkRemoveIllegalItems;

	[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_INTERACTION_MENU_ILLEGALITEMSREMOVED", name(daylight_vehInteractionCurrentPlayer)], true] call daylight_fnc_showHint;

	if (true) exitWith {};
};

/*
	Description:	Remove illegal items (local)
	Args:			veh player who wanted to remove illegal items
	Return:			nothing
*/
daylight_fnc_interactionRemoveIllegalItemsLocal = {
	// Remove illegal items
	_iIllegalItemsCount = 0;

	_iTotalProfit = 0;

	for "_i" from 0 to ((count daylight_arrInventory) - 1) do {
		// Get item ID and amount from the current array
		_iItemID = (daylight_arrInventory select _i) select 0;
		_iItemAmount = (daylight_arrInventory select _i) select 1;

		// If item is in illegal ID's range, set text color to red
		if ((_iItemID >= (daylight_cfg_arrInvIllegalIDRange select 0)) && (_iItemID <= (daylight_cfg_arrInvIllegalIDRange select 1))) then {
			daylight_arrInventory set [_i, -1];

			_iIllegalItemsCount = _iIllegalItemsCount + 1;

			// Get item price
			_iProfit = [_iItemID, _iItemAmount] call daylight_fnc_shopCalculateTotalProfit;

			_iTotalProfit = _iTotalProfit + _iProfit;
		};
	};

	daylight_arrInventory = daylight_arrInventory - [-1];

	// Show notification if player was carrying illegal items
	if (_iIllegalItemsCount != 0) then {
		[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_INTERACTION_MENU_ILLEGALITEMSREMOVEDBY", name(_this)], true] call daylight_fnc_showHint;

		[player, "Posession of illegal items", round _iTotalProfit] call daylight_fnc_jailSetWanted;
	};
};

/*
	Description:	Handle interact key
	Args:			obj cursorTarget
	Return:			nothing
*/
daylight_fnc_handleInteractKey = {
	_bDisableDefaultAction = false;

	if ((player distance _this) < daylight_cfg_iMaxDistanceFromInteractedUnit) then {
		// Merchant
		if ((daylight_arrMerchants find _this) != -1) exitWith {
			_this call daylight_fnc_shopOpenUI;

			_bDisableDefaultAction = true;
		};

		// Vehicle shop
		if ((daylight_arrVehicleShops find _this) != -1) exitWith {
			_this call daylight_fnc_shopVehicleOpenUI;

			_bDisableDefaultAction = true;
		};

		// Gear shop
		if ((daylight_arrGearShops find _this) != -1) exitWith {
			_this call daylight_fnc_shopGearOpenUI;

			_bDisableDefaultAction = true;
		};

		// Impound officer
		if ((daylight_arrImpoundOfficers find _this) != -1) exitWith {
			_this call daylight_fnc_impoundReturnOpenUI;

			_bDisableDefaultAction = true;
		};

		// License seller
		if ((daylight_arrLicenseSellers find _this) != -1) exitWith {
			_this call daylight_fnc_licensesBuyOpenUI;

			_bDisableDefaultAction = true;
		};

		// Process unit
		if ((daylight_arrProcessUnits find _this) != -1) exitWith {
			(daylight_arrProcessUnits find _this) call daylight_fnc_processProcessItemsOpenUI;

			_bDisableDefaultAction = true;
		};

		// Vote unit
		if ((daylight_arrVoteUnits find _this) != -1) exitWith {
			_this call daylight_fnc_presidentAddVoteOpenUI;

			_bDisableDefaultAction = true;
		};

		// Autobounty merchant
		if ((daylight_arrMerchantsAutoBounty find _this) != -1) exitWith {
			(daylight_arrMerchantsAutoBounty find _this) call daylight_fnc_shopAutoBountyOpenUI;

			_bDisableDefaultAction = true;
		};

		// Autobounty merchant
		if ((daylight_arrWreckingYards find _this) != -1) exitWith {
			call daylight_fnc_wreckingYardOpenUI;

			_bDisableDefaultAction = true;
		};

		// Player
		if (isPlayer (vehicle _this) && ((vehicle _this) isKindOf "CAManBase") && (playerSide == blufor)) exitWith {
			_this call daylight_fnc_interactionOpenUI;

			_bDisableDefaultAction = true;
		};

		// Vehicle
		if (((vehicle _this) isKindOf "AllVehicles") && !((vehicle _this) isKindOf "CAManBase") && (playerSide == blufor)) exitWith {
			(vehicle _this) call daylight_fnc_interactionVehicleOpenUI;

			_bDisableDefaultAction = true;
		};
	};

	// ATM
	_strNearestATM = [player, ["mrkATM_1", "mrkATM_2", "mrkATM_3", "mrkATM_4", "mrkATM_5", "mrkATM_6"]] call daylight_fnc_getNearestMarker;

	if ((player distance (getMarkerPos _strNearestATM)) <= 1.5) exitWith {
		true call daylight_fnc_bankOpenUI;
	};
};

/*
	Description:	Open InteractionMenuVehicle UI
	Args:			obj cursorTarget
	Return:			nothing
*/
daylight_fnc_interactionVehicleOpenUI = {
	if (!dialog && !daylight_bRestrained && !daylight_bSurrendered && !daylight_bJailed && ((vehicle player) == player)) then {
		createDialog "InteractionMenuVehicle";

		daylight_vehInteractionCurrentVehicle = cursorTarget;

		// Print out vehicle info
		lbAdd [1500, "[Vehicle information]"];
		lbAdd [1500, format["	Type: %1", getText(configFile >> "CfgVehicles" >> typeOf _this >> "displayName")]];
		lbAdd [1500, format["	License plate: %1", "(not implemented)"]];
		lbAdd [1500, ""];
		lbAdd [1500, "[Key owners]"];

		_iCount = 0;
		for "_i" from 0 to ((count playableUnits) - 1) do {
			_objCurrentUnit = (playableUnits select _i);

			_arrKeys = [_objCurrentUnit, format["arrKeys%1", _objCurrentUnit call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

			if ((_arrKeys find _this) != -1) then {
				lbAdd [1500, format["	%1", name _objCurrentUnit]];

				_iCount = _iCount + 1;
			};
		};

		if (_iCount == 0) then {
			lbAdd [1500, "	No owners to show."]
		}
	};
};

/*
	Description:	Trunk search RETURN
	Args:			obj searched
	Return:			nothing
*/
daylight_fnc_interactionVehicleTrunkSearchReturn = {
	createDialog "BodySearchReturn";

	// Set title, localize
	ctrlSetText [1000, format["Inventory of %1", getText(configFile >> "CfgVehicles" >> typeOf _this >> "displayName")]];

	lbAdd [1500, "[Items]"];

	// Populate inventory item list from inventory array
	_arrTrunk = _this getVariable ["daylight_arrTrunk", []];

	for "_i" from 0 to ((count _arrTrunk) - 1) do {
		// Get item ID and amount from the current array
		_iItemID = (_arrTrunk select _i) select 0;
		_iItemAmount = (_arrTrunk select _i) select 1;

		_strItemText = format["	%1x %2", _iItemAmount, ((_iItemID call daylight_fnc_invIDToStr) select 0)];

		lbAdd [1500, _strItemText];

		// If item is in illegal ID's range, set text color to red
		if ((_iItemID >= (daylight_cfg_arrInvIllegalIDRange select 0)) && (_iItemID <= (daylight_cfg_arrInvIllegalIDRange select 1))) then {
			lbSetColor [1500, _i, [1, 0, 0, 1]];
		};
	};

	if ((count _arrTrunk) == 0) then {
		lbAdd [1500, "	No items to show."];
	};
};

/*
	Description:	Remove vehicle illegal items
	Args:			obj vehicle
	Return:			nothing
*/
daylight_fnc_interactionVehicleRemoveIllegalItems = {
	// Localize
	daylight_bActionBusy = true;

	["Removing illegal items ..", 0.5] call daylight_fnc_progressBarCreate;
	[1, 6.7] call daylight_fnc_progressBarSetProgress;

	// Play sound
	[player, 23, false] call daylight_fnc_networkSay3D;
	playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select 25));

	sleep 6.7;

	1 call daylight_fnc_progressBarClose;

	daylight_bActionBusy = false;

	sleep 0.1;

	// Remove illegal items
	_arrTrunk = _this getVariable ["daylight_arrTrunk", []];

	_iIllegalItemsCount = 0;
	for "_i" from 0 to ((count _arrTrunk) - 1) do {
		// Get item ID and amount from the current array
		_iItemID = (_arrTrunk select _i) select 0;

		// If item is in illegal ID's range, set text color to red
		if ((_iItemID >= (daylight_cfg_arrInvIllegalIDRange select 0)) && (_iItemID <= (daylight_cfg_arrInvIllegalIDRange select 1))) then {
			_arrTrunk set [_i, -1];

			_iIllegalItemsCount = _iIllegalItemsCount + 1;
		};
	};

	_arrTrunk = _arrTrunk - [-1];

	_this setVariable ["daylight_arrTrunk", _arrTrunk, true];

	[localize "STR_INTERACTION_MENU_TITLE", format[localize "STR_INTERACTION_MENU_ILLEGALITEMSREMOVED_VEH", getText(configFile >> "CfgVehicles" >> typeOf _this >> "displayName")], true] call daylight_fnc_showHint;

	if (true) exitWith {};
};