/*
	Description:	Stun functions
	Author:			qbt
*/

/*
	Description:	Apply stun value
	Args:			obj shooter
	Return:			nothing
*/
daylight_fnc_stunApplyStun = {
	_iDistance = player distance _this;
	_iValue = 0;

	if ((side _this) == blufor) then {
		if (_iDistance <= daylight_cfg_iStunMaxDistance) then {
			_iValue = daylight_cfg_iStunMaxValue * (1 - (_iDistance / daylight_cfg_iStunMaxDistance));

			if (daylight_iStunValue == 0) then {
				format["%1 was stunned by officer %2!", name player, name _this] call daylight_fnc_networkChatNotification;
			};
		
			daylight_iStunValue = daylight_iStunValue + _iValue;

			if (daylight_iStunValue > daylight_cfg_iStunMaxValue) then {
				daylight_iStunValue = daylight_cfg_iStunMaxValue;
			};

			if (daylight_iStunValue >= 4) then {
				[player, [1, -1, -1]] call daylight_fnc_handlePlayerState;
			};

			if (daylight_iStunValue >= 10) then {
				if (count (weapons player) > 0) then {
					_vehWeaponHolder = createVehicle ["GroundWeaponHolder", [0, 0, 0], [], 0, "NONE"];
					_vehWeaponHolder setPosATL (player modelToWorld [0, 1, 0]);

					{if (_x != "") then {_vehWeaponHolder addWeaponCargoGlobal [_x, 1]}} forEach [primaryWeapon player, handgunWeapon player, secondaryWeapon player];
					{if (_x != "") then {_vehWeaponHolder addItemCargoGlobal [_x, 1]}} forEach ((primaryWeaponItems player) + (handgunItems player));

					{player removeWeapon _x} forEach (weapons player);
				};
			};

			titleText [" ", "WHITE IN", 1];

			daylight_bActionBusy = false;
		};
	};
};

/*
	Description:	Apply stun value
	Args:			obj shooter
	Return:			nothing
*/
daylight_fnc_stunMainLoop = {
	// Create stun ppeffect
	daylight_ppStunBlurEffect = ppEffectCreate ["DynamicBlur", 401];
	daylight_ppStunBlurEffect ppEffectEnable true;

	daylight_ppStunBlurEffect ppEffectAdjust [0];
	daylight_ppStunBlurEffect ppEffectCommit 0;

	while {true} do {
		if (daylight_iStunValue > 0) then {
			if ((vehicle player) == player) then {
				if (daylight_iStunValue > 4) then {
					daylight_camStun cameraEffect ["Internal", "Back"];
					player switchCamera "Internal";

					if (
						(
							[
								"amovppnemstpsnonwnondnon",
								"amovpercmsprsnonwnondf_amovppnemstpsnonwnondnon",
								"amovpercmsprsnonwnondf_amovppnemstpsnonwnondnon_2",
								"amovppnemstpsnonwnondnon_turnr",
								"amovppnemstpsnonwnondnon_turnl",
								"amovpercmstpsnonwnondnon_ease",
								"amovpercmstpsnonwnondnon_easeout",
								"amovpercmstpsnonwnondnon_easein"
							] find (animationState player)
						) == -1
					) then {
						if (!daylight_bJailed && !daylight_bSurrendered && !daylight_bRestrained) then {
							[player, "amovpercmsprsnonwnondf_amovppnemstpsnonwnondnon"] call daylight_fnc_networkSwitchMove;
						};
					};
				} else {
					daylight_camStun cameraEffect ["Terminate", "Back"];

					if (!daylight_bSurrendered) then {
						[player, [0, -1, -1]] call daylight_fnc_handlePlayerState;
					};
				};
			};

			daylight_ppStunBlurEffect ppEffectAdjust [10 * (daylight_iStunValue / daylight_cfg_iStunMaxValue)];
			daylight_ppStunBlurEffect ppEffectCommit 0.25;

			daylight_iStunValue = daylight_iStunValue - 0.25;

			if (daylight_iStunValue <= 1) then {
				daylight_ppStunBlurEffect ppEffectAdjust [0];
				daylight_ppStunBlurEffect ppEffectCommit 15;

				daylight_iStunValue = 0;
			};
		};

		sleep 0.25;
	};
};

if (playerSide == civilian) then {
	[] spawn daylight_fnc_stunMainLoop;
};