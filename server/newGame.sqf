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
PUBLIC(ITD_global_serviceData,[]);		// Service point data.
PUBLIC(ITD_global_recruitmentTents,[]);	// List of recruitment tents.

[paramsArray select 2] call BIS_fnc_paramDaytime;

// Objectives.
"objCamp" call BIS_fnc_missionTasks;
"objLiberate" call BIS_fnc_missionTasks;

// Persistence arrays.
ITD_server_db_progress = [0,0,0,0,1,false];
ITD_server_db_camps = [];
ITD_server_db_objectives = [];

if (ITD_global_persistence) then {
	// Persistence is enabled, pass references to the db hash.
	["ITD_progress", ITD_server_db_progress] call ALiVE_fnc_setData;
	["ITD_camps", ITD_server_db_camps] call ALiVE_fnc_setData;
	["ITD_objectives", ITD_server_db_objectives] call ALiVE_fnc_setData;
	["ITD_version", 1] call ALiVE_fnc_setData;
};

// Start the objective manager.
["manage"] spawn ITD_fnc_objectiveManager;
