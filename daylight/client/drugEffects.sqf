/*
	Description:	Drug effects
	Author:			qbt
*/

// Initialize ppEffects
daylight_ppDrugDynamicBlur = ppEffectCreate ["DynamicBlur", 402];
daylight_ppDrugDynamicBlur ppEffectEnable true;

_bWarnedAlcohol = false;
_bWarnedHeroin = false;
_bWarnedAmphetamine = false;
_bWarnedCannabis = false;

_bNotifiedEffectAlcohol = false;
_bNotifiedEffectHeroin = false;
_bNotifiedEffectAmphetamine = false;
_bNotifiedEffectCannabis = false;

// Fatigue fx in another loop that runs more often
[] spawn {
	while {true} do {
		// Fatigue
		if (((daylight_iDrugAlcoholLevel >= 0.75) || (daylight_iDrugCannabisLevel >= 0.5) || (daylight_iDrugHeroinLevel >= 0.5)) && (daylight_iDrugAmphetamineLevel < 0.4)) then {
			player setFatigue ((getFatigue player) + 0.025);
		} else {
			if (daylight_iDrugAmphetamineLevel >= 0.4) then {
				player setFatigue ((getFatigue player) * (0.75 - daylight_iDrugAmphetamineLevel));
			};
		};

		sleep 2.5;
	};
};

while {true} do {
	// Decrease drug effects every loop
	daylight_iDrugAlcoholLevel = daylight_iDrugAlcoholLevel - 0.05;
	daylight_iDrugHeroinLevel = daylight_iDrugHeroinLevel - 0.05;
	daylight_iDrugCannabisLevel = daylight_iDrugCannabisLevel - 0.05;
	daylight_iDrugAmphetamineLevel = daylight_iDrugAmphetamineLevel - 0.025;

	if (daylight_iDrugAlcoholLevel < 0) then {
		daylight_iDrugAlcoholLevel = 0;
	};

	if (daylight_iDrugHeroinLevel < 0) then {
		daylight_iDrugHeroinLevel = 0;
	};

	if (daylight_iDrugCannabisLevel < 0) then {
		daylight_iDrugCannabisLevel = 0;
	};

	if (daylight_iDrugAmphetamineLevel < 0) then {
		daylight_iDrugAmphetamineLevel = 0;
	};

	// Camera shake power
	_iCamShakePowerMax = 40;
	
	_iCamShakePower =
	(_iCamShakePowerMax * daylight_iDrugAlcoholLevel)
	+
	(_iCamShakePowerMax * (daylight_iDrugHeroinLevel / 4))
	+
	(_iCamShakePowerMax * (daylight_iDrugCannabisLevel / 2));

	if (_iCamShakePower > _iCamShakePowerMax) then {
		_iCamShakePower = _iCamShakePowerMax;
	};

	// Camera shake frequency
	_iCamShakeFrequencyMax = 0.2;

	_iCamShakeFrequency =
	(_iCamShakeFrequencyMax * daylight_iDrugAlcoholLevel)
	+
	(_iCamShakeFrequencyMax * (daylight_iDrugHeroinLevel / 4))
	+
	(_iCamShakeFrequencyMax * (daylight_iDrugCannabisLevel / 2));

	if (_iCamShakeFrequency > _iCamShakeFrequencyMax) then {
		_iCamShakeFrequency = _iCamShakeFrequencyMax;
	};

	// Blur
	_iBlurAmountMax = 4;

	_iBlurAmount =
	(_iBlurAmountMax * daylight_iDrugAlcoholLevel)
	+
	(_iBlurAmountMax * (daylight_iDrugHeroinLevel / 5))
	+
	(_iBlurAmountMax * (daylight_iDrugCannabisLevel / 5));

	if (_iBlurAmount > _iBlurAmountMax) then {
		_iBlurAmount = _iBlurAmountMax;
	};

	// Apply fx
	// Dynamic blur
	daylight_ppDrugDynamicBlur ppEffectAdjust [_iBlurAmount];
	daylight_ppDrugDynamicBlur ppEffectCommit 15;

	// Cam shake
	sleep 10;

	resetCamShake;
	addCamShake [_iCamShakePower, 59, _iCamShakeFrequency];

	// Notify about effects
	if (daylight_iDrugAlcoholLevel >= 0.4) then {
		// Alcohol
		if (!_bNotifiedEffectAlcohol) then {
			systemChat "** You feel intense relaxation.";

			_bNotifiedEffectAlcohol = true;
		};
	} else {
		_bNotifiedEffectAlcohol = false;
	};

	if (daylight_iDrugHeroinLevel >= 0.3) then {
		// Heroin
		if (!_bNotifiedEffectHeroin) then {
			systemChat "** You feel intense euphoria and relaxation.";

			_bNotifiedEffectHeroin = true;
		};
	} else {
		_bNotifiedEffectHeroin = false;
	};

	if (daylight_iDrugAmphetamineLevel >= 0.4) then {
		// Amphetamine
		if (!_bNotifiedEffectAmphetamine) then {
			systemChat "** You feel euphoria, extreme focus and no fatigue.";

			_bNotifiedEffectAmphetamine = true;
		};
	} else {
		_bNotifiedEffectAmphetamine = false;
	};

	if (daylight_iDrugCannabisLevel >= 0.3) then {
		// Cannabis
		if (!_bNotifiedEffectCannabis) then {
			systemChat "** You feel relaxed and euphoric and you are starting to get hungry.";

			daylight_iHunger = daylight_iHunger + 0.3;

			if (daylight_iHunger > 1) then {
				daylight_iHunger = 1;
			};

			_bNotifiedEffectCannabis = true;
		};
	} else {
		_bNotifiedEffectCannabis = false;
	};

	// Overdose
	if (daylight_iDrugAlcoholLevel >= 0.8) then {
		// Alcohol overdose
		if (!_bWarnedAlcohol) then {
			systemChat "** Your head is spinning and you feel like you might pass out.";

			_bWarnedAlcohol = true;
		};
	} else {
		_bWarnedAlcohol = false;
	};

	if (daylight_iDrugAlcoholLevel >= 1) then {
		// Alcohol overdose
	};

	if (daylight_iDrugHeroinLevel >= 0.8) then {
		// Heroin overdose warning
		if (!_bWarnedHeroin) then {
			systemChat "** Your breathing very slowly and you feel very sleepy.";

			_bWarnedHeroin = true;
		};
	} else {
		_bWarnedHeroin = false;
	};

	if (daylight_iDrugHeroinLevel >= 1) then {
		// Heroin overdose
	};

	if (daylight_iDrugAmphetamineLevel >= 0.8) then {
		// Amphetamine overdose warning
		if (!_bWarnedAmphetamine) then {
			systemChat "** Your heart is racing and you feel like you might pass out.";

			_bWarnedAmphetamine = true;
		};
	} else {
		_bWarnedAmphetamine = false;
	};

	if (daylight_iDrugAmphetamineLevel >= 1) then {
		// Amphetamine overdose
	};

	if (daylight_iDrugCannabisLevel >= 1) then {
		// Cannabis overdose
		if (!_bWarnedCannabis) then {
			systemChat "** You start to feel sick.";

			_bWarnedCannabis = true;
		};
	} else {
		_bWarnedCannabis = false;
	};

	sleep 50;
};