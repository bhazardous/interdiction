scriptName "loadGame";
/*--------------------------------------------------------------------
	file: loadGame.sqf
	==================
	Author: Bhaz <>
	Description:
--------------------------------------------------------------------*/
#define __filename "loadGame.sqf"

// Retrieve mission data from its piggy back ride.
waitUntil {!isNil "ALiVE_globalForcePool"};
waitUntil {!isNil ([ALiVE_globalForcePool, "missionData"] call ALiVE_fnc_hashGet)};
INT_server_persistentData = [ALiVE_globalForcePool, "missionData"] call ALiVE_fnc_hashGet;
