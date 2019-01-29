/*
	Description:	Misc SHARED functions
	Author:			qbt
*/

/*
	Description:	Disable respawn button
	Args:			arr [arr search in, any search query]
	Return:			int index in array
*/
daylight_fnc_findVariableInNestedArray = {
	// Get parameters
	_arrArray = (_this select 0);
	_iArraySize = (count _arrArray);
	_varValue = (_this select 1);

	_iRetVal = -1;

	// Loop trough arrArray
	for "_i" from 0 to _iArraySize do {
		// If array in nested array return val = position in nested array
		if (_varValue in (_arrArray select _i)) then {
			_iRetVal = _i;
		};
	};

	// Return val
	_iRetVal
};

/*
	Description:	Checks if target 1 has introduced himself to target 2
	Args:			arr [obj target1, obj target2]
	Return:			bool hasIntroducedTo
*/
daylight_fnc_hasIntroducedTo = {
	_bReturn = false;

	// Get list of introduced player ID's of target2
	_arrIntroducedPlayerIDs = [(_this select 0), "arrIntroducedPlayerIDsCivilian", [""]] call daylight_fnc_loadVar;

	if ((_arrIntroducedPlayerIDs find (getPlayerUID (_this select 1))) != -1) then {
		_bReturn = true;
	};

	_bReturn
};

/*
	Description:	Spawn misc interactable units
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_spawnMiscInteractableUnits = {
	daylight_arrMiscInteractableUnits = [];

	_grpMiscInteractableUnits = createGroup civilian;

	{
		_untMiscInteractableUnit = _grpMiscInteractableUnits createUnit [(_x select 0) select 0, [0, 0, 0], [], 0, "NONE"];

		_untMiscInteractableUnit setVariable ["daylight_arrInitialPos", (_x select 3)];

		_untMiscInteractableUnit enableSimulation false;
		_untMiscInteractableUnit allowDamage false;

		_untMiscInteractableUnit addEventHandler ["HandleDamage", {
			(_this select 0) setVelocity [0, 0, 0];

			_arrPos = (_this select 0) getVariable "daylight_arrInitialPos";

			if (((_this select 0) distance _arrPos) > 5) then {
				(_this select 0) setPosATL ((_this select 0) getVariable "daylight_arrInitialPos");
			};

			(_this select 0) switchMove "";
		}];

		{_untMiscInteractableUnit disableAI _x} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];
		_untMiscInteractableUnit setSkill 0;

		_untMiscInteractableUnit setFace ((_x select 0) select 1);
		_untMiscInteractableUnit addHeadgear ((_x select 0) select 2);
		_untMiscInteractableUnit addGoggles ((_x select 0) select 3);
		_untMiscInteractableUnit addUniform ((_x select 0) select 4);
		_untMiscInteractableUnit addVest ((_x select 0) select 5);

		_untMiscInteractableUnit switchMove "";

		_untMiscInteractableUnit setPos (_x select 1);
		_untMiscInteractableUnit setDir (_x select 2);

		daylight_arrMiscInteractableUnits set [count daylight_arrMiscInteractableUnits, _untMiscInteractableUnit];
	} forEach daylight_cfg_arrMiscInteractableUnits;

	publicVariable "daylight_arrMiscInteractableUnits";
};

/*
	Description:	Init (run scripts) for misc interactable units (client)
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_initMiscInteractableUnits = {
	waitUntil {!(isNil "daylight_arrMiscInteractableUnits")};

	for "_i" from 0 to ((count daylight_arrMiscInteractableUnits) - 1) do {
		_hSQF = (daylight_arrMiscInteractableUnits select _i) execVM format["daylight\client\misc\%1", ((daylight_cfg_arrMiscInteractableUnits select _i) select 4)];
	};

	if (true) exitWith {};
};

/*
	Description:	Perform isEqualTo check, thanks to Killzone_Kid for this (http://feedback.arma3.com/view.php?id=18089)
	Args:			any compare a, any compare b
	Return:			nothing
*/
daylight_fnc_isEqualTo = {
	switch (_this select 0) do {
		case (_this select 1) : {true};

		default {false};
	};
};

/*
	Description:	Show global message
	Args:			str message
	Return:			nothing
*/
daylight_fnc_globalMessage = {
	daylight_arrGlobalMessages set [count daylight_arrGlobalMessages, _this];

	systemChat format ["** %1", _this];
};

// Spawn misc interactable units on server, or init them on clients
if (isServer) then {
	[] call daylight_fnc_spawnMiscInteractableUnits;
	[] spawn daylight_fnc_initMiscInteractableUnits; // TO-DO: remove
} else {
	[] spawn daylight_fnc_initMiscInteractableUnits;
};

/*
	Description:	Seconds to minutes and seconds (no rounding)
	Args:			int seconds
	Return:			arr [i minutes, i seconds]
*/
daylight_fnc_secondsToMinutesAndSecondsNoRounding = {
	_arrOuput = [0, 0];

	_iMinutes = (_this / 60) % 60;
	_iSeconds = _this % 60;

	if (_iMinutes < 0) then {
		_iMinutes = 0;
	};

	if (_iSeconds < 0) then {
		_iSeconds = 0;
	};

	_arrOuput = [_iMinutes, _iSeconds];

	_arrOuput
};

/*
	Description:	UID to player object
	Args:			str uid
	Return:			obj player
*/
daylight_fnc_playerUIDtoPlayerObject = {
	_objReturn = objNull;

	{
		if ((getPlayerUID _x) == _this) then {
			_objReturn = _x;
		};
	} forEach playableUnits;

	_objReturn
};

/*
	Description:	Seconds to minutes and seconds
	Args:			int seconds
	Return:			arr [i minutes, i seconds]
*/
daylight_fnc_secondsToMinutesAndSeconds = {
	_arrOuput = [0, 0];

	_iMinutes = floor((_this / 60) % 60);
	_iSeconds = floor(_this % 60);

	if (_iMinutes < 0) then {
		_iMinutes = 0;
	};

	if (_iSeconds < 0) then {
		_iSeconds = 0;
	};

	_arrOuput = [_iMinutes, _iSeconds];

	_arrOuput
};

/*
	Description:	Seconds to hours and minutes
	Args:			int seconds
	Return:			arr [i minutes, i seconds]
*/
daylight_fnc_secondsToHoursAndMinutes = {
	_arrOuput = [0, 0];

	_iHours = floor((_this / 3600) % 3600);
	_iMinutes = floor((_this / 60) % 60);

	if (_iHours < 0) then {
		_iHours = 0;
	};

	if (_iMinutes < 0) then {
		_iMinutes = 0;
	};

	_arrOuput = [_iHours, _iMinutes];

	_arrOuput
};