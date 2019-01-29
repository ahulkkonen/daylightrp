/*
	Description:	Time and weather sync
	Author:			qbt
*/

if ((isNil "daylight_arrDate") && (isNil "daylight_iFog")) then {
	daylight_arrDate = [];
	daylight_iFog = -1;
};

daylight_fnc_timeAndWeatherSyncServer = {
	daylight_arrDate = (daylight_cfg_arrDateAndWeatherCycle select 0) select 0;

	_iNextSkipTime = -1;
	_iIndex = 0;

	_bWindSet = false;

	while {true} do {
		_arrDateCurrent = daylight_cfg_arrDateAndWeatherCycle select _iIndex;

		if ((time - _iNextSkipTime) >= _iNextSkipTime) then {
			_arrDate = (_arrDateCurrent select 0);

			_iOvercastMin = ((_arrDateCurrent select 3) select 0) select 0;
			_iOvercastRandom = ((_arrDateCurrent select 3) select 0) select 1;
			_iOvercast = (_iOvercastMin + (random _iOvercastRandom));

			_iFogMin = ((_arrDateCurrent select 3) select 1) select 0;
			_iFogRandom = ((_arrDateCurrent select 3) select 1) select 1;
			_iFog = 0;

			daylight_arrDate = (_arrDateCurrent select 0);
			setDate daylight_arrDate;

			0 setOvercast _iOvercast;
			forceWeatherChange;
			simulWeatherSync;

			if (overcast >= 0.6) then {
				_iFog = _iFogRandom * (0.75 + (random 0.25));
			} else {
				_iFog = (_iFogMin + (random _iFogRandom)) * 0.5;
			};

			0 setFog [_iFog, 0.075, 0];

			daylight_iFog = _iFog;
			publicVariable "daylight_iFog";

			_iNextSkipTime = ((_arrDateCurrent select 1) * 3600);

			_bWindSet = false;

			_iIndex = _iIndex + 1;

			if (_iIndex > ((count daylight_cfg_arrDateAndWeatherCycle) - 1)) then {
				_iIndex = 0;
			};

			publicVariable "daylight_arrDate";
		} else {
			if (_arrDateCurrent select 2) then {
				daylight_arrDate = (_arrDateCurrent select 0);

				setDate daylight_arrDate;

				publicVariable "daylight_arrDate";
			};
		};

		if ((overcast >= 0.6) && _bWindSet) then {
			setWind [(wind select 0) * 2.5, (wind select 1) * 2.5, true];

			_bWindSet = true;
		};

		sleep 60;
	};
};

daylight_fnc_timeAndWeatherSyncClient = {
	// Initial time & weather sync
	waitUntil {(count daylight_arrDate) != 0};
	setDate daylight_arrDate;

	waitUntil {!(isNil "daylight_fnc_setDefaultColorCorrection") && !(isNil "daylight_fnc_setWeatherColorCorrection")};
	call daylight_fnc_setDefaultColorCorrection;
	call daylight_fnc_setWeatherColorCorrection;

	daylight_bWeatherAndTimeSynced = true;

	waitUntil {daylight_iFog != -1};
	0 setFog [daylight_iFog, 0.075, 0];

	_arrLastTime = daylight_arrDate;
	_iLastFog = daylight_iFog;

	while {true} do {
		if (!(_arrLastTime isEqualTo daylight_arrDate)) then {
			setDate daylight_arrDate;

			call daylight_fnc_setDefaultColorCorrection;
			call daylight_fnc_setWeatherColorCorrection;

			_arrLastTime = daylight_arrDate;
		};

		if (!(_iLastFog isEqualTo daylight_iFog)) then {
			0 setFog [daylight_iFog, 0.075, 0];

			_iLastFog = daylight_iFog;
		};

		sleep 1;
	};
};

if (isDedicated) then {
	[] spawn daylight_fnc_timeAndWeatherSyncServer
} else {
	if (isServer) then {
		[] spawn daylight_fnc_timeAndWeatherSyncServer;
	};

	[] spawn daylight_fnc_timeAndWeatherSyncClient;
};