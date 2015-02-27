scriptName "newGame";
/*--------------------------------------------------------------------
	file: newGame.sqf
	=================
	Author: Bhaz <>
	Description: Prepare vars for new game.
--------------------------------------------------------------------*/
#define __filename "newGame.sqf"
#define PUBLIC(var,value) var = value; publicVariable #var

// Set up the starting position for players.
call compile preprocessFileLineNumbers "server\playerStart.sqf";

// Mission variables and other misc stuff.
PUBLIC(INT_global_crewAvailable,0);		// Number of support crew (groups) available.
PUBLIC(INT_global_campsAvailable,1);	// Number of camps that can be constructed.
PUBLIC(INT_global_tech1,false);			// Tech tier 1.

PUBLIC(INT_global_campExists,false);	// A resistance HQ exists.
PUBLIC(INT_global_camps,[]);			// List of camp positions.
PUBLIC(INT_global_servicePoints,[]);	// List of service point buildings.
PUBLIC(INT_global_recruitmentTents,[]);	// List of recruitment tents.

[paramsArray select 2] call BIS_fnc_paramDaytime;

// Objectives.
"objCamp" call BIS_fnc_missionTasks;
"objLiberate" call BIS_fnc_missionTasks;

// Persistent variables.
private ["_camps"];

waitUntil {!isNil "ALiVE_globalForcePool"};
INT_server_persistentData = [] call CBA_fnc_hashCreate;
[ALiVE_globalForcePool, "missionData", INT_server_persistentData] call ALiVE_fnc_hashSet;

[INT_server_persistentData, "stats", [0,0,0,0,1,false]] call CBA_fnc_hashSet;
[INT_server_persistentData, "camps", [[],[]]] call CBA_fnc_hashSet;
[INT_server_persistentData, "objectives", []] call CBA_fnc_hashSet;

// Reference vars directly to persistent data.
_camps = [INT_server_persistentData, "camps"] call CBA_fnc_hashGet;
INT_server_campData = _camps select 0;
INT_server_servicePointData = _camps select 1;
INT_server_persistentObjectives = [INT_server_persistentData, "objectives"] call CBA_fnc_hashGet;

// Start the objective manager.
["manage"] spawn INT_fnc_objectiveManager;
