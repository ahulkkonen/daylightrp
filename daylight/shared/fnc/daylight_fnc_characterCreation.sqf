/*
	Description:	SHARED Character creation functions
	Author:			qbt
*/

// If server, create array that contains all UID's of owners of saved characters.
if (isServer) then {
	daylight_arrCharacters = [];
	publicVariable "daylight_arrCharacters";
};

/*
	Description:	Initialize character creation
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_characterCreationInit = {
	// Make player not take damage
	player allowDamage false;

	// Create overview camera
	showCinemaBorder false;
	/*daylight_camOverview = "Camera" camCreate [0, 0, 0];
	daylight_camOverview cameraEffect ["Internal", "Back"];
	daylight_camOverview camSetPos daylight_cfg_arrCamOverviewPos;
	daylight_camOverview camSetTarget daylight_cfg_arrCamOverviewTarget;
	daylight_camOverview camSetFOV daylight_cfg_iCamOverviewFOV;
	daylight_camOverview camCommit 0;*/

	// Set player state
	player setVariable ["daylight_arrState", [0, 0, 0], true]; // [i hands up, i restrained, i jailed]

	// Remove players gear
	removeAllWeapons player;
	{player removeMagazine _x} forEach (magazines player);
	player unassignItem "NVGoggles";
	player removeItem "NVGoggles";
	player switchMove "";

	// Wait until main display becomes active
	waitUntil {!(isNull (findDisplay 46))};

	// Wait until we get the list of UID's of owners of characters
	waitUntil {!(isNil "daylight_arrCharacters")};

	// Check if character exists
	/*if (!(player call daylight_fnc_characterCreationCharacterExists)) then {
		// Character does not exist -> create CharacterCreation dialog
		createDialog format["CharacterCreation%1", player call daylight_fnc_returnSideStringForSavedVariables];
	} else {
		// Character exists, if player is civilian ask if he wants to create a new character
		if (playerSide == civilian) then {
			[] spawn daylight_fnc_newCharacterQuestion;
		};
	};*/

	if (!(player call daylight_fnc_characterCreationCharacterExists)) then {
		[] call daylight_fnc_characterCreationSaveCharacter;
	} else {
		// Show map after charcater created, we dont want people looking at the map in briefing.
		showMap true;

		// Character has been saved, HUD now knows to continue.
		daylight_bCharacterCreated = true;

		player allowDamage true;

		// Check if player has jailtime left
		_iJailTime = [player, format["iJailTime%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;

		if (_iJailTime > 0) then {
			[objNull, _iJailTime] call daylight_fnc_jailJailedMonitor;
		};

		// Join last gang
		_strLastGang = [player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_loadVar;

		if (_strLastGang != "") then {
			_iOldGang = [daylight_arrGangs, _strCurrentGang] call daylight_fnc_findVariableInNestedArray;
			[_iOldGang, false, false] call daylight_fnc_gangsJoinGang;
		};
	};
};

/*
	Description:	Initialize character creation (civilian clothing)
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_characterCreationInitClothingCivilian = {
	createDialog "CharacterCreationClothingCivilian";

	// Populate headgear list
	for "_i" from 0 to ((count daylight_cfg_arrHeadgear) - 1) do {
		lbAdd[2100, (daylight_cfg_arrHeadgear select _i) select 0];
		lbSetData[2100, _i, (daylight_cfg_arrHeadgear select _i) select 1];
	};
	lbSetCurSel[2100, ceil(random(count daylight_cfg_arrHeadgear - 1))];

	// Populate glasses list
	for "_i" from 0 to ((count daylight_cfg_arrGlasses) - 1) do {
		lbAdd[2101, (daylight_cfg_arrGlasses select _i) select 0];
		lbSetData[2101, _i, (daylight_cfg_arrGlasses select _i) select 1];	
	};
	lbSetCurSel[2101, ceil(random(count daylight_cfg_arrGlasses - 1))];

	// Populate outfit list
	for "_i" from 0 to ((count daylight_cfg_arrOutfits) - 1) do {
		lbAdd[2102, (daylight_cfg_arrOutfits select _i) select 0];
		lbSetData[2102, _i, (daylight_cfg_arrOutfits select _i) select 1];
	};
	lbSetCurSel[2102, ceil(random(count daylight_cfg_arrOutfits - 1))];
};

/*
	Description:	Initialize character creation (civilian clothing)
	Args:			arr [str headgear, str glasses, str outfit]
	Return:			nothing
*/
daylight_fnc_characterSetClothing = {
	removeHeadgear player;
	removeGoggles player;
	removeVest player;
	removeUniform player;

	if (playerSide == civilian) then {
		if (!(player call daylight_fnc_characterCreationCharacterExists)) then {
			[player, format["arrClothing%1", player call daylight_fnc_returnSideStringForSavedVariables], _this] call daylight_fnc_saveVar;

			player addHeadgear (_this select 0);
			player addGoggles (_this select 1);
			player addUniform (_this select 2);
		} else {
			_arrClothing = [player, format["arrClothing%1", player call daylight_fnc_returnSideStringForSavedVariables]] call daylight_fnc_loadVar;

			player addHeadgear (_arrClothing select 0);
			player addGoggles (_arrClothing select 1);
			player addUniform (_arrClothing select 2);
		};
	} else {
		player addHeadgear (daylight_cfg_arrStartGearBLUFORClothing select 0);
		player addVest (daylight_cfg_arrStartGearBLUFORClothing select 1);
		player addUniform ((daylight_cfg_arrStartGearBLUFORClothing select 2) select 0);
		player addBackpack (daylight_cfg_arrStartGearBLUFORClothing select 3);

		{player addWeapon _x} forEach daylight_cfg_arrStartGearBLUFORWeapons;
	};

	daylight_bCharacterClothed = true;
};

/*
	Description:	Save character
	Args:			arr [str fname, str lname, str desc]
	Return:			nothing
*/
daylight_fnc_characterCreationSaveCharacter = {
	// Save default variables
	[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], daylight_cfg_iCharacterStartMoney] call daylight_fnc_saveVar;
	[player, format["iBounty%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_saveVar;
	[player, format["iJailTime%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_saveVar;
	[player, format["arrKeys%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_saveVar;
	[player, format["arrWanted%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_saveVar;
	[player, format["arrLicenses%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_saveVar;

	// Reset received mobile phone messages
	profileNamespace setVariable ["daylight_arrMobilePhoneMessages", []];
	saveProfileNamespace;

	// Set random clothing
	[
		(daylight_cfg_arrHeadgear select ceil(random(count daylight_cfg_arrHeadgear - 1))) select 1,
		(daylight_cfg_arrGlasses select ceil(random(count daylight_cfg_arrGlasses - 1))) select 1,
		(daylight_cfg_arrOutfits select ceil(random(count daylight_cfg_arrOutfits - 1))) select 1
	] call daylight_fnc_characterSetClothing;

	// Variables for civ and blufor only
	/*if (playerSide == civilian) then {
		// Civilian
		[player, "arrIntroducedPlayerIDsCivilian", [""]] call daylight_fnc_saveVar;
		[] call daylight_fnc_characterCreationInitClothingCivilian;
	} else {
		// Blufor
		// Add player UID in the list of character owners
		player call daylight_fnc_characterCreationCharacterCreate;
	};*/

	player call daylight_fnc_characterCreationCharacterCreate;

	// Save default data
	[player, "arrKills", [0, 0]] call daylight_fnc_saveVar;

	// Show map after charcater created, we dont want people looking at the map in briefing.
	showMap true;

	// Character has been saved, HUD now knows to continue.
	daylight_bCharacterCreated = true;

	// Enable damage
	player allowDamage true;
};

/*
	Description:	Add character to character list
	Args:			obj player
	Return:			nothing
*/
daylight_fnc_characterCreationCharacterCreate = {
	_iIndex = [daylight_arrCharacters, getPlayerUID _this] call daylight_fnc_findVariableInNestedArray;

	if (_iIndex != -1) then {
		// Player UID in list
		_arrSides = (daylight_arrCharacters select _iIndex) select 1;
		_arrSides set [count _arrSides, playerSide];

		// Remove current item from array
		daylight_arrCharacters set [_iIndex, -1];
		daylight_arrCharacters = daylight_arrCharacters - [-1];

		// Add new entry with our new side
		daylight_arrCharacters set [count daylight_arrCharacters, [getPlayerUID _this, _arrSides]];
		publicVariable "daylight_arrCharacters";
	} else {
		// Player UID not in list, add it with our current side
		daylight_arrCharacters set [count daylight_arrCharacters, [getPlayerUID _this, [side _this]]];
		publicVariable "daylight_arrCharacters";
	};

	//[] spawn daylight_fnc_characterCreationFadeCameraToPlayerView;
};

/*
	Description:	Check if character exists already
	Args:			obj player
	Return:			nothing
*/
daylight_fnc_characterCreationCharacterExists = {
	_iIndex = [daylight_arrCharacters, getPlayerUID _this] call daylight_fnc_findVariableInNestedArray;

	_bReturn = false;
	if (_iIndex != -1) then {
		// Player UID in list
		// Does character exists for current player side?
		if ((((daylight_arrCharacters select _iIndex) select 1) find playerSide) != -1) then {
			// Exists
			_bReturn = true;
		};
	};

	_bReturn
};

/*
	Description:	Handles NewCharacterQuestion dialog
	Args:			nothing
	Return:			nothing
*/
/*
daylight_fnc_characterCreationNewCharacterQuestion = {
	createDialog "NewCharacterQuestion";
	ctrlEnable [1701, false];

	(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1100) ctrlSetStructuredText (parseText (format [localize "STR_DIALOG_NEWCHARACTERQUESTION", ([player, format["arrCharacterData%1", player call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar) select 0]));
	for "_i" from 0 to 9 do {
		(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1701) ctrlSetText (format ["%1 (%2)", localize "STR_DIALOG_NEWCHARACTERQUESTION_CREATENEW", 10 - _i]);

		sleep 1;
	};

	(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1701) ctrlSetText (localize "STR_DIALOG_NEWCHARACTERQUESTION_CREATENEW");
	ctrlEnable [1701, true];
};
*/

/*
	Description:	Handles NewCharacterQuestion dialog
	Args:			nothing
	Return:			nothing
*/
/*daylight_fnc_characterCreationFadeCameraToPlayerView = {
	titleText ["", "BLACK OUT", 2];
	sleep 2.5;

	// Delete overview camera
	//daylight_camOverview cameraEffect ["Terminate", "Back"];
	//camDestroy daylight_camOverview;

	titleText ["", "BLACK IN", 2]
};*/