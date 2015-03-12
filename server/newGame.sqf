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
PUBLIC(ITD_global_crewAvailable,0);		// Number of support crew (groups) available.
PUBLIC(ITD_global_campsAvailable,1);	// Number of camps that can be constructed.
PUBLIC(ITD_global_tech1,false);			// Tech tier 1.

PUBLIC(ITD_global_campExists,false);	// A resistance HQ exists.
PUBLIC(ITD_global_camps,[]);			// List of camp positions.
PUBLIC(ITD_global_servicePoints,[]);	// List of service point buildings.
PUBLIC(ITD_global_recruitmentTents,[]);	// List of recruitment tents.

[paramsArray select 2] call BIS_fnc_paramDaytime;

// Objectives.
"objCamp" call BIS_fnc_missionTasks;
"objLiberate" call BIS_fnc_missionTasks;

// Persistent variables.
private ["_camps"];

waitUntil {!isNil "ALiVE_globalForcePool"};
ITD_server_persistentData = [];

ITD_server_persistentData set [0, [0,0,0,0,1,false]];
ITD_server_persistentData set [1, [[],[]]];
ITD_server_persistentData set [2, []];

[] call ITD_fnc_updatePersistence;

// Reference vars directly to persistent data.
ITD_server_statData = ITD_server_persistentData select 0;
_camps = ITD_server_persistentData select 1;
ITD_server_campData = _camps select 0;
ITD_server_servicePointData = _camps select 1;
ITD_server_persistentObjectives = ITD_server_persistentData select 2;

// Start the objective manager.
["manage"] spawn ITD_fnc_objectiveManager;
