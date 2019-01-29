/*
	Description: 	Rob gas station
	Author:			qbt
*/

_untMerchant = _this select 0;
_untRobber = _this select 1;

_iLastRobTime = _untMerchant getVariable ["daylight_iLastRobTime", -1];

_iMoneyReceived = daylight_cfg_iRobReceiveAmountMin + ((random daylight_cfg_iRobReceiveAmountMax) - daylight_cfg_iRobReceiveAmountMin);
_iMoneyReceived = (round (_iMoneyReceived / 100) * 100);

if (((time - _iLastRobTime) >= daylight_cfg_iRobCooldownTime) || (_iLastRobTime == -1)) then {
	_untMerchant setVariable ["daylight_iLastRobTime", time, true];

	[_untMerchant, true] call daylight_fnc_networkEnableSimulation;

	sleep 0.1;

	[_untMerchant, "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon"] call daylight_fnc_networkPlayMove;

	sleep 1;

	[localize "STR_GAS_STATION_TITLE", format[localize "STR_GAS_STATION_ROBBED", _iMoneyReceived, localize "STR_CURRENCY"], true] call daylight_fnc_showHint;

	[daylight_cfg_iInvMoneyID, _iMoneyReceived] call daylight_fnc_invAddItemWithWeight;

	sleep 1;

	[_untMerchant, "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon"] call daylight_fnc_networkSwitchMove;

	sleep 2;

	[_untMerchant, false] call daylight_fnc_networkEnableSimulation;

	waitUntil {_untMerchant distance _untRobber >= 7.5};

	[player, "Robbing gas station", _iMoneyReceived] call daylight_fnc_jailSetWanted;
	format["Gas station %1 has been robbed!", (daylight_arrGasStationMerchants find _untMerchant) + 1] call daylight_fnc_networkChatNotification;

	// Spawn sound player
	_untMerchant say3D "72757_benboncan_fire_alarm";
	[_untMerchant, 32, false] call daylight_fnc_networkSay3D;

	sleep 20;

	[_untMerchant, true] call daylight_fnc_networkEnableSimulation;
	[_untMerchant, "amovpercmstpssurwnondnon_amovpercmstpsnonwnondnon"] call daylight_fnc_networkSwitchMove;

	sleep 2.5;

	[_untMerchant, false] call daylight_fnc_networkEnableSimulation;
} else {
	[localize "STR_GAS_STATION_TITLE", localize "STR_GAS_STATION_COOLDOWN", true] call daylight_fnc_showHint;
};

if (true) exitWith {};