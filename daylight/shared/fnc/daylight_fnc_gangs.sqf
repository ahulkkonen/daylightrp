/*	
	Description: 	SHARED gang functions
	Author:			qbt
*/

daylight_fnc_gangsInitServer = {
	daylight_arrGangs = [];

	publicVariable "daylight_arrGangs";

	call daylight_fnc_gangsAreasInitServer;
};

daylight_fnc_gangsOpenUI = {
	if (isNil "daylight_arrGangs") exitWith {};

	if (!dialog || !_this) then {
		createDialog "GangMenu";

		daylight_bCreateGangDialogOpen = false;
		daylight_bGangMenuOpen = true;

		call daylight_fnc_gangsUpdateUI;
		[] spawn daylight_fnc_gangsUpdateUILoop;
	};
};

daylight_fnc_gangsUpdateUI = {
	_strGang = [player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_loadVar;
	
	// List gangs
	_bNoGangs = false;

	lbClear 1500;

	if (_strGang == "") then {
		ctrlEnable [1701, true];
		ctrlEnable [1704, false];
	} else {
		ctrlEnable [1701, false];
	};

	for "_i" from 0 to ((count daylight_arrGangs) - 1) do {
		_iLocked = (daylight_arrGangs select _i) select 2;

		_arrCur = daylight_arrGangs select _i;

		_strLocked = "U";
		if (_iLocked == 1) then {
			_strLocked = "L";
		};

		_strName = format["(%1) (%2x) %3", _strLocked, count (_arrCur select 1), _arrCur select 0];

		lbAdd [1500, _strName];

		if ((_arrCur select 0) == _strGang) then {
			lbSetColor [1500, _i, [1, 0.79, 0, 1]];
		};
	};

	if (lbSize 1500 == 0) then {
		lbAdd [1500, "No gangs to show"];

		_bNoGangs = true;

		ctrlEnable [1500, false];
	} else {
		ctrlEnable [1500, true];
	};

	while {((lbCurSel 1500) == -1)} do {
		lbSetCurSel [1500, 0];
	};

	if (lbCurSel 1500 > ((lbSize 1500) - 1)) then {
		_iOldCurSel = lbCurSel 1500;

		while {((lbCurSel 1500) == _iOldCurSel)} do {
			lbSetCurSel [1500, 0];
		};
	};

	// List members
	if (!_bNoGangs) then {
		_arrCur = (daylight_arrGangs select (lbCurSel 1500)) select 1;
		
		_iLocked = (daylight_arrGangs select (lbCurSel 1500)) select 2;
		
		/*_strLocked = "Unlocked";
		if (_iLocked == 1) then {
			_strLocked = "Locked";
		};*/

		_bJoinEnabled = false;
		if ((_arrCur find (getPlayerUID player)) != -1) then {
			ctrlEnable [1700, false];
			ctrlEnable [1702, true];
		} else {
			ctrlEnable [1700, true];
			ctrlEnable [1702, false];

			_bJoinEnabled = true;		
		};

		if (_iLocked == 1) then {
			((uiNamespace getVariable "daylight_dsplActive") displayCtrl 1703) ctrlSetText "Unlock";

			ctrlEnable [1700, false];
		} else {
			((uiNamespace getVariable "daylight_dsplActive") displayCtrl 1703) ctrlSetText "Lock";
		};

		lbClear 1501;

		for "_i" from 0 to ((count _arrCur) - 1) do {
			_vehUnit = (_arrCur select _i) call daylight_fnc_playerUIDtoPlayerObject;

			if (!(isNull _vehUnit)) then {
				_strName = format["%1", name _vehUnit];

				lbAdd [1501, _strName];
			};
		};

		while {((lbCurSel 1501) == -1)} do {
			lbSetCurSel [1501, 0];
		};

		if (lbCurSel 1501 > ((lbSize 1501) - 1)) then {
			_iOldCurSel = lbCurSel 1501;

			while {((lbCurSel 1501) == _iOldCurSel)} do {
				lbSetCurSel [1501, 0];
			};
		};

		_vehAdmin = (((daylight_arrGangs select (lbCurSel 1500)) select 1) select 0) call daylight_fnc_playerUIDtoPlayerObject;
		_vehCurrentPlayer = (((daylight_arrGangs select (lbCurSel 1500)) select 1) select (lbCurSel 1501)) call daylight_fnc_playerUIDtoPlayerObject;

		if ((_vehAdmin == player) && (_vehCurrentPlayer != player)) then {
			ctrlEnable [1704, true];
		} else {
			ctrlEnable [1704, false];
		};

		if (_vehAdmin == player) then {
			ctrlEnable [1703, true];
		} else {
			ctrlEnable [1703, false];
		};
	} else {
		lbClear 1501;

		ctrlEnable [1700, false];
		ctrlEnable [1702, false];
		ctrlEnable [1703, false];
		ctrlEnable [1704, false];
	};

	if (side player == blufor) then {
		ctrlEnable [1700, false];
		ctrlEnable [1701, false];
		ctrlEnable [1702, false];
		ctrlEnable [1703, false];
		ctrlEnable [1704, false];
	};
};

daylight_fnc_gangsUpdateUILoop = {
	while {daylight_bGangMenuOpen && !daylight_bCreateGangDialogOpen} do {
		_arrOldArray = daylight_arrGangs;

		sleep 0.025;

		if (!(_arrOldArray isEqualTo daylight_arrGangs)) then {
			call daylight_fnc_gangsUpdateUI;
		};
	};

	if (true) exitWith {};
};

daylight_fnc_gangsJoinGang = {
	_strCurrentGang = [player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_loadVar;

	_arrGang = daylight_arrGangs select (_this select 0);

	_arrPlayers = _arrGang select 1;
	_vehLeader = (_arrPlayers select 0) call daylight_fnc_playerUIDtoPlayerObject;

	[player] joinSilent _vehLeader;

	_arrPlayers set [count _arrPlayers, getPlayerUID player];

	daylight_arrGangs set [_this select 0, [_arrGang select 0, _arrPlayers, _arrGang select 2]];

	if (_strCurrentGang != "") then {
		false call daylight_fnc_gangsLeaveGang;
	};

	[player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], _arrGang select 0] call daylight_fnc_saveVar;
	publicVariable "daylight_arrGangs";

	call daylight_fnc_gangsUpdateUI;

	if ((_this select 1)) then {
		_strText = format [localize "STR_GANGMENU_JOINED", _arrGang select 0];
		[localize "STR_GANGMENU_TITLE", _strText, true] call daylight_fnc_showHint;
	};
};

daylight_fnc_gangsLeaveGang = {
	_strCurrentGang = [player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_loadVar;

	_iOldGang = [daylight_arrGangs, _strCurrentGang] call daylight_fnc_findVariableInNestedArray;

	_arrOldGang = daylight_arrGangs select _iOldGang;

	_arrOldPlayers = _arrOldGang select 1;
	_arrOldPlayers = _arrOldPlayers - [getPlayerUID player];

	if (count _arrOldPlayers > 0) then {
		daylight_arrGangs set [_iOldGang, [_arrOldGang select 0, _arrOldPlayers, _arrOldGang select 2]];
	} else {
		daylight_arrGangs set [_iOldGang, -1];
		daylight_arrGangs = daylight_arrGangs - [-1];
	};

	if (_this) then {
		[player] joinSilent grpNull;

		publicVariable "daylight_arrGangs";
		[player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_saveVar;

		call daylight_fnc_gangsUpdateUI;

		_strText = format [localize "STR_GANGMENU_LEFT", _arrOldGang select 0];
		[localize "STR_GANGMENU_TITLE", _strText, true] call daylight_fnc_showHint;
	};
};

daylight_fnc_gangsKickFromGang = {
	_strCurrentPlayerUID = ((daylight_arrGangs select (lbCurSel 1500)) select 1) select (lbCurSel 1501);
	_vehCurrentPlayer = _strCurrentPlayerUID call daylight_fnc_playerUIDtoPlayerObject;

	_arrOldGang = daylight_arrGangs select (lbCurSel 1500);

	_arrOldPlayers = _arrOldGang select 1;
	_arrOldPlayers = _arrOldPlayers - [_strCurrentPlayerUID];

	daylight_arrGangs set [lbCurSel 1500, [_arrOldGang select 0, _arrOldPlayers, _arrOldGang select 2]];

	[_vehCurrentPlayer] joinSilent grpNull;

	[_vehCurrentPlayer, format["strGang%1", _vehCurrentPlayer call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_saveVar;
	publicVariable "daylight_arrGangs";

	_strText = format [localize "STR_GANGMENU_KICK", name _vehCurrentPlayer];

	[localize "STR_GANGMENU_TITLE", _strText, true] call daylight_fnc_showHint;

	call daylight_fnc_gangsUpdateUI;
};

daylight_fnc_gangsLockToggle = {
	_arrGang = daylight_arrGangs select (lbCurSel 1500);

	_iLocked = _arrGang select 2;
	_iLockedNew = 0;

	_strText = "";
	if (_iLocked == 0) then {
		_iLockedNew = 1;

		_strText = format [localize "STR_GANGMENU_LOCKED", _arrGang select 0];
	} else {
		_strText = format [localize "STR_GANGMENU_UNLOCKED", _arrGang select 0];
	};

	[localize "STR_GANGMENU_TITLE", _strText, true] call daylight_fnc_showHint;

	daylight_arrGangs set [lbCurSel 1500, [_arrGang select 0, _arrGang select 1, _iLockedNew]];
	publicVariable "daylight_arrGangs";

	call daylight_fnc_gangsUpdateUI;
};

daylight_fnc_gangsCreateOpenUI = {
	closeDialog 0;

	createDialog "CreateGang";

	while {daylight_bCreateGangDialogOpen} do {
		_iAmount = count (toArray (ctrlText 1400));

		if (_iAmount < 3) then {
			ctrlEnable [1701, false];
		} else {
			ctrlEnable [1701, true];
		};

		sleep 0.05;
	};

	if (true) exitWith {};
};

daylight_fnc_gangsCreate = {
	// Check for duplicate
	_iIndex = [daylight_arrGangs, _this] call daylight_fnc_findVariableInNestedArray;

	if (_iIndex != -1) exitWith {
		[localize "STR_GANGMENU_TITLE", localize "STR_GANGMENU_EXISTS", true] call daylight_fnc_showHint;

		daylight_bCreateGangDialogOpen = false;
		false call daylight_fnc_gangsOpenUI;
	};

	// Check if player has enough money in inventory or in bank if not in inv entory
	_bHasMoney = false;

	if (([daylight_cfg_iInvMoneyID, daylight_cfg_iGangCreationCost] call daylight_fnc_invCheckAmount) >= daylight_cfg_iGangCreationCost) then {
		_bHasMoney = true;

		// Remove money from inventory
		[daylight_cfg_iInvMoneyID, daylight_cfg_iGangCreationCost] call daylight_fnc_invRemoveItem;

		[localize "STR_GANGMENU_TITLE", format[localize "STR_GANGMENU_CREATED", daylight_cfg_iGangCreationCost, localize "STR_CURRENCY", _this, localize "STR_PAIDFROMINVENTORY"], true] call daylight_fnc_showHint;
	} else {
		_iMoneyBank = [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
		if (_iMoneyBank >= daylight_cfg_iGangCreationCost) then {
			_bHasMoney = true;

			// Minus cost from current amount
			_iMoneyBank = _iMoneyBank - daylight_cfg_iGangCreationCost;

			// Update bank money amount
			[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], _iMoneyBank] call daylight_fnc_saveVar;

			[localize "STR_GANGMENU_TITLE", format[localize "STR_GANGMENU_CREATED", daylight_cfg_iGangCreationCost, localize "STR_CURRENCY", _this, localize "STR_PAIDFROMBANK"], true] call daylight_fnc_showHint;
		} else {
			// No money
			[localize "STR_GANGMENU_TITLE", localize "STR_GANGMENU_NOMONEY", true] call daylight_fnc_showHint;
		};
	};

	if (_bHasMoney) then {
		closeDialog 0;

		daylight_bCreateGangDialogOpen = false;

		if (_strCurrentGang != "") then {
			false call daylight_fnc_gangsLeaveGang;
		};

		daylight_arrGangs set [count daylight_arrGangs, [_this, [getPlayerUID player], 0]];

		[player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], _this] call daylight_fnc_saveVar;
		publicVariable "daylight_arrGangs";

		false call daylight_fnc_gangsOpenUI;
	};
};

daylight_fnc_gangsAreasInitServer = {
	{
		_vehFlag = createVehicle ["Flag_White_F", [0, 0, 0], [], 0, "NONE"];
		_vehFlag allowDamage false;

		_vehFlag setPosATL (getMarkerPos _x);

		_vehFlag setVariable ["daylight_strGangAreaOwner", ""];
	} forEach daylight_cfg_arrGangAreas;
};

daylight_fnc_gangsAreasInitClient = {
	daylight_arrGangFlags = [];

	_arrGangFlagsCurrent = [];

	{
		_arrGangFlagsCurrent = [];

		while {count _arrGangFlagsCurrent == 0} do {
			_arrGangFlagsCurrent = nearestObjects [getMarkerPos _x, ["Flag_White_F"], 5];

			sleep 0.5;
		};

		daylight_arrGangFlags set [count daylight_arrGangFlags, _arrGangFlagsCurrent select 0];

		sleep 0.5;
	} forEach daylight_cfg_arrGangAreas;

	{
		_x addAction ["<t color=""#75c2e6"">Capture / neutralize gang area</t>", "daylight\client\actions\captureGangArea.sqf", [], 10, true, true, "", "((player distance _target) < 7.5) && (side player == civilian) && !daylight_bActionBusy"];
	} forEach daylight_arrGangFlags;

	if (true) exitWith {};
};

daylight_fnc_gangsCaptureNotification = {
	_strGang = [player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_loadVar;
	_strNewGang = (_this select 0);
	_strOldGang = (_this select 1);
	_iGangArea = (_this select 2);
	_iStatus = (_this select 3);

	if (_strGang == _strNewGang) then {
		if (_iStatus == 0) then {
			[format ["Your gang has neutralized gang area %1!", _iGangArea]] call daylight_fnc_showActionMsg;
		} else {
			[format ["Your gang has captured gang area %1!", _iGangArea]] call daylight_fnc_showActionMsg;
		};
	} else {
		if ((_strGang == _strOldGang) && _strGang != "") then {
			if (_iStatus == 1) then {
				[format ["%1 has captured gang area %2 from your gang!", _strNewGang, _iGangArea]] call daylight_fnc_showActionMsg;
			} else {
				[format ["%1 has neutralized gang area %2 from your gang!", _strNewGang, _iGangArea]] call daylight_fnc_showActionMsg;
			};
		};
	};
};

if (isDedicated) then {
	call daylight_fnc_gangsInitServer;
} else {
	if (isServer) then {
		call daylight_fnc_gangsInitServer;
	};

	[] spawn daylight_fnc_gangsAreasInitClient;
};