/*
	Description: 	Post office
	Author:			qbt
*/

daylight_bDeliveryMissionActive = false;
daylight_vehCurrentMiscUnits = _this;

_this addAction ["<t color=""#75c2e6"">Take delivery mission</t>", "daylight\client\actions\deliveryMission.sqf", [], 10, true, true, "", "((player distance _target) < 2.5) && (side player == civilian) && !daylight_bActionBusy && !daylight_bDeliveryMissionActive"];