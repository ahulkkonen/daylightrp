/*
	Description:	License functions
	Author:			qbt
*/

/*
	Description:	Spawn license sellers
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_impoundSpawnLicenseSellers = {
	daylight_arrLicenseSellers = [];

	_grpLicenseSellers = createGroup civilian;

	{
		_untLicenseSeller = _grpLicenseSellers createUnit [(_x select 0) select 0, [0, 0, 0], [], 0, "NONE"];

		_untLicenseSeller setVariable ["daylight_arrInitialPos", (_x select 3)];

		_untLicenseSeller enableSimulation false;
		_untLicenseSeller allowDamage false;

		_untLicenseSeller addEventHandler ["HandleDamage", {
			(_this select 0) setVelocity [0, 0, 0];

			_arrPos = (_this select 0) getVariable "daylight_arrInitialPos";

			if (((_this select 0) distance _arrPos) > 5) then {
				(_this select 0) setPosATL ((_this select 0) getVariable "daylight_arrInitialPos");
			};

			(_this select 0) switchMove "";
		}];

		{_untLicenseSeller disableAI _x} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		_untLicenseSeller setSkill 0;

		_untLicenseSeller setFace ((_x select 0) select 1);
		_untLicenseSeller addHeadgear ((_x select 0) select 2);
		_untLicenseSeller addGoggles ((_x select 0) select 3);
		_untLicenseSeller addUniform ((_x select 0) select 4);
		_untLicenseSeller addVest ((_x select 0) select 5);

		_untLicenseSeller switchMove "";

		_untLicenseSeller setPosATL (_x select 1);
		_untLicenseSeller setDir (_x select 2);

		_untLicenseSeller setVariable ["daylight_arrLicenseSellerInfo", _x select 3, true];

		daylight_arrLicenseSellers set [count daylight_arrLicenseSellers, _untLicenseSeller];
	} forEach daylight_cfg_arrLicenseSellers;

	publicVariable "daylight_arrLicenseSellers";
};

/*
	Description:	Add license
	Args:			i index from license-config
	Return:			nothing
*/
daylight_fnc_licensesAddLicense = {
	// Get variable name to load/save
	_strVariable = format["arrLicenses%1", player call daylight_fnc_returnSideStringForSavedVariables];

	// Load current license array
	_arrLicenses = [player, _strVariable, []] call daylight_fnc_loadVar;

	// Add license
	_arrLicenses set [count _arrLicenses, daylight_cfg_arrLicenses select _this];

	// Update saved variable
	[player, _strVariable, _arrLicenses] call daylight_fnc_saveVar;
};

/*
	Description:	Remove license
	Args:			i index from license-config
	Return:			nothing
*/
daylight_fnc_licensesRemoveLicense = {
	// Get variable name to load/save
	_strVariable = format["arrLicenses%1", player call daylight_fnc_returnSideStringForSavedVariables];

	// Load current license array
	_arrLicenses = [player, _strVariable, []] call daylight_fnc_loadVar;

	// Add license
	_iIndexInArray = _arrLicenses find (daylight_cfg_arrLicenses select _this);
	_arrLicenses set [_iIndexInArray, -1];
	_arrLicenses = _arrLicenses - [-1];

	// Update saved variable
	[player, _strVariable, _arrLicenses] call daylight_fnc_saveVar;
};

/*
	Description:	Check if player has license
	Args:			arr [veh player, i index from license-config]
	Return:			nothing
*/
daylight_fnc_licensesHasLicense = {
	_bReturn = false;

	// Get variable name to load/save
	_strVariable = format["arrLicenses%1", (_this select 0) call daylight_fnc_returnSideStringForSavedVariables];

	// Load current license array
	_arrLicenses = [(_this select 0), _strVariable, []] call daylight_fnc_loadVar;

	if ((_arrLicenses find (daylight_cfg_arrLicenses select (_this select 1)) != -1)) then {
		_bReturn = true;
	};

	_bReturn
};

