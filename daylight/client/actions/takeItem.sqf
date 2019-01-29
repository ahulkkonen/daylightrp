/*
	Description: 	Take item action used by objects created by daylight_fnc_dropItem
	Author:			qbt
*/

// Parameters
_objItem = (_this select 0);
_arrPos = getPosATL _objItem;

_iItemID = ((_this select 3) select 0);
_iItemAmount = ((_this select 3) select 1);

if ([([_iItemID, _iItemAmount] call daylight_fnc_invGetItemWeight)] call daylight_fnc_invCheckWeight) then {
	// If not already picking up something
	if ((time - daylight_iLastPickUpTime) > 1.5) then {
		daylight_iLastPickUpTime = time;

		_bContinue = false;
		if ((playerSide == blufor)) then {
			// If item is not in illegal ID's range BLUFOR can pick up
			if (!((_iItemID >= (daylight_cfg_arrInvIllegalIDRange select 0)) && (_iItemID <= (daylight_cfg_arrInvIllegalIDRange select 1)))) then {
				_bContinue = true;
			} else {
				// Hit cant pick up illegal
				hint "cant pick up illegal placeholder";
			};
		} else {
			_bContinue = true;
		};

		if (_bContinue) then {
			deleteVehicle (_this select 0);

			// Delete dropped object from game world
			_arrPos call daylight_fnc_networkDropItemDeleteObject;

			// Add to carried weight
			[([_iItemID, _iItemAmount] call daylight_fnc_invGetItemWeight)] call daylight_fnc_invModifyWeight;

			// Add items to takers inv
			[_iItemID, _iItemAmount] call daylight_fnc_invAddItem;

			// Play take anim
			[player, "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon"] call daylight_fnc_networkPlayMove;

			sleep 1;

			[format["You picked up %1x %2!", _iItemAmount, (_iItemID call daylight_fnc_invIDToStr) select 0]] call daylight_fnc_showActionMsg;
		};
	};
} else {
	["You can't carry that much, max weight reached!"] call daylight_fnc_showActionMsg;
};

if (true) exitWith {};