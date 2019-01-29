/*
	Description:	Shout functions
	Author:			qbt
*/

daylight_arrShouts = daylight_cfg_arrShouts;
daylight_iLastShoutTime = time;

/*
	Description:	Send shout
	Args:			i index from shouts-array
	Return:			nothing
*/
daylight_fnc_shoutSend = {
	if ((time - daylight_iLastShoutTime) >= daylight_cfg_iShoutTimeBetween) then {
		(daylight_arrShouts select _this) call daylight_fnc_networkShoutSend;

		daylight_iLastShoutTime = time;
	};
};

/*
	Description:	Receive shout
	Args:			arr [veh shouter, str shout]
	Return:			nothing
*/
daylight_fnc_shoutReceive = {
	daylight_iRadioChannelShout radioChannelAdd playableUnits;

	if ((player distance (_this select 0)) <= daylight_cfg_iShoutMaxDistance) then {
		systemChat format[localize "STR_SHOUT", name (_this select 0), (_this select 1)];
	};

	daylight_iRadioChannelShout radioChannelRemove playableUnits;
};

/*
	Description:	Open shout edit UI
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_shoutEditOpenUI = {
	createDialog "EditShouts";

	// List shouts in RscEdit-boxes
	for "_i" from 0 to ((count daylight_arrShouts) - 1) do {
		ctrlSetText [1400 + _i, daylight_arrShouts select _i];
	};
};

/*
	Description:	Save shouts from ShoutEdit dialog to shout array
	Args:			arr [ctrlText 1400-1404]
	Return:			nothing
*/
daylight_fnc_shoutSave = {
	closeDialog 0;

	for "_i" from 0 to ((count _this) - 1) do {
		daylight_arrShouts set [_i, _this select _i];
	};
};