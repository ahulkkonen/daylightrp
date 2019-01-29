/*
	Description:	Shops config file
	Author:			qbt
*/

/*
	Notes:

	-1 stock = infinite stock
*/

dayight_cfg_iShopSoldProfit			= 0.75;

daylight_cfg_iShopAutoBountyMaxTime	= 600;

daylight_cfg_strAmmoBoxClassName	= "Box_IND_Wps_F";

daylight_cfg_arrGearItems			= [
	// 0 = weapon, 1 = magazine, 2 = item
	// Weapons
	[100001, 0, "hgun_Rook40_F"],
	[100003, 0, "arifle_SDAR_F"],
	[100005, 0, "hgun_P07_F"],
	[100007, 0, "hgun_Pistol_heavy_02_F"],
	[100009, 0, "hgun_PDW2000_F"],
	[100011, 0, "SMG_01_F"],
	[100013, 0, "arifle_TRG20_F"],
	[100015, 0, "arifle_Katiba_F"],
	[100017, 0, "srifle_DMR_01_F"],
	[100019, 0, "LMG_Mk200_F"],
	[100021, 0, "srifle_LRR_SOS_F"],
	[100023, 0, "launch_RPG32_F"],
	[100027, 0, "hgun_ACPC2_F"],
	[100029, 0, "SMG_02_F"],
	[100031, 0, "arifle_MXM_Black_F"],
	[100033, 0, "srifle_EBR_F"],
	[100035, 0, "srifle_LRR_SOS_F"],

	// Magazines
	[100002, 1, "16Rnd_9x21_Mag"],
	[100004, 1, "30Rnd_556x45_Stanag"],
	[100006, 1, "16Rnd_9x21_Mag"],
	[100008, 1, "6Rnd_45ACP_Cylinder"],
	[100010, 1, "30Rnd_9x21_Mag"],
	[100012, 1, "30Rnd_45ACP_Mag_SMG_01"],
	[100014, 1, "30Rnd_556x45_Stanag"],
	[100016, 1, "30Rnd_65x39_caseless_green"],
	[100018, 1, "10Rnd_762x51_Mag"],
	[100020, 1, "200Rnd_65x39_cased_Box"],
	[100022, 1, "7Rnd_408_Mag"],
	[100024, 1, "RPG32_F"],
	[100028, 1, "9Rnd_45ACP_Mag"],
	[100030, 1, "30Rnd_9x21_Mag"],
	[100032, 1, "30Rnd_65x39_caseless_mag"],
	[100034, 1, "20Rnd_762x51_Mag"],
	[100036, 1, "7Rnd_408_Mag"],

	// Items
	[50010, 2, "Binocular"],
	[50011, 2, "ItemGPS"],

	[100025, 2, "V_Chestrig_oli"],
	[100026, 2, "H_Shemag_olive"],
	[100037, 2, "Rangefinder"],
	[100038, 2, "V_TacVest_blk_POLICE"],

	[110001, 2, "U_C_Poloshirt_blue"],
	[110002, 2, "U_C_Poloshirt_burgundy"],
	[110003, 2, "U_C_Poloshirt_stripped"],
	[110004, 2, "U_C_Poloshirt_tricolour"],
	[110005, 2, "U_C_Poloshirt_salmon"],
	[110006, 2, "U_C_Poloshirt_redwhite"],
	[110007, 2, "U_IG_Guerilla2_1"],
	[110008, 2, "U_IG_Guerilla2_2"],
	[110009, 2, "U_IG_Guerilla2_3"],
	[110010, 2, "U_IG_Guerilla3_1"],
	[110011, 2, "U_IG_Guerilla3_2"],
	[110012, 2, "U_C_Poor_1"],
	[110013, 2, "U_C_HunterBody_grn"],
	[110014, 2, "U_I_G_Story_Protagonist_F"],
	[110015, 2, "U_IG_Guerilla1_1"],
	[50012, 2, "acc_flashlight"],

	// Backpacks
	[110016, 3, "B_AssaultPack_blk"],
	[110017, 3, "B_Bergen_blk"]
];

