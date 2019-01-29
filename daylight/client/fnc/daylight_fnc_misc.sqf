/*
	Description:	Misc CLIENT functions
	Author:			qbt
*/

/*
	Description:	Disable respawn button
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_disableRespawnButton = {
	disableSerialization;

	// Wait until IngamePause menu display comes active
	waitUntil {!(isNull (findDisplay 49))};

	// Disable respawn button
	((findDisplay 49) displayCtrl 1010) ctrlEnable false;

	// Exit thread
	if (true) exitWith {};
};

/*
	Description:	Add needed EH's to player
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_addDefaultEventHandlers = {
	_this addEventHandler ["Killed", {_this spawn daylight_fnc_handleKilledPlayer}];

	_this addEventHandler ["HandleDamage", {_this call daylight_fnc_handleDamagePlayer}];

	// Add repair actions
	if ((side player) == blufor) then {
		{
			player addAction [format["<t color=""#75c2e6"">Repair %1</t>", (_x select 0)], "daylight\client\actions\repairEndMissionLocation.sqf", [], 10, true, true, "", "_this call daylight_fnc_endMissionAction"];
		} forEach daylight_cfg_arrEndMissionLocations;
	};

	// Add holster actions
	daylight_strHolsteredWeapon = "";
	player addAction ["<t color=""#75c2e6"">Holster handgun</t>", "daylight\client\actions\holsterUnholsterWeapon.sqf", [], 10, true, true, "", "(_this call daylight_fnc_handleHolsterAction) select 0"];
	player addAction ["<t color=""#75c2e6"">Unholster handgun </t>", "daylight\client\actions\holsterUnholsterWeapon.sqf", [], 10, true, true, "", "(_this call daylight_fnc_handleHolsterAction) select 1"];
};

/*
	Description:	Remove attached EH's from player
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_removeDefaultEventHandlers = {
	_this removeAllEventHandlers "Killed";
};

/*
	Description:	Control game master volume
	Args:			arr [int time, int vol]
	Return:			nothing
*/
daylight_fnc_setMasterVolume = {
	(_this select 0) fadeSound (_this select 1);
	(_this select 0) fadeSpeech (_this select 1);
	(_this select 0) fadeMusic (_this select 1);
	(_this select 0) fadeRadio (_this select 1);
};

/*
	Description:	Show action text
	Args:			arr [str text, (int time)]
	Return:			nothing
*/
daylight_fnc_showActionMsg = {
	_iTime = (_this select 1);

	// disableSerialization so we can work with UI datatypes
	disableSerialization;

	// Show message
	if (!(isNil "_iTime")) then {
		202 cutRsc ["actionMsg", "PLAIN", _iTime];
	} else {
		202 cutRsc ["actionMsg", "PLAIN", 2.5];
	};

	// Get variables set in RscTitles.hpp
	_dDisplay = ((uiNamespace getVariable "daylight_arrRscActionMsg") select 0);
	_iIDC = ((uiNamespace getVariable "daylight_arrRscActionMsg") select 1);
	_cControl = _dDisplay displayCtrl _iIDC;

	// Set text
	_cControl ctrlSetStructuredText (parseText format["<t align=""center"" size=""1.8"" shadow=""1"">%1</t>", (_this select 0)]);
};

/*
	Description:	Broadcasts whistle sound
	Args:			obj whistler
	Return:			nothing
*/

// Keep track of time last whistled
daylight_iLastWhistleTime = 0;

daylight_fnc_whistle = {
	if (((time - daylight_iLastWhistleTime) > 5) && !(underwater player)) then {
		daylight_iLastWhistleTime = time;

		_arrSounds = [
			0,
			1
		];

		// Select random sound from _arrSounds
		_iSound = _arrSounds call BIS_fnc_selectRandom;

		// Play the sound locally and broadcast it as positional audio as well
		playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select _iSound));
		[player, _iSound, false] call daylight_fnc_networkSay3D;
	};
};

/*
	Description:	Return players in certain radius (including self)
	Args:			arr [obj from, int radius]
	Return:			arr [obj players in radius]
*/
daylight_fnc_playersInRadius = {
	_arrPlayers = [];

	{
		if (((_this select 0) distance _x) <= (_this select 1)) then {
			_arrPlayers set [count _arrPlayers, _x];
		};
	} forEach playableUnits;

	_arrPlayers
};

