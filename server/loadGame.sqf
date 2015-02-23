scriptName "loadGame";
/*--------------------------------------------------------------------
	file: loadGame.sqf
	==================
	Author: Bhaz <>
	Description:
--------------------------------------------------------------------*/
#define __filename "loadGame.sqf"
#define PUBLIC(var,value) var = value; publicVariable #var

/*
	PERSISTENT DATA ROAD MAP

	"stats" = [
		0 kill count,
		1 support counter (for next unlock),
		2 camp counter (for next unlock),
		3 support crew available,				(global: INT_global_crewAvailable)
		4 additional camps available,			(global: INT_global_campsAvailable)
		5 tech1 available,						(global: INT_global_tech1)
	]
*/

// Retrieve mission data from its piggy back ride.
waitUntil {!isNil "ALiVE_globalForcePool"};
waitUntil {!isNil ([ALiVE_globalForcePool, "missionData"] call ALiVE_fnc_hashGet)};
INT_server_persistentData = [ALiVE_globalForcePool, "missionData"] call ALiVE_fnc_hashGet;

// Look for mission data, and fill in blanks if anything is missing.
private ["_stats"];
_stats = [INT_server_persistentData, "stats"] call CBA_fnc_hashGet;
if (isNil "_stats") then {
	"INTERDICTION: Mission stats not found in persistent data." call BIS_fnc_log;
	[INT_server_persistentData, "stats", [0,0,0,0,1,false]] call CBA_fnc_hashSet;
	_stats = [INT_server_persistentData, "stats"] call CBA_fnc_hashGet;
};

// Broadcast variables that need to be global.
PUBLIC(INT_global_crewAvailable,_stats select 3);
PUBLIC(INT_global_campsAvailable,_stats select 4);
PUBLIC(INT_global_tech1,_stats select 5);

// TODO: Additional persistence, force some defaults for now.
PUBLIC(INT_global_campExists,false);	// A resistance HQ exists.
PUBLIC(INT_global_campCount,0);			// Number of resistance camps.
PUBLIC(INT_global_servicePointCount,0);	// Number of service points.
PUBLIC(INT_global_servicePoints,[]);	// List of service point buildings.
PUBLIC(INT_global_recruitmentTentCount,0);	// Number of recruitment tents.
PUBLIC(INT_global_recruitmentTents,[]);	// List of recruitment tents.
PUBLIC(INT_global_camps,[]);			// List of camp positions.
PUBLIC(INT_global_canJoin,false);

INT_server_campData = [];
INT_server_servicePointData = [];
