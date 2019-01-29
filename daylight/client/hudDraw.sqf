/*
	Description:	HUD for Daylight
	Author:			qbt
*/

disableSerialization;

// Apply vignette
250 cutRsc ["OverlayVignette", "PLAIN", 0.001, false];

// Initialize nametags
500 cutRsc ["InfoTags", "PLAIN", 0.001, false];

// Initialize HUD
1000 cutRsc ["DaylightHUD", "PLAIN", 0.001, false];

// ProgressBar
//1500 cutRsc ["ProgressBar", "PLAIN", 0.001, false];

// Get variables set in RscTitles.hpp
_dDisplay = ((uiNamespace getVariable "daylight_arrRscInfoTag") select 0);
_cInfoTagsTextControl = _dDisplay displayCtrl ((uiNamespace getVariable "daylight_arrRscInfoTag") select 1);

_dDisplay = ((uiNamespace getVariable "daylight_arrRscDaylightHUD") select 0);
_cHUDControlLT = _dDisplay displayCtrl ((uiNamespace getVariable "daylight_arrRscDaylightHUD") select 1);
_cHUDControlRT = _dDisplay displayCtrl ((uiNamespace getVariable "daylight_arrRscDaylightHUD") select 2);
_cHUDControlLB = _dDisplay displayCtrl ((uiNamespace getVariable "daylight_arrRscDaylightHUD") select 3);
_cHUDControlRB = _dDisplay displayCtrl ((uiNamespace getVariable "daylight_arrRscDaylightHUD") select 4);

// Stun camera to disable input
daylight_camStun = "Camera" camCreate [0, 0, 0];
daylight_camStun camSetFOV 0.8;

// Remove dev-build watermark (thanks to Killzone Kid)
waitUntil {!(isNull (findDisplay 46))};

{
	((findDisplay 46) displayCtrl _x) ctrlShow false;
} forEach [1000, 1001, 1002, 1200, 1202];

waitUntil {!(isNil "daylight_arrPresidentInfo")};

