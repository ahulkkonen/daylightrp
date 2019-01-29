/*
	Description:	Settings menu functions
	Author:			qbt
*/

daylight_fnc_settingsOpenUI = {
	createDialog "Settings";

	[] call daylight_fnc_settingsUpdateUI;

	{sliderSetRange [_x, 200, daylight_cfg_iViewDistanceTerrain]} forEach [1901, 1902, 1903];

	sliderSetPosition [1901, (daylight_arrViewDistance select 0)];
	sliderSetPosition [1902, (daylight_arrViewDistance select 1)];
	sliderSetPosition [1903, (daylight_arrViewDistance select 2)];

	sliderSetSpeed [1901, 100, 100];
	sliderSetSpeed [1902, 100, 100];
	sliderSetSpeed [1903, 100, 100];

	ctrlSetText [1003, str (daylight_arrViewDistance select 0)];
	ctrlSetText [1007, str (daylight_arrViewDistance select 1)];
	ctrlSetText [1006, str (daylight_arrViewDistance select 2)];
};

daylight_fnc_settingsUpdateUI = {
	ctrlSetText [1003, str (round ((sliderPosition 1901) / 100) * 100)];
	ctrlSetText [1007, str (round ((sliderPosition 1902) / 100) * 100)];
	ctrlSetText [1006, str (round ((sliderPosition 1903) / 100) * 100)];
};

daylight_fnc_settingsSave = {
	daylight_arrViewDistance = [(round ((sliderPosition 1901) / 100) * 100), (round ((sliderPosition 1903) / 100) * 100), (round ((sliderPosition 1902) / 100) * 100)];

	profileNamespace setVariable ["daylight_arrVDSettings", daylight_arrViewDistance];
	saveProfileNamespace;
};