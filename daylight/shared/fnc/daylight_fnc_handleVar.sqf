/*
	Description:	Saves/loads data to/from one game logic for mission saving.
	Author:			qbt
*/

// Server init
if (isServer) then {
	// Create game logic group, and game logic used for mission saving.
	createCenter sideLogic;
	daylight_grpSideLogic = createGroup sideLogic;
	daylight_logSave = daylight_grpSideLogic createUnit ["Logic", [0, 0, 0], [], 0, "NONE"];

	// We need to broadcast the game logic.
	publicVariable "daylight_logSave";
};

/*
	Description:	Saves variable in game logic
	Args:			arr [obj unit, any variable, any value]
	Return:			nothing
*/
daylight_fnc_saveVar = {
	_untUnit = (_this select 0);
	_anyVar = (_this select 1);
	_anyVal = (_this select 2);

	if (!(isNull _untUnit)) then {
		// Figure out saved variable name
		_strVarName = format["daylight_%1_%2", getPlayerUID _untUnit, _anyVar];

		// Save variable
		daylight_logSave setVariable [_strVarName, _anyVal, true];
	};
};

/*
	Description:	Loads variable from game logic
	Args:			arr [obj unit, any variable, any fallbackVar (if var not found)]
	Return:			any (loaded var), nil if var value not found
*/
daylight_fnc_loadVar = {
	_untUnit = (_this select 0);
	_anyVar = (_this select 1);
	_anyFallback = (_this select 2);
	_anyReturn = _anyFallback;

	if (!(isNull _untUnit)) then {
		// Figure out saved variable name
		_strVarName = format["daylight_%1_%2", getPlayerUID _untUnit, _anyVar];

		// Load variable
		_anyReturn = daylight_logSave getVariable [_strVarName, _anyFallback];
	};

	_anyReturn
};