/*
	Description:	Check if player has license
	Args:			arr [veh player, str license]
	Return:			nothing
*/
daylight_fnc_licensesHasLicenseStr = {
	_bReturn = false;

	// Get variable name to load/save
	_strVariable = format["arrLicenses%1", (_this select 0) call daylight_fnc_returnSideStringForSavedVariables];

	// Load current license array
	_arrLicenses = [(_this select 0), _strVariable, []] call daylight_fnc_loadVar;

	if ((_arrLicenses find (_this select 1)) != -1) then {
		_bReturn = true;
	};

	_bReturn
};


/*
	Description:	Buy license
	Args:			int lbData of lbCurSel
	Return:			nothing
*/
daylight_fnc_licensesBuyLicense = {
	_arrSoldLicense = (daylight_vehCurrentLicenseSeller getVariable "daylight_arrLicenseSellerInfo") select _this;

	// Check if player has enough money in inventory or in bank if not in inv entory
	_bHasMoney = false;

	if (([daylight_cfg_iInvMoneyID, _arrSoldLicense select 1] call daylight_fnc_invCheckAmount) >= _arrSoldLicense select 1) then {
		_bHasMoney = true;

		// Remove money from inventory
		[daylight_cfg_iInvMoneyID, _arrSoldLicense select 1] call daylight_fnc_invRemoveItem;

		[localize "STR_LICENSE_SELLER_MESSAGE_TITLE", format[localize "STR_LICENSE_SELLER_MESSAGE_PAID", _arrSoldLicense select 1, localize "STR_CURRENCY", daylight_cfg_arrLicenses select (_arrSoldLicense select 0), localize "STR_PAIDFROMINVENTORY"], true] call daylight_fnc_showHint;
	} else {
		_iMoneyBank = [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
		if (_iMoneyBank >= _arrSoldLicense select 1) then {
			_bHasMoney = true;

			// Minus cost from current amount
			_iMoneyBank = _iMoneyBank - (_arrSoldLicense select 1);

			// Update bank money amount
			[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], _iMoneyBank] call daylight_fnc_saveVar;

			[localize "STR_LICENSE_SELLER_MESSAGE_TITLE", format[localize "STR_LICENSE_SELLER_MESSAGE_PAID", _arrSoldLicense select 1, localize "STR_CURRENCY", daylight_cfg_arrLicenses select (_arrSoldLicense select 0), localize "STR_PAIDFROMBANK"], true] call daylight_fnc_showHint;
		} else {
			// No money
			[localize "STR_LICENSE_SELLER_MESSAGE_TITLE", localize "STR_LICENSE_SELLER_MESSAGE_NOMONEY", true] call daylight_fnc_showHint;
		};
	};

	if (_bHasMoney) then {
		(_arrSoldLicense select 0) call daylight_fnc_licensesAddLicense;

		closeDialog 0;
	};
};

/*
	Description:	Buy license UI
	Args:			veh cursorTarget
	Return:			nothing
*/
daylight_fnc_licensesBuyOpenUI = {
	if (!dialog) then {
		createDialog "BuyLicense";

		daylight_vehCurrentLicenseSeller = _this;

		// Disable button temporarily
		ctrlEnable [1700, false];

		_arrSoldLicense = daylight_vehCurrentLicenseSeller getVariable "daylight_arrLicenseSellerInfo";

		_iLastLbIndex = 0;
		for "_i" from 0 to ((count _arrSoldLicense) - 1) do {
			_strLicense = daylight_cfg_arrLicenses select ((_arrSoldLicense select _i) select 0);

			// Lets not add licenses we do not have
			if (!([player, _strLicense] call daylight_fnc_licensesHasLicenseStr)) then {
				lbAdd [1500, format ["%1 (%2%3)", daylight_cfg_arrLicenses select ((_arrSoldLicense select _i) select 0), (_arrSoldLicense select _i) select 1, localize "STR_CURRENCY"]];
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
			ctrlEnable [1500, false];

			lbAdd [1500, localize "STR_LICENSE_SELLER_OWNSALLLICENSES"];
		};
	};
};

// Spawn license sellers
if (isServer) then {
	call daylight_fnc_impoundSpawnLicenseSellers;
};