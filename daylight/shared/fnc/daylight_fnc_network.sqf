/*	
	Description: 	SHARED network functions for Daylight
	Author:			qbt
*/

// Initialize PV's and PVEH's
daylight_arrPVLockVehicle = [];
daylight_arrPVSay3D = [];
daylight_arrPVBankTransfer = [];
daylight_arrPVBodySearchDo = [];
daylight_arrPVBodySearchReturn = [];
daylight_arrPVRestrain = [];
daylight_arrPVTicket = [];
daylight_arrPVTicketReturn = [];
daylight_arrPVSwitchMove = [];
daylight_arrPVPlayMove = [];
daylight_arrPVEnableSimulation = [];
daylight_arrPVRemoveIllegalItems = [];
daylight_arrPVJailPlayer = [];
daylight_arrPVAllowDamage = [];
daylight_arrPVShoutSend = [];
daylight_arrPVMobilePhoneMessage = [];
daylight_arrPVEffectFire = [];
daylight_arrPVEffectSmoke = [];
daylight_arrPVDropItem = [];
daylight_arrPVDropItemDeleteObject = [];
daylight_arrPVGiveItem = [];
daylight_arrPVGiveKeys = [];
daylight_arrPVDestroyKey = [];
daylight_arrPVGlobalMessage = [];
daylight_arrPVSetFlagTexture = [];
daylight_arrPVCaptureGangArea = [];
daylight_objPVRevealGlobal = [];
daylight_arrPVChatNotificationNear = [];
daylight_arrPVChatNotification = [];
daylight_strPVVoteForPresident = "";
daylight_arrPVBountyAddItemSold = [];
daylight_iPVAddSoldItemsBounty = [];
daylight_vehPVFreezeToggle = objNull;
daylight_arrPVWarnPlayer = [];

"daylight_arrPVLockVehicle" addPublicVariableEventHandler {
	((_this select 1) select 0) lock ((_this select 1) select 1);

	if ((vehicle player) == ((_this select 1) select 0)) then {
		if (((_this select 1) select 1) == 0) then {
			playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select 15));
		} else {
			playSound ((getArray (missionConfigFile >> "CfgSounds" >> "sounds") select 14));
		};
	};

	if (true) exitWith {};
};

"daylight_arrPVSay3D" addPublicVariableEventHandler {
	((_this select 1) select 0) say3D (getArray (missionConfigFile >> "CfgSounds" >> "sounds") select ((_this select 1) select 1));

	if (true) exitWith {};
};

"daylight_arrPVBodySearchDo" addPublicVariableEventHandler {
	if (((_this select 1) select 1) == player) then {
		((_this select 1) select 0) call daylight_fnc_networkBodySearchReturn;

		// Introduce self to officer, as the officer can already see name from body search
		//((_this select 1) select 1) call daylight_fnc_interactionIntroduceSelf;
	};

	if (true) exitWith {};
};

"daylight_arrPVBodySearchReturn" addPublicVariableEventHandler {
	if (((_this select 1) select 0) == player) then {
		[(_this select 1) select 1, (_this select 1) select 2] call daylight_fnc_interactionBodySearchReturn;
	};

	if (true) exitWith {};
};

"daylight_arrPVRestrain" addPublicVariableEventHandler {
	if (((_this select 1) select 1) == player) then {
		((_this select 1) select 0) spawn daylight_fnc_interactionRestrainToggle;
	};

	if (true) exitWith {};
};

"daylight_arrPVTicket" addPublicVariableEventHandler {
	if (((_this select 1) select 1) == player) then {
		[(_this select 1) select 0, (_this select 1) select 2, (_this select 1) select 3] call daylight_fnc_interactionOpenPayTicketUI;
	};

	if (true) exitWith {};
};

"daylight_arrPVTicketReturn" addPublicVariableEventHandler {
	if (((_this select 1) select 1) == player) then {
		(_this select 1) call daylight_fnc_interactionHandleTicketResponse;
	};

	// Add cash to cops
};

"daylight_arrPVSwitchMove" addPublicVariableEventHandler {
	((_this select 1) select 0) switchMove ((_this select 1) select 1);

	if (true) exitWith {};
};

