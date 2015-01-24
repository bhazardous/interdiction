scriptName "serverInit";
/*--------------------------------------------------------------------
	file: serverInit.sqf
	====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "serverInit.sqf"
#define PUBLIC(var,value) var = value; publicVariable "var"

// Set up the starting position for players.
call compile preprocessFileLineNumbers "server\playerStart.sqf";

// Mission variables and other misc stuff.
INT_server_killThreshold = 25;			// Number of OPFOR killed for civilians to join resistance movement.
INT_server_kills = 0;					// Counting OPFOR kills.

PUBLIC(INT_global_buildingEnabled,true);
PUBLIC(INT_global_campExists,false);
PUBLIC(INT_global_tech1,false);
INT_server_campCount = 0;				// Number of resistance camps.

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
