/*
	Description:	Init for Daylight
	Author:			qbt
*/

// Protection against Steam Workshop.
if (isSteamMission) exitWith {};

/* Config */
// List of scripts that we need to run. (both, client, server)
_arrScriptsShared		= [
];

_arrScriptsClient	= [
	"daylight\client\clientLoop.sqf",
	"daylight\client\hudDraw.sqf",
	"daylight\client\disableSimulationOfNearObjects.sqf",
	"daylight\client\revealSurroundingsToPlayer.sqf",
	"daylight\client\forceClothing.sqf",
	"daylight\client\drugEffects.sqf"
];

_arrScriptsServer	= [
	"daylight\shared\endMissionLoop.sqf"
];

// List of functions that we need to initialize. (both, client, server)
_arrFunctionsShared	= [
	"daylight\shared\fnc\daylight_fnc_misc.sqf",
	"daylight\shared\fnc\daylight_fnc_network.sqf",
	"daylight\shared\fnc\daylight_fnc_handleVar.sqf",
	"daylight\shared\fnc\daylight_fnc_characterCreation.sqf",
	"daylight\shared\fnc\daylight_fnc_handleKilled.sqf",
	"daylight\shared\fnc\daylight_fnc_shop.sqf",
	"daylight\shared\fnc\daylight_fnc_jail.sqf",
	"daylight\shared\fnc\daylight_fnc_impound.sqf",
	"daylight\shared\fnc\daylight_fnc_licenses.sqf",
	"daylight\shared\fnc\daylight_fnc_handleDamage.sqf",
	"daylight\shared\fnc\daylight_fnc_gasStations.sqf",
	"daylight\shared\fnc\daylight_fnc_gangs.sqf",
	"daylight\shared\fnc\daylight_fnc_timeAndWeatherSync.sqf",
	"daylight\shared\fnc\daylight_fnc_objects.sqf",
	"daylight\shared\fnc\daylight_fnc_processing.sqf",
	"daylight\shared\fnc\daylight_fnc_president.sqf",
	"daylight\shared\fnc\daylight_fnc_wreckingYard.sqf"
];

_arrFunctionsClient	= [
	"daylight\client\fnc\daylight_fnc_misc.sqf",
	"daylight\client\fnc\daylight_fnc_str.sqf",
	"daylight\client\fnc\daylight_fnc_handleInput.sqf",
	"daylight\client\fnc\daylight_fnc_inventory.sqf",
	"daylight\client\fnc\daylight_fnc_trunk.sqf",
	"daylight\client\fnc\daylight_fnc_bank.sqf",
	"daylight\client\fnc\daylight_fnc_interaction.sqf",
	"daylight\client\fnc\daylight_fnc_locking.sqf",
	"daylight\client\fnc\daylight_fnc_shout.sqf",
	"daylight\client\fnc\daylight_fnc_mobilePhone.sqf",
	"daylight\client\fnc\daylight_fnc_stats.sqf",
	"daylight\client\fnc\daylight_fnc_settings.sqf",
	"daylight\client\fnc\daylight_fnc_stun.sqf",
	"daylight\client\fnc\daylight_fnc_progressBar.sqf",
	"daylight\client\fnc\daylight_fnc_policeMenu.sqf",
	"daylight\client\fnc\daylight_fnc_fishing.sqf",
	"daylight\client\fnc\daylight_fnc_statusMenu.sqf",
	"daylight\client\fnc\daylight_fnc_build.sqf",
	"daylight\client\fnc\daylight_fnc_tool.sqf",
	"daylight\client\fnc\daylight_fnc_policeVehicleFX.sqf",
	"daylight\client\fnc\daylight_fnc_adminMenu.sqf"
];

_arrFunctionsServer	= [
];

// Sleep a moment to make sure we don't initialize anything else in briefing.
sleep 0.001;

// Black out screen
titleText ["", "BLACK", 0.001];

//startLoadingScreen [""];
progressLoadingScreen 1;

/* Main script */
// Initialize config init and disable some stuff in briefing
_hConfigInit = execVM "daylight\cfg\init.sqf";
waitUntil {scriptDone _hConfigInit};

// Initialize variables with their default values
call compile preprocessFile "daylight\shared\defVariables.sqf";

