/*
	Description:	Bank functions
	Author:			qbt
*/

/*
	Description:	Open bank UI
	Args:			bool isATM
	Return:			nothing
*/
daylight_fnc_bankOpenUI = {
	if (!dialog) then {
		createDialog "ATM";

		// If ATM, player can only transfer money
		if (_this) then {
			(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1701) ctrlSetText (localize "STR_TRANSFER");
		};

		// Update account balance
		// Get money in inventory
		_iIndex = [daylight_arrInventory, daylight_cfg_iInvMoneyID] call daylight_fnc_findVariableInNestedArray;
		_iAmountInventory = 0;
		if (_iIndex != -1) then {
			_iAmountInventory = (daylight_arrInventory select _iIndex) select 1;
		};

		ctrlSetText [1006, format["%1%2", _iAmountInventory, localize "STR_CURRENCY"]];

		// Get money in bank
		ctrlSetText [1007, format["%1%2", [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar, localize "STR_CURRENCY"]];

		// Populate player list
		_iPlayerPos = 0;

		_iX = 0;
		for "_i" from 0 to (count(playableUnits) - 1) do {
			// Civs can only see other civs, and blufor can only see other blufor, the president can see everyone
			if (playerSide == civilian) then {
				//_iPresident = (([player, "arrICDataCiv"] call daylight_fnc_loadVar) select 2);
				_iPresident = 0;
				if (_iPresident == 0) then {
					if ((side (playableUnits select _i)) == civilian) then {
						if ((playableUnits select _i) == player) then {
							lbAdd [2100, format["%1 (Your Account)", name((playableUnits select _i))]];
							lbSetData [2100, _iX, str _i];

							_iX = _iX + 1;
						} else {
							lbAdd [2100, format["%1", name((playableUnits select _i))]];
							lbSetData [2100, _iX, str _i];

							_iX = _iX + 1;
						};
					};
				} else {
					if ((playableUnits select _i) == player) then {
						lbAdd [2100, format["%1 (Your Account)", name((playableUnits select _i))]];
						lbSetData [2100, _iX, str _i];

						_iX = _iX + 1;
					} else {
						lbAdd [2100, format["%1", name((playableUnits select _i))]];
						lbSetData [2100, _iX, str _i];

						_iX = _iX + 1;
					};
				};
			} else {
				if ((side (playableUnits select _i)) == blufor) then {
					if ((playableUnits select _i) == player) then {
						lbAdd [2100, format["%1 (Your Account)", name((playableUnits select _i))]];
						lbSetData [2100, _iX, str _i];

						_iX = _iX + 1;
					} else {
						lbAdd [2100, format["%1", name((playableUnits select _i))]];
						lbSetData [2100, _iX, str _i];

						_iX = _iX + 1;
					};
				};
			};
		};

		// If list is empty, disable button
		if ((lbSize 2100) == 0) then {
			ctrlEnable [1701, false];
		};

		// Select own account
		//if (!_this) then {
			lbSetCurSel [2100, (playableUnits find player)];
		//} else {
		//	lbSetCurSel [2100, 0];
		//};
	};
};

/*
	Description:	Withdraw from bank
	Args:			str amount
	Return:			nothing
*/
daylight_fnc_bankWithdraw = {
	_iAmount = round(abs parseNumber(_this));

	_iMoneyBank = [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;

	if (_iAmount > 0) then {		
		// daylight_cfg_iMaxIntValue is max amount we can accurately handle
		if (_iAmount > daylight_cfg_iMaxIntValue) then {
			_iAmount = daylight_cfg_iMaxIntValue;
		};

		// Send max we can send
		if (_iAmount > _iMoneyBank) then {
			_iAmount = _iMoneyBank;
		};

		if (_iAmount > 0) then {
			closeDialog 0;

			[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], (_iMoneyBank - _iAmount)] call daylight_fnc_saveVar;
			[daylight_cfg_iInvMoneyID, _iAmount] call daylight_fnc_invAddItem;

			// Show message
			[localize "STR_ATM_MESSAGE", format[localize "STR_ATM_MESSAGE_WITHDRAW_SUCCESS", _iAmount, _iMoneyBank - _iAmount, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;
		};
	};
};

/*
	Description:	Withdraw from bank
	Args:			arr [i target index in playableUnits, i amount]
	Return:			nothing
*/
daylight_fnc_bankDepositOrTransfer = {
	// Get target player
	_vehTarget = (playableUnits select (_this select 0));

	_iAmount = abs parseNumber(_this select 1);

	// Get current money amount
	_iMoneyBank = [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;

	// Make sure _iAmount is more than 0
	if (_iAmount > 0) then {
		// daylight_cfg_iMaxIntValue is max amount we can accurately handle
		if (_iAmount > daylight_cfg_iMaxIntValue) then {
			_iAmount = daylight_cfg_iMaxIntValue;
		};

		// Is target player or someone else?
		if (_vehTarget == player) then {
			// Player, deposit to own account
			// Get amount from inventory
			_iAmountInventory = round([daylight_cfg_iInvMoneyID, _iAmount] call daylight_fnc_invCheckAmount);

			if (_iAmountInventory > 0) then {
				closeDialog 0;

				// Remove amount from inventory
				[daylight_cfg_iInvMoneyID, _iAmountInventory] call daylight_fnc_invRemoveItem;

				_iAmountToSave = (_iMoneyBank + _iAmountInventory);

				if (_iAmountToSave > daylight_cfg_iMaxIntValue) then {
					_iAmountToSave = daylight_cfg_iMaxIntValue;
				};

				// Save bank variable
				[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], _iAmountToSave] call daylight_fnc_saveVar;

				// Show message
				[localize "STR_ATM_MESSAGE", format[localize "STR_ATM_MESSAGE_DEPOSIT_SUCCESS", _iAmount, daylight_cfg_iInvMoneyID call daylight_fnc_invItemAmount, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;
			};
		} else {
			// Someone else, transfer money
			if(_iMoneyBank >= _iAmount) then {
				closeDialog 0;

				[_vehTarget, player, _iAmount] call daylight_fnc_networkMakeBankTransfer;

				_iAmountToSave = (_iMoneyBank - _iAmount);
				[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], _iAmountToSave] call daylight_fnc_saveVar;

				// Show message
				[localize "STR_ATM_MESSAGE", format[localize "STR_ATM_MESSAGE_TRANSFER_SUCCESS", _iAmount, _iMoneyBank - _iAmount, localize "STR_CURRENCY", name(_vehTarget)], true] call daylight_fnc_showHint;
			} else {
				// Show message
				[localize "STR_ATM_MESSAGE", localize "STR_ATM_MESSAGE_TRANSFER_FAIL", true] call daylight_fnc_showHint;
			};
		};
	};
};

/*
	Description:	Receive transferred money
	Args:			arr [veh sender, i amount]
	Return:			nothing
*/
daylight_fnc_bankTransferReceive = {
	// Get current money amount
	_iMoneyBank = [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;

	_iAmountToSave = _iMoneyBank + (_this select 1);

	// Save bank variable
	[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], _iAmountToSave] call daylight_fnc_saveVar;

	// Show message
	[localize "STR_ATM_MESSAGE", format[localize "STR_ATM_MESSAGE_TRANSFER_RECEIVE_SUCCESS", (_this select 1), _iAmountToSave, localize "STR_CURRENCY", name((_this select 0))], true] call daylight_fnc_showHint;
};