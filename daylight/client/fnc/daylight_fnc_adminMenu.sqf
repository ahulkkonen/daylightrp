/*
	Description:	Admin menu
	Author:			qbt
*/

/*
	Description:	Open admin menu UI
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_adminMenuOpenUI = {
	if (!dialog) then {
		if ((getPlayerUID player) in daylight_arrAdminMenuAdminUIDs) then {
			createDialog "AdminMenu";

			daylight_vehAdminMenuTarget = player;
			daylight_strAdminMenuViewMode = "External";

			daylight_bAdminMenuWarnPlayerOpen = false;

			/*if (isNil "daylight_camAdmin") then {
				daylight_camAdmin = "Camera" camCreate [0, 0, 0];
			};*/

			{
				lbAdd [2100, name _x];
			} forEach playableUnits;

			lbSetCurSel [2100, (playableUnits find player)];

			//daylight_camAdmin cameraEffect ["Internal", "Back"];

			[] spawn daylight_fnc_adminMenuUpdateUI;
		};
	};
};

/*
	Description:	Admin menu update ui
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_adminMenuUpdateUI = {
	/*[] spawn {
		while {true} do {
			daylight_camAdmin setPosATL (daylight_vehAdminMenuTarget modelToWorld [0, -7.5, 3]);
			daylight_camAdmin camSetTarget daylight_vehAdminMenuTarget;

			daylight_camAdmin camCommit 0;			
		};
	};*/

	_vehLastTarget = objNull;

	_cfg_arrTitleColor = [0, 0.35, 1, 1];
	_cfg_arrSubTitleColor = [0, 0.49, 1, 1];

	while {dialog} do {
		if (!daylight_bAdminMenuWarnPlayerOpen) then {
			daylight_vehAdminMenuTarget = (playableUnits select (lbCurSel 2100));

			if (isNull daylight_vehAdminMenuTarget) then {
				daylight_vehAdminMenuTarget = player;

				{
					lbAdd [2100, name _x];
				} forEach playableUnits;

				lbSetCurSel [2100, (playableUnits find player)];
			};

			if (_vehLastTarget != daylight_vehAdminMenuTarget) then {
				// Print player info
				lbAdd [1500, "[Player information]"];
				lbSetColor [1500, (lbSize 1500) - 1, _cfg_arrTitleColor];

				_iMoneyBank = [daylight_vehAdminMenuTarget, format["iMoneyBank%1", daylight_vehAdminMenuTarget call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;

				lbAdd [1500, format["	Money in bank: %1%2", _iMoneyBank, localize "STR_CURRENCY"]];
				lbAdd [1500, ""];

				if ((side daylight_vehAdminMenuTarget) == civilian) then {
					lbAdd [1500, "	[Criminal record]"];
					lbSetColor [1500, (lbSize 1500) - 1, _cfg_arrSubTitleColor];

					// Is wanted?
					_bIsWanted = daylight_vehAdminMenuTarget call daylight_fnc_jailPlayerIsWanted;
					_strIsWanted = "No";

					_arrWantedColor = [1, 1, 1, 1];

					if (_bIsWanted) then {
						_strIsWanted = "Yes";

						_arrWantedColor = [1, 0, 0, 1];
					};

					lbAdd [1500, format ["		Wanted: %1", _strIsWanted]];
					lbSetColor [1500, (lbSize 1500) - 1, _arrWantedColor];

					// Bounty
					_iBounty = [daylight_vehAdminMenuTarget, format["iBounty%1", daylight_vehAdminMenuTarget call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;
					_strBounty = format ["%1%2", _iBounty, localize "STR_CURRENCY"];

					if (_iBounty == 0) then {
						_strBounty = "None";
					};

					lbAdd [1500, format ["		Bounty: %1", _strBounty]];
				
					_strVariable = format["arrWanted%1", daylight_vehAdminMenuTarget call daylight_fnc_returnSideStringForSavedVariables];
					_arrWanted = [daylight_vehAdminMenuTarget, _strVariable, []] call daylight_fnc_loadVar;

					if (count _arrWanted != 0) then {
						lbAdd [1500, ""];
					};

					for "_i" from 0 to ((count _arrWanted) - 1) do {
						_strWanted = (_arrWanted select _i) select 0;
						_iBounty = (_arrWanted select _i) select 1;

						lbAdd [1500, format["		%2. %1 (%3%4)", _strWanted, _i + 1, _iBounty, localize "STR_CURRENCY"]];
					};

					lbAdd [1500, ""];
				};

				// Licenses
				_arrLicenses = [daylight_vehAdminMenuTarget, format["arrLicenses%1", daylight_vehAdminMenuTarget call daylight_fnc_returnSideStringForSavedVariables], []] call daylight_fnc_loadVar;

				lbAdd [1500, "	[Licenses]"];
				lbSetColor [1500, (lbSize 1500) - 1, _cfg_arrSubTitleColor];

				if ((count _arrLicenses) > 0) then {
					for "_i" from 0 to ((count _arrLicenses) - 1) do {
						_strLicense = _arrLicenses select _i;

						lbAdd [1500, format["		%1", _strLicense]];
					};
				} else {
					lbAdd [1500, "		No licenses to show."];
				};
			};

			_iFrozen = daylight_vehAdminMenuTarget getVariable ["daylight_iFrozen", 0];

			if (_iFrozen == 1) then {
				(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1702) ctrlSetText "Unfreeze player";
			} else {
				(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1702) ctrlSetText "Freeze player";
			};

			if (daylight_bPlayerGodMode) then {
				(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1704) ctrlSetText "Disable godmode";
			} else {
				(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1704) ctrlSetText "Enable godmode";
			};

			daylight_vehAdminMenuTarget switchCamera daylight_strAdminMenuViewMode;

			_vehLastTarget = daylight_vehAdminMenuTarget;
		};

		sleep 0.1;
	};

	player switchCamera daylight_strAdminMenuViewMode;

	//daylight_camAdmin cameraEffect ["Terminate", "Back"];

	if (true) exitWith {};
};

/*
	Description:	Teleport to player
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_adminMenuTeleportToPlayer = {
	player setPosATL (daylight_vehAdminMenuTarget modelToWorld [0, 0.5, 0]);

	systemChat format["** You have teleported to %1.", name daylight_vehAdminMenuTarget];
};

/*
	Description:	Toggle godmode
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_adminMenuGodmodeToggle = {
	daylight_bPlayerGodMode = !daylight_bPlayerGodMode;

	player allowDamage daylight_bPlayerGodMode;

	if (daylight_bPlayerGodMode) then {
		systemChat "** You have enabled godmode for yourself.";

		player setVariable ["daylight_iGodMode", 1, true];
	} else {
		systemChat "** You have disabled godmode for yourself.";

		player setVariable ["daylight_iGodMode", 0, true];
	};
};

/*
	Description:	Freeze player locally
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_adminMenuFreezeToggleLocal = {
	daylight_bPlayerFreezed = !daylight_bPlayerFreezed;

	disableUserInput daylight_bPlayerFreezed;

	if (daylight_bPlayerFreezed) then {
		systemChat "** You have been temporarily freezed by an admin.";
	} else {
		systemChat "** You have been unfreezed by an admin.";
	};
};

/*
	Description:	Toggle admin menu view
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_adminMenuViewToggle = {
	if (daylight_strAdminMenuViewMode == "External") then {
		daylight_strAdminMenuViewMode = "Internal";
	} else {
		daylight_strAdminMenuViewMode = "External";
	};
};

/*
	Description:	Warn player
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_adminMenuWarnPlayer = {
	daylight_bAdminMenuWarnPlayerOpen = true;

	createDialog "WarnPlayer";
};

/*
	Description:	Warn player local
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_adminMenuWarnPlayerLocal = {
	createDialog "WarnPlayerReceive";

	ctrlEnable [1700, false];

	ctrlSetText [1002, _this];

	for "_i" from 0 to 10 do {
		sleep 1;

		(uiNamespace getVariable "daylight_dsplActive" displayCtrl 1700) ctrlSetText format["Ok (%1)", 10 - _i];
	};

	ctrlEnable [1700, true];

	if (true) exitWith {};
};