/*
	Description:	Return side string for saved variables, "civilian" for civ and "blufor" for blufor
	Args:			obj player
	Return:			bool
*/
daylight_fnc_returnSideStringForSavedVariables = {
	_strReturn = "Civilian";

	if ((side _this) == blufor) then {
		_strReturn = "Blufor"
	};

	_strReturn
};

/*
	Description:	Removes items from cargo
	Args:			[obj cargo, str item to remove]
	Return:			nothing
*/
daylight_fnc_removeItemsFromCargo = {
	_arrCurrentCargo = (itemCargo (_this select 0)) call daylight_fnc_lowercaseStringInArray;

	if ((_arrCurrentCargo find (_this select 1)) != -1) then {
		_arrNewCargo = _arrCurrentCargo - [(_this select 1)];

		_arrItemsProcessed = [];

		// Clear cargo
		clearItemCargoGlobal (_this select 0);

		{
			if ((_arrItemsProcessed find _x) == -1) then {
				(_this select 0) addItemCargoGlobal [_x, [_x, _arrNewCargo] call daylight_fnc_countOccurencesInArray];
				_arrItemsProcessed set [count _arrItemsProcessed, _x];
			};
		} forEach _arrNewCargo;
	};
};

/*
	Description:	Find occurences in array
	Args:			[any needle, arr haystack]
	Return:			int amount of occurences
*/
daylight_fnc_countOccurencesInArray = {
	_iOccurences = 0;

	{
		if (_x == (_this select 0)) then {
			_iOccurences = _iOccurences + 1;
		};
	} forEach (_this select 1);

	_iOccurences
};

/*
	Description:	Lowercase strings in arrays
	Args:			arr array
	Return:			arr lowercased strings in array
*/
daylight_fnc_lowercaseStringInArray = {
	_arrOuput = [];

	{
		if (typeName _x == "STRING") then {
			_arrOuput set [count _arrOuput, toLower(_x)];
		} else {
			_arrOuput set [count _arrOuput, _x];
		};
	} forEach _this;

	_arrOuput
};

/*
	Description:	Withdraw from bank
	Args:			arr [str title, str message, b playSound]
	Return:			nothing
*/
daylight_fnc_showHint = {
	//old color #ff0000
	_strMessage = parseText(format["<t size=""1.5"" color=""#007dff"" underline=""1"">%1</t><br/><br/><t size=""1"" color=""#ffffff"">%2</t>", (_this select 0), (_this select 1)]);

	if ((_this select 2)) then {
		hint _strMessage;
	} else {
		hintSilent _strMessage;
	};
};

/*
	Description:	Create notification window
	Args:			arr [str title, str message]
	Return:			nothing
*/
daylight_fnc_showNotificationWindow = {
	createDialog "NotificationWindow";

	// Set title
	ctrlSetText [1000, (_this select 0)];

	// Set structured text
	((uiNamespace getVariable "daylight_dsplActive") displayCtrl 1100) ctrlSetStructuredText (parseText(_this select 1));
};

/*
	Description:	Create & set default color correction
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_setDefaultColorCorrection = {
	if (isNil "daylight_ppColorCorrection") then {
		daylight_ppColorCorrection = ppEffectCreate ["ColorCorrections", 1550];
		daylight_ppColorCorrection ppEffectEnable true;
	};

	_iOffset = (daylight_cfg_arrDefaultColorCorrection select 2);

	if (sunOrMoon <= 0.1) then {
		_iOffset = -0.025;
	};

	daylight_ppColorCorrection ppEffectAdjust [
		daylight_cfg_arrDefaultColorCorrection select 0,
		daylight_cfg_arrDefaultColorCorrection select 1,
		_iOffset,
		daylight_cfg_arrDefaultColorCorrection select 3,
		daylight_cfg_arrDefaultColorCorrection select 4,
		daylight_cfg_arrDefaultColorCorrection select 5
	];

	daylight_ppColorCorrection ppEffectCommit 0;
};

/*
	Description:	Create & set weather color correction
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_setWeatherColorCorrection = {
	if (isNil "daylight_ppColorCorrectionWeather") then {
		daylight_ppColorCorrectionWeather = ppEffectCreate ["ColorCorrections", 1551];
		daylight_ppColorCorrectionWeather ppEffectEnable true;
	};

	_iOvercast = overcast;

	if (_iOvercast < 0.6) then {
		_iOvercast = 0;
	};

	daylight_ppColorCorrectionWeather ppEffectAdjust [
		1,
		1,
		0,
		[0, 0, 0, 0],
		[1, 1, 1, 1 - (1 * (_iOvercast * 0.5))],
		[0.35, 0.25, 0.25, 0]
	];

	daylight_ppColorCorrectionWeather ppEffectCommit 0;
};

/*
	Description:	Invert array
	Args:			arr array
	Return:			arr array (inverted)
*/
daylight_fnc_invertArray = {
	_arrInput = _this;
	_arrOuput = [];

	for "_i" from 0 to ((count _arrInput) - 1) do {
		_arrOuput set [count _arrOuput, _arrInput select (((count _arrInput) - 1) - _i)];
	};

	_arrOuput
};