"daylight_arrPVPlayMove" addPublicVariableEventHandler {
	((_this select 1) select 0) playMoveNow ((_this select 1) select 1);

	if (true) exitWith {};
};

"daylight_arrPVEnableSimulation" addPublicVariableEventHandler {
	((_this select 1) select 0) enableSimulation ((_this select 1) select 1);

	if (true) exitWith {};
};

"daylight_arrPVRemoveIllegalItems" addPublicVariableEventHandler {
	if (((_this select 1) select 1) == player) then {
		((_this select 1) select 0) call daylight_fnc_interactionRemoveIllegalItemsLocal;
	};

	if (true) exitWith {};
};

"daylight_arrPVJailPlayer" addPublicVariableEventHandler {
	if (((_this select 1) select 1) == player) then {
		[((_this select 1) select 0), ((_this select 1) select 2)] call daylight_fnc_jailJailPlayerLocal;
	};
};

"daylight_arrPVAllowDamage" addPublicVariableEventHandler {
	((_this select 1) select 0) allowDamage ((_this select 1) select 1);

	if (true) exitWith {};
};

"daylight_arrPVShoutSend" addPublicVariableEventHandler {
	(_this select 1) call daylight_fnc_shoutReceive;

	if (true) exitWith {};
};

"daylight_arrPVMobilePhoneMessage" addPublicVariableEventHandler {
	if (((_this select 1) select 1) == player) then {
		[(_this select 1) select 0, (_this select 1) select 2] call daylight_fnc_mobilePhoneReceiveMessage;
	};

	if (true) exitWith {};
};

"daylight_arrPVEffectFire" addPublicVariableEventHandler {
	(_this select 1) call daylight_fnc_createEffectFire;

	if (true) exitWith {};
};

"daylight_arrPVEffectSmoke" addPublicVariableEventHandler {
	(_this select 1) call daylight_fnc_createEffectSmoke;

	if (true) exitWith {};
};

"daylight_arrPVBankTransfer" addPublicVariableEventHandler {
	if (((_this select 1) select 0) == player) then {
		[(_this select 1) select 1, (_this select 1) select 2] call daylight_fnc_bankTransferReceive;
	};

	if (true) exitWith {};
};

"daylight_arrPVDropItem" addPublicVariableEventHandler {
	(_this select 1) call daylight_fnc_dropItemCreateObject;

	if (true) exitWith {};
};

"daylight_arrPVDropItemDeleteObject" addPublicVariableEventHandler {
	(_this select 1) call daylight_fnc_dropItemDeleteObject;

	if (true) exitWith {};
};

"daylight_arrPVGiveItem" addPublicVariableEventHandler {
	if (((_this select 1) select 0) == player) then {
		[(_this select 1) select 1, (_this select 1) select 2, (_this select 1) select 3, (_this select 1) select 4] spawn daylight_fnc_receiveItem;
	};

	if (true) exitWith {};
};

"daylight_arrPVGiveKeys" addPublicVariableEventHandler {
	if (((_this select 1) select 0) == player) then {
		[(_this select 1) select 1, (_this select 1) select 2] call daylight_fnc_keychainReceiveKey;
	};

	if (true) exitWith {};
};

"daylight_arrPVDestroyKey" addPublicVariableEventHandler {
	(_this select 1) call daylight_fnc_keychainInformPlayersOfKeyDestruction;

	if (true) exitWith {};
};

"daylight_arrPVGlobalMessage" addPublicVariableEventHandler {
	(_this select 1) call daylight_fnc_globalMessage;

	if (true) exitWith {};
};

"daylight_arrPVSetFlagTexture" addPublicVariableEventHandler {
	((_this select 1) select 0) setFlagTexture ((_this select 1) select 1);

	if (true) exitWith {};
};

"daylight_arrPVCaptureGangArea" addPublicVariableEventHandler {
	(_this select 1) call daylight_fnc_gangsCaptureNotification;

	if (true) exitWith {};
};

"daylight_objPVRevealGlobal" addPublicVariableEventHandler {
	player reveal (_this select 1);

	if (true) exitWith {};
};

