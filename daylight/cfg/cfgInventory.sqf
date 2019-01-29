/*
	Description:	Inventory config
	Author:			qbt
*/

// General settings
daylight_cfg_iInvMaxCarryWeight				= 60; // 60kg
daylight_cfg_iInvMaxGiveDistance			= 15; // meters
daylight_cfg_iInvMaxInputItemAmountDigits	= 6;

daylight_cfg_iInvMoneyID					= 10000; // ID of money

// Illegal item config
daylight_cfg_arrInvIllegalIDRange			= [90000, 100000];

// Unusable & undroppable items config
daylight_cfg_arrUnusableItems				= [10000];
daylight_cfg_arrUndroppableItems			= [];

// Always usable items
daylight_cfg_arrAlwaysUsableItems			= [50006, 90012];

// Normal items
daylight_cfg_strDefaultItemClassName		= "Land_Suitcase_F";

// Special items
daylight_cfg_arrSpecialItems				= [
	[daylight_cfg_iInvMoneyID, "Land_Money_F"]
];

daylight_cfg_arrItemClassNames 				= [
	"Land_Suitcase_F",
	"Land_Money_F"
];