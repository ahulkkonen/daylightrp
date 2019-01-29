/*
	Description:	License config
	Author:			qbt
*/

// Main config
daylight_cfg_arrLicenses = [
	"Drivers License",
	"Fishing License",
	"Pilot License",
	"Truck License",
	"Weapon License",
	"E.K.A.M. License" // 150000
];

daylight_cfg_arrLicenseSellers = [
	// arr [arr clothing, arr officer position, i officer dir, arr list of licenses sold [[i index from daylight_cfg_arrLicenses, i cost]]

	// Main license seller
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],

		[3277.63,12969.1,0.325299],
		177,

		[
			[0, 1000],
			[1, 500],
			[2, 50000],
			[3, 15000],
			[4, 10000]
		]
	],

	// EKAM license seller
	[
		["c_man_1", "", "h_cap_blk", "g_squares", "u_rangemaster", ""],

		[2836.14,12668.2,2.88509],
		130,

		[
			[5, 150000]
		]
	]
];