"daylight_arrPVChatNotificationNear" addPublicVariableEventHandler {
	if ((player distance ((_this select 1) select 0)) <= daylight_cfg_iChatNotificationMaxDistance) then {
		systemChat format["** %1", (_this select 1) select 1];
	};

	if (true) exitWith {};
};

"daylight_arrPVChatNotification" addPublicVariableEventHandler {
	systemChat format["** %1", _this select 1];

	if (true) exitWith {};
};

"daylight_arrPresidentInfo" addPublicVariableEventHandler {
	//_vehUnit = ((_this select 1) select 0) call daylight_fnc_playerUIDtoPlayerObject;
	_strName = ((_this select 1) select 1);

	//if (!(isNull _vehUnit)) then {
		systemChat format["** %1 has been elected as the new president of Altis. Next voting will start in %2 minutes.", _strName, (daylight_iPresidentRulingTime call daylight_fnc_secondsToMinutesAndSeconds) select 0];
	//};

	if ((name player) == _strName) then {
		systemChat "** You are now the president of Altis, you can use the president menu by pressing F1!"
	};

	daylight_bPresidentVoted = false;
	daylight_iPresidentRulingTimeStarted = time;

	if (true) exitWith {};
};

"daylight_strPVVoteForPresident" addPublicVariableEventHandler {
	(_this select 1) call daylight_fnc_presidentAddVoteServer;

	if (true) exitWith {};
};

"daylight_arrCustomLaws" addPublicVariableEventHandler {
	systemChat "** Laws have been updated by the president of Altis. Check the new laws in the status menu.";

	if (true) exitWith {};
};

"daylight_iPresidentTax" addPublicVariableEventHandler {
	systemChat format["** General tax level have been updated by the president of Altis to %1%2.", round((_this select 1) * 100), "%"];

	if (true) exitWith {};
};

"daylight_arrPVBountyAddItemSold" addPublicVariableEventHandler {
	if (isServer) then {
		(_this select 1) call daylight_fnc_shopAutoBountyAddSoldItemServer;
	};

	if (true) exitWith {};
};

"daylight_iPVAddSoldItemsBounty" addPublicVariableEventHandler {
	if (isServer) then {
		(_this select 1) spawn daylight_fnc_shopAutoBountyAddSoldItemsBountyServer;
	};

	if (true) exitWith {};
};

"daylight_vehPVFreezeToggle" addPublicVariableEventHandler {
	if ((_this select 1) == player) then {
		call daylight_fnc_adminMenuFreezeToggleLocal;
	};

	if (true) exitWith {};
};


"daylight_arrPVWarnPlayer" addPublicVariableEventHandler {
	if (((_this select 1) select 0) == player) then {
		((_this select 1) select 1) spawn daylight_fnc_adminMenuWarnPlayerLocal;
	};

	if (true) exitWith {};
};

/*
	Description:	Exec code for clients + server
	Args:			arr [any args, code code]
	Return:			nothing
*/
/*daylight_fnc_networkExecGlobal = {
	daylight_arrPVExecGlobal = _this;
	publicVariable "daylight_arrPVExecGlobal";

	(_this select 0) call (_this select 1);
};*/

/*
	Description:	Exec code for server
	Args:			arr [any args, code code]
	Return:			nothing
*/
/*daylight_fnc_networkExecServer = {
	daylight_arrPVExecServer = _this;
	publicVariable "daylight_arrPVExecServer";

	if (isServer) then {
		(_this select 0) call (_this select 1);
	};
};*/

/*
	Description:	Exec code for clients
	Args:			arr [any args, code code]
	Return:			nothing
*/
/*daylight_fnc_networkExecClient = {
	daylight_arrPVExecClient = _this;
	publicVariable "daylight_arrPVExecClient";

	if (!isDedicated) then {
		(_this select 0) call (_this select 1);
	};
};*/

/*
	Description:	Exec code for specific client
	Args:			arr [any args, code code]
	Return:			nothing
*/
/*daylight_fnc_networkExecPlayer = {
	daylight_arrPVExecPlayer = _this;
	publicVariable "daylight_arrPVExecPlayer";

	if ((_this select 0) == player) then {
		(_this select 1) call (_this select 2);
	};
};*/

