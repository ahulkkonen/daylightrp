/*
	Description:	Force player clothing
	Author:			qbt
*/

// Different loop for civ
if ((playerSide) != blufor) then {
	_strOldUniform = "";

	_bPresident = false;

	while {true} do {
		// If player is president
		if ((getPlayerUID player) == (daylight_arrPresidentInfo select 0)) then {
			_bPresident = true;

			// Force clothes
			_bRemoveNearWeaponHolders = false;

			if ((uniform player) != "U_NikosAgedBody") then {
				_bRemoveNearWeaponHolders = true;

				player addUniform "U_NikosAgedBody";
			};

			if (_bRemoveNearWeaponHolders) then {
				_arrNearWeaponHolders = nearestObjects [player, ["WeaponHolder", "WeaponHolderSimulated"], 5];

				deleteVehicle(_arrNearWeaponHolders select 0);

				_arrNearItemsWithCargo = nearestObjects [player, ["AllVehicles", "ReammoBox"], 5];

				{
					if (!(isPlayer vehicle(_x)) && !(_x isKindOf "Man")) then {
						[vehicle(_x), _arrClothing select 0] call daylight_fnc_removeItemsFromCargo;
						[vehicle(_x), _arrClothing select 1] call daylight_fnc_removeItemsFromCargo;
						[vehicle(_x), _arrClothing select 2] call daylight_fnc_removeItemsFromCargo;
					};
				} forEach _arrNearItemsWithCargo;
			};
		} else {
			if (!_bPresident) then {
				_strOldUniform = uniform player;
			} else {
				player addUniform _strOldUniform;

				_bPresident = false;
			};
		};

		sleep 0.33;
	};

	if (true) exitWith {};
};

/*removeHeadgear player;
removeGoggles player;
removeUniform player;
removeVest player;

waitUntil {daylight_bCharacterClothed || (playerSide == blufor)};

_arrClothing = [];
if (playerSide == civilian) then {
	_arrClothing = [player, format["arrClothing%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;
} else {
	_arrClothing = daylight_cfg_arrClothingBlufor;
};*/

_arrClothing = daylight_cfg_arrStartGearBLUFORClothing;

while {true} do {
	// Remove near WeaponHolders
	_bRemoveNearWeaponHolders = false;

	// Check if player has same headgear
	if ((headgear player) != (_arrClothing select 0)) then {
		_bRemoveNearWeaponHolders = true;

		if ((_arrClothing select 0) == "") then {
			removeHeadgear player;
		} else {
			player addHeadgear (_arrClothing select 0);
		};
	};

	// Check if player has same goggles
	/*if ((goggles player) != (_arrClothing select 1)) then {
		_bRemoveNearWeaponHolders = true;

		if ((_arrClothing select 1) == "") then {
			removeGoggles player;
		} else {
			player addGoggles (_arrClothing select 1);
		};
	};*/

	// Check if player has same uniform
	if ((uniform player) != ((_arrClothing select 2) select 0)) then {
		_bRemoveNearWeaponHolders = true;

		player addUniform ((_arrClothing select 2) select 0);
	};

	// Check if player has same vest (blufor)
	if (playerSide == blufor) then {
		if ((vest player) != (_arrClothing select 1)) then {
			_bRemoveNearWeaponHolders = true;

			if ((_arrClothing select 1) == "") then {
				removeVest player;
			} else {
				player addVest (_arrClothing select 1);
			};
		};
	};

	if (_bRemoveNearWeaponHolders) then {
		_arrNearWeaponHolders = nearestObjects [player, ["WeaponHolder", "WeaponHolderSimulated"], 5];

		deleteVehicle(_arrNearWeaponHolders select 0);

		_arrNearItemsWithCargo = nearestObjects [player, ["AllVehicles", "ReammoBox"], 5];

		{
			if (!(isPlayer vehicle(_x)) && !(_x isKindOf "Man")) then {
				[vehicle(_x), _arrClothing select 0] call daylight_fnc_removeItemsFromCargo;
				[vehicle(_x), _arrClothing select 1] call daylight_fnc_removeItemsFromCargo;
				[vehicle(_x), _arrClothing select 2] call daylight_fnc_removeItemsFromCargo;
			};
		} forEach _arrNearItemsWithCargo;
	};

	sleep 0.33;
};