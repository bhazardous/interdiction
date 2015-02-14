scriptName "serverInit";
/*--------------------------------------------------------------------
	file: serverInit.sqf
	====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "serverInit.sqf"
#define PUBLIC(var,value) var = value; publicVariable #var

// Set up the starting position for players.
call compile preprocessFileLineNumbers "server\playerStart.sqf";

// Mission variables and other misc stuff.
INT_server_killThreshold = 15;			// Number of OPFOR killed for civilians to join resistance movement.
INT_server_kills = 0;					// Counting OPFOR kills.
INT_server_crewThreshold = 5;			// Reach the kill threshold x times to unlock support crew.
INT_server_crewCounter = 0;				// Keeps track of kill threshold counter for crew.
INT_server_campThreshold = 10;			// Unlocks extra camps.
INT_server_campCounter = 0;				// Keeps track of camp threshold counter.

PUBLIC(INT_global_buildingEnabled,true);// Global toggle for building.
PUBLIC(INT_global_campExists,false);	// A resistance HQ exists.
PUBLIC(INT_global_tech1,false);			// Tech tier 1.
PUBLIC(INT_global_campCount,0);			// Number of resistance camps.
PUBLIC(INT_global_servicePointCount,0);	// Number of service points.
PUBLIC(INT_global_servicePoints,[]);	// List of service point buildings.
PUBLIC(INT_global_recruitmentTentCount,0);	// Number of recruitment tents.
PUBLIC(INT_global_recruitmentTents,[]);	// List of recruitment tents.
PUBLIC(INT_global_crewAvailable,0);		// Number of support crew (groups) available.
PUBLIC(INT_global_campsAvailable,1);	// Number of camps that can be constructed.
PUBLIC(INT_global_camps,[]);			// List of camp positions.

INT_server_servicePointData = [];

// Objectives.
"objCamp" call BIS_fnc_missionTasks;
"objLiberate" call BIS_fnc_missionTasks;

// (TEMPORARY) Random convoy spawner.
[] spawn {
	// Every 10-30 mins.
	while {true} do {
		private ["_sleepTime"];
		_sleepTime = 10 + floor (random (20));
		_sleepTime = _sleepTime * 60;
		sleep _sleepTime;
		[] call INT_fnc_spawnConvoy;
	};
};