/*
	Description:	Broadcasted vehicle lock/unlock
	Args:			arr [veh vehicle, int locked-status]
	Return:			nothing
*/
daylight_fnc_networkLockVehicle = {
	daylight_arrPVLockVehicle = _this;
	publicVariable "daylight_arrPVLockVehicle";

	(_this select 0) lock (_this select 1);
};

/*
	Description:	Broadcast say3D-command
	Args:			arr [veh source, str ClassName]
	Return:			nothing
*/
daylight_fnc_networkSay3D = {
	daylight_arrPVSay3D = _this;
	publicVariable "daylight_arrPVSay3D";

	if (!(_this select 2)) then {
		(_this select 0) say3D (getArray (missionConfigFile >> "CfgSounds" >> "sounds") select (_this select 1));
	};
};

/*
	Description:	Make bank transfer
	Args:			arr [veh receiver, veh sender, i amount]
	Return:			nothing
*/
daylight_fnc_networkMakeBankTransfer = {
	daylight_arrPVBankTransfer = _this;
	publicVariable "daylight_arrPVBankTransfer";
};

/*
	Description:	Body search DO
	Args:			veh player to search
	Return:			nothing
*/
daylight_fnc_networkBodySearchDo = {
	daylight_arrPVBodySearchDo = [player, _this];

	publicVariable "daylight_arrPVBodySearchDo";
};

/*
	Description:	Body search SEND to DOer after DO
	Args:			veh doer
	Return:			nothing
*/
daylight_fnc_networkBodySearchReturn = {
	daylight_arrPVBodySearchReturn = [_this, player, daylight_arrInventory];

	publicVariable "daylight_arrPVBodySearchReturn";
};

/*
	Description:	Restrain
	Args:			veh player to restrain
	Return:			nothing
*/
daylight_fnc_networkRestrainPlayer = {
	daylight_arrPVRestrain = [player, _this];

	publicVariable "daylight_arrPVRestrain";
};

/*
	Description:	Give ticket
	Args:			arr [veh player to give ticket to, i amount, str reason]
	Return:			nothing
*/
daylight_fnc_networkGiveTicket = {
	_iAmount = (_this select 1);
	if (_iAmount > daylight_cfg_iMaxIntValue) then {
		_iAmount = daylight_cfg_iMaxIntValue;
	};

	if (_iAmount != 0) then {
		daylight_iCurrentTicketAmount = _iAmount;

		daylight_arrPVTicket = [player, _this select 0, _iAmount, _this select 2];
		publicVariable "daylight_arrPVTicket";
	};
};

/*
	Description:	Give ticket
	Args:			arr [veh player to give ticket response to, b pay]
	Return:			nothing
*/
daylight_fnc_networkReturnTicket = {
	daylight_arrPVTicketReturn = [player, _this select 0, _this select 1];
	publicVariable "daylight_arrPVTicketReturn";
};

/*
	Description:	Switch move
	Args:			arr [veh to animate, str animation]
	Return:			nothing
*/
daylight_fnc_networkSwitchMove = {
	daylight_arrPVSwitchMove = _this;
	publicVariable "daylight_arrPVSwitchMove";

	(_this select 0) switchMove (_this select 1);
};

/*
	Description:	Play move
	Args:			arr [veh to animate, str animation]
	Return:			nothing
*/
daylight_fnc_networkPlayMove = {
	daylight_arrPVPlayMove = _this;
	publicVariable "daylight_arrPVPlayMove";

	(_this select 0) playMoveNow (_this select 1);
};

/*
	Description:	Enable/disable simulation
	Args:			arr [veh to disable/enable simulation from, b enabled]
	Return:			nothing
*/
daylight_fnc_networkEnableSimulation = {
	daylight_arrPVEnableSimulation = _this;
	publicVariable "daylight_arrPVEnableSimulation";

	(_this select 0) enableSimulation (_this select 1);
};

