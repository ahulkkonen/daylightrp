/*
	Description:	Gas station functions
	Author:			qbt
*/

/*
	Description:	Spawn merchants from cfgShops
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_shopSpawnGasStationMerchants = {
	daylight_arrGasStationMerchants = [];

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

		_untMerchant setFace ((_x select 0) select 1);
		_untMerchant addHeadgear ((_x select 0) select 2);
		_untMerchant addGoggles ((_x select 0) select 3);
		_untMerchant addUniform ((_x select 0) select 4);
		_untMerchant addVest ((_x select 0) select 5);

		_untMerchant switchMove "";

		_untMerchant setPosATL (_x select 1);
		_untMerchant setDir (_x select 2);

		daylight_arrGasStationMerchants set [count daylight_arrGasStationMerchants, _untMerchant];
	} forEach daylight_cfg_arrGasStationMerchants;

	publicVariable "daylight_arrGasStationMerchants";
};

daylight_fnc_shopGasStationMerchantsInit = {
	waitUntil {!(isNil "daylight_arrGasStationMerchants")};

	{
		_x addAction ["<t color=""#75c2e6"">Rob Gas Station</t>", "daylight\client\actions\robGasStation.sqf", [], 10, true, true, "", "((player distance _target) < 2.5) && (currentWeapon player != """") && (side player == civilian)"];
	} forEach daylight_arrGasStationMerchants;
};

// Spawn shop merchants
if (isServer) then {
	call daylight_fnc_shopSpawnGasStationMerchants;
};

if (!isDedicated) then {
	[] spawn daylight_fnc_shopGasStationMerchantsInit;
};