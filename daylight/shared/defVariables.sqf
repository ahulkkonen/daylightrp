/*
	Description:	Initialize variables with their default value
	Author:			qbt
*/

daylight_bDialogOpen = false;

// Character creation related
daylight_bCharacterCreated = false;
daylight_bCharacterClothed = false;

// Respawn related
daylight_bRespawning = false;
daylight_bReadyToRespawn = false;

// Interaction menu
daylight_objInteractionCurrentPlayer = objNull;
daylight_bGiveTicketDialogOpen = false;

// Restrain related
daylight_bRestrained = false;
daylight_bSurrendered = false;
daylight_arrSurrenderWeaponsPlaceholder = [];
daylight_strSurrenderWeaponsPlaceholderCurrentWeapon = "";

// Jail related
daylight_bJailed = false;
daylight_iLastJailPlayerTime = 0;

// 3rd person controller
daylight_b3rdPersonEnabled = true;

// Stun value
daylight_iStunValue = 0;

// PP effect commited
daylight_ppColorCorrectionCommited = false;

// HUD ready
daylight_bHUDReady = false;

// Inventory
daylight_iLastInventoryOpenTime = 0;
daylight_iLastDropTime = 0;
daylight_iLastPickUpTime = 0;
daylight_iLastGiveTime = 0;

daylight_bInvDisabled = false;

// Trunk
daylight_bDialogTrunkOpen = false;
daylight_iTrunkLastOpenTime = 0;

// Shop
daylight_iShopItemSelected = 0;
daylight_iShopButtonWaitForUpdate = false;

// Trunk / shop
daylight_bTrunkOrShopButtonWaitForUpdate = false;

// Keychain
daylight_bKeychainVehiclesEmpty = true;
daylight_bKeychainNearEmpty = true;

// Progress bar
daylight_bProgressBarActive = false;

// Last move time
daylight_iLastMoveTime = 0;

// General action busy
daylight_bActionBusy = false;

// Global message log
daylight_arrGlobalMessages = [];

// Police menu
daylight_bPoliceMenuOpen = false;

// Mouse UIEH
daylight_iLastMouse1InputTime = 0;
daylight_iLastMouse2InputTime = 0;
daylight_iLastMouse3InputTime = 0;

// Fishing
daylight_bFishing = false;

// Gang areas
daylight_strOldGang = "";

// Weather & time
daylight_bWeatherAndTimeSynced = false;

// Hunger
daylight_iHunger = 0;

// Drug effects
daylight_iDrugAlcoholLevel = 0;
daylight_iDrugHeroinLevel = 0;
daylight_iDrugAmphetamineLevel = 0;
daylight_iDrugCannabisLevel = 0;

// Dialogs
//daylight_strActiveDialogClass = "";

daylight_bPlayerGodMode = false;
daylight_bPlayerFreezed = false;