// Nametags
onEachFrame {
	{
		_iDistance = (player distance _x);
		_bInGroup = _x in (units (group player));

		if (_bInGroup) then {
			_iDistance = _iDistance * 0.5;
		};

		if (((side player) == blufor) && (side _x == blufor)) then {
			_iDistance = _iDistance * 0.5;
		};

		_iGodMode = _x getVariable ["daylight_iGodMode", 0];

		if (_iGodMode == 1) then {
			_iDistance = _iDistance * 0.25;
		};

		if ((name _x) == (daylight_arrPresidentInfo select 1)) then {
			_iDistance = _iDistance * 0.5;
		};

		if (_iDistance <= 20 && (alive _x) && (_x != player)) then {
			if (!(lineIntersects [eyePos player, eyePos _x, vehicle player, vehicle _x])) then {
				_iAlpha = 0;

				if (_iDistance > 5) then {
					_iAlpha = -(_iDistance / 10) + 2;

					if (_iDistance >= 20) then {
						_iAlpha = 0;
					};
				} else {
					_iAlpha = 1;
				};

				_arrColor = [(daylight_cfg_arrNameTagColors select 0) select 0, (daylight_cfg_arrNameTagColors select 0) select 1, (daylight_cfg_arrNameTagColors select 0) select 2, _iAlpha];

				if (side _x == civilian) then {
					_arrColor = [(daylight_cfg_arrNameTagColors select 0) select 0, (daylight_cfg_arrNameTagColors select 0) select 1, (daylight_cfg_arrNameTagColors select 0) select 2, _iAlpha];
				} else {
					_arrColor = [(daylight_cfg_arrNameTagColors select 1) select 0, (daylight_cfg_arrNameTagColors select 1) select 1, (daylight_cfg_arrNameTagColors select 1) select 2, _iAlpha];
				};

				if (_bInGroup) then {
					_arrColor = [(daylight_cfg_arrNameTagColors select 2) select 0, (daylight_cfg_arrNameTagColors select 2) select 1, (daylight_cfg_arrNameTagColors select 2) select 2, _iAlpha];
				};

				if (_iGodMode == 1) then {
					_arrColor = [(daylight_cfg_arrNameTagColors select 4) select 0, (daylight_cfg_arrNameTagColors select 4) select 1, (daylight_cfg_arrNameTagColors select 4) select 2, _iAlpha];
				};

				if ((name _x) == (daylight_arrPresidentInfo select 1)) then {
					_arrColor = [(daylight_cfg_arrNameTagColors select 3) select 0, (daylight_cfg_arrNameTagColors select 3) select 1, (daylight_cfg_arrNameTagColors select 3) select 2, _iAlpha];
				};

				// Name changes according to state
				_strName = format["%1", name _x];

				if (_iGodMode == 1) then {
					_strName = format["(ADMIN) %1", name _x];
				};

				if ((name _x) == (daylight_arrPresidentInfo select 1)) then {
					_strName = format["(President) %1", name _x];
				};

				_arrPos = [(visiblePositionASL _x) select 0, (visiblePositionASL _x) select 1, ((visiblePositionASL _x) select 2) + 2.15];

				if (!(surfaceIsWater _arrPos)) then {
					_arrPos = ASLtoATL _arrPos;
				} else {
					_arrPos = [_arrPos select 0, _arrPos select 1, ((_arrPos select 2) - ((_arrPos select 2) - ((getPosASLW _x) select 2))) + 2.15];
				};

				drawIcon3D ["", _arrColor, _arrPos, 0, 0, 0, _strName, 1, 0.035, "PuristaMedium"];
			};
		};
	} forEach playableUnits;

	// Update stun camera pos if stunned
	if (daylight_iStunValue > 0) then {
		daylight_camStun setPosASL [player modelToWorld [0, 1.25, 0] select 0, player modelToWorld [0, 1, 0] select 1, (eyePos player) select 2];
		daylight_camStun camSetTarget (player modelToWorld [0, 2.5, 0.25]);
		daylight_camStun camCommit 0;
	};
};

// Map draw
daylight_fnc_hudDrawMap = {
	if ((side player) == blufor) then {
		{
			if ((side _x) == blufor) then {
				// Outline
				(_this select 0) drawIcon [
					getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "Icon"),

					[0, 0, 0, 1],

					visiblePosition (vehicle _x),

					18 min ((2 max (ctrlMapScale (_this select 0))) * 115),
					18 min ((2 max (ctrlMapScale (_this select 0))) * 115),

					getDir (vehicle _x)
				];

				(_this select 0) drawIcon [
					getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "Icon"),

					[1, 1, 1, 1],

					visiblePosition (vehicle _x),

					16 min ((2 max (ctrlMapScale (_this select 0))) * 100),
					16 min ((2 max (ctrlMapScale (_this select 0))) * 100),

					getDir (vehicle _x)
				];

				_strName = "";

				if ((count (crew (vehicle _x))) == 1) then {
					_strName = name _x;
				} else {
					{
						if (_strName == "") then {
							_strName = name _x;
						} else {
							_strName = format ["%1, %2", _strName, name _x];
						};
					} forEach (crew (vehicle _x));
				};

				(_this select 0) drawIcon [
					getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "Icon"),

					[1, 1, 1, 1],

					visiblePosition (vehicle _x),

					16 min ((2 max (ctrlMapScale (_this select 0))) * 100),
					16 min ((2 max (ctrlMapScale (_this select 0))) * 100),

					getDir (vehicle _x),

					_strName,
					2,
					0.05,
					"PuristaMedium"
				];
			};
		} forEach playableUnits;
	} else {
		{
			// Outline
			(_this select 0) drawIcon [
				getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "Icon"),

				[0, 0, 0, 1],

				visiblePosition (vehicle _x),

				18 min ((2 max (ctrlMapScale (_this select 0))) * 115),
				18 min ((2 max (ctrlMapScale (_this select 0))) * 115),

				getDir (vehicle _x)
			];

			(_this select 0) drawIcon [
				getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "Icon"),

				[1, 1, 1, 1],

				visiblePosition (vehicle _x),

				16 min ((2 max (ctrlMapScale (_this select 0))) * 100),
				16 min ((2 max (ctrlMapScale (_this select 0))) * 100),

				getDir (vehicle _x)
			];

			_strName = "";

			if ((count (crew (vehicle _x))) == 1) then {
				_strName = name _x;
			} else {
				{
					if (_strName == "") then {
						_strName = name _x;
					} else {
						_strName = format ["%1, %2", _strName, name _x];
					};
				} forEach (crew (vehicle _x));
			};

			(_this select 0) drawIcon [
				getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "Icon"),

				[1, 1, 1, 1],

				visiblePosition (vehicle _x),

				16 min ((2 max (ctrlMapScale (_this select 0))) * 100),
				16 min ((2 max (ctrlMapScale (_this select 0))) * 100),

				getDir (vehicle _x),

				_strName,
				2,
				0.05,
				"PuristaMedium"
			];
		} forEach (units (group player));
	};
};

