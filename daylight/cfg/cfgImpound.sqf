/*
	Description:	Impound config
	Author:			qbt
*/

// Main config
daylight_cfg_arrImpoundStoreLocation		= [7092, 5965, 0]; // Fix this for Altis
daylight_cfg_arrImpoundReturnLocation		= [3045, 6074, 0]; // Fix this for Altis
daylight_cfg_iImpoundReturnDir				= 275;

daylight_cfg_iImpoundReturnCost				= 1000;

daylight_cfg_arrImpoundAction				= ["<t color=""#75c2e6"">Impound vehicle</t>", "daylight\client\actions\impoundVehicle.sqf", nil, 0, false, true, "", "(((crew _target find player) == -1) && ((vehicle player) == player) && ((_this distance _target) < 3.5))"];

daylight_cfg_arrImpoundOfficers				= [
	// arr [arr clothing, arr officer position, i officer dir, arr impound return pos,i impound return dir]

	// Main impound officer
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],

		[3158.6,12486.4,1],
		328,

		[3155.12,12499.1, 0],
		326
	],

	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],

		[3571.66,13406,0],
		310,

		[3570.99,13413.1,0],
		310
	]
];