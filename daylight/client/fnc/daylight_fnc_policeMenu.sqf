/*	
	Description: 	Police menu
	Author:			qbt
*/

/*
	Description:	Open police menu
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_policeMenuOpenUI = {
	if ((playerSide == blufor) && !dialog) then {
		createDialog "PoliceMenu";

		// Populate target list
		_iX = 0;
		for "_i" from 0 to ((count playableUnits) - 1) do {
			_objPlayer = playableUnits select _i;

			if ((side _objPlayer) == civilian) then {
				lbAdd [2100, name _objPlayer];
				lbSetData [2100, _iX, str _i];

				if (_objPlayer call daylight_fnc_jailPlayerIsWanted) then {
					lbSetColor [2100, _iX, [1, 0, 0, 1]];
				};

				_iX = _iX + 1;
			};
		};

		if ((lbSize 2100) == 0) then {
			lbAdd [2100, "No players to show"];

			ctrlEnable [1700, false];
			ctrlEnable [1701, false];
			ctrlEnable [1702, false];

			lbAdd [1500, "No player selected."];

			daylight_bPoliceMenuListEmpty = true;
		} else {
			daylight_bPoliceMenuListEmpty = false;
		};

		while {(lbCurSel 2100) == -1} do {
			lbSetCurSel [2100, 0];
		};
	};
};

/*
	Description:	Police menu update ui
	Args:			arr [veh to set unwanted, i index]
	Return:			nothing
*/
daylight_fnc_policeMenuUpdateUI = {
	if (!daylight_bPoliceMenuListEmpty) then {
		daylight_objCurrentPoliceMenuPlayer = playableUnits select (parseNumber(lbData [2100, (_this select 1)]));

		lbClear 1500;

		lbAdd [1500, "[Player information]"];

		_iBounty = [daylight_objCurrentPoliceMenuPlayer, format["iBounty%1", daylight_objCurrentPoliceMenuPlayer call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
		_strBounty = format ["%1%2", _iBounty, localize "STR_CURRENCY"];

		if (_iBounty == 0) then {
			_strBounty = "None";
		};

		lbAdd [1500, format ["	Bounty: %1", _strBounty]];

		_strIsWanted = "No";

		_bIsWanted = daylight_objCurrentPoliceMenuPlayer call daylight_fnc_jailPlayerIsWanted;
		if (_bIsWanted) then {
			_strIsWanted = "Yes";
		} else {
			ctrlEnable [1701, false];
		};

		lbAdd [1500, format ["	Wanted: %1", _strIsWanted]];

		_strJailed = "Yes";
		_iIsJailed = ((daylight_objCurrentPoliceMenuPlayer getVariable ["daylight_arrState", [0, 0, 0]]) select 2);

		if (_iIsJailed == 0) then {
			ctrlEnable [1702, false];

			_strJailed = "No";
		} else {
			ctrlEnable [1702, true];
		};

		lbAdd [1500, format ["	Jailed: %1", _strJailed]];

		_arrLicenses = [daylight_objCurrentPoliceMenuPlayer, format["arrLicenses%1", daylight_objCurrentPoliceMenuPlayer call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

		lbAdd [1500, ""];
		lbAdd [1500, "	[Licenses]"];

		if ((count _arrLicenses) > 0) then {
			for "_i" from 0 to ((count _arrLicenses) - 1) do {
				_strLicense = _arrLicenses select _i;

				lbAdd [1500, format["		%1", _strLicense]];
			};
		} else {
			lbAdd [1500, "		No licenses to show."];
		};

		if (_bIsWanted) then {
			_arrWanted = [daylight_objCurrentPoliceMenuPlayer, format["arrWanted%1", daylight_objCurrentPoliceMenuPlayer call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

			lbAdd [1500, ""];
			lbAdd [1500, "	[Wanted for]"];

			if ((count _arrWanted) > 0) then {
				for "_i" from 0 to ((count _arrWanted) - 1) do {
					_strReason = (_arrWanted select _i) select 0;
					_iBounty = (_arrWanted select _i) select 1;

					if (_iBounty == 0) then {
						lbAdd [1500, format["		%1", _strReason]];
					} else {
						lbAdd [1500, format["		%1 (%2%3)", _strReason, _iBounty, localize "STR_CURRENCY"]];
					};
				};
			};
		};
	};
};

/*
	Description:	Set wanted open UI
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_policeMenuSetWantedOpenUI = {
	closeDialog 0;

	createDialog "SetWanted";

	daylight_bPoliceMenuActionOpen = true;

	ctrlEnable [1700, false];
	[] spawn daylight_fnc_policeMenuActionUpdateUI;

	((uiNamespace getVariable "daylight_dsplActive") displayCtrl 1100) ctrlSetStructuredText (parseText(format[localize "STR_POLICE_MENU_SETWANTED_INFORMATION", name(daylight_objCurrentPoliceMenuPlayer)]));
};

/*
	Description:	Set unwanted open UI
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_policeMenuSetUnwantedOpenUI = {
	closeDialog 0;

	createDialog "SetUnwanted";

	daylight_bPoliceMenuActionOpen = true;

	ctrlEnable [1700, false];
	[] spawn daylight_fnc_policeMenuActionUpdateUI;

	// Populate wanted list
	_arrWanted = [daylight_objCurrentPoliceMenuPlayer, format["arrWanted%1", daylight_objCurrentPoliceMenuPlayer call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

	if (count _arrWanted == 0) exitWith {closeDialog 0};

	for "_i" from 0 to ((count _arrWanted) - 1) do {
		_strReason = (_arrWanted select _i) select 0;
		_iBounty = (_arrWanted select _i) select 1;

		if (_iBounty == 0) then {
			lbAdd [2100, format["%1", _strReason]];
		} else {
			lbAdd [2100, format["%1 (%2%3)", _strReason, _iBounty, localize "STR_CURRENCY"]];
		};
	};

	while {lbCurSel 2100 == -1} do {
		lbSetCurSel [2100, 0];
	};

	((uiNamespace getVariable "daylight_dsplActive") displayCtrl 1100) ctrlSetStructuredText (parseText(format[localize "STR_POLICE_MENU_SETUNWANTED_INFORMATION", name(daylight_objCurrentPoliceMenuPlayer)]));
};

/*
	Description:	Release from jail open UI
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_policeMenuReleaseFromJailOpenUI = {
	closeDialog 0;

	createDialog "ReleaseFromJail";

	daylight_bPoliceMenuActionOpen = true;

	ctrlEnable [1700, false];
	[] spawn daylight_fnc_policeMenuActionUpdateUI;

	((uiNamespace getVariable "daylight_dsplActive") displayCtrl 1100) ctrlSetStructuredText (parseText(format[localize "STR_POLICE_MENU_RELEASEFROMJAIL_INFORMATION", name(daylight_objCurrentPoliceMenuPlayer)]));
};

/*
	Description:	Set wanted
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_policeMenuSetWanted = {
	closeDialog 0;

	daylight_bPoliceMenuActionOpen = false;

	[daylight_objCurrentPoliceMenuPlayer, _this, 0] call daylight_fnc_jailSetWanted;

	format ["Officer %1 set %2 wanted for %3", name player, name daylight_objCurrentPoliceMenuPlayer, _this] call daylight_fnc_networkGlobalMessage;

	call daylight_fnc_policeMenuOpenUI;
};


/*
	Description:	Set unwanted
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_policeMenuSetUnwanted = {
	closeDialog 0;

	daylight_bPoliceMenuActionOpen = false;

	[daylight_objCurrentPoliceMenuPlayer, (_this select 1)] call daylight_fnc_jailSetUnwanted;

	format ["Officer %1 unwanted %2 for %3 (%4)", name player, name daylight_objCurrentPoliceMenuPlayer, _this select 2, (_this select 0)] call daylight_fnc_networkGlobalMessage;

	call daylight_fnc_policeMenuOpenUI;
};

/*
	Description:	Release from jail
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_policeMenuReleaseFromJail = {
	closeDialog 0;

	daylight_bPoliceMenuActionOpen = false;

	[daylight_objCurrentPoliceMenuPlayer, [0, 0, 0]] call daylight_fnc_handlePlayerState;

	format ["Officer %1 released %2 from jail (%3)", name player, name daylight_objCurrentPoliceMenuPlayer, _this] call daylight_fnc_networkGlobalMessage;

	call daylight_fnc_policeMenuOpenUI;
};

/*
	Description:	Update want/unwant/release UI's
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_policeMenuActionUpdateUI = {
	while {daylight_bPoliceMenuActionOpen} do {
		if ((count ((toArray (ctrlText 1400)) - [32])) == 0) then {
			ctrlEnable [1700, false];
		} else {
			ctrlEnable [1700, true];
		};

		sleep 0.05;
	};

	if (true) exitWith {};
};