/*
	Description:	Create fire effect (using BIS fnc)
	Args:			[arr positionASL, int timeout, (([veh attachTo, arr attachTo pos]), (int size, int density, int particle liftime))]
	Return:			obj fire
*/
daylight_fnc_createEffectFire = {
	// Compile BIS function
	BIS_fn_moduleEffectsFireCore = compile preprocessFile "\a3\modules_f\Effects\functions\fn_moduleEffectsFire.sqf";

	_vehLogic = "Land_HelipadEmpty_F" createVehicleLocal [0, 0, 0];
	_vehLogic setPosASL (_this select 0);

	_vehLogic setVariable ["ColorRed", 0.5];
	_vehLogic setVariable ["ColorGreen", 0.5];
	_vehLogic setVariable ["ColorBlue", 0.5];
	_vehLogic setVariable ["ColorAlpha", 0.5];

	_vehLogic setVariable ["Timeout", (_this select 1)];

	if (count _this >= 3) then {
		_vehLogic setVariable ["ParticleSize", (_this select 3)];
		_vehLogic setVariable ["ParticleDensity", (_this select 4)];
		_vehLogic setVariable ["ParticleLifeTime", (_this select 5)];
	} else {
		_vehLogic setVariable ["ParticleSize", 1];
		_vehLogic setVariable ["ParticleDensity", 20];
		_vehLogic setVariable ["ParticleLifeTime", 2];
	};

	_vehParticleSource = "#particlesource" createVehicleLocal [0, 0, 0];
	_vehParticleSource setPosASL (_this select 0);

	if (count _this >= 2) then {
		_vehLogic attachTo (_this select 2);
		_vehParticleSource attachTo (_this select 2);
	};

	_vehLogic setVariable ["effectEmitter", [_vehParticleSource]];

	_vehLogic call BIS_fn_moduleEffectsFireCore;

	_vehLogic
};

/*
	Description:	Create smoke effect (using BIS fnc)
	Args:			[arr positionASL, int timeout, (([veh attachTo, arr attachTo pos]), (int size, int density, int particle liftime))]
	Return:			obj fire
*/
daylight_fnc_createEffectSmoke = {
	// Compile BIS function
	BIS_fn_moduleEffectsSmokeCore = compile preprocessFile "\a3\modules_f\Effects\functions\fn_moduleEffectsSmoke.sqf";

	_vehLogic = "Land_HelipadEmpty_F" createVehicleLocal [0, 0, 0];
	_vehLogic setPosASL (_this select 0);

	_vehLogic setVariable ["ColorRed", 0.5];
	_vehLogic setVariable ["ColorGreen", 0.5];
	_vehLogic setVariable ["ColorBlue", 0.5];
	_vehLogic setVariable ["ColorAlpha", 0.9];

	_vehLogic setVariable ["Timeout", (_this select 1)];

	if (count _this >= 3) then {
		_vehLogic setVariable ["ParticleSize", (_this select 3)];
		_vehLogic setVariable ["ParticleDensity", (_this select 4)];
		_vehLogic setVariable ["ParticleLifeTime", (_this select 5)];
	} else {
		_vehLogic setVariable ["ParticleSize", 1];
		_vehLogic setVariable ["ParticleDensity", 10];
		_vehLogic setVariable ["ParticleLifeTime", 50];
	};

	_vehParticleSource = "#particlesource" createVehicleLocal [0, 0, 0];
	_vehParticleSource setPosASL (_this select 0);

	if (count _this >= 2) then {
		_vehLogic attachTo (_this select 2);
		_vehParticleSource attachTo (_this select 2);
	};

	_vehLogic setVariable ["effectEmitter", [_vehParticleSource]];

	_vehLogic call BIS_fn_moduleEffectsSmokeCore;

	_vehLogic
};

