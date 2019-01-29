/*
	Description:	Mobile phone functions
	Author:			qbt
*/

/*
	Description:	Open mobile phone UI
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_mobilePhoneOpenUI = {
	createDialog "MobilePhone";

	// Play sound
	[player, 16, false] call daylight_fnc_networkSay3D;
	playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select 17));

	// Populate player list
	_iX = 0;
	for "_i" from 0 to ((count playableUnits) - 1) do {
		if ((playableUnits select _i) != player) then {
			lbAdd [2100, name((playableUnits select _i))];
			lbSetData [2100, _iX, str _i];

			_iX = _iX + 1;
		};
	};

	if ((lbSize 2100) == 0) then {
		lbAdd [2100, "No players to show"];

		ctrlEnable [1700, false];
	};

	while {(lbCurSel 2100) == -1} do {
		lbSetCurSel [2100, 0];
	};

	// Add options for anonymous and not anonymous sending
	/*lbAdd [2101, "Send with name"]; // TO-DO: Localize
	lbAdd [2101, "Send anonymously"];

	while {(lbCurSel 2101) == -1} do {
		lbSetCurSel [2101, 0];
	};*/

	// Populate messages list
	_arrMessages = profileNamespace getVariable ["daylight_arrMobilePhoneMessages", []];
	_arrMessages = _arrMessages call daylight_fnc_invertArray;

	for "_i" from 0 to ((count _arrMessages) - 1) do {
		lbAdd [1500, format["Message from %1", (_arrMessages select _i) select 0]];

		// Mark read messages with grey
		if (!((_arrMessages select _i) select 2)) then {
			lbSetColor [1500, _i, [0.5, 0.5, 0.5, 0.5]];
		};
	};

	if ((lbSize 1500) > 0) then {
		while {(lbCurSel 1500) == -1} do {
			lbSetCurSel [1500, 0];
		};
	} else {
		ctrlEnable [1701, false];

		lbAdd [1500, "No messages to show."]; // TO-DO: Localize
	};
};

/*
	Description:	Receive message
	Args:			arr [obj sender, str message]
	Return:			nothing
*/
daylight_fnc_mobilePhoneReceiveMessage = {
	// Play sound
	[player, 18, false] call daylight_fnc_networkSay3D;
	playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select 19));

	[localize "STR_PHONE_TITLE", format[localize "STR_PHONE_MESSAGERECEIVED", name (_this select 0)], true] call daylight_fnc_showHint;

	_arrMessages = profileNamespace getVariable ["daylight_arrMobilePhoneMessages", []];
	_arrMessages set [count _arrMessages, [name (_this select 0), _this select 1, true]];

	profileNamespace setVariable ["daylight_arrMobilePhoneMessages", _arrMessages];
	saveProfileNamespace;
};

/*
	Description:	Send message
	Args:			arr [veh to, str message]
	Return:			nothing
*/
daylight_fnc_mobilePhoneSendMessage = {
	if (count (toArray (_this select 1)) != 0) then {
		closeDialog 0;

		[player, (_this select 0), (_this select 1)] call daylight_fnc_networkMobilePhoneSendMessage;
	};
};

/*
	Description:	Read message
	Args:			i index from messages array
	Return:			nothing
*/
daylight_fnc_mobilePhoneReadMessage = {
	_arrMessages = profileNamespace getVariable "daylight_arrMobilePhoneMessages";
	_arrMessages = _arrMessages call daylight_fnc_invertArray;

	[format["Message from %1", (_arrMessages select _this) select 0], (_arrMessages select _this) select 1] call daylight_fnc_showNotificationWindow;

	// Mark as read
	_arrMessages set [_this, [(_arrMessages select _this) select 0, (_arrMessages select _this) select 1, false]];
	profileNamespace setVariable ["daylight_arrMobilePhoneMessages", _arrMessages call daylight_fnc_invertArray];
	saveProfileNamespace;
};