_cfg_arrTestMerchantDefault 		= [
	// [i item id, i stock]
	[10001, 1]
];

_cfg_arrMerchantCivilianBuildingMaterialStore = [
	[
		[70001, -1],
		[70002, -1],
		[70003, -1],
		[70004, -1],
		[70005, -1],
		[70006, -1],
		[70007, -1],
		[70008, -1],
		[70009, -1],
		[70010, -1],
		[70011, -1],
		[70012, -1],
		[70013, -1],
		[70014, -1],
		[70015, -1],
		[70016, -1],
		[70017, -1]
	],

	[
		70001,
		70002,
		70003,
		70004,
		70005,
		70006,
		70007,
		70008,
		70009,
		70010,
		70011,
		70012,
		70013,
		70014,
		70015,
		70016,
		70017
	]
];

_cfg_arrMerchantCivilianGeneralStore = [
	[
		[50001, -1],
		[50002, -1],
		[50003, -1],
		[50004, -1],
		[50005, -1],
		[50006, -1],
		[50007, -1],
		[50008, -1],
		[50009, -1],
		[50010, -1],
		[50011, -1]
	],

	[
		50001,
		50002,
		50003,
		50004,
		50005,
		50006,
		50007,
		50008,
		50009
	]
];

_cfg_arrMerchantCivilianGroceryStore	= [
	[
		[20002, -1],
		[20003, -1],
		[20004, -1],
		[20005, -1],
		[20006, -1],
		[20007, -1],
		[20008, -1],
		[20009, -1],
		[20010, -1]
	],

	[
		20002,
		20003,
		20004,
		20005,
		20006,
		20007,
		20008,
		20009,
		20010
	]
];

_cfg_arrMerchantCivilianGangArea		= [
	[
		[90006, -1],
		[90012, -1],
		[100005, -1],
		[100006, -1],
		[100009, -1],
		[100010, -1]
	],

	[
		90006,
		90012
	]
];

_cfg_arrMerchantCivilianWeaponShop		= [
	[
		[100001, -1],
		[100002, -1],
		[100003, -1],
		[100004, -1]
	],

	[]
];

_cfg_arrMerchantCivilianBlackMarket		= [
	[
		[90006, -1],
		[90012, -1],

		[100005, -1],
		[100006, -1],

		[100007, -1],
		[100008, -1],

		[100009, -1],
		[100010, -1],

		[100011, -1],
		[100012, -1],

		[100013, -1],
		[100014, -1],

		[100015, -1],
		[100016, -1]
	],

	[
		90006,
		90012
	]
];

_cfg_arrMerchantCivilianDrugSeller		= [
	[
		[90001, -1],
		[90002, -1],
		[90003, -1]
	],

	[

	]
];

_cfg_arrMerchantCivilianTerroristIsland	= [
	[
		[100017, -1],
		[100018, -1],
		[100019, -1],
		[100020, -1],
		[100021, -1],
		[100022, -1],
		[100023, -1],
		[100024, -1],
		[100025, -1],
		[100026, -1]
	],

	[

	]
];

_cfg_arrMerchantBluforItemShop			= [
	[
		[50001, -1],
		[50002, -1],

		[50003, -1],
		[50004, -1],

		[50010, -1],
		[50011, -1]
	],

	[
		50001,
		50002,
		50003,
		50004
	]
];

_cfg_arrMerchantBluforWeaponShop		= [
	[
		[100027, -1],
		[100028, -1],

		[100029, -1],
		[100030, -1],

		[100031, -1],
		[100032, -1],

		[50012, -1]
	],

	[

	]
];

_cfg_arrMerchantBluforBuildingMaterialShop	= [
	[
		[60001, -1],
		[60002, -1],
		[60003, -1],
		[60004, -1],
		[60005, -1],
		[60006, -1],
		[60011, -1],
		[60012, -1],
		[60013, -1],
		[60014, -1],
		[60015, -1],
		[60016, -1],
		[60017, -1],
		[60018, -1],
		[60019, -1],
		[60020, -1],
		[60021, -1]
	],

	[
		60001,
		60002,
		60003,
		60004,
		60005,
		60006,
		60011,
		60012,
		60013,
		60014,
		60015,
		60016,
		60017,
		60018,
		60019,
		60020,
		60021
	]
];

