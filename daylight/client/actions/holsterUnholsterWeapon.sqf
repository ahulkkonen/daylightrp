/*
	Description: 	Holster weapon
	Author:			qbt
*/

if (daylight_strHolsteredWeapon == "") then {
	daylight_strHolsteredWeapon = currentWeapon player;
	daylight_strHolsterMagazine = currentMagazine player;
	daylight_iHolsterMagazineAmmo = player ammo daylight_strHolsteredWeapon;

	[player, "AmovPercMstpSrasWpstDnon_AmovPercMstpSnonWnonDnon"] call daylight_fnc_networkPlayMove;

	sleep 1;

	player removeWeapon daylight_strHolsteredWeapon;
} else {
	player addMagazine daylight_strHolsterMagazine;

	player addWeapon daylight_strHolsteredWeapon;
	player selectWeapon daylight_strHolsteredWeapon;

	player setAmmo [daylight_strHolsteredWeapon, daylight_iHolsterMagazineAmmo];

	daylight_strHolsteredWeapon = "";
	daylight_strHolsterMagazine = "";
	daylight_iHolsterMagazineAmmo = 0;
};

if (true) exitWith {};