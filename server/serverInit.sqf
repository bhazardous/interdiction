scriptName "serverInit";
/*--------------------------------------------------------------------
	file: serverInit.sqf
	====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "serverInit.sqf"
#define PUBLIC(var,value) var = value; publicVariable #var

// If using persistence, determine if this is a new game or loading from DB.
INT_server_newGame = true;
if (INT_server_persistence) then {
	waitUntil {!isNil "ALiVE_sys_data_dictionaryLoaded"};
	if (ALiVE_sys_data_dictionaryLoaded) then {
		INT_server_newGame = false;
	};
};

// General mission variables.
INT_server_killThreshold = 15;			// Number of OPFOR killed for civilians to join resistance movement.
INT_server_crewThreshold = 5;			// Reach the kill threshold x times to unlock support crew.
INT_server_campThreshold = 10;			// Unlocks extra camps.

PUBLIC(INT_global_buildingEnabled,true);// Global toggle for building.

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

if (INT_server_newGame) then {
	// Set up the starting position for players.
	call compile preprocessFileLineNumbers "server\playerStart.sqf";

	// Mission variables and other misc stuff.
	PUBLIC(INT_global_crewAvailable,0);		// Number of support crew (groups) available.
	PUBLIC(INT_global_campsAvailable,1);	// Number of camps that can be constructed.
	PUBLIC(INT_global_tech1,false);			// Tech tier 1.

	PUBLIC(INT_global_campExists,false);	// A resistance HQ exists.
	PUBLIC(INT_global_campCount,0);			// Number of resistance camps.
	PUBLIC(INT_global_servicePointCount,0);	// Number of service points.
	PUBLIC(INT_global_servicePoints,[]);	// List of service point buildings.
	PUBLIC(INT_global_recruitmentTentCount,0);	// Number of recruitment tents.
	PUBLIC(INT_global_recruitmentTents,[]);	// List of recruitment tents.
	PUBLIC(INT_global_camps,[]);			// List of camp positions.

	INT_server_campData = [];
	INT_server_servicePointData = [];

	// Objectives.
	"objCamp" call BIS_fnc_missionTasks;
	"objLiberate" call BIS_fnc_missionTasks;

	// Persistent variables.
	waitUntil {!isNil "ALiVE_globalForcePool"};
	INT_server_persistentData = [] call CBA_fnc_hashCreate;
	[ALiVE_globalForcePool, "missionData", INT_server_persistentData] call ALiVE_fnc_hashSet;

	[INT_server_persistentData, "stats", [0,0,0,0,1,false]] call CBA_fnc_hashSet;
} else {
	call compile preprocessFileLineNumbers "server\loadGame.sqf";
};