_cfg_arrMerchantBluforEKAMShop			= [
	[
		[100033, -1],
		[100034, -1],

		[100035, -1],
		[100036, -1],

		[100037, -1]
	],
	
	[

	]
];

_cfg_arrMerchantCivilianClothingStore	= [
	[
		[110001, -1],
		[110002, -1],
		[110003, -1],
		[110004, -1],
		[110005, -1],
		[110006, -1],
		[110007, -1],
		[110008, -1],
		[110009, -1],
		[110010, -1],
		[110011, -1],
		[110012, -1],
		[110013, -1],
		[110014, -1],
		[110015, -1],
		[110016, -1],
		[110017, -1]
	],

	[

	]
];

_cfg_arrMerchantCivilianExportDocks		= [
	[

	],

	[
		30010,
		30007,
		30008,
		30005,
		30002,
		90008
	]
];

daylight_cfg_arrMerchants		= [
	// [arr [str classname, str face, str headgear, str goggles, str uniform, str vest], str name, arr default stock, arr accepted ids, arr pos, i dir, b add item to stock when sold]
	// Civilian building material store
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Building Material Shop",

		_cfg_arrMerchantCivilianBuildingMaterialStore select 0,
		_cfg_arrMerchantCivilianBuildingMaterialStore select 1,

		[3482.32,13230.6,0.53356],
		315,

		false,
		[civilian],
		""
	],

	// Kavala General Store
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"General Store",

		_cfg_arrMerchantCivilianGeneralStore select 0,
		_cfg_arrMerchantCivilianGeneralStore select 1,

		[3446.42,13279.9,0.498027],
		305,

		false,
		[civilian],
		"",

		// Gear box position
		[3445.44,13278.7,0.473075],
		309
	],

	// Zaros General Store
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"General Store",

		_cfg_arrMerchantCivilianGeneralStore select 0,
		_cfg_arrMerchantCivilianGeneralStore select 1,

		[9088.39,11967.8,0.47842],
		190,

		false,
		[civilian],
		"",

		// Gear box position
		[9090.05,11967.5,0.510759],
		190
	],

	// Agios General Store
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"General Store",

		_cfg_arrMerchantCivilianGeneralStore select 0,
		_cfg_arrMerchantCivilianGeneralStore select 1,

		[9108.51,15802,0.325005],
		152,

		false,
		[civilian],
		"",

		// Gear box position
		[9110.17,15802.8,0.284302],
		152
	],

	// Grocery store Kavala
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Grocery Store",

		_cfg_arrMerchantCivilianGroceryStore select 0,
		_cfg_arrMerchantCivilianGroceryStore select 1,

		[3416.38,13092.3,0.616152],
		168,

		false,
		[civilian],
		""
	],

	// Grocery store Zaros
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Grocery Store",

		_cfg_arrMerchantCivilianGroceryStore select 0,
		_cfg_arrMerchantCivilianGroceryStore select 1,

		[9052.21,11936.1,0.326017],
		89,

		false,
		[civilian],
		""
	],

	// Grocery store Agios
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Grocery Store",

		_cfg_arrMerchantCivilianGroceryStore select 0,
		_cfg_arrMerchantCivilianGroceryStore select 1,

		[9322.39,15886.4,0.517906],
		158,

		false,
		[civilian],
		""
	],

	// Gang area 1
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Gang Store",

		_cfg_arrMerchantCivilianGangArea select 0,
		_cfg_arrMerchantCivilianGangArea select 1,

		[4597.23,13909.6,0.247055],
		228,

		false,
		[civilian],
		"",

		[4597.38,13907.2,0.446659],
		321
	],

	// Gang area 2
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Gang Store",

		_cfg_arrMerchantCivilianGangArea select 0,
		_cfg_arrMerchantCivilianGangArea select 1,

		[9017.2,15804.7,0.00154877],
		160,

		false,
		[civilian],
		"",

		[9018.17,15805,0.00164795],
		160
	],

	// Gang area 3
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Gang Store",

		_cfg_arrMerchantCivilianGangArea select 0,
		_cfg_arrMerchantCivilianGangArea select 1,

		[9055.97,11747.2,0.00153351],
		311,

		false,
		[civilian],
		"",

		[9054.73,11745.8,0.00153351],
		311
	],

	// Weapon Shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Weapon Shop",

		_cfg_arrMerchantCivilianWeaponShop select 0,
		_cfg_arrMerchantCivilianWeaponShop select 1,

		[5501.95,14606.8,0.732304],
		41,

		false,
		[civilian],
		"Weapon License",

		[5503.35,14605.6,0.691422],
		41
	],

	// Black market
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Black Market",

		_cfg_arrMerchantCivilianBlackMarket select 0,
		_cfg_arrMerchantCivilianBlackMarket select 1,

		[7514.28,16266.3,0.203491],
		200,

		false,
		[civilian],
		"",

		[7512.65,16266.9,0.264648],
		200
	],

	// Drug dealer
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Drug Dealer",

		_cfg_arrMerchantCivilianDrugSeller select 0,
		_cfg_arrMerchantCivilianDrugSeller select 1,

		[3678.84,13294.7,0.00205278],
		168,

		false,
		[civilian],
		""
	],

	// Terrorist island
	[
		["c_man_1", "", "H_Shemag_olive_hs", "", "U_OG_Guerilla2_3", "V_BandollierB_oli"],
		"Terrorist Shop",

		_cfg_arrMerchantCivilianTerroristIsland select 0,
		_cfg_arrMerchantCivilianTerroristIsland select 1,

		[13577.3,12197.7,0.701735],
		110,

		false,
		[civilian],
		"",

		[13577.8,12198.7,0.609081],
		115
	],

	// Police item shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Police Item Shop",

		_cfg_arrMerchantBluforItemShop select 0,
		_cfg_arrMerchantBluforItemShop select 1,

		[3098.07,12571,0.00143886],
		235,

		false,
		[blufor],
		"",

		[3098.7,12570.1,0.00143886],
		235
	],

	// Police weapon shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Police Weapon Shop",

		_cfg_arrMerchantBluforWeaponShop select 0,
		_cfg_arrMerchantBluforWeaponShop select 1,

		[3102.77,12564.6,0.00143886],
		235,

		false,
		[blufor],
		"",

		[3103.71,12563.5,0.00143886],
		235
	],

	// Police building material shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Police Building Material Shop",

		_cfg_arrMerchantBluforBuildingMaterialShop select 0,
		_cfg_arrMerchantBluforBuildingMaterialShop select 1,

		[2950.06,12577.8,0.215693],
		30,

		false,
		[blufor],
		""
	],

	// E.K.A.M. shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Police E.K.A.M. Shop",

		_cfg_arrMerchantBluforEKAMShop select 0,
		_cfg_arrMerchantBluforEKAMShop select 1,

		[2838.09,12669.8,3.00639],
		130,

		false,
		[blufor],
		"E.K.A.M. License",

		[2839.1,12670.35,3.03518],
		139
	],

	// Clothing store - Kavala
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Clothing Store",

		_cfg_arrMerchantCivilianClothingStore select 0,
		_cfg_arrMerchantCivilianClothingStore select 1,

		[3475.94,13314.8,0.596153],
		302,

		false,
		[civilian],
		"",

		[3475.1,13313.5,0.583773],
		302
	],

	// Clothing store - Agios
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Clothing Store",

		_cfg_arrMerchantCivilianClothingStore select 0,
		_cfg_arrMerchantCivilianClothingStore select 1,

		[9404.86,15918,0.624458],
		160,

		false,
		[civilian],
		"",

		[9406.08,15918.4,0.731674],
		160
	],

	// Clothing store - Zaros
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Clothing Store",

		_cfg_arrMerchantCivilianClothingStore select 0,
		_cfg_arrMerchantCivilianClothingStore select 1,

		[9072.81,11995.7,1.59627],
		285,

		false,
		[civilian],
		"",

		[9072.37,11994.1,1.52868],
		285
	],

	// Export docks
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Export Docks",

		_cfg_arrMerchantCivilianExportDocks select 0,
		_cfg_arrMerchantCivilianExportDocks select 1,

		[3192.02,12863.4,2.86819],
		0,

		false,
		[civilian],
		""
	]
];