/*
	Description:	Remove illegal items
	Args:			veh from
	Return:			nothing
*/
daylight_fnc_networkRemoveIllegalItems = {
	daylight_arrPVRemoveIllegalItems = [player, _this];
	publicVariable "daylight_arrPVRemoveIllegalItems";
};

/*
	Description:	Jail player
	Args:			arr [veh to jail, i time]
	Return:			nothing
*/
daylight_fnc_networkJailPlayer = {
	daylight_arrPVJailPlayer = [player, _this select 0, _this select 1];
	publicVariable "daylight_arrPVJailPlayer";
};

/*
	Description:	Global allowDamage
	Args:			arr [veh vehicle, b allowDamage]
	Return:			nothing
*/
daylight_fnc_networkAllowDamage = {
	daylight_arrPVAllowDamage = _this;
	publicVariable "daylight_arrPVAllowDamage";
};

/*
	Description:	Send shout
	Args:			str shout text
	Return:			nothing
*/
daylight_fnc_networkShoutSend = {
	daylight_arrPVShoutSend = [player, _this];
	publicVariable "daylight_arrPVShoutSend";

	daylight_arrPVShoutSend call daylight_fnc_shoutReceive;
};

/*
	Description:	Send mobile phone message
	Args:			arr [veh sender, veh target, str name, str message]
	Return:			nothing
*/
daylight_fnc_networkMobilePhoneSendMessage = {
	daylight_arrPVMobilePhoneMessage = _this;
	publicVariable "daylight_arrPVMobilePhoneMessage";
};

/*
	Description:	Fire effect
	Args:			arr daylight_fnc_createEffectFire params
	Return:			nothing
*/
daylight_fnc_networkEffectFire = {
	daylight_arrPVEffectFire = _this;
	publicVariable "daylight_arrPVEffectFire";

	_this call daylight_fnc_createEffectFire;
};

/*
	Description:	Fire effect
	Args:			arr daylight_fnc_createEffectSmoke params
	Return:			nothing
*/
daylight_fnc_networkEffectSmoke = {
	daylight_arrPVEffectSmoke = _this;
	publicVariable "daylight_arrPVEffectSmoke";

	_this call daylight_fnc_createEffectSmoke;
};

/*
	Description:	Drop item
	Args:			arr [_strClassname, _arrPos, _iItemID, _iDropAmount]
	Return:			nothing
*/
daylight_fnc_networkDropItem = {
	daylight_arrPVDropItem = _this;
	publicVariable "daylight_arrPVDropItem";

	_this call daylight_fnc_dropItemCreateObject;
};

/*
	Description:	Delete dropped item
	Args:			arr [_strClassname, _arrPos, _iItemID, _iDropAmount]
	Return:			nothing
*/
daylight_fnc_networkDropItemDeleteObject = {
	daylight_arrPVDropItemDeleteObject = _this;
	publicVariable "daylight_arrPVDropItemDeleteObject";
};

/*
	Description:	Give item
	Args:			arr [_strClassname, _arrPos, _iItemID, _iDropAmount]
	Return:			nothing
*/
daylight_fnc_networkGiveItem = {
	daylight_arrPVGiveItem = _this;
	publicVariable "daylight_arrPVGiveItem";
};

/*
	Description:	Give keys
	Args:			arr [obj receiver, obj sender, veh vehicle]
	Return:			nothing
*/
daylight_fnc_networkGiveKeys = {
	daylight_arrPVGiveKeys = _this;
	publicVariable "daylight_arrPVGiveKeys";
};

/*
	Description:	Remove keys
	Args:			arr [obj remover, veh vehicle]
	Return:			nothing
*/
daylight_fnc_networkDestroyKey = {
	daylight_arrPVDestroyKey = _this;
	publicVariable "daylight_arrPVDestroyKey";

	_this call daylight_fnc_keychainInformPlayersOfKeyDestruction;
};

/*
	Description:	Global message
	Args:			str message
	Return:			nothing
*/
daylight_fnc_networkGlobalMessage = {
	daylight_arrPVGlobalMessage = _this;
	publicVariable "daylight_arrPVGlobalMessage";

	_this call daylight_fnc_globalMessage;
};

