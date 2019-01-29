/*
	Description:	Init for Daylight config files
	Author:			qbt
*/

_arrConfigs	= [
	"cfgMain.sqf",
	"cfgStrings.sqf",
	"cfgInventory.sqf",
	"cfgEconomy.sqf",
	"cfgClothing.sqf",
	"cfgShops.sqf",
	"cfgInteraction.sqf",
	"cfgJail.sqf",
	"cfgImpound.sqf",
	"cfgLicenses.sqf",
	"cfgMisc.sqf",
	"cfgShout.sqf",
	"cfgHUD.sqf",
	"cfgDamage.sqf",
	"cfgStun.sqf",
	"cfgFishing.sqf",
	"cfgGasStations.sqf",
	"cfgGangs.sqf",
	"cfgBuild.sqf",
	"cfgTrunk.sqf",
	"cfgProcess.sqf",
	"cfgPresident.sqf",
	"cfgPoliceVehicleFX.sqf",
	"cfgEndMission.sqf",
	"cfgWreckingYard.sqf",
	"cfgAdminMenu.sqf"
];

{
	call compileFinal preprocessFile (format["daylight\cfg\%1", _x])
} forEach _arrConfigs;

if (true) exitWith {};