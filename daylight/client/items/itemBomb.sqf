/*
	Description:	Bomb
	Author:			qbt
*/

// If near end mission area
_strNearestMarker = [player, daylight_cfg_arrEndMissionLocationsMarkers] call daylight_fnc_getNearestMarker;

_bEndMissionLocation = false;

if ((player distance (getMarkerPos _strNearestMarker)) <= 40) then {
	_bEndMissionLocation = true;
};

[player, "AmovPercMstpSnonWnonDnon_AinvPknlMstpSnonWnonDnon"] call daylight_fnc_networkPlayMove;

sleep 1;

_vehBomb = createVehicle ["Land_SatellitePhone_F", [0, 0, 0], [], 0, "NONE"];
_vehBomb enableSimulation false;
_vehBomb allowDamage false;

_vehBomb setDir (getDir player);
_vehBomb setPosATL [(player modelToWorld [0, 1, 0]) select 0, (player modelToWorld [0, 1, 0]) select 1, (getPosATL player) select 2];

[_vehBomb, 42, false] call daylight_fnc_networkSay3D;

sleep 17;

_vehExplosion = createVehicle ["Bo_GBU12_LGB", [(getPos _vehBomb) select 0, (getPos _vehBomb) select 1, 0], [], 0, "NONE"];

if (_bEndMissionLocation) then {
	// "Disable" near transformers if not already disabled
	_iCount = count (nearestObjects [_vehBomb, ["test_EmptyObjectForSmoke"], 25]);

	if (_iCount == 0) then {
		{
			_vehVehicle = createVehicle ["test_EmptyObjectForSmoke", [0, 0, 0], [], 0, "NONE"];

			_vehVehicle setPosATL [(getPosATL _x) select 0, (getPosATL _x) select 1, ((getPosATL _x) select 2) + 2.5];
		} forEach (nearestObjects [_vehBomb, ["Land_dp_transformer_F"], 25]);
	};
};

deleteVehicle _vehBomb;

if (true) exitWith {};