/*
	Description:	onMapSingleCLick
	Args:			
	Return:			nothing
*/
daylight_fnc_onMapSingleClick = {
	/*_strGang = [player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_loadVar;

	_arrWPs = waypoints player;

	if (_strGang != "") then {
		_iIndex = [daylight_arrGangs, _strGang] call daylight_fnc_findVariableInNestedArray;

		_bIsAdmin = (((daylight_arrGangs select _iIndex) select 1) select 0) == player;

		if (_bIsAdmin) then {
			{
				deleteWaypoint [group player, _x select 1];
			} forEach _arrWPs;

			_wpWaypoint = (group player) addWaypoint [_this select 0, 0];
		};
	} else {
		{
			deleteWaypoint [group player, _x select 1];
		} forEach _arrWPs;

		_wpWaypoint = (group player) addWaypoint [_this select 0, 0];
	};*/
};

/*
	Description:	Fade in / out dialog
	Args:			b fadeIn
	Return:			obj fire
*/
/*daylight_fnc_fadeDialog = {
	disableSerialization;

	_arrIDCs = [];
	_iFade = 1;

	if (_this) then {
		_iFade = 0;
	};

	_iControlsCount = count (missionConfigFile >> daylight_strActiveDialogClass >> "controls");

	for "_i" from 0 to ((_iControlsCount) - 1) do {
		_arrIDCs set [count _arrIDCs, getNumber (((missionConfigFile >> daylight_strActiveDialogClass >> "controls") select _i) >> "idc")];
	};

	_dDisplay = (uiNamespace getVariable "daylight_dsplActive");

	if (_this) then {
		{
			_cControl = _dDisplay displayCtrl _x;

			_cControl ctrlSetFade 1;
			_cControl ctrlCommit 0;
		} forEach _arrIDCs;
	};

	{
		_cControl = _dDisplay displayCtrl _x;

		_cControl ctrlSetFade _iFade;
		_cControl ctrlCommit daylight_cfg_iDialogFadeInOutTime /2;
	} forEach _arrIDCs;

	if (!_this) then {
		[] spawn {
			sleep daylight_cfg_iDialogFadeInOutTime / 2;

			closeDialog 0;
		};
	};
};*/

/*
	Description:	Return nearest marker of array
	Args:			arr [obj from, arr markers]
	Return:			obj fire
*/
daylight_fnc_getNearestMarker = {
	_arrMarkers = _this select 1;
	_strReturn = "";

	_iDistance = 0;
	_iNearestDistance = 999999;
	{
		_iDistance = (_this select 0) distance (getMarkerPos _x);
		
		if (_iDistance < _iNearestDistance) then {
			_iNearestDistance = _iDistance;
			_strReturn = _x;
		};
	} forEach _arrMarkers;

	_strReturn
};

/*
	Description:	Return all mission markers of
	Args:			nothing
	Return:			arr markers
*/
daylight_fnc_getMissionMarkers = {
	_arrMarkers = allMapMarkers;
	_arrMarkersMission = [];

	{
		_strFirstCharacter = [_x, 0, 0] call BIS_fnc_trimString;
		
		if ((_strFirstCharacter != "_")) then {
			_arrMarkersMission set [count _arrMarkersMission, _x];
		};
	} forEach _arrMarkers;

	_arrMarkersMission
};

/*
	Description:	End mission action
	Args:			nothing
	Return:			b show
*/
daylight_fnc_endMissionAction = {
	_bReturn = false;
	
	_strNearestMarker = [player, daylight_cfg_arrEndMissionLocationsMarkers] call daylight_fnc_getNearestMarker;

	if ((player distance (getMarkerPos _strNearestMarker)) <= 5) then {
		_arrNearSmokes = nearestObjects [getMarkerPos _strNearestMarker, ["test_EmptyObjectForSmoke"], 25];

		if ((count _arrNearSmokes) > 0) then {
			_bReturn = true;
		};
	};

	_bReturn
};

/*
	Description:	Handle holster action
	Args:			nothing
	Return:			arr [b show, b show]
*/
daylight_fnc_handleHolsterAction = {
	_arrReturn = [false, false];

	if (((currentWeapon player) == (handgunWeapon player)) && ((currentWeapon player) != "")) then {
		if (daylight_strHolsteredWeapon == "") then {
			_arrReturn = [true, false];
		};
	} else {
		if ((daylight_strHolsteredWeapon != "") && ((handgunWeapon player) == "")) then {
			_arrReturn = [false, true];
		};
	};

	_arrReturn
};