/*
	Description:	Set flag texture
	Args:			arr [obj flag, str texture]
	Return:			nothing
*/
daylight_fnc_networkSetFlagTexture = {
	daylight_arrPVSetFlagTexture = _this;
	publicVariable "daylight_arrPVSetFlagTexture";

	(_this select 0) setFlagTexture (_this select 1);
};

/*
	Description:	Capture gang area
	Args:			arr [str gang, str old gang, i number]
	Return:			nothing
*/
daylight_fnc_networkCaptureGangArea = {
	daylight_arrPVCaptureGangArea = _this;
	publicVariable "daylight_arrPVCaptureGangArea";

	_this call daylight_fnc_gangsCaptureNotification
};

/*
	Description:	Reveal global
	Args:			obj to reveal
	Return:			nothing
*/
daylight_fnc_networkRevealGlobal = {
	daylight_objPVRevealGlobal = _this;
	publicVariable "daylight_objPVRevealGlobal";

	player reveal _this;
};

/*
	Description:	Chat notification (near)
	Args:			arr [obj from, str text]
	Return:			nothing
*/
daylight_fnc_networkChatNotificationNear = {
	daylight_arrPVChatNotificationNear = _this;
	publicVariable "daylight_arrPVChatNotificationNear";

	systemChat format ["** %1", _this select 1];
};

/*
	Description:	Chat notification
	Args:			str text
	Return:			nothing
*/
daylight_fnc_networkChatNotification = {
	daylight_arrPVChatNotification = _this;
	publicVariable "daylight_arrPVChatNotification";

	systemChat format ["** %1", _this];
};

/*
	Description:	Vote for president
	Args:			str UID
	Return:			nothing
*/
daylight_fnc_networkVoteForPresident = {
	daylight_strPVVoteForPresident = _this;
	publicVariableServer "daylight_strPVVoteForPresident";
};

/*
	Description:	Add sold item
	Args:			arr [i current merchant, arr [i itemid, i amount], str uid]
	Return:			nothing
*/
daylight_fnc_networkBountyAddSold = {
	daylight_arrPVBountyAddItemSold = _this;
	publicVariableServer "daylight_arrPVBountyAddItemSold";
};

/*
	Description:	Add bounty for sold items
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_networkAddSoldItemsBounty = {
	daylight_iPVAddSoldItemsBounty = _this;
	publicVariableServer "daylight_iPVAddSoldItemsBounty";
};

/*
	Description:	Add bounty for sold items
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_networkFreezePlayerToggle = {
	daylight_vehPVFreezeToggle = _this;
	publicVariable "daylight_vehPVFreezeToggle";

	_iFrozen = daylight_vehAdminMenuTarget getVariable ["daylight_iFrozen", 0];

	if (_iFrozen == 0) then {
		daylight_vehAdminMenuTarget setVariable ["daylight_iFrozen", 1, false];

		systemChat format["** You have freezed %1.", name daylight_vehAdminMenuTarget];
	} else {
		daylight_vehAdminMenuTarget setVariable ["daylight_iFrozen", 0, false];

		systemChat format["** You have unfreezed %1.", name daylight_vehAdminMenuTarget];
	};
};

/*
	Description:	Warn player
	Args:			nothing
	Return:			nothing
*/
daylight_fnc_networkWarnPlayer = {
	daylight_arrPVWarnPlayer = [daylight_vehAdminMenuTarget, _this];
	publicVariable "daylight_arrPVWarnPlayer";

	systemChat format["** You warned %1 for %2.", name daylight_vehAdminMenuTarget, _this];
};

/*
	Description:	Handle player state
	Args:			arr [veh player, [i hands up, i restrained, i jailed]]
	Return:			nothing

	Notes:			-1 as input will not change current value
*/
daylight_fnc_handlePlayerState = {
	_arrOutput = [];

	for "_i" from 0 to ((count(_this select 1)) - 1) do {
		_iValue = (_this select 1) select _i;
		if (((_this select 1) select _i) == -1) then {
			_iValue = ((_this select 0) getVariable "daylight_arrState") select _i;
		};

		_arrOutput set [_i, _iValue];
	};

	(_this select 0) setVariable ["daylight_arrState", _arrOutput, true];
};