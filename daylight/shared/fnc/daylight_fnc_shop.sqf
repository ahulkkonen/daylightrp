/*
	Description:	Shop functions
	Author:			qbt
*/

/*
	Description:	Spawn merchants from cfgShops
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_shopSpawnMerchants = {
	daylight_arrMerchants = [];
	daylight_arrMerchantsAutoBounty = [];

	_grpMerchants = createGroup civilian;

	{
		_untMerchant = _grpMerchants createUnit [(_x select 0) select 0, [0, 0, 0], [], 0, "NONE"];

		_untMerchant setVariable ["daylight_arrInitialPos", (_x select 3)];

		_untMerchant enableSimulation false;
		_untMerchant allowDamage false;

		_untMerchant addEventHandler ["HandleDamage", {
			(_this select 0) setVelocity [0, 0, 0];

			_arrPos = (_this select 0) getVariable "daylight_arrInitialPos";

			if (((_this select 0) distance _arrPos) > 5) then {
				(_this select 0) setPosATL ((_this select 0) getVariable "daylight_arrInitialPos");
			};

			(_this select 0) switchMove "";
		}];

		{_untMerchant disableAI _x} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		_untMerchant setSkill 0;

		removeBackpack _untMerchant;
		removeHeadgear _untMerchant;
		removeGoggles _untMerchant;

		_untMerchant setFace ((_x select 0) select 1);
		_untMerchant addHeadgear ((_x select 0) select 2);
		_untMerchant addGoggles ((_x select 0) select 3);
		_untMerchant addUniform ((_x select 0) select 4);
		_untMerchant addVest ((_x select 0) select 5);

		_untMerchant switchMove "";

		_untMerchant setPosATL (_x select 4);
		_untMerchant setDir (_x select 5);

		_untMerchant setVariable ["daylight_arrMerchantInfo", [_x select 1, _x select 2, _x select 3, _x select 6, _x select 7, _x select 8], true];

		// If shop has gear items, spawn gear box
		_arrItems = _x select 2;
		_bSpawnGearBox = false;

		{
			if (([daylight_cfg_arrGearItems, _x select 0] call daylight_fnc_findVariableInNestedArray) != -1) then {
				_bSpawnGearBox = true;
			};
		} forEach _arrItems;

		if (_bSpawnGearBox) then {
			_vehVehicle = createVehicle [daylight_cfg_strAmmoBoxClassName, [0, 0, 0], [], 0, "NONE"];

			_vehVehicle allowDamage false;
			
			clearWeaponCargoGlobal _vehVehicle;
			clearMagazineCargoGlobal _vehVehicle;

			_vehVehicle setDir (_x select 10);
			_vehVehicle setPosATL (_x select 9);
		};

		daylight_arrMerchants set [count daylight_arrMerchants, _untMerchant];
	} forEach daylight_cfg_arrMerchants;

	publicVariable "daylight_arrMerchants";

	{
		_untMerchant = _grpMerchants createUnit [(_x select 0) select 0, [0, 0, 0], [], 0, "NONE"];

		_untMerchant setVariable ["daylight_arrInitialPos", (_x select 3)];

		_untMerchant enableSimulation false;
		_untMerchant allowDamage false;

		_untMerchant addEventHandler ["HandleDamage", {
			(_this select 0) setVelocity [0, 0, 0];

			_arrPos = (_this select 0) getVariable "daylight_arrInitialPos";

			if (((_this select 0) distance _arrPos) > 5) then {
				(_this select 0) setPosATL ((_this select 0) getVariable "daylight_arrInitialPos");
			};

			(_this select 0) switchMove "";
		}];

		{_untMerchant disableAI _x} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		_untMerchant setSkill 0;

		removeBackpack _untMerchant;
		removeHeadgear _untMerchant;
		removeGoggles _untMerchant;

		_untMerchant setFace ((_x select 0) select 1);
		_untMerchant addHeadgear ((_x select 0) select 2);
		_untMerchant addGoggles ((_x select 0) select 3);
		_untMerchant addUniform ((_x select 0) select 4);
		_untMerchant addVest ((_x select 0) select 5);

		_untMerchant switchMove "";

		_untMerchant setPosATL (_x select 3);
		_untMerchant setDir (_x select 4);

		//_untMerchant setVariable ["daylight_arrMerchantInfo", [_x select 1, _x select 2, _x select 3, _x select 6, _x select 7, _x select 8], true];
		_untMerchant setVariable ["daylight_arrSoldItems", [], false];

		daylight_arrMerchantsAutoBounty set [count daylight_arrMerchantsAutoBounty, _untMerchant];
	} forEach daylight_cfg_arrMerchantsAutoBounty;

	publicVariable "daylight_arrMerchantsAutoBounty";
};

/*
	Description:	Spawn vehicle shops from cfgShops
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_shopSpawnVehicleShops = {
	daylight_arrVehicleShops = [];

	_grpMerchants = createGroup civilian;

	{
		_untMerchant = _grpMerchants createUnit [(_x select 0) select 0, [0, 0, 0], [], 0, "NONE"];

		_untMerchant setVariable ["daylight_arrInitialPos", (_x select 3)];

		_untMerchant enableSimulation false;
		_untMerchant allowDamage false;

		_untMerchant addEventHandler ["HandleDamage", {
			(_this select 0) setVelocity [0, 0, 0];

			_arrPos = (_this select 0) getVariable "daylight_arrInitialPos";

			if (((_this select 0) distance _arrPos) > 5) then {
				(_this select 0) setPosATL ((_this select 0) getVariable "daylight_arrInitialPos");
			};

			(_this select 0) switchMove "";
		}];

		{_untMerchant disableAI _x} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		_untMerchant setSkill 0;

		removeBackpack _untMerchant;
		_untMerchant setFace ((_x select 0) select 1);
		_untMerchant addHeadgear ((_x select 0) select 2);
		_untMerchant addGoggles ((_x select 0) select 3);
		_untMerchant addUniform ((_x select 0) select 4);
		_untMerchant addVest ((_x select 0) select 5);

		_untMerchant switchMove "";

		_untMerchant setPosATL (_x select 5);
		_untMerchant setDir (_x select 6);

		_untMerchant setVariable ["daylight_arrVehicleShopInfo", [_x select 1, _x select 2, _x select 3, _x select 4, _x select 7, _x select 8], true];

		daylight_arrVehicleShops set [count daylight_arrVehicleShops, _untMerchant];
	} forEach daylight_cfg_arrVehicleShops;

	publicVariable "daylight_arrVehicleShops";
};

/*
	Description:	Open shop UI
	Args:			veh cursorTarget
	Return:			nothing
*/
daylight_fnc_shopOpenUI = {
	if (!dialog) then {
		_arrCur = _this getVariable "daylight_arrMerchantInfo";

		_strShopName = _arrCur select 0;
		_arrSides = _arrCur select 4;
		_strNeededLicense = _arrCur select 5;

		if ((side player) in _arrSides) then {
			if ((_strNeededLicense == "") || ([player, _strNeededLicense] call daylight_fnc_licensesHasLicenseStr)) then {
				_bContinue = true;

				// Check for gang area
				_strNearestMarker = [_this, daylight_cfg_arrGangAreas] call daylight_fnc_getNearestMarker;

				if ((_this distance (getMarkerPos _strNearestMarker)) <= 25) then {
					// Is gang area, check if in gang
					_vehGangFlag = (nearestObjects [getMarkerPos _strNearestMarker, ["Flag_White_F"], 50]) select 0;

					_strOwnerGang = _vehGangFlag getVariable ["daylight_strGangAreaOwner", ""];
					_strCurrentGang = [player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_loadVar;

					if ((_strOwnerGang != _strCurrentGang) || (_strOwnerGang == "")) then {
						[_strShopName, localize "STR_SHOP_WRONGGANG", true] call daylight_fnc_showHint;

						_bContinue = false;
					};
				};

				if (_bContinue) then {
					createDialog "Shop";

					// Set current merchant
					daylight_vehCurrentMerchant = _this;

					// Spawn loop that updates UI
					[] spawn daylight_fnc_shopUpdateUI;

					// Update main title
					ctrlSetText [1002, (_this getVariable "daylight_arrMerchantInfo") select 0];
				};
			} else {
				[_strShopName, format [localize "STR_SHOP_MESSAGE_NOLICENSE", _strNeededLicense], true] call daylight_fnc_showHint;
			};
		} else {
			[_strShopName, localize "STR_SHOP_MESSAGE_WRONGSIDE", true] call daylight_fnc_showHint;
		};

		/*// Update current carried weight
		ctrlSetText [1001, format["Items (%1/%2kg)", round daylight_iInventoryWeight, daylight_cfg_iInvMaxCarryWeight]];

		_arrMerchantInfo = daylight_vehCurrentMerchant getVariable "daylight_arrMerchantInfo";

		// Populate inv item list
		_iX = 0;
		for "_i" from 0 to (count(daylight_arrInventory) - 1) do {
			// Get item ID and amount from the current array
			_iItemID = (daylight_arrInventory select _i) select 0;
			_iItemAmount = (daylight_arrInventory select _i) select 1;

			// Add item to list if we can sell it
			if (((((_arrMerchantInfo) select 2) find _iItemID) != -1) || (_iItemID == daylight_cfg_iInvMoneyID)) then {
				// Different text if the amount is more than 1 or -1
				_strItemText = format["%1x %2 (%3%4 / %5%6)", _iItemAmount, (_iItemID call daylight_fnc_invIDToStr) select 0, round ([_iItemID, _iItemAmount] call daylight_fnc_invGetItemWeight), localize "STR_WEIGHT_UNIT", [_iItemID, 1] call daylight_fnc_shopCalculateTotalProfit, localize "STR_CURRENCY"];

				lbAdd[1500, _strItemText];

				// Attach item ID data to lbItem
				lbSetData[1500, _iX, str(_iItemID)];

				// If item is in illegal ID's range, set text color to red
				if ((_iItemID >= (daylight_cfg_arrInvIllegalIDRange select 0)) && (_iItemID <= (daylight_cfg_arrInvIllegalIDRange select 1))) then {
					lbSetColor[1500, _iX, [1, 0, 0, 1]];
				};

				_iX = _iX + 1;
			};
		};

		lbSetCurSel [1500, 0];

		// Populate shop item list
		_arrShop = ((_this getVariable "daylight_arrMerchantInfo") select 1);
		for "_i" from 0 to (count(_arrShop) - 1) do {
			// Get item ID and amount from the current array
			_iItemID = (_arrShop select _i) select 0;
			_iItemAmount = (_arrShop select _i) select 1;

			// Get item text
			_strItemText = format["%1x %2 (%3%4 / %5%6)", _iItemAmount, ((_iItemID call daylight_fnc_invIDToStr) select 0), [_iItemID, 1] call daylight_fnc_invGetItemWeight, localize "STR_WEIGHT_UNIT", [_iItemID, 1] call daylight_fnc_shopCalculateTotalPrice, localize "STR_CURRENCY"];

			// Add item to list
			lbAdd[1501, _strItemText];

			// Attach item ID data to lbItem
			lbSetData[1501, _i, str(_iItemID)];

			// If item is in illegal ID's range, set text color to red
			if ((_iItemID >= (daylight_cfg_arrInvIllegalIDRange select 0)) && (_iItemID <= (daylight_cfg_arrInvIllegalIDRange select 1))) then {
				lbSetColor[1501, _i, [1, 0, 0, 1]];
			};
		};*/
	};
};

/*
	Description:	Update UI
	Args:			int lbCurSel OR nothing
	Return:			nothing
*/
daylight_fnc_shopUpdateUI = {
	if (count _this != 0) then {
		_iShopItemSelected = abs parseNumber((_this select 0) lbData (_this select 1));

		// Update description
		ctrlSetText [1004, format["%1", ((_iShopItemSelected call daylight_fnc_invIDToStr) select 1)]];
	} else {
		_iLastUpdateTimeMarked = 0;

		daylight_bTrunkOrShopButtonWaitForUpdate = true;

		_bFirstLoop = true;

		while {daylight_bDialogShopOpen} do {
			_arrMerchantInfo = daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ["", [], true]];
			_iLastUpdateTime = daylight_vehCurrentMerchant getVariable ["daylight_iLastUpdateTime", 0];

			// Update button texts
			if ((lbCurSel 1500) != -1) then {
				// Get parameters
				_iItemID = abs parseNumber(lbData [1500, lbCurSel 1500]);

				// Round the value so we don't remove decimal amount
				_iAmount = round(abs parseNumber(ctrlText 1400));

				_iRealAmount = [_iItemID, _iAmount] call daylight_fnc_invCheckAmount;

				_iProfit = [_iItemID, _iRealAmount] call daylight_fnc_shopCalculateTotalProfit;

				if (_iProfit > daylight_cfg_iMaxIntValue) then {
					_iProfit = daylight_cfg_iMaxIntValue;
				};

				(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1700) ctrlSetText (format[localize "STR_SHOP_BUTTON_SELL", round _iProfit, localize "STR_CURRENCY", round ([_iItemID, _iRealAmount] call daylight_fnc_invGetItemWeight), localize "STR_WEIGHT_UNIT"]);
			
				if (!daylight_bTrunkOrShopButtonWaitForUpdate) then {
					if ((lbSize 1500) > 0) then {
						ctrlEnable [1700, true];
					};
				};
			} else {
				(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1700) ctrlSetText (format[localize "STR_SHOP_BUTTON_SELL", 0, localize "STR_CURRENCY", 0, localize "STR_WEIGHT_UNIT"]);
			};

			if ((lbCurSel 1501) != -1) then {
				// Get parameters
				_iItemID = abs parseNumber(lbData [1501, lbCurSel 1501]);

				// Round the value so we don't remove decimal amount
				_iAmount = round(abs parseNumber(ctrlText 1401));

				_iRealAmount = [_iItemID, _iAmount] call daylight_fnc_shopCheckAmount;

				if (_iRealAmount == -1) then {
					_iRealAmount = 1;
				};

				_iCost = [_iItemID, _iRealAmount] call daylight_fnc_shopCalculateTotalPrice;
				if (_iCost > daylight_cfg_iMaxIntValue) then {
					_iCost = daylight_cfg_iMaxIntValue;
				};

				(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1701) ctrlSetText (format[localize "STR_SHOP_BUTTON_BUY", round _iCost, localize "STR_CURRENCY", round ([_iItemID, _iRealAmount] call daylight_fnc_invGetItemWeight), localize "STR_WEIGHT_UNIT"]);
			
				if (!daylight_bTrunkOrShopButtonWaitForUpdate) then {
					if ((lbSize 1501) > 0) then {
						ctrlEnable [1701, true];
					};
				};
			} else {
				(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1701) ctrlSetText (format[localize "STR_SHOP_BUTTON_BUY", 0, localize "STR_CURRENCY", 0, localize "STR_WEIGHT_UNIT"]);
			};

			if (daylight_bTrunkOrShopButtonWaitForUpdate) then {
				lbClear 1500;

				// Populate inv item list
				_iX = 0;
				for "_i" from 0 to (count(daylight_arrInventory) - 1) do {
					// Get item ID and amount from the current array
					_iItemID = (daylight_arrInventory select _i) select 0;
					_iItemAmount = (daylight_arrInventory select _i) select 1;

					// Add item to list if we can sell it
					if (((((_arrMerchantInfo) select 2) find _iItemID) != -1) || (_iItemID == daylight_cfg_iInvMoneyID)) then {
						_strItemText = format["%1x %2 (%3%4 / %5%6)", _iItemAmount, (_iItemID call daylight_fnc_invIDToStr) select 0, round ([_iItemID, _iItemAmount] call daylight_fnc_invGetItemWeight), localize "STR_WEIGHT_UNIT", [_iItemID, 1] call daylight_fnc_shopCalculateTotalProfit, localize "STR_CURRENCY"];
	
						lbAdd [1500, _strItemText];

						// Attach item ID data to lbItem
						lbSetData [1500, _iX, str(_iItemID)];

						// If item is in illegal ID's range, set text color to red
						if ((_iItemID >= (daylight_cfg_arrInvIllegalIDRange select 0)) && (_iItemID <= (daylight_cfg_arrInvIllegalIDRange select 1))) then {
							lbSetColor [1500, _iX, [1, 0, 0, 1]];
						};

						_iX = _iX + 1;
					};
				};

				if ((lbSize 1500) > 0) then {
					lbSetCurSel [1500, 0];
				};

				daylight_bTrunkOrShopButtonWaitForUpdate = false;
			};

			if ((_iLastUpdateTime != _iLastUpdateTimeMarked) || _bFirstLoop) then {
				lbClear 1501;

				// Populate shop item list
				_arrShop = (_arrMerchantInfo select 1);
				for "_i" from 0 to (count(_arrShop) - 1) do {
					// Get item ID and amount from the current array
					_iItemID = (_arrShop select _i) select 0;
					_iItemAmount = (_arrShop select _i) select 1;

					// Get item text
					_strItemText = format["%1x %2 (%3%4 / %5%6)", _iItemAmount, ((_iItemID call daylight_fnc_invIDToStr) select 0), [_iItemID, 1] call daylight_fnc_invGetItemWeight, localize "STR_WEIGHT_UNIT", [_iItemID, 1] call daylight_fnc_shopCalculateTotalPrice, localize "STR_CURRENCY"];

					// Different text if the amount is more than 1 or -1
					if (_iItemAmount == -1) then {
						_strItemText = format["%1 (%2%3 / %4%5)", (_iItemID call daylight_fnc_invIDToStr) select 0, round ([_iItemID, 1] call daylight_fnc_invGetItemWeight), localize "STR_WEIGHT_UNIT", [_iItemID, 1] call daylight_fnc_shopCalculateTotalPrice, localize "STR_CURRENCY"];
					};

					// Add item to list
					lbAdd [1501, _strItemText];

					// Attach item ID data to lbItem
					lbSetData [1501, _i, str(_iItemID)];

					// If item is in illegal ID's range, set text color to red
					if ((_iItemID >= (daylight_cfg_arrInvIllegalIDRange select 0)) && (_iItemID <= (daylight_cfg_arrInvIllegalIDRange select 1))) then {
						lbSetColor [1501, _i, [1, 0, 0, 1]];
					};
				};

				if ((lbSize 1501) < (lbCurSel 1501)) then {
					lbSetCurSel [1501, 0];
				};

				daylight_bTrunkOrShopButtonWaitForUpdate = false;

				_iLastUpdateTimeMarked = _iLastUpdateTime;

				_bFirstLoop = false;
			};

			if ((abs (parseNumber(ctrlText 1400)) >= 1) && ((lbSize 1500) > 0) && (lbCurSel 1500 != -1) && (((lbSize 1500) - 1) >= lbCurSel 1500)) then {
				ctrlEnable [1700, true];
			} else {
				ctrlEnable [1700, false];
			};

			if ((abs (parseNumber(ctrlText 1401)) >= 1) && ((lbSize 1501) > 0) && (lbCurSel 1501 != -1) && (((lbSize 1501) - 1) >= lbCurSel 1501)) then {
				ctrlEnable [1701, true];
			} else {
				ctrlEnable [1701, false];
			};

			sleep 0.25;
		};
	};

	if (true) exitWith {};
};

