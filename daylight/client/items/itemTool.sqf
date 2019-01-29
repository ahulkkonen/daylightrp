/*
	Description: 	Tool used for harvesting/collecting items
	Author:			qbt
*/

// Determine tool we are using
_strName = ((_this select 0) call daylight_fnc_invIDToStr) select 0;
_arrMarkers = [];

_strSound = "";
_iSound = -1;

if (side player == blufor) exitWith {};

switch ((_this select 0)) do {
	case 50005 : {
		_arrMarkers = [
			"mrkIronMine_1",
			"mrkGoldMine_1",
			"mrkUraniumMine_1"
		];

		_strSound = "1937292892_soundbible_com_pickaxe_local";
		_iSound = 34;
	};

	case 50007 : {
		_arrMarkers = [
			"mrkVineyard_1",
			"mrkHerbGarden_1",
			"mrkTomatoPlant_1",
			"mrkOpiumField_1",
			"mrkCannabisField_1",
			"mrkOlivetrees_1"
		];

		_strSound = "51164_rutgermuller_scissors_cutting_air_local";
		_iSound = 37;
	};

	case 50008 : {
		_arrMarkers = [
			"mrkField_1"
		];

		_strSound = "72191_snowflakes_whip03_local";
		_iSound = 38;
	};

	case 50009 : {
		_arrMarkers = [
			"mrkOilField_1"
		];

		_strSound = "98859_tomlija_jackhammer_local";
		_iSound = 35;
	};
};

_strNearestMarker = [player, _arrMarkers] call daylight_fnc_getNearestMarker;

if ((player distance (getMarkerPos _strNearestMarker)) <= daylight_cfg_iMaxToolUseDistance) then {
	_iItemID = -1;

	// Which item we get with this tool
	switch (_strNearestMarker) do {
		case "mrkIronMine_1" : {
			_iItemID = 30006;
		};

		case "mrkGoldMine_1" : {
			_iItemID = 30004;
		};

		case "mrkUraniumMine_1" : {
			_iItemID = 90009;
		};

		case "mrkVineyard_1" : {
			_iItemID = 20004;
		};

		case "mrkHerbGarden_1" : {
			_iItemID = 20005;
		};

		case "mrkTomatoPlant_1" : {
			_iItemID = 20003;
		};

		case "mrkOpiumField_1" : {
			_iItemID = 90004;
		};

		case "mrkCannabisField_1" : {
			_iItemID = 90005;
		};

		case "mrkField_1" : {
			_iItemID = 30009;
		};

		case "mrkOilField_1" : {
			_iItemID = 30001;
		};

		case "mrkOlivetrees_1" : {
			_iItemID = 20002;
		};
	};

	[_strName, _strNearestMarker, _iItemID, _strSound, _iSound] call daylight_fnc_toolUseInit;
} else {
	// Too far away
	[_strName, localize "STR_TOOL_ERROR", true] call daylight_fnc_showHint;
};