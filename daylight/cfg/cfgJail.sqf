/*
	Description:	Jail config
	Author:			qbt
*/

// General settings
daylight_cfg_iBountyMinusPerMinute			= 2000; // How much bounty minused from total bounty for every minute in jail.
daylight_cfg_iOneBountyInSeconds			= 0.1; // How much is 1 bounty in seconds
daylight_cfg_iMaxJailTime					= 30; // Max jail time even if bounty is larger
daylight_cfg_iMaxJailTimeByPolice			= 25; // Max jail time police can give, bigger bounty can result in bigger jailtimes

// Jail position
daylight_cfg_arrJailPosition				= [3650.2, 13387, 0]; // Where player will be teleported to jail
daylight_cfg_iJailDir						= 42; // Player dir when teleported to jail
daylight_cfg_arrJailReleasePosition			= [3619.7, 13353.3, 0]; // Where player will be teleported when released
daylight_cfg_iJailReleaseDir				= 223; // Player dir when teleported when released
daylight_cfg_iJailRadius					= 40; // Max player distance from daylight_cfg_arrJailPosition before teleported back