/*
	Description:	Buy item
	Args:			arr [int item id, int amount]
	Return:			nothing
*/
daylight_fnc_shopBuyItem = {
	_iID = (_this select 0);
	_iAmount = round(_this select 1);

	_iRealAmount = [_iID, _iAmount] call daylight_fnc_shopCheckAmount;
	_iTotalCost = [_iID, _iAmount] call daylight_fnc_shopCalculateTotalPrice;

	// Get money in inventory
	_iIndex = [daylight_arrInventory, daylight_cfg_iInvMoneyID] call daylight_fnc_findVariableInNestedArray;
	_iAmountInventory = 0;
	if (_iIndex != -1) then {
		_iAmountInventory = (daylight_arrInventory select _iIndex) select 1;
	};

	if (_iTotalCost <= _iAmountInventory) then {
		// Check if we can carry this much weight
		if ([([_iID, _iAmount] call daylight_fnc_invGetItemWeight)] call daylight_fnc_invCheckWeight) then {
			//closeDialog 0;

			ctrlEnable [1700, false];
			ctrlEnable [1701, false];

			// if stock is finite, remove
			if (_iRealAmount != -1) then {
				[_iID, _iRealAmount] call daylight_fnc_shopRemoveFrom;
			};
			
			// Weapon / magazine or item?
			_iIndexGearItem = [daylight_cfg_arrGearItems, _iID] call daylight_fnc_findVariableInNestedArray;

			if (_iIndexGearItem != -1) then {
				_arrNearestBoxes = nearestObjects [player, [daylight_cfg_strAmmoBoxClassName], 10];

				_arrGearItemsCur = daylight_cfg_arrGearItems select _iIndexGearItem;

				if ((count _arrNearestBoxes) != 0) then {
					_vehNearestBox = _arrNearestBoxes select 0;

					switch (_arrGearItemsCur select 1) do {
						case 0 : {
							_vehNearestBox addWeaponCargoGlobal [(_arrGearItemsCur select 2), _iRealAmount];
						};

						case 1 : {
							_vehNearestBox addMagazineCargoGlobal [(_arrGearItemsCur select 2), _iRealAmount];
						};

						case 2 : {
							_vehNearestBox addItemCargoGlobal [(_arrGearItemsCur select 2), _iRealAmount];
						};

						case 3 : {
							_vehNearestBox addBackpackCargoGlobal [(_arrGearItemsCur select 2), _iRealAmount];
						};
					};
				};
			} else {
				// Add items to player
				[_iID, _iRealAmount] call daylight_fnc_invAddItemWithWeight;
			};

			// Remove money from inventory
			[daylight_cfg_iInvMoneyID, _iTotalCost] call daylight_fnc_invRemoveItem;

			// Show notification
			[localize "STR_SHOP_MESSAGE_TITLE", format[localize "STR_SHOP_MESSAGE_BUY_SUCCESS", (_iID call daylight_fnc_invIDToStr) select 0, _iRealAmount, (daylight_vehCurrentMerchant getVariable "daylight_arrMerchantInfo") select 0, _iTotalCost, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;
		} else {
			// Show notification cant carry this much
			[localize "STR_SHOP_MESSAGE_TITLE", localize "STR_SHOP_MESSAGE_BUY_WEIGHTREACHED", true] call daylight_fnc_showHint;
		};
	} else {
		_iMore = _iTotalCost - _iAmountInventory;

		if (_iMore > daylight_cfg_iMaxIntValue) then {
			_iMore = daylight_cfg_iMaxIntValue;
		};

		// Not enough money, show notification
		[localize "STR_SHOP_MESSAGE_TITLE", format[localize "STR_SHOP_MESSAGE_NOMONEY", _iMore, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;
	};
};

/*
	Description:	Sell item
	Args:			arr [int item id, int amount]
	Return:			nothing
*/
daylight_fnc_shopSellItem = {
	_iID = (_this select 0);

	// Check if we can sell this item
	_arrMerchantInfo = daylight_vehCurrentMerchant getVariable "daylight_arrMerchantInfo";
	if (((((_arrMerchantInfo) select 2) find _iID) != -1) || (count(_arrMerchantInfo) == 0)) then {
		//closeDialog 0;

		ctrlEnable [1700, false];
		ctrlEnable [1701, false];

		_iAmount = round(_this select 1);

		_iRealAmount = [_iID, _iAmount] call daylight_fnc_invCheckAmount;
		_iTotalProfit = [_iID, _iAmount] call daylight_fnc_shopCalculateTotalProfit;

		// Check if we need to add to stock at all
		if ((daylight_vehCurrentMerchant getVariable "daylight_arrMerchantInfo") select 3) then {
			[_iID, _iRealAmount] call daylight_fnc_shopAddTo;
		};

		// Remove sold item(s) from inventory
		[_iID, _iRealAmount] call daylight_fnc_invRemoveItem;

		// Add money to player inventory
		[daylight_cfg_iInvMoneyID, _iTotalProfit] call daylight_fnc_invAddItem;

		daylight_bTrunkOrShopButtonWaitForUpdate = true;

		// Show notification
		[localize "STR_SHOP_MESSAGE_TITLE", format[localize "STR_SHOP_MESSAGE_SELL_SUCCESS", (_iID call daylight_fnc_invIDToStr) select 0, _iRealAmount, (daylight_vehCurrentMerchant getVariable "daylight_arrMerchantInfo") select 0, _iTotalProfit, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;
	} else {
		// We can't sell this item here, show notification
		[localize "STR_SHOP_MESSAGE_TITLE", format[localize "STR_SHOP_MESSAGE_SELL_CANTSELL", (_iID call daylight_fnc_invIDToStr) select 0, (daylight_vehCurrentMerchant getVariable "daylight_arrMerchantInfo") select 0], true] call daylight_fnc_showHint;
	};
};

/*
	Description:	Check if we are trying to put/take more than we have FROM SHOP
	Args:			arr [int item id, int amount]
	Return:			int input (or int max)
*/
/*daylight_fnc_shopCheckAmount = {
	_iItemID = (_this select 0);
	_iAmount = round(_this select 1);

	// Get merchant inventory
	_arrShopInventory = (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", []]) select 1;

	// Make sure amount >= 1
	if (_iAmount >= 1) then {
		// daylight_cfg_iMaxIntValue is max amount we can accurately handle
		if (_iAmount <= daylight_cfg_iMaxIntValue) then {
			// Get item position in array for if (if exists)
			_iItemInShopInventoryPos = [_arrShopInventory, _iItemID] call daylight_fnc_findVariableInNestedArray;

			// Check if item is in inventory
			if (_iItemInShopInventoryPos != -1) then {
				// Check if finite
				if (((_arrShopInventory select _iItemInShopInventoryPos) select 1) != -1) then {
					// Get item array (contains id and amount)
					_arrInventoryItemArray = _arrShopInventory select _iItemInShopInventoryPos;

					if ((_arrInventoryItemArray select 1) <= _iAmount) then {
						_iAmount = (_arrInventoryItemArray select 1);
					};
				};
			};
		} else {
			_iAmount = daylight_cfg_iMaxIntValue;
		};
	};

	_iAmount
};*/

/*
	Description:	Removes item from SHOP
	Args:			arr [int item id, int amount]
	Return:			nothing
*/
daylight_fnc_shopRemoveFrom = {
	// Get parameters
	_iItemID = (_this select 0);
	// Round the value so we don't remove decimal amount
	_iAmount = round(_this select 1);
	// Get merchant inventory
	_arrShopInventory = (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", []]) select 1;

	// Make sure amount >= 1
	if (_iAmount >= 1) then {
		// Get item position in array for if (if exists)
		_iItemInInventoryPos = [_arrShopInventory, _iItemID] call daylight_fnc_findVariableInNestedArray;

		// Check if item is in inventory
		if (_iItemInInventoryPos != -1) then {
			// Check if finite
			if (((_arrShopInventory select _iItemInInventoryPos) select 1) != -1) then {
				// Get item array (contains id and amount)
				_arrInventoryItemArray = (_arrShopInventory select _iItemInInventoryPos);

				// Check if we're trying to remove more than we have (remove item from array if we have 0 of that item)
				if ((_arrInventoryItemArray select 1) <= _iAmount) then {
					// Make value -1 and remove it (we need to make the value something else than an array, -1 will do fine)
					_arrShopInventory set [_iItemInInventoryPos, -1];

					// Remove -1
					_arrShopInventory = _arrShopInventory - [-1];
				} else {
					// Calculate new amount
					_iNewAmount = ((_arrInventoryItemArray select 1) - _iAmount);

					// Modify array to new amount
					_arrShopInventory set [_iItemInInventoryPos, [_iItemID, _iNewAmount]];
				};
			};

			// Update trunk
			daylight_vehCurrentMerchant setVariable ["daylight_arrMerchantInfo", [(daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 0, _arrShopInventory, (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 2, (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 3, (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 4, (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 5], true];
			daylight_vehCurrentMerchant setVariable ["daylight_iLastUpdateTime", time, true];

			daylight_bTrunkOrShopButtonWaitForUpdate = true;
		};
	};
};

/*
	Description:	Add item in SHOP
	Args:			arr [int item id, int amount]
	Return:			nothing
*/
daylight_fnc_shopAddTo = {
	// Get parameters
	_iItemID = (_this select 0);
	// Round the value so we don't remove decimal amount
	_iAmount = round(_this select 1);
	// Get vehicle trunk
	_arrShopInventory = (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", []]) select 1;

	// Make sure amount >= 1
	if (_iAmount >= 1) then {
		// Get item position in array for if (if exists)
		_iItemInInventoryPos = [_arrShopInventory, _iItemID] call daylight_fnc_findVariableInNestedArray;

		// Check if item is in inventory, don't add it again but add to the amount
		if (_iItemInInventoryPos != -1) then {
			// Check if finite
			if (((_arrShopInventory select _iItemInInventoryPos) select 1) != -1) then {
				// Get item array (contains id and amount)
				_arrInventoryItemArray = (_arrShopInventory select _iItemInInventoryPos);

				// Calculate new amount
				_iNewAmount = ((_arrInventoryItemArray select 1) + _iAmount);

				// Modify array to new amount
				_arrShopInventory set [_iItemInInventoryPos, [_iItemID, _iNewAmount]];
			};
		} else {
			// Add item to inventory
			_arrShopInventory set [(count _arrShopInventory), [_iItemID, _iAmount]];
		};
	};

	// Update trunk
	daylight_vehCurrentMerchant setVariable ["daylight_arrMerchantInfo", [(daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 0, _arrShopInventory, (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 2, (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 3, (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 4, (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", ""]) select 5], true];
	daylight_vehCurrentMerchant setVariable ["daylight_iLastUpdateTime", time, true];

	daylight_bTrunkOrShopButtonWaitForUpdate = true;
};

/*
	Description:	Calculate total price
	Args:			arr [i id, i amount]
	Return:			i total price
*/
daylight_fnc_shopCalculateTotalPrice = {
	_iOutput = 0;

	// Get values from stringtable.csv and set them as the return value
	_iPricePerItem = abs parseNumber (localize (format["STR_ITEM_%1_PRICE", (_this select 0)]));

	// Calculate output
	_iOutput = round((_iPricePerItem * (_this select 1)) * (1 + daylight_iPresidentTax));

	_iOutput
};

/*
	Description:	Calculate total profit
	Args:			arr [i id, i amount]
	Return:			i total price
*/
daylight_fnc_shopCalculateTotalProfit = {
	_iOutput = 0;

	// Get price
	_iPrice = (abs (parseNumber (localize format["STR_ITEM_%1_PRICE", (_this select 0)]))) * (_this select 1);

	// Calculate output
	_iOutput = round((_iPrice * dayight_cfg_iShopSoldProfit) * (1 + daylight_iPresidentTax));

	_iOutput
};

/*
	Description:	Check if we are trying to drop/give more than we have FROM SHOP
	Args:			arr [int item id, int amount]
	Return:			int input (or int max droppable/giveable)
*/
daylight_fnc_shopCheckAmount = {
	_iItemID = (_this select 0);
	_iAmount = round(_this select 1);

	_arrShop = (daylight_vehCurrentMerchant getVariable ["daylight_arrMerchantInfo", []]) select 1;

	// Make sure amount >= 1
	if (_iAmount >= 1) then {
		// Get item position in array for if (if exists)
		_iItemInInventoryPos = [_arrShop, _iItemID] call daylight_fnc_findVariableInNestedArray;

		// Check if item is in inventory
		if (_iItemInInventoryPos != -1) then {
			// Get item array (contains id and amount)
			_arrInventoryItemArray = (_arrShop select _iItemInInventoryPos);

			// Check if we're trying to drop more than we have (remove item from array if we have 0 of that item)
			if ((_arrInventoryItemArray select 1) <= _iAmount) then {
				// Drop amount is all we have
				_iAmount = (_arrInventoryItemArray select 1);
			};

			// Check if infinite
			if ((_arrInventoryItemArray select 1) == -1) then {
				_iAmount = round(_this select 1);
			};
		} else {
			_iAmount = 0;
		};

		// daylight_cfg_iMaxIntValue is max amount we can accurately handle
		if (_iAmount > daylight_cfg_iMaxIntValue) then {
			_iAmount = daylight_cfg_iMaxIntValue;
		};
	};

	_iAmount
};

/*
	Description:	Open vehicle shop UI
	Args:			veh cursorTarget
	Return:			nothing
*/
daylight_fnc_shopVehicleOpenUI = {
	if (!dialog) then {
		daylight_vehCurrentVehicleShop = _this;

		_arrVehicleShopInfo = daylight_vehCurrentVehicleShop getVariable "daylight_arrVehicleShopInfo";
		_arrSides = _arrVehicleShopInfo select 4;

		_strShopName = _arrVehicleShopInfo select 0;

		if ((side player) in _arrSides) then {
			createDialog "BuyVehicle";

			// Disable button temporarily
			ctrlEnable [1700, false];

			_arrSoldVehicles = _arrVehicleShopInfo select 1;

			ctrlSetText [1000, _strShopName];

			for "_i" from 0 to ((count _arrSoldVehicles) - 1) do {
				_arrCur = _arrSoldVehicles select _i;

				_strCar = format ["%1 (%2%3)", _arrCur select 0, (_arrCur select 4) * (1 + daylight_iPresidentTax), localize "STR_CURRENCY"];

				lbAdd [1500, _strCar];
				lbSetData [1500, _i, str _i];
			};

			while {((lbCurSel 1500) != 0)} do {
				lbSetCurSel [1500, 0];
			};

			[0, 0] call daylight_fnc_shopVehicleUpdateUI;

			if ((lbSize 1500) > 0) then {
				// Enable button
				ctrlEnable [1700, true];
			} else {
				lbAdd [1500, localize "STR_IMPOUND_OFFICER_DIALOG_NOVEHICLES"];
			};
		} else {
			[_strShopName, localize "STR_SHOP_MESSAGE_WRONGSIDE", true] call daylight_fnc_showHint;
		};
	};
};

/*
	Description:	Vehicle shop UI update
	Args:			lb index
	Return:			nothing
*/
daylight_fnc_shopVehicleUpdateUI = {
	lbClear 2100;

	_arrVehicleShopInfo = daylight_vehCurrentVehicleShop getVariable "daylight_arrVehicleShopInfo";
	_arrSoldVehicles = _arrVehicleShopInfo select 1;

	_arrCur = _arrSoldVehicles select (_this select 1);
	_arrTextures = _arrCur select 2;

	if (count _arrTextures != 0) then {
		for "_i" from 0 to ((count _arrTextures) - 1) do {
			lbAdd [2100, (_arrTextures select _i) select 0];
			lbSetData [2100, _i, str _i];
		};

		while {((lbCurSel 2100) == -1)} do {
			lbSetCurSel [2100, 0];
		};

		ctrlEnable [2100, true];
	} else {
		lbAdd [2100, localize "STR_VEHICLE_SHOP_MESSAGE_NOTEXTURES"];

		while {((lbCurSel 2100) == -1)} do {
			lbSetCurSel [2100, 0];
		};

		ctrlEnable [2100, false];
	};
};

/*
	Description:	Buy vehicle
	Args:			arr [i index in daylight_cfg_arrVehicleShops, i index in textures]
	Return:			nothing
*/
daylight_fnc_shopVehicleBuy = {
	_arrVehicleShopInfo = (daylight_vehCurrentVehicleShop getVariable "daylight_arrVehicleShopInfo");
	_arrCur = (_arrVehicleShopInfo select 1) select (_this select 0);

	_strShopName = _arrVehicleShopInfo select 0;
	_arrSpawnPos = _arrVehicleShopInfo select 2;
	_iSpawnDir = _arrVehicleShopInfo select 3;
	_strName = _arrCur select 0;
	_strClassName = _arrCur select 1;
	_arrTextures = _arrCur select 2;
	_strTexture = (_arrTextures select (_this select 1)) select 1;
	_codeInit = _arrCur select 3;
	_iPrice = (_arrCur select 4) * (1 + daylight_iPresidentTax);

	_strNeededLicense = _arrVehicleShopInfo select 5;

	if (!([player, _strNeededLicense] call daylight_fnc_licensesHasLicenseStr) && (_strNeededLicense != "")) exitWith {
		// Needs license
		[_strShopName, format [localize "STR_VEHICLE_SHOP_MESSAGE_NOLICENSE", _strNeededLicense], true] call daylight_fnc_showHint;
	};

	// Check if there is a vehicle blocking the spawn
	_arrNearVehicles = nearestObjects [_arrSpawnPos, ["LandVehicle", "Air", "Ship"], 7.5];

	if (count _arrNearVehicles > 0) then {
		[_strShopName, localize "STR_VEHICLE_SHOP_MESSAGE_BLOCKING", true] call daylight_fnc_showHint;
	} else {
		// Check if player has enough money in inventory or in bank if not in inv entory
		_bHasMoney = false;

		if (([daylight_cfg_iInvMoneyID, _iPrice] call daylight_fnc_invCheckAmount) >= _iPrice) then {
			_bHasMoney = true;

			// Remove money from inventory
			[daylight_cfg_iInvMoneyID, _iPrice] call daylight_fnc_invRemoveItem;

			[_strShopName, format[localize "STR_VEHICLE_SHOP_MESSAGE_PAID", _iPrice, localize "STR_CURRENCY", _strName, localize "STR_PAIDFROMINVENTORY"], true] call daylight_fnc_showHint;
		} else {
			// No money
			[_strShopName, localize "STR_VEHICLE_SHOP_MESSAGE_NOMONEY", true] call daylight_fnc_showHint;
		};

		if (_bHasMoney) then {
			closeDialog 0;

			// Spawn vehicle
			_vehVehicle = createVehicle [_strClassName, [0, 0, 999999], [], 0, "NONE"];
			_vehVehicle allowDamage false;

			[_vehVehicle, _strTexture, count _arrTextures != 0, _iSpawnDir, _arrSpawnPos] spawn {
				sleep 0.5;

				if (_this select 2) then {
					(_this select 0) setObjectTextureGlobal [0, (_this select 1)];
				};

				sleep 0.5;

				// Move vehicle to spawn pos
				(_this select 0) setDir (_this select 3);
				(_this select 0) setPosATL (_this select 4);

				sleep 5;

				(_this select 0) allowDamage true;

				if ((side player) == blufor) then {
					(_this select 0) setVariable ["daylight_iVehicleSide", 0, true];
				};

				if (true) exitWith {};
			};

			_vehVehicle call _codeInit;

			// Remove items inside
			clearItemCargoGlobal _vehVehicle;

			// Lock vehicle
			[_vehVehicle, 2] call daylight_fnc_networkLockVehicle;

			// Add key
			_arrKeys = [player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;
			_arrKeys set [count _arrKeys, _vehVehicle];
			[player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], _arrKeys] call daylight_fnc_saveVar;
		};
	};
};

/*
	Description:	Spawn gear shops from cfgShops
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_shopSpawnGearShops = {
	daylight_arrGearShops = [];

	_grpMerchants = createGroup civilian;

	{
		_untMerchant = _grpMerchants createUnit [(_x select 0) select 0, [0, 0, 0], [], 0, "NONE"];

		_untMerchant setVariable ["daylight_arrInitialPos", (_x select 3)];

		_untMerchant enableSimulation false;
		_untMerchant allowDamage false;

		_untMerchant addEventHandler ["HandleDamage", {
			(_this select 0) setVelocity [0, 0, 0];

			_arrPos = (_this select 0) getVariable "daylight_arrInitialPos";

			if (((_this select 0) distance _arrPos) > 5) then {
				(_this select 0) setPosATL ((_this select 0) getVariable "daylight_arrInitialPos");
			};

			(_this select 0) switchMove "";
		}];

		{_untMerchant disableAI _x} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		_untMerchant setSkill 0;

		removeBackpack _untMerchant;
		_untMerchant setFace ((_x select 0) select 1);
		_untMerchant addHeadgear ((_x select 0) select 2);
		_untMerchant addGoggles ((_x select 0) select 3);
		_untMerchant addUniform ((_x select 0) select 4);
		_untMerchant addVest ((_x select 0) select 5);

		_untMerchant switchMove "";

		_untMerchant setPosATL (_x select 3);
		_untMerchant setDir (_x select 4);

		_untMerchant setVariable ["daylight_arrGearShopInfo", [_x select 1, _x select 2, _x select 5], true];

		daylight_arrGearShops set [count daylight_arrGearShops, _untMerchant];
	} forEach daylight_cfg_arrGearShops;

	publicVariable "daylight_arrGearShops";
};

/*
	Description:	Open gear shop UI
	Args:			veh cursorTarget
	Return:			nothing
*/
daylight_fnc_shopGearOpenUI = {
	if (!dialog) then {
		daylight_vehCurrentGearShop = _this;

		_arrGearShopInfo = daylight_vehCurrentGearShop getVariable "daylight_arrGearShopInfo";
		_sideSide = _arrGearShopInfo select 2;

		_strShopName = _arrGearShopInfo select 0;

		if (_sideSide == side player) then {
			createDialog "BuyGear";

			// Disable button temporarily
			ctrlEnable [1700, false];

			_arrSoldGear = _arrGearShopInfo select 1;

			ctrlSetText [1000, _strShopName];

			for "_i" from 0 to ((count _arrSoldVehicles) - 1) do {
				_arrCur = _arrSoldVehicles select _i;

				_strCar = format ["%1 (%2%3)", _arrCur select 0, _arrCur select 3, localize "STR_CURRENCY"];

				lbAdd [1500, _strCar];
				lbSetData [1500, _i, str _i];
			};

			while {((lbCurSel 1500) != 0)} do {
				lbSetCurSel [1500, 0];
			};

			if ((lbSize 1500) > 0) then {
				// Enable button
				ctrlEnable [1700, true];
			} else {
				lbAdd [1500, localize "STR_IMPOUND_OFFICER_DIALOG_NOVEHICLES"];
			};
		} else {
			[_strShopName, localize "STR_SHOP_MESSAGE_WRONGSIDE", true] call daylight_fnc_showHint;
		};
	};
};

/*
	Description:	Open gear shop UI
	Args:			veh cursorTarget
	Return:			nothing
*/
daylight_fnc_shopGearUpdateUI = {

};

daylight_fnc_shopInitClient = {
	waitUntil {
		!(isNil "daylight_arrMerchants")
		&&
		!(isNil "daylight_arrVehicleShops")
	};

	_fnc_spawnLight = {
		_vehLight = "#lightpoint" createVehicleLocal [0, 0, 0];

		_vehLight setLightBrightness 0.15;

		_vehLight setLightAmbient [1, 1, 1];
		_vehLight setLightColor [1, 1, 1];

		_vehLight setPosATL (_this modelToWorld [0, 1, 1.5]);
	};

	{
		_x call _fnc_spawnLight;
	} forEach daylight_arrMerchants;

	{
		_x call _fnc_spawnLight;
	} forEach daylight_arrVehicleShops;
};

/*
	Description:	Autobounty Open shop UI
	Args:			veh cursorTarget
	Return:			nothing
*/
daylight_fnc_shopAutoBountyOpenUI = {
	if (!dialog) then {
		daylight_iCurrentMerchant = _this;
		_arrCur = daylight_cfg_arrMerchantsAutoBounty select daylight_iCurrentMerchant;

		_arrSides = _arrCur select 5;
		_strNeededLicense = _arrCur select 6;

		if ((side player) in _arrSides) then {
			if ((_strNeededLicense == "") || ([player, _strNeededLicense] call daylight_fnc_licensesHasLicenseStr)) then {
				createDialog "ShopAutoBounty";

				ctrlSetText [1000, _arrCur select 1];

				call daylight_fnc_shopAutoBountyUpdateUI;
			} else {
				[_arrCur select 1, format [localize "STR_SHOP_MESSAGE_NOLICENSE", _strNeededLicense], true] call daylight_fnc_showHint;
			};
		} else {
			[_arrCur select 1, localize "STR_SHOP_MESSAGE_WRONGSIDE", true] call daylight_fnc_showHint;
		};
	};
};

/*
	Description:	Autobounty Update shop UI
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_shopAutoBountyUpdateUI = {
	_arrCur = daylight_cfg_arrMerchantsAutoBounty select daylight_iCurrentMerchant;

	lbClear 1500;

	// Populate items
	_iX = 0;
	for "_i" from 0 to ((count daylight_arrInventory) - 1) do {
		_iItemIDInv = (daylight_arrInventory select _i) select 0;

		if (((_arrCur select 2) find _iItemIDInv) != -1) then {
			_strName = format["%1x %2", _iItemIDInv call daylight_fnc_invItemAmount, (_iItemIDInv call daylight_fnc_invIDToStr) select 0];

			lbAdd [1500, _strName];
			lbSetData [1500, _iX, str _iItemIDInv];

			_iX = _iX + 1;
		};
	};

	if ((lbSize 1500) == 0) then {
		lbAdd [1500, "No items to sell."];

		ctrlEnable [1500, false];
		ctrlEnable [1700, false];
	};

	while {(lbCurSel 1500) == -1} do {
		lbSetCurSel [1500, 0];
	};
};

/*
	Description:	Autobounty shop sell
	Args:			arr [i item id, i amount]
	Return:			nothing
*/
daylight_fnc_shopAutoBountySell = {
	_iItemIDBounty = _this select 0;
	_iItemAmountBounty = _this select 1;

	_arrCur = daylight_cfg_arrMerchantsAutoBounty select daylight_iCurrentMerchant;

	// Check if we can sell this amount
	if (([_iItemIDBounty, _iItemAmountBounty] call daylight_fnc_invCheckAmount) >= _iItemAmountBounty) then {
		// Check if we have enough room in inventory
		if ([([daylight_cfg_iInvMoneyID, _iItemAmountBounty] call daylight_fnc_invGetItemWeight)] call daylight_fnc_invCheckWeight) then {
			// Remove item
			[_iItemIDBounty, _iItemAmountBounty] call daylight_fnc_invRemoveItem;

			// Add profit
			_iProfit = [_iItemIDBounty, _iItemAmountBounty] call daylight_fnc_shopCalculateTotalProfit;

			// Add money
			[daylight_cfg_iInvMoneyID, _iProfit] call daylight_fnc_invAddItemWithWeight;

			// Add sold item
			[daylight_iCurrentMerchant, [_iItemIDBounty, _iItemAmountBounty], getPlayerUID player] call daylight_fnc_networkBountyAddSold;

			// Show hint
			[_arrCur select 1, format[localize "STR_SHOP_MESSAGE_SELL_SUCCESSBOUNTY", _iItemAmountBounty, (_iItemIDBounty call daylight_fnc_invIDToStr) select 0, _iProfit, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;
		} else {
			[_arrCur select 1, localize "STR_SHOP_MESSAGE_SELL_WEIGHTREACHED", true] call daylight_fnc_showHint;
		};
	} else {
		[_arrCur select 1, localize "STR_SHOP_MESSAGE_CANTSELL", true] call daylight_fnc_showHint;
	};

	call daylight_fnc_shopAutoBountyUpdateUI;
};

/*
	Description:	Autobounty shop add item server
	Args:			arr [i current merchant, arr [i itemid, i amount], str uid]
	Return:			nothing
*/
daylight_fnc_shopAutoBountyAddSoldItemServer = {
	_vehUnit = (daylight_arrMerchants select (_this select 0));

	_arrSoldItems = _vehUnit getVariable ["daylight_arrSoldItems", []];

	_iIndex = [_arrSoldItems, (_this select 2)] call daylight_fnc_findVariableInNestedArray;

	if (_iIndex == -1) then {
		_arrSoldItems set [count _arrSoldItems, [(_this select 1) select 0, (_this select 1) select 1, (_this select 2), time]];
	} else {
		_arrCur = _arrSoldItems select _iIndex;

		_arrSoldItems set [_iIndex, [(_this select 1) select 0, (_arrCur select 1) + ((_this select 1) select 1), (_this select 2), time]];
	};

	_vehUnit setVariable ["daylight_arrSoldItems", _arrSoldItems, false];
};

/*
	Description:	Autobounty shop add item server
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_shopAutoBountyAddSoldItemsBountyServer = {
	_vehUnit = daylight_arrMerchants select _this;
	_arrSoldItems = _vehUnit getVariable ["daylight_arrSoldItems", []];

	{
		_iItemIDCur = _x select 0;
		_iItemAmountCur = _x select 1;
		_strUID = _x select 2;
		_iTimeStamp = _x select 3;

		_iProfit = [_iItemIDCur, _iItemAmountCur] call daylight_fnc_shopCalculateTotalProfit;

		if ((time - _iTimeStamp) <= daylight_cfg_iShopAutoBountyMaxTime) then {
			// Add bounty
			_vehUnit = _strUID call daylight_fnc_playerUIDtoPlayerObject;

			if (!(isNull _vehUnit)) then {
				[_vehUnit, "Drug trafficking", _iProfit] call daylight_fnc_jailSetWanted;

				format ["%1 has been caught for drug trafficking worth of %2%3, %1 is now wanted by the police.", name _vehUnit, _iProfit, localize "STR_CURRENCY"] call daylight_fnc_networkChatNotification;
			
				sleep 0.25;
			};
		};
	} forEach _arrSoldItems;

	_vehUnit setVariable ["daylight_arrSoldItems", [], false];

	if (true) exitWith {};
};

/*
	Description:	Autobounty shop client init
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_shopAutoBountyInitClient = {
	if (side player == blufor) then {
		waitUntil {!(isNil "daylight_arrMerchantsAutoBounty")};

		{
			_x addAction ["<t color=""#75c2e6"">Interrogate drug trafficker</t>", "daylight\client\actions\interrogateDrugTrafficker.sqf", [], 10, true, true, "", "((player distance _target) < 2.5) && !daylight_bActionBusy"];
		} forEach daylight_arrMerchantsAutoBounty;
	};

	if (true) exitWith {};
};

// Spawn shop merchants
if (isServer) then {
	call daylight_fnc_shopSpawnMerchants;
	call daylight_fnc_shopSpawnVehicleShops;
	//call daylight_fnc_shopSpawnGearShops;
};

if (!isDedicated) then {
	[] spawn daylight_fnc_shopInitClient;
	[] spawn daylight_fnc_shopAutoBountyInitClient;
};