// Initialize functions
{
	call compile preprocessFile _x;
} forEach _arrFunctionsShared;

if (!isDedicated) then {
	{
		call compile preprocessFile _x;
	} forEach _arrFunctionsClient;
};

if (isServer) then {
	{
		call compile preprocessFile _x;
	} forEach _arrFunctionsServer;
};

0 fadeRadio 0;

enableRadio false;
enableSaving [false, false];
enableSentences false;
enableTeamSwitch false;
player disableConversation true;

// Get view distance settings
_arrVDSettings = profileNamespace getVariable ["daylight_arrVDSettings", []];

if (count _arrVDSettings == 0) then {
	daylight_arrViewDistance = [daylight_cfg_iViewDistanceTerrain / 3, daylight_cfg_iViewDistanceTerrain / 3, daylight_cfg_iViewDistanceTerrain / 3];

	profileNamespace setVariable ["daylight_arrVDSettings", daylight_arrViewDistance];
	saveProfileNamespace;
} else {
	daylight_arrViewDistance = _arrVDSettings;
};

// Disable sound, music, etc. while loading.
enableEnvironment false;
[0, 0] call daylight_fnc_setMasterVolume;

// Execute scripts for both, client and server
{
	_hSQF = execVM _x;
} forEach _arrScriptsShared;

if (!isDedicated) then {
	{
		_hSQF = execVM _x;
	} forEach _arrScriptsClient;
};

if (isServer) then {
	{
		_hSQF = execVM _x;
	} forEach _arrScriptsServer;
};

// Apply some config from cfgMain/player settings
setTerrainGrid daylight_cfg_iTerrainGrid;
setViewDistance (daylight_arrViewDistance select 0);
setObjectViewDistance daylight_cfg_iViewDistanceObjects;
setShadowDistance daylight_cfg_iViewDistanceShadow;
setDetailMapBlendPars [daylight_cfg_iDetailMapDistance * 0.5, daylight_cfg_iDetailMapDistance * 1.5];

// Make blufor friendly to civ and the other way around
if (isServer) then {
	blufor setFriend [civilian, 1];
	civilian setFriend [blufor, 1];
};

// Create respawn markers to move players in to a safe-area.
createMarkerLocal ["respawn_civilian", daylight_cfg_arrRespawnHoldPos];

// Add map click EH
/*["daylight_onMapSingleClick", "onMapSingleClick", {
	[_pos, _shift, _alt] call daylight_fnc_onMapSingleClick;
}] call BIS_fnc_addStackedEventHandler;*/

// Enable sound, music, etc. after loading. Only enable env for clients.
if (!isDedicated) then {
	setViewDistance 1;

	enableEnvironment true;
};

if (!isDedicated) then {
	// Attach EH's to player
	player call daylight_fnc_addDefaultEventHandlers;

	// Set custom recoilCoefficient to player
	player setUnitRecoilCoefficient daylight_cfg_iRecoilCoefficient;

	// Start character creation
	[] spawn daylight_fnc_characterCreationInit;

	// Appy color correction for clients
	[] spawn daylight_fnc_setDefaultColorCorrection;
};

// Spawn bank vault on server
if (isServer) then {
	daylight_vehBankVault = createVehicle ["Box_NATO_AmmoVeh_F", [0, 0, 0], [], 0, "NONE"];

	daylight_vehBankVault enableSimulation true;

	daylight_vehBankVault setDir 11;
	daylight_vehBankVault setPosATL [3538.58,12998.1,12.358];

	publicVariable "daylight_vehBankVault";
};

daylight_arrRespawnPos = getPosATL player;
daylight_iRespawnDir = getDir player;

// Create end mission flag
_vehFlag = "Flag_Altis_F" createVehicleLocal [0, 0, 0];
_vehFlag setPosATL daylight_cfg_arrEndMissionGovBuildingFlagPos;

waitUntil {!(isNil "daylight_bGovBuildingCaptureable")};

_vehFlag addAction ["<t color=""#75c2e6"">Capture Government Building</t>", "daylight\client\actions\captureGovBuilding.sqf", [], 10, true, true, "", "((player distance _target) < 5) && daylight_bGovBuildingCaptureable && ((side player) == civilian)"];

endLoadingScreen;

daylight_arrInventory = [
	[10000, 999999]
];

if (true) exitWith {};