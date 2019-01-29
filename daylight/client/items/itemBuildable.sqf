/*
	Description: 	Buildable item
	Author:			qbt
*/

daylight_iBuildID = (_this select 0);

(daylight_iBuildID call daylight_fnc_buildItemIDToClassName) spawn daylight_fnc_buildItem;

if (true) exitWith {};