/*
	Description:	Wrecking yard
	Author:			qbt
*/

/*
	Description:	Spawn wrecking yards
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_wreckingYardSpawn = {
	daylight_arrWreckingYards = [];

	_grpWreckingYards = createGroup civilian;

	{
		_untWreckingYards = _grpWreckingYards createUnit [(_x select 0) select 0, [0, 0, 0], [], 0, "NONE"];

		_untWreckingYards setVariable ["daylight_arrInitialPos", (_x select 3)];

		_untWreckingYards enableSimulation false;
		_untWreckingYards allowDamage false;

		_untWreckingYards addEventHandler ["HandleDamage", {
			(_this select 0) setVelocity [0, 0, 0];

			_arrPos = (_this select 0) getVariable "daylight_arrInitialPos";

			if (((_this select 0) distance _arrPos) > 5) then {
				(_this select 0) setPosATL ((_this select 0) getVariable "daylight_arrInitialPos");
			};

			(_this select 0) switchMove "";
		}];

		{_untWreckingYards disableAI _x} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		_untWreckingYards setSkill 0;

		_untWreckingYards setFace ((_x select 0) select 1);
		_untWreckingYards addHeadgear ((_x select 0) select 2);
		_untWreckingYards addGoggles ((_x select 0) select 3);
		_untWreckingYards addUniform ((_x select 0) select 4);
		_untWreckingYards addVest ((_x select 0) select 5);

		_untWreckingYards switchMove "";

		_untWreckingYards setPosATL (_x select 1);
		_untWreckingYards setDir (_x select 2);

		_untWreckingYards setVariable ["daylight_arrLicenseSellerInfo", _x select 3, true];

		daylight_arrWreckingYards set [count daylight_arrWreckingYards, _untWreckingYards];
	} forEach daylight_cfg_arrWreckingYards;

	publicVariable "daylight_arrWreckingYards";
};

/*
	Description:	Open wrecking yard UI
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_wreckingYardOpenUI = {
	if (!dialog) then {
		if ((side player) == civilian) then {
			createDialog "WreckingYard";

			_arrNearVehicles = nearestObjects [player, ["AllVehicles"], 40];
			daylight_arrNearVehiclesWithKeys = [];

			{
				if (!(_x isKindOf "Man")) then {
					if ([player, _x] call daylight_fnc_hasKeysFor) then {
						daylight_arrNearVehiclesWithKeys set [count daylight_arrNearVehiclesWithKeys, _x];
					};
				};
			} forEach _arrNearVehicles;

			{
				_iPos = [daylight_cfg_arrWreckingYardsVehicles, typeOf _x] call daylight_fnc_findVariableInNestedArray;
				_iProfit = ((daylight_cfg_arrWreckingYardsVehicles select _iPos) select 1) * daylight_cfg_arrWreckingYardsProfit;

				lbAdd [1500, format["%1 (%2%3)", getText(configFile >> "CfgVehicles" >> typeOf _x >> "displayName"), _iProfit, localize "STR_CURRENCY"]];
			} forEach daylight_arrNearVehiclesWithKeys;

			if ((lbSize 1500) == 0) then {
				lbAdd [1500, "No vehicles to show."];

				ctrlEnable [1500, false];
				ctrlEnable [1700, false];
			};
		} else {
			["Wrecking Yard", localize "STR_SHOP_MESSAGE_WRONGSIDE", true] call daylight_fnc_showHint;
		};
	};
};

/*
	Description:	Wrecking sell vehicle
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_wreckingYardSellVehicle = {
	closeDialog 0;

	_iPos = [daylight_cfg_arrWreckingYardsVehicles, typeOf _this] call daylight_fnc_findVariableInNestedArray;
	_iProfit = ((daylight_cfg_arrWreckingYardsVehicles select _iPos) select 1) * daylight_cfg_arrWreckingYardsProfit;

	if ([([daylight_cfg_iInvMoneyID, _iProfit] call daylight_fnc_invGetItemWeight)] call daylight_fnc_invCheckWeight) then {
		deleteVehicle _this;

		[daylight_cfg_iInvMoneyID, _iProfit] call daylight_fnc_invAddItemWithWeight;

		[localize "STR_WRECKING_YARD_TITLE", format[localize "STR_WRECKNG_YARD_SOLD", _iProfit, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;
	} else {
		["You can't carry that much, max weight reached!"] call daylight_fnc_showActionMsg;
	};
};

// Spawn license sellers
if (isServer) then {
	call daylight_fnc_wreckingYardSpawn;
};