_iEHMapDraw = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", "_this call daylight_fnc_hudDrawMap"];

// Wait until character saved
waitUntil {
	daylight_bCharacterCreated
	&&
	!(isNil "daylight_arrMerchants")
	&&
	!(isNil "daylight_arrImpoundOfficers")
	&&
	!(isNil "daylight_arrLicenseSellers")
	&&
	!(isNil "daylight_arrMiscInteractableUnits")
	&&
	!(isNil "daylight_arrVehicleShops")
	&&
	!(isNil "daylight_cfg_arrProcessUnits")
	&&
	!(isNil "daylight_arrVoteUnits")
	&&
	!(isNil "daylight_arrMerchantsAutoBounty")
	&&
	!(isNil "daylight_arrWreckingYards")
	&&
	daylight_bWeatherAndTimeSynced
};

// Fade in screen & sound
titleText ["", "BLACK IN", 5];
[5, 1] call daylight_fnc_setMasterVolume;

daylight_bHUDReady = true;

// HUD main loop
while {true} do {
	_strTag = "";

	// InfoTags
	if ((cursorTarget != player) && !(isNull cursorTarget) && ((cursorTarget distance player) <= daylight_cfg_iMaxDistanceFromInteractedUnit) && (abs(((getPosATL cursorTarget) select 2) - ((getPosATL player) select 2)) <= 1.5) && (alive cursorTarget)) then {
		// Is cursorTarget merchant
		if ((daylight_arrMerchants find cursorTarget) != -1) then {
			_strTagName = (cursorTarget getVariable "daylight_arrMerchantInfo") select 0;
			_strTag = format["<t align=""center"" shadow=""1""><t size=""2.7"" color=""#ffffff"">%1</t> <t size=""1.5"" color=""#dbdbdb"">(E)</t></t>", _strTagName];
		};

		// Is cursorTarget impound officer
		if ((daylight_arrImpoundOfficers find cursorTarget) != -1) then {
			_strTagName = "Impound Officer"; // TO-DO: Localize
			_strTag = format["<t align=""center"" shadow=""1""><t size=""2.7"" color=""#ffffff"">%1</t> <t size=""1.5"" color=""#dbdbdb"">(E)</t></t>", _strTagName];
		};

		// Is cursorTarget license seller
		if ((daylight_arrLicenseSellers find cursorTarget) != -1) then {
			_strTagName = "License Seller"; // TO-DO: Localize
			_strTag = format["<t align=""center"" shadow=""1""><t size=""2.7"" color=""#ffffff"">%1</t> <t size=""1.5"" color=""#dbdbdb"">(E)</t></t>", _strTagName];
		};

		// Is cursorTarget misc interactable unit
		if ((daylight_arrMiscInteractableUnits find cursorTarget) != -1) then {
			_strTagName = (daylight_cfg_arrMiscInteractableUnits select (daylight_arrMiscInteractableUnits find cursorTarget)) select 3;
			_strTag = format["<t align=""center"" shadow=""1""><t size=""2.7"" color=""#ffffff"">%1</t></t>", _strTagName];
		};

		// Is cursorTarget vehicle shop
		if ((daylight_arrVehicleShops find cursorTarget) != -1) then {
			_strTagName = (daylight_cfg_arrVehicleShops select (daylight_arrVehicleShops find cursorTarget)) select 1;
			_strTag = format["<t align=""center"" shadow=""1""><t size=""2.7"" color=""#ffffff"">%1</t> <t size=""1.5"" color=""#dbdbdb"">(E)</t></t>", _strTagName];
		};

		// Is cursorTarget process unit
		if ((daylight_arrProcessUnits find cursorTarget) != -1) then {
			_strTagName = (daylight_cfg_arrProcessUnits select (daylight_arrProcessUnits find cursorTarget)) select 0;
			_strTag = format["<t align=""center"" shadow=""1""><t size=""2.7"" color=""#ffffff"">%1</t> <t size=""1.5"" color=""#dbdbdb"">(E)</t></t>", _strTagName];
		};

		// Is cursorTarget vote unit
		if ((daylight_arrVoteUnits find cursorTarget) != -1) then {
			_strTagName = (daylight_cfg_arrVoteUnits select (daylight_arrVoteUnits find cursorTarget)) select 1;
			_strTag = format["<t align=""center"" shadow=""1""><t size=""2.7"" color=""#ffffff"">%1</t> <t size=""1.5"" color=""#dbdbdb"">(E)</t></t>", _strTagName];
		};

		if ((daylight_arrWreckingYards find cursorTarget) != -1) then {
			_strTagName = "Wrecking Yard";
			_strTag = format["<t align=""center"" shadow=""1""><t size=""2.7"" color=""#ffffff"">%1</t> <t size=""1.5"" color=""#dbdbdb"">(E)</t></t>", _strTagName];
		};

		// Is cursorTarget merchant autobounty unit
		if ((daylight_arrMerchantsAutoBounty find cursorTarget) != -1) then {
			_strTagName = (daylight_cfg_arrMerchantsAutoBounty select (daylight_arrMerchantsAutoBounty find cursorTarget)) select 1;
			_strTag = format["<t align=""center"" shadow=""1""><t size=""2.7"" color=""#ffffff"">%1</t> <t size=""1.5"" color=""#dbdbdb"">(E)</t></t>", _strTagName];
		};
	};

	// Apply text to InfoTags text control
	_cInfoTagsTextControl ctrlSetStructuredText (parseText _strTag);

	// Weapon info
	if ((currentWeapon player) != "") then {
		_strFireMode = currentWeaponMode player;

		_bDraw = true;

		if ((_strFireMode != "Single") && (_strFireMode != "Burst") && (_strFireMode != "FullAuto")) then {
			_bDraw = false;
		};

		if (_strFireMode == "FullAuto") then {
			_strFireMode = "Auto";
		};

		_iZeroing = currentZeroing player;

		if (_bDraw) then {
			_strText = format["<t size=""1.75"" align=""right"">%1 (%2)</T>", _strFireMode, _iZeroing];

			_cHUDControlRT ctrlSetStructuredText (parseText _strText);
		} else {
			_cHUDControlRT ctrlSetStructuredText (parseText "");
		};
	} else {
		_cHUDControlRT ctrlSetStructuredText (parseText "");
	};

	false call BIS_fnc_showUnitInfo;

	sleep 0.05;
};