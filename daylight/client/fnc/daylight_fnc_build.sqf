/*
	Description:	Build item
	Author:			qbt
*/

/*
	Description:	Build item
	Args:			str classname
	Return:			nothing
*/
daylight_fnc_buildItem = {
	if (daylight_bActionBusy) exitWith {};

	// Check if too close to a marker
	_bTooClose = false;
	_arrMapMarkers = call daylight_fnc_getMissionMarkers;
	{
		if ((player distance (getMarkerPos _x)) < daylight_cfg_iMinDistanceFromMarker) then {
			_bTooClose = true;
		};
	} forEach _arrMapMarkers;

	if (_bTooClose) exitWith {
		[localize "STR_BUILDING_TITLE", localize "STR_BUILDING_TOOCLOSE", true] call daylight_fnc_showHint;
	};

	disableSerialization;

	// Check if too close to any marker

	// Wait until main display becomes active
	waitUntil {!(isNull (findDisplay 46))};

	// Add UI-EH's
	daylight_iBuildEHIDKeyDown = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call daylight_fnc_buildHandleKeyDown"];
	daylight_iBuildEHIDButtonDown = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", "_this call daylight_fnc_buildHandleMouseButtonDown"];
	daylight_iBuildEHIDZChanged = (findDisplay 46) displayAddEventHandler ["MouseZChanged", "_this call daylight_fnc_buildHandleMouseZChanged"];

	daylight_bActionBusy = true;

	daylight_strBuildClassName = _this;
	daylight_arrBuildYZR = [3.5, 0, 0];
	daylight_iBuildMode = 0;
	daylight_bBuildAlignToGround = false;

	// Remove weapons
	daylight_arrSurrenderWeaponsPlaceholder = [
		primaryWeapon player,
		primaryWeaponItems player,
		handgunWeapon player,
		handgunItems player,
		secondaryWeapon player
	];

	{player removeWeapon _x} forEach (weapons player);

	daylight_strSurrenderWeaponsPlaceholderCurrentWeapon = currentWeapon player;

	player switchMove "";

	_vehBuilding = _this createVehicleLocal [0, 0, 0];
	_vehBuilding allowDamage false;
	_vehBuilding disableCollisionWith player;
	_vehBuilding enableSimulation false;

	// Show tutorial hint
	[localize "STR_BUILDING_TITLE", format[localize "STR_BUILDING_TEXT", "Forward / Back", "Aligning"], true] call daylight_fnc_showHint;

	// Force walking
	player forceWalk true;

	while {daylight_bActionBusy} do {
		_vehBuilding setDir ((getDir player) + (daylight_arrBuildYZR select 2));

		_strAlign = "Not aligning";
		if (daylight_bBuildAlignToGround) then {
			_vehBuilding setVectorUp (surfaceNormal (getPosATL _vehBuilding));

			_strAlign = "Aligning";
		};

		_vehBuilding setPosATL (player modelToWorld [0, daylight_arrBuildYZR select 0, daylight_arrBuildYZR select 1]);

		_strMode = "Forward / Back";

		if (daylight_iBuildMode == 1) then {
			_strMode = "Up / Down";
		};

		if (daylight_iBuildMode == 2) then {
			_strMode = "Rotate";
		};

		// Show tutorial hint
		[localize "STR_BUILDING_TITLE", format[localize "STR_BUILDING_TEXT", _strMode, _strAlign], false] call daylight_fnc_showHint;

		if ((vehicle player != player) || !(alive player)) then {
			daylight_bActionBusy = false;
		};

		sleep 0.001;
	};

	(findDisplay 46) displayRemoveEventHandler ["KeyDown", daylight_iBuildEHIDKeyDown];
	(findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", daylight_iBuildEHIDButtonDown];
	(findDisplay 46) displayRemoveEventHandler ["MouseZChanged", daylight_iBuildEHIDZChanged];

	deleteVehicle _vehBuilding;

	player forceWalk false;

	// Add weapons
	if ((count daylight_arrSurrenderWeaponsPlaceholder) > 0) then {
		{if (_x != "") then {player addWeapon _x}} forEach [daylight_arrSurrenderWeaponsPlaceholder select 0, daylight_arrSurrenderWeaponsPlaceholder select 2, daylight_arrSurrenderWeaponsPlaceholder select 4];

		{if (_x != "") then {player addPrimaryWeaponItem _x}} forEach (daylight_arrSurrenderWeaponsPlaceholder select 1);
		{if (_x != "") then {player addHandgunItem _x}} forEach (daylight_arrSurrenderWeaponsPlaceholder select 3);

		player selectWeapon daylight_strSurrenderWeaponsPlaceholderCurrentWeapon;
	};

	player switchMove "";
};

/*
	Description:	Build item create
	Args:			arr [str classname, arr pos, i dir]
	Return:			nothing
*/
daylight_fnc_buildItemCreate = {
	// Check if too close to a marker
	_bTooClose = false;
	_arrMapMarkers = call daylight_fnc_getMissionMarkers;
	{
		if (((_this select 1) distance (getMarkerPos _x)) < daylight_cfg_iMinDistanceFromMarker) then {
			_bTooClose = true;
		};
	} forEach _arrMapMarkers;

	_arrNearestObjects = nearestObjects [(_this select 1), ["LandVehicle"], 5];

	if ((count _arrNearestObjects) > 0) then {
		_bTooClose = true;
	};

	if (_bTooClose) then {
		[localize "STR_BUILDING_TITLE", localize "STR_BUILDING_TOOCLOSE", true] call daylight_fnc_showHint;
	} else {
		// Remove item
		[daylight_iBuildID, 1] call daylight_fnc_invRemoveItem;

		_vehBuilding = createVehicle [_this select 0, [0, 0, 0], [], 0, "NONE"];

		_vehBuilding allowDamage false;

		if (!((_this select 0) in daylight_cfg_arrSimulationEnabled)) then {
			_vehBuilding enableSimulation false;
		};

		if (daylight_bBuildAlignToGround) then {
			_vehBuilding setVectorUp (surfaceNormal (_this select 1));
		};

		_vehBuilding setDir (_this select 2);	
		_vehBuilding setPosATL (_this select 1);

		_vehBuilding setVariable ["daylight_iBuildTime", round(time), true];

		_vehBuilding call daylight_fnc_networkRevealGlobal;

		hintSilent "";
	};
};

/*
	Description:	Handle mouse button down
	Args:			arr [(from UIEH)]
	Return:			nothing
*/
daylight_fnc_buildHandleMouseButtonDown = {
	switch (_this select 1) do {
		case 0 : {
			[daylight_strBuildClassName, (player modelToWorld [0, daylight_arrBuildYZR select 0, daylight_arrBuildYZR select 1]), ((getDir player) + (daylight_arrBuildYZR select 2))] call daylight_fnc_buildItemCreate;

			daylight_bActionBusy = false;
		};

		case 1 : {
			daylight_bActionBusy = false;

			hintSilent "";
		};

		case 2 : {
			daylight_iBuildMode = daylight_iBuildMode + 1;

			if (daylight_iBuildMode > 2) then {
				daylight_iBuildMode = 0;
			};
		};
	};
};

/*
	Description:	Handle mouse Z changed
	Args:			arr [(from UIEH)]
	Return:			nothing
*/
daylight_fnc_buildHandleMouseZChanged = {
	_bMinus = (_this select 1) < 0;

	switch (daylight_iBuildMode) do {
		// Forward / Back
		case 0 : {
			_iForwardBack = 0;

			if (_bMinus) then {
				_iForwardBack = (daylight_arrBuildYZR select 0) - 0.25;
			} else {
				_iForwardBack = (daylight_arrBuildYZR select 0) + 0.25;
			};

			if ((_iForwardBack >= daylight_cfg_iBuildMinDistance) && (_iForwardBack <= daylight_cfg_iBuildMaxDistance)) then {
				daylight_arrBuildYZR set [0, _iForwardBack];
			};
		};

		// Up / Down
		case 1 : {
			_iUpDown = 0;

			if (_bMinus) then {
				_iUpDown = (daylight_arrBuildYZR select 1) - 0.15;
			} else {
				_iUpDown = (daylight_arrBuildYZR select 1) + 0.15;
			};

			if ((_iUpDown >= daylight_cfg_iBuildMinZ) && (_iUpDown <= daylight_cfg_iBuildMaxZ)) then {
				daylight_arrBuildYZR set [1, _iUpDown];
			};
		};

		// Rotate
		case 2 : {
			_iRotate = 0;

			if (_bMinus) then {
				_iRotate = (daylight_arrBuildYZR select 2) - 5;
			} else {
				_iRotate = (daylight_arrBuildYZR select 2) + 5;
			};

			if (_iRotate == 360) then {
				_iRotate = 0;
			};

			daylight_arrBuildYZR set [2, _iRotate];
		};
	};
};

/*
	Description:	Handle KeyDowh-EH
	Args:			arr [(from UIEH)]
	Return:			nothing
*/
daylight_fnc_buildHandleKeyDown = {
	_bDisableDefaultAction = false;

	switch (true) do {
		// X - align to ground
		case ((_this select 1) == 0x2D) : {
			_bDisableDefaultAction = true;

			daylight_bBuildAlignToGround = !daylight_bBuildAlignToGround;
		};
	};

	_bDisableDefaultAction
};

/*
	Description:	ID to classname
	Args:			i id
	Return:			nothing
*/
daylight_fnc_buildItemIDToClassName = {
	_strClassName = "";

	switch (_this) do {
		case 60001 : {
			_strClassName = "Land_CncBarrier_stripes_F";
		};

		case 60002 : {
			_strClassName = "Land_Crash_barrier_F";
		};

		case 60003 : {
			_strClassName = "Land_Razorwire_F";
		};

		case 60004 : {
			_strClassName = "RoadBarrier_F";
		};

		case 60005 : {
			_strClassName = "RoadCone_L_F";
		};

		case 60011 : {
			_strClassName = "Land_BagBunker_Small_F";
		};

		case 60012 : {
			_strClassName = "Land_BagFence_Long_F";
		};

		case 60013 : {
			_strClassName = "Land_BagFence_Round_F";
		};

		case 60014 : {
			_strClassName = "Land_Cargo_HQ_V1_F";
		};

		case 60015 : {
			_strClassName = "Land_Cargo_House_V1_F";
		};

		case 60016 : {
			_strClassName = "Land_Mil_ConcreteWall_F";
		};

		case 60017 : {
			_strClassName = "Land_PortableLight_double_F";
		};

		case 60018 : {
			_strClassName = "Land_Portable_generator_F";
		};

		case 60019 : {
			_strClassName = "Land_BarGate_F";
		};

		case 60020 : {
			_strClassName = "ArrowDesk_L_F";
		};

		case 60021 : {
			_strClassName = "ArrowDesk_R_F";
		};

		case 70001 : {
			_strClassName = "Land_Campfire_F";
		};

		case 70002 : {
			_strClassName = "Land_CampingChair_V1_F";
		};

		case 70003 : {
			_strClassName = "Land_TentA_F";
		};

		case 70004 : {
			_strClassName = "Land_TentDome_F";
		};

		case 70005 : {
			_strClassName = "Land_cargo_addon02_V2_F";
		};

		case 70006 : {
			_strClassName = "Land_BagBunker_Large_F";
		};

		case 70007 : {
			_strClassName = "Land_BagFence_Long_F";
		};

		case 70008 : {
			_strClassName = "Land_BagFence_Round_F";
		};

		case 70009 : {
			_strClassName = "Land_HBarrier_3_F";
		};

		case 70010 : {
			_strClassName = "Land_HBarrierWall_corner_F";
		};

		case 70011 : {
			_strClassName = "Land_HBarrierWall4_F";
		};

		case 70012 : {
			_strClassName = "CamoNet_INDP_F";
		};

		case 70013 : {
			_strClassName = "CamoNet_INDP_big_F";
		};

		case 70014 : {
			_strClassName = "Land_Mil_WallBig_4m_F";
		};

		case 70015 : {
			_strClassName = "Land_PortableLight_double_F";
		};

		case 70016 : {
			_strClassName = "Land_Portable_generator_F";
		};

		case 70017 : {
			_strClassName = "Land_BarGate_F";
		};
	};

	_strClassName
};

/*
	Description:	Classname to id
	Args:			str classname
	Return:			nothing
*/
daylight_fnc_buildItemClassNameToID = {
	_iID = -1;

	switch (_this) do {
		case "Land_CncBarrier_stripes_F" : {
			_iID = 60001;
		};

		case "Land_Crash_barrier_F" : {
			_iID = 60002;
		};

		case "Land_Razorwire_F" : {
			_iID = 60003;
		};

		case "RoadBarrier_F" : {
			_iID = 60004;
		};

		case "RoadCone_L_F" : {
			_iID = 60005;
		};

		case "Land_Campfire_F" : {
			_iID = 70001;
		};

		case "Land_CampingChair_V1_F" : {
			_iID = 70002;
		};

		case "Land_TentA_F" : {
			_iID = 70003;
		};

		case "Land_TentDome_F" : {
			_iID = 70004;
		};

		case "Land_cargo_addon02_V2_F" : {
			_iID = 70005;
		};

		case "Land_BagBunker_Large_F" : {
			_iID = 70006;
		};

		case "Land_BagFence_Long_F" : {
			_iID = 70007;
		};

		case "Land_BagFence_Round_F" : {
			_iID = 70008;
		};

		case "Land_HBarrier_3_F" : {
			_iID = 70009;
		};

		case "Land_HBarrierWall_corner_F" : {
			_iID = 70010;
		};

		case "Land_HBarrierWall4_F" : {
			_iID = 70011;
		};

		case "CamoNet_INDP_F" : {
			_iID = 70012;
		};

		case "CamoNet_INDP_big_F" : {
			_iID = 70013;
		};

		case "Land_Mil_WallBig_4m_F" : {
			_iID = 70014;
		};

		case "Land_PortableLight_double_F" : {
			_iID = 70015;
		};

		case "Land_Portable_generator_F" : {
			_iID = 70016;
		};

		case "Land_BarGate_F" : {
			_iID = 70017;
		};

		case "Land_BagBunker_Small_F" : {
			_iID = 60011;
		};

		case "Land_BagFence_Long_F" : {
			_iID = 60012;
		};

		case "Land_BagFence_Round_F" : {
			_iID = 60013;
		};

		case "Land_Cargo_HQ_V1_F" : {
			_iID = 60014;
		};

		case "Land_Cargo_House_V1_F" : {
			_iID = 60015;
		};

		case "Land_Mil_ConcreteWall_F" : {
			_iID = 60016;
		};

		case "Land_PortableLight_double_F" : {
			_iID = 60017;
		};

		case "Land_Portable_generator_F" : {
			_iID = 60018;
		};

		case "Land_BarGate_F" : {
			_iID = 60019;
		};

		case "ArrowDesk_L_F" : {
			_iID = 60020;
		};

		case "ArrowDesk_R_F" : {
			_iID = 60021;
		};
	};

	_iID
};