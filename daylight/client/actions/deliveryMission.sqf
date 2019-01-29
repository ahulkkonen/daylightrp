/*
	Description: 	Delivery mission
	Author:			qbt
*/

daylight_bDeliveryMissionActive = true;

_arrDPs = ["mrkDP_1", "mrkDP_2", "mrkDP_3", "mrkDP_4", "mrkDP_5", "mrkDP_6"];
_iDP = round (random ((count _arrDPs) - 1));
_strDP = _arrDPs select _iDP;
_iPayment = daylight_cfg_iDPMaxProfit * ((player distance (getMarkerPos _strDP)) / daylight_cfg_iDPMaxDistance);

if (_iPayment > daylight_cfg_iDPMaxProfit) then {
	_iPayment = daylight_cfg_iDPMaxProfit;
};

_iPayment = (round (_iPayment / 10) * 10);

[format["Deliver this package to delivery point %1, our client is waiting for you.", _iDP + 1]] call daylight_fnc_showActionMsg;

_bToggle = true;
while {daylight_bDeliveryMissionActive} do {
	if (_bToggle) then {
		_strDP setMarkerAlphaLocal 1;
	} else {
		_strDP setMarkerAlphaLocal 0;
	};

	_bToggle = !_bToggle;

	if (((player distance (getMarkerPos _strDP)) <= 7.5) && (vehicle player == player)) then {
		daylight_bDeliveryMissionActive = false;

		[format["Thank you for delivering my package, here is your payment (%1%2).", _iPayment, localize "STR_CURRENCY"]] call daylight_fnc_showActionMsg;

		[daylight_cfg_iInvMoneyID, _iPayment] call daylight_fnc_invAddItemWithWeight;
	};

	if (!alive player) then {
		daylight_bDeliveryMissionActive = false;
	};

	sleep 0.75;
};

if (true) exitWith {};