daylight_cfg_arrMerchantsAutoBounty = [
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Sell Heroin",

		[90001], // Limited to one item currently

		[3965.36,13884.5,0.00148392],
		175,

		[civilian],
		""
	],

	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Sell Amphetamine",

		[90002], // Limited to one item currently

		[9345.45,15774.2,0.00151062],
		178,

		[civilian],
		""
	],

	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Sell Cannabis",

		[90003], // Limited to one item currently

		[3432.05,13179.9,0.00145006],
		45,

		[civilian],
		""
	]
];

_arrVehicleShops_boats_civilian = [
	["Motorboat", "C_Boat_Civil_01_F",
		[

		],
		{

		},
	2500, -1],

	["Motorboat (Rescue)", "C_Boat_Civil_01_rescue_F",
		[

		],
		{

		},
	2500, -1]
];

_arrVehicleShops_boats_blufor = [
	["Motorboat (Police)", "C_Boat_Civil_01_police_F",
		[

		],
		{

		},
	2500, -1]
];

_arrVehicleShops_cars_blufor = [
	["Offroad", "C_Offroad_01_F",
		[
			//["Police", "daylight\gfx\skins\offroad.jpg"]
		],

		{
			_this spawn {
				sleep 1;

				_this animate ["HidePolice", 0];
				_this animate ["HideBumper", 0];
			}
		},
	2500, -1],

	["SUV", "C_SUV_01_F",
		[
		],

		{
			// Set texture
		},
	2500, -1]
];


