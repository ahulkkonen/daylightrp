/*
	Description:	Loop ran on client that takes care of misc things
	Author:			qbt
*/

_arrVehiclesWithImpoundActionAdded = [];
_arrVehiclesWithEHsAttached = [];

_iLastPaycheckTime = time;

_iLoopCounter = 0;

_iLastRadioTime = -1;
_iNextRadioTime = -1;
_iRandom = -1;
_iLastRandom = -1;

_arrBuildActionsAdded = [];

_bHungerWarned = false;

_iLeaveTime = 0;
_iTimesAway = 0;
_bAwayWarned = false;

while {true} do {
	// Determine if players are near
	_arrNearMen = nearestObjects [player, ["CAManBase"], 4];
	_arrNearPlayers = [];
	{
		if (((isPlayer _x) && (_x != player) && (alive _x))) then {
			_arrNearPlayers set [count _arrNearPlayers, _x];
		};
	} forEach _arrNearMen;

	if ((count _arrNearPlayers) == 0) then {
		daylight_bPlayerNears = false;
	} else {
		daylight_bPlayerNears = true;
	};

	// BLUFOR stuff
	if (playerSide == blufor) then {
		if ((cursorTarget isKindOf "Car") && (isNull(driver(cursorTarget)))) then {
			if ((_arrVehiclesWithImpoundActionAdded find cursorTarget) == -1) then {
				cursorTarget addAction daylight_cfg_arrImpoundAction;

				_arrVehiclesWithImpoundActionAdded set [count _arrVehiclesWithImpoundActionAdded, cursorTarget];
			};
		};
	};

	// Paycheck
	if ((time - _iLastPaycheckTime) >= daylight_cfg_iPaycheckInterval) then {
		_iPaycheckAmount = daylight_cfg_iPaycheckCivilian;

		if (playerSide == blufor) then {
			_iPaycheckAmount = daylight_cfg_iPaycheckBlufor;
		};

		// Owns gang area?
		_iOwned = -1;

		_i = 0;
		{
			_strOwner = _x getVariable ["daylight_strGangAreaOwner", ""];

			_strCurrentGang = [player, format["strGang%1", player call daylight_fnc_returnSideStringForSavedVariables], ""] call daylight_fnc_loadVar;

			if ((_strOwner == _strCurrentGang) && (_strOwner != "")) then {
				_iOwned = _i;
			};

			_i = _i + 1;
		} forEach daylight_arrGangFlags;

		if (_iOwned != -1) then {
			switch (_iOwned) do {
				case 0 : {
					_iPaycheckAmount = _iPaycheckAmount + daylight_cfg_iPaycheckGangArea1;
				};

				case 1 : {
					_iPaycheckAmount = _iPaycheckAmount + daylight_cfg_iPaycheckGangArea2;
				};

				case 2 : {
					_iPaycheckAmount = _iPaycheckAmount + daylight_cfg_iPaycheckGangArea3;
				};
			};
		};

		// If is president
		_strPlayerUID = getPlayerUID player;

		if (_strPlayerUID == (daylight_arrPresidentInfo select 0)) then {
			_iPaycheckAmount = _iPaycheckAmount + daylight_cfg_iPaycheckPresident;
		};

		// Get current bank money
		_iMoneyBank = [player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], 0] call daylight_fnc_loadVar;

		// Add paycheck to it
		_iMoneyBank = _iMoneyBank + _iPaycheckAmount;

		// Update bank money amount
		[player, format["iMoneyBank%1", player call daylight_fnc_returnSideStringForSavedVariables], _iMoneyBank] call daylight_fnc_saveVar;

		// Show notification
		[localize "STR_PAYCHECK_MESSAGE_TITLE", format[localize "STR_PAYCHECK_MESSAGE_RECEIVED", _iPaycheckAmount, localize "STR_CURRENCY", _iMoneyBank, (daylight_cfg_iPaycheckInterval call daylight_fnc_secondsToMinutesAndSeconds) select 0], true] call daylight_fnc_showHint;

		_iLastPaycheckTime = time;
	};

	// Force 1st person if not in vehicle
	/*if ((vehicle player) == player) then {
		daylight_b3rdPersonEnabled = false;

		if (cameraView == "External") then {
			player switchCamera "Internal";
		};
	} else {
		daylight_b3rdPersonEnabled = true;
	};*/

	if ((vehicle player) isKindOf "CAManBase") then {
		if (viewDistance != (daylight_arrViewDistance select 0)) then {
			setViewDistance (daylight_arrViewDistance select 0);
		};
	};

	if ((vehicle player) isKindOf "LandVehicle") then {
		if (viewDistance != (daylight_arrViewDistance select 1)) then {
			setViewDistance (daylight_arrViewDistance select 1);
		};

		// Add EH
		if (((daylight_cfg_arrLandVehicleDamageEHBlacklist find vehicle player)) == -1) then {
			if ((_arrVehiclesWithEHsAttached find (vehicle player)) == -1) then {
				if ((driver (vehicle player)) == player) then {
					(vehicle player) addEventHandler ["HandleDamage", {_this call daylight_fnc_handleDamageVehicleLand}];

					_arrVehiclesWithEHsAttached set [count _arrVehiclesWithEHsAttached, vehicle player];
				};
			};
		};
	};

	if ((vehicle player) isKindOf "Air") then {
		if (viewDistance != (daylight_arrViewDistance select 2)) then {
			setViewDistance (daylight_arrViewDistance select 2);
		};
	};

	// Color BLUFOR uniforms
	{
		if ((side _x) == blufor) then {
			if ((uniform _x) == ((daylight_cfg_arrStartGearBLUFORClothing select 2) select 0)) then {
				_x setObjectTexture [0, ((daylight_cfg_arrStartGearBLUFORClothing) select 2) select 1];
			};
		};
	} forEach playableUnits;

	if (!(isNull (findDisplay 602))) then {
		if (((locked cursorTarget) == 2) && ((player distance cursorTarget) <= 7.5)) then {
			closeDialog 0;

			["<t color=""#ffcb00"">You cant access the gear of a locked vehicle!</t>"] call daylight_fnc_showActionMsg;
		} else {
			/*if (!daylight_bCanUseGear) then {
				closeDialog 0;
			};*/
		};
	};

	// Police vehicle radio chatter
	if ((vehicle player) != player) then {
		_iSide = (vehicle player) getVariable ["daylight_iVehicleSide", -1];

		if ((_iSide == 0) || ((vehicle player) isKindOf "Air")) then {
			if ((time - _iLastRadioTime) >= _iNextRadioTime) then {
				while {(_iRandom == _iLastRandom) || (_iRandom == 1)} do {
					_iRandom = ceil(random 30);
				};

				_iLastRandom = _iRandom;

				_iNextRadioTime = time + (15 + (random 15));

				0 fadeMusic 0.15;

				playMusic format["RadioAmbient%1", _iRandom];
			};
		};
	} else {
		playMusic "";

		0 fadeMusic 1;
	};

	// Add lock / unlock options to built objects
	if ((cursorTarget getVariable ["daylight_iBuildTime", -1] != -1) && !(cursorTarget in _arrBuildActionsAdded)) then {
		cursorTarget addAction ["<t color=""#75c2e6"">Remove item</t>", "daylight\client\actions\removeItem.sqf", [], 10, true, true, "", "((player distance _target) < 2.5) && !daylight_bActionBusy"];

		_arrBuildActionsAdded set [count _arrBuildActionsAdded, cursorTarget];
	};

	if (_iLoopCounter == 999999) then {
		_iLoopCounter = 0;
	} else {
		_iLoopCounter = _iLoopCounter + 1;
	};

	if (overcast < 0.8) then {
		0 setRain 0;
	};

	// Update gangs
	if (!(isNil "daylight_arrGangFlags")) then {
		{
			_strGang = _x getVariable ["daylight_strGangAreaOwner", ""];
			_strNearestMarker = [getPosATL _x, daylight_cfg_arrGangAreas] call daylight_fnc_getNearestMarker;

			_strText = [markerText _strNearestMarker, 0, 11] call BIS_fnc_trimString;

			if (_strGang != "") then {
				_strNearestMarker setMarkerTextLocal format["%1 (%2)", _strText, _strGang];
			} else {
				_strNearestMarker setMarkerTextLocal format["%1 (Neutral)", _strText];
			};
		} forEach daylight_arrGangFlags;
	};

	daylight_iHunger = daylight_iHunger + 0.00005;

	if (daylight_iHunger > 1) then {
		daylight_iHunger = 1;

		player setDamage ((damage player) + 0.00025);
	};

	if (daylight_iHunger >= 0.75) then {
		if (!_bHungerWarned) then {
			systemChat "** You start to feel hungry..";

			_bHungerWarned = true;
		};
	} else {
		_bHungerWarned = false;
	};

	// Make sure player doesnt become side ENEMY
	while {(rating player) < 0} do {
		player addRating 5000;

		sleep 0.025;
	};

	// Player not in playable area
	_arrList = list trgMapBorder;

	if (!((vehicle player) in _arrList) && !(player in _arrList)) then {
		if ((player distance daylight_cfg_arrRespawnHoldPos) > 100) then {
			if (!daylight_bRespawning) then {
				if (_iTimesAway >= 30) then {
					if (!_bAwayWarned) then {
						systemChat "** You are leaving the playable area, turn back or you will be punished.";

						_bAwayWarned = true;
					};

					if (_iTimesAway >= 80) then {
						player setDamage 1;
					};
				};

				_iTimesAway = _iTimesAway + 1;
			};
		};
	} else {
		_iTimesAway = 0;
		_bAwayWarned = false;
	};

	// If we are using a stun gun, update "stun" variable
	if ((side player) == blufor) then {
		_iStun = player getVariable ["daylight_iStun", 0];

		if ((currentWeapon player) == daylight_cfg_strStunWeapon) then {
			if (_iStun == 0) then {
				player setVariable ["daylight_iStun", 1, true];
			};
		} else {
			if (_iStun == 1) then {
				player setVariable ["daylight_iStun", 0, true];
			};
		};
	};

	if (!(isNil "daylight_bEndMissionComplete")) then {
		if (daylight_bEndMissionComplete && !isServer) then {
			sleep 30;

			["End1", true, true] call BIS_fnc_endMission;
		};	
	};

	sleep 0.33;
};