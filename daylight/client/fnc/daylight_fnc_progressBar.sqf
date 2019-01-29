/*
	Description:	Misc CLIENT functions
	Author:			qbt
*/

/*
	Description:	Create progress bar
	Args:			arr [str text, i fadein time]
	Return:			nothing
*/
daylight_fnc_progressBarCreate = {
	if (!daylight_bProgressBarActive) then {
		disableSerialization;

		daylight_bProgressBarActive = true;

		1500 cutRsc ["ProgressBar", "PLAIN", 0.001, false];
		[1, 0] call daylight_fnc_progressBarSetFade;

		_iFadeTime = abs(_this select 1);

		if (_iFadeTime < 0) then {
			_iFadeTime = 0;
		};

		(_this select 0) call daylight_fnc_progressBarSetText;

		[0, _iFadeTime] call daylight_fnc_progressBarSetFade;
	};
};

/*
	Description:	Set progress bar text
	Args:			str text
	Return:			nothing
*/
daylight_fnc_progressBarSetText = {
	if (daylight_bProgressBarActive) then {
		disableSerialization;

		_dDisplay = ((uiNamespace getVariable "daylight_arrRscProgressBar") select 0);
		_cProgressBarText = _dDisplay displayCtrl ((uiNamespace getVariable "daylight_arrRscProgressBar") select 1);

		_cProgressBarText ctrlSetText _this;
	};
};

/*
	Description:	Set progress bar progress
	Args:			arr [i progress (0-1), i commit time]
	Return:			nothing
*/
daylight_fnc_progressBarSetProgress = {
	if (daylight_bProgressBarActive) then {
		disableSerialization;

		_iMultiplier = abs(_this select 0);

		if (_iMultiplier > 1) then {
			_iMultiplier = 1;
		};

		if (_iMultiplier < 0) then {
			_iMultiplier = 0;
		};

		_iCommitTime = abs(_this select 1);

		if (_iCommitTime < 0) then {
			_iCommitTime = 0;
		};

		_dDisplay = ((uiNamespace getVariable "daylight_arrRscProgressBar") select 0);
		_cProgressBarText = _dDisplay displayCtrl ((uiNamespace getVariable "daylight_arrRscProgressBar") select 1);
		_cProgressBarProgress = _dDisplay displayCtrl ((uiNamespace getVariable "daylight_arrRscProgressBar") select 2);
		
		_arrProgressBarPosition = ctrlPosition _cProgressBarProgress;

		_cProgressBarProgress ctrlSetPosition [_arrProgressBarPosition select 0, _arrProgressBarPosition select 1, ((ctrlPosition _cProgressBarText) select 2) * _iMultiplier, _arrProgressBarPosition select 3];
		_cProgressBarProgress ctrlCommit _iCommitTime;
	};
};

/*
	Description:	Close progress bar
	Args:			i fade time
	Return:			nothing
*/
daylight_fnc_progressBarClose = {
	if (daylight_bProgressBarActive) then {
		disableSerialization;

		_iFadeTime = abs _this;

		if (_iFadeTime < 0) then {
			_iFadeTime = 0;
		};

		[1, _iFadeTime] call daylight_fnc_progressBarSetFade;

		_iFadeTime spawn {
			sleep _this;

			daylight_bProgressBarActive = false;

			if (true) exitWith {};
		};
	};
};

/*
	Description:	Set progress bar fade
	Args:			arr [i fade amount, i fade time]
	Return:			nothing
*/
daylight_fnc_progressBarSetFade = {
	if (daylight_bProgressBarActive) then {
		disableSerialization;

		_iFadeAmount = abs(_this select 0);

		if (_iFadeAmount > 1) then {
			_iFadeAmount = 1;
		};

		if (_iFadeAmount < 0) then {
			_iFadeAmount = 0;
		};

		_iFadeTime = abs (_this select 1);

		if (_iFadeTime < 0) then {
			_iFadeTime = 0;
		};

		_dDisplay = ((uiNamespace getVariable "daylight_arrRscProgressBar") select 0);

		_arrControls = [];
		{_arrControls set [count _arrControls, _dDisplay displayCtrl _x]} forEach [1000, 1001, 2200, 2201];

		{
			_x ctrlSetFade _iFadeAmount;

			_x ctrlCommit _iFadeTime;
		} forEach _arrControls;
	};
};