_arrVehicleShops_cars_civilian = [
	["Quadbike", "C_Quadbike_01_F",
		[
			["White", "\A3\Soft_F_beta\Quadbike_01\Data\quadbike_01_civ_white_co.paa"],
			["Black", "\A3\Soft_F_beta\Quadbike_01\Data\quadbike_01_civ_black_co.paa"],

			["Red", "\A3\Soft_F_beta\Quadbike_01\Data\quadbike_01_civ_red_co.paa"],
			["Blue", "\A3\Soft_F_beta\Quadbike_01\Data\quadbike_01_civ_blue_co.paa"]
		],
		{

		},
	2500, -1],

	["Offroad", "C_Offroad_01_F",
		[
			["White", "\A3\soft_F\Offroad_01\Data\Offroad_01_ext_BASE02_CO.paa"],
			["Red", "\A3\soft_F\Offroad_01\Data\Offroad_01_ext_co.paa"],
			["Yellow", "\A3\soft_F\Offroad_01\Data\Offroad_01_ext_BASE01_CO.paa"],
			["Blue", "\A3\soft_F\Offroad_01\Data\Offroad_01_ext_BASE03_CO.paa"],
			["Dark red", "\A3\soft_F\Offroad_01\Data\Offroad_01_ext_BASE04_CO.paa"],
			["Dark blue", "\A3\soft_F\Offroad_01\Data\Offroad_01_ext_BASE05_CO.paa"]
		],
		{

		},
	6500, -1],

	["Hatchback", "C_Hatchback_01_F",
		[
			["White", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_CO.paa"],
			["Black", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_BASE09_CO.paa"],

			["Green", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_BASE02_CO.paa"],
			
			["Blue", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_BASE03_CO.paa"],
			["Blue (Pattern)", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_BASE04_CO.paa"],

			["Yellow", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_BASE06_CO.paa"],

			["Beige", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_BASE01_CO.paa"],
			["Beige (Pattern)", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_BASE05_CO.paa"],
		
			["Grey", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_BASE07_CO.paa"],
			["Dark Grey", "\A3\soft_f_gamma\Hatchback_01\data\Hatchback_01_ext_BASE08_CO.paa"]
		],
		{

		},
	5000, -1],

	["Hatchback (Sport)", "C_Hatchback_01_sport_F",
		[
			["White", "\A3\soft_f_gamma\Hatchback_01\data\hatchback_01_ext_sport04_co.paa"],
			["Red", "\A3\soft_f_gamma\Hatchback_01\data\hatchback_01_ext_sport01_co.paa"],
			["Green", "\A3\soft_f_gamma\Hatchback_01\data\hatchback_01_ext_sport06_co.paa"],

			["Turquoise", "\A3\soft_f_gamma\Hatchback_01\data\hatchback_01_ext_sport02_co.paa"],
			["Orange", "\A3\soft_f_gamma\Hatchback_01\data\hatchback_01_ext_sport03_co.paa"],
			["Beige", "\A3\soft_f_gamma\Hatchback_01\data\hatchback_01_ext_sport05_co.paa"]
		],
		{

		},
	15000, -1],

	["SUV", "C_SUV_01_F",
		[
			["Black", "\A3\Soft_F_Gamma\SUV_01\Data\SUV_01_ext_02_CO.paa"],
			["Red", "\A3\Soft_F_Gamma\SUV_01\Data\SUV_01_ext_CO.paa"],
			["Grey", "\A3\Soft_F_Gamma\SUV_01\Data\SUV_01_ext_03_CO.paa"],
			["Orange", "\A3\Soft_F_Gamma\SUV_01\Data\SUV_01_ext_04_CO.paa"]
		],
		{

		},
	12000, -1]
];

_arrVehicleShops_trucks_civilian = [
	["Truck", "C_Van_01_box_F",
		[
			["White", "\a3\soft_f_gamma\Van_01\Data\van_01_ext_co.paa"],
			["Red", "\a3\soft_f_gamma\Van_01\Data\van_01_ext_red_co.paa"]
		],
		{

		},
	50000, -1],

	["Truck (Transport)", "C_Van_01_transport_F",
		[
			["White", "\a3\soft_f_gamma\Van_01\Data\van_01_ext_co.paa"],
			["Red", "\a3\soft_f_gamma\Van_01\Data\van_01_ext_red_co.paa"]
		],
		{

		},
	50000, -1],

	["Fuel Truck", "C_Van_01_fuel_F",
		[
			["White", "\a3\soft_f_gamma\Van_01\Data\van_01_ext_co.paa"],
			["Red", "\a3\soft_f_gamma\Van_01\Data\van_01_ext_red_co.paa"]
		],
		{

		},
	50000, -1]
];

_arrVehicleShops_air_civilian = [
	["MH-9 Hummingbird", "B_Heli_Light_01_F",
		[
			["White (Blue stripes)", "A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_blue_co.paa"],
			["White (Red stripes)", "A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_co.paa"],
			["White (Blue stripes #2)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_blueline_co.paa"],
			["White (Red stripes #2)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_elliptical_co.paa"],
			["White (Green/brown stripes)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_sheriff_co.paa"],
			["White (Dark blue stripes)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_furious_co.paa"],
			["White (Red stripes #3)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_speedy_co.paa"],

			["Black", "A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_ion_co.paa"],
			["Black (Yellow stripes)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_wasp_co.paa"],
			["Black (Orange stripes)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_graywatcher_co.paa"],
			["Black (Red/brown stripes)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_shadow_co.paa"],
			
			["Blue (With white)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_wave_co.paa"],
			["Dark blue (White/brown stripes)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_jeans_co.paa"],

			["Red (With black)", "A3\Air_F\Heli_Light_01\Data\Skins\heli_light_01_ext_vrana_co.paa"]

		],
		{

		},
	150000, -1],

	["CH-49 Mohawk", "I_Heli_Transport_02_F",
		[
		],
		{
			for "_i" from 0 to 2 do {
				_this setObjectTextureGlobal [_i, "#(argb,8,8,3)color(0.05,0.05,0.05,1)"];
			};
		},
	230000, -1],

	["Po-30 Orca", "O_Heli_Light_02_unarmed_F",
		[
		],
		{

		},
	230000, -1]
];

_arrVehicleShops_air_blufor = [
	["WY-55 Hellcat", "I_Heli_light_03_unarmed_F",
		[
		],
		{

		},
	120000, -1]
];

daylight_cfg_arrVehicleShops	= [
	// Boat shop #1
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Boat Shop",

		_arrVehicleShops_boats_civilian,

		[3339.72, 12922.2, 6.41157],
		327,

		[3330.28, 12917.4, 3.47625],
		62,

		[civilian],
		"Fishing License"
	],

	// Boat shop #2
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Boat Shop",

		_arrVehicleShops_boats_civilian,

		[3322.77, 14082.6, 3.16659],
		142,

		[3309.66, 14081.2, 2.81885],
		51,

		[civilian],
		"Fishing License"
	],

	// Police boat shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Police Boat Shop",

		_arrVehicleShops_boats_blufor,

		[2943.78,12602.7, 7],
		302,

		[2935.64,12601.3,8.0903],
		118,

		[blufor],
		""
	],

	// Police car shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Police Car Shop",

		_arrVehicleShops_cars_blufor,

		[3052.07,12617,0.00142264],
		138,

		[3052.28,12624.4,0.00144053],
		138,

		[blufor],
		""
	],

	// Police air vehicle shop
	/*[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Police Air Vehicle Shop",

		_arrVehicleShops_cars_blufor,

		[3014.45,12609.3,0.00146198],
		232,

		[3026.52,12592.3,0.00147867],
		350,

		blufor,
		""
	],*/

	// Car shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Car Shop",

		_arrVehicleShops_cars_civilian,

		[3506.75, 13018.3, 0],
		190,

		[3511.11, 13024.1, 0.165912],
		189,

		[civilian],
		"Drivers License"
	],

	// Air vehicle shop
	[
		["C_man_pilot_F", "", "", "", "", ""],
		"Air Vehicle Shop",

		_arrVehicleShops_air_civilian,

		[11577.9,11908.4,0.00146294],
		121,

		[11576.3,11946.5,0.223001],
		119,

		[civilian],
		"Pilot License"
	],

	// Car vehicle shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Car Shop",

		_arrVehicleShops_cars_civilian,

		[9138.36,15886,0.00180054],
		161,

		[9135.91,15878.9,0.181015],
		64,

		[civilian],
		"Drivers License"
	],

	// Truck shop Kavala
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Truck Shop",

		_arrVehicleShops_trucks_civilian,

		[4150.35,13928.5,0.0340538],
		269,

		[4137.5,13935.9,0.00144577],
		158,

		[civilian],
		"Truck License"
	],

	// Truck shop Agios
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Truck Shop",

		_arrVehicleShops_trucks_civilian,

		[9113.19,15767,0.0235596],
		336,

		[9112.9,15758.1,0.182961],
		319,

		[civilian],
		"Truck License"
	],

	// Police air shop
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Police Air Vehicle Shop",

		_arrVehicleShops_air_blufor,

		[3016.05, 12607, 0],
		325,

		[3026.52,12592.3,0.00147867],
		350,

		[blufor]
	]
];

daylight_arrGearShops_blufor = [
	// Weapons
	[
		["Stun Pistol (Rook 40 9mm)", "hgun_rook40_f", ["16rnd_9x21_mag"], 1000, -1]
	],

	// Items
	[
		"optic_Aco"
	]
];

daylight_cfg_arrGearShops		= [
	// Gear shop 1
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],
		"Gear Shop",

		daylight_arrGearShops_blufor,

		[3071.53, 12569.6, 0],
		320,

		blufor
	]
];