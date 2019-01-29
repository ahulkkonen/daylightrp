/*	
	Description: 	Reveals surroundings to player for faster interaction
	Author:			qbt
*/

while {true} do {
	// Get nearest objects
	_arrNearestObjects = nearestObjects [vehicle(player), ["AllVehicles", "ReammoBox"], 15];
	{
		// Reveal each object to player for faster interaction
		player reveal _x;
	} forEach _arrNearestObjects;

	// Sleep and loop again
	sleep 2.5;
};

if (true) exitWith {};