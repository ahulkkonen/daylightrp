/*
	Description:	Main config file for Daylight
	Author:			qbt
*/

// Performance
daylight_cfg_iViewDistanceTerrain				= 3000;						// Max VD, user can lower setting.
daylight_cfg_iViewDistanceObjects				= 750;
daylight_cfg_iViewDistanceShadow				= 100;
daylight_cfg_iTerrainGrid						= 50;
daylight_cfg_iDetailMapDistance					= 200;

// Gameplay
daylight_cfg_i24hIn								= 1;						// 24h in how many hours?
daylight_cfg_iSkipInterval						= 5;

daylight_cfg_arrDateAndWeatherCycle				= [
	[
		[2014, 6, 1, 4, 35],
		4,
		false,

		[
			[0.1, 0.2],
			[0.4, 0.4]
		]
	],

	[
		[2014, 6, 1, 12, 0],
		4,
		false,

		[
			[0.3, 0.65],
			[0.1, 0.75]
		]
	],

	[
		[2014, 6, 1, 15, 30],
		3,
		false,

		[
			[0.3, 0.65],
			[0.1, 0.75]
		]
	],

	[
		[2014, 6, 1, 18, 30],
		1,
		false,

		[
			[0.1, 0.2],
			[0.4, 0.5]
		]
	],

	[
		[2014, 6, 1, 19, 30],
		3,
		true,

		[
			[0.1, 0.2],
			[0.4, 0.4]
		]
	]
];

daylight_cfg_arrDateStart						= [2014, 6, 1, 15, 0];
daylight_cfg_arrDateHourMinuteMax				= [2014, 6, 1, 19, 30];
daylight_cfg_arrDateHourMinuteMin				= [2014, 6, 1, 11.166, 30];

daylight_cfg_iRecoilCoefficient					= 2;						// Custom recoilCoefficient (by default value 3 used to make firefigts last longer)

// Respawn
//daylight_cfg_arrRespawnPos					= [3758, 12997, 0];			// Actual respawn pos.
//daylight_cfg_iRespawnDir						= 270;						// Dir player will be facing when respawned.
daylight_cfg_arrRespawnHoldPos					= [16708, 13609, 0];		// Safe zone position where the player will spawn until moved to actual respawn location.
daylight_cfg_iRespawnTimeMin					= 10;
daylight_cfg_arrRespawnTimeAddedPerKillPerSide	= [10, 20];					// Amount of time added per kill per side in seconds. [civ, blufor]

// Misc
daylight_cfg_iMaxIntValue						= 999999;

// Items that always have simulation enabled
daylight_cfg_arrSimulationEnabled				= [
	"Box_IND_Wps_F",
	"FlagCarrierCore",
	"Land_PortableLight_single_F",
	"Land_PortableLight_double_F",
	"Land_FirePlace_F",
	"FirePlace_burning_F",
	"Land_Campfire_F",
	"Campfire_burning_F",
	"MetalBarrel_burning_F",
	"Land_LightHouse_F",
	"Land_LampAirport_F",
	"Land_LampDecor_F",
	"Land_LampHalogen_F",
	"Land_LampHarbour_F",
	"Land_LampShabby_F",
	"Land_LampStadium_F",
	"Land_LampStreet_F",
	"Land_LampStreet_small_F",
	"Land_Hospital_side2_F",
	"RoadCone_L_F",
	"GroundWeaponHolder"
];

// Items always spawned on server as global objects
daylight_cfg_arrSpawnGlobal					= [
	"Land_CarService_F",
	"Land_i_Barracks_V1_F",
	"Land_MilOffices_V1_F",
	"Land_Cargo_HQ_V1_F",
	"Land_Factory_Main_F",
	"Land_LightHouse_F",
	"Land_Cargo_Patrol_V1_F",
	"Land_FuelStation_Build_F",
	"Land_Kiosk_papers_F",
	"Land_BarGate_F"
];

// Interaction Menu max player distance from interacted
daylight_cfg_iMaxDistanceFromInteractedUnit		= 2.5;

// Main color correction params
daylight_cfg_arrDefaultColorCorrection			= [1, 1, -0.125, [0, 0, 0, 0], [0.5, 0.5, 0.5, 1.1], [0, 0, 0, 0]];
daylight_cfg_arrDefaultColorInversion			= [-0.02, -0.02, 0.02];

// Overview camera parameters
daylight_cfg_arrCamOverviewPos					= [3742, 12970, 25];
daylight_cfg_arrCamOverviewTarget				= [3350, 13258, 0];
daylight_cfg_iCamOverviewFOV					= 0.7;

// BLUFOR start gear
daylight_cfg_arrStartGearBLUFORWeapons			= [
	"Binocular",
	"ItemGPS"
];

daylight_cfg_arrStartGearBLUFORClothing			= [
	"H_Beret_blk_POLICE",
	"V_TacVestIR_blk",
	["u_rangemaster", "daylight\gfx\skins\police_7.jpg"],
	"B_Bergen_blk"
];

// BLUFOR vehicles
/*daylight_cfg_arrVehiclesBLUFOR					= [
	""
];*/

// Tools
daylight_cfg_iMaxToolUseDistance				= 25;

// Chat notifcation max distance
daylight_cfg_iChatNotificationMaxDistance		= 25;