scriptName "serverInit";
/*--------------------------------------------------------------------
	file: serverInit.sqf
	====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "serverInit.sqf"

// Set up the starting position for players.
call compile preprocessFileLineNumbers "server\playerStart.sqf";

// Mission variables and other misc stuff.
INT_server_killThreshold = 30;			// Number of OPFOR killed for civilians to join resistance movement.
INT_server_kills = 0;					// Counting OPFOR kills.

// Objectives.
"objCamp" call BIS_fnc_missionTasks;
"objLiberate" call BIS_fnc_missionTasks;
