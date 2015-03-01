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

	0 = [
		0 kill count,
		1 support counter (for next unlock),
		2 camp counter (for next unlock),
		3 support crew available,				(global: INT_global_crewAvailable)
		4 additional camps available,			(global: INT_global_campsAvailable)
		5 tech1 available,						(global: INT_global_tech1)
	]

	1 = [
		0 array of camp locations and directions, empty array if building doesn't exist
		[
			[
				campPos,
				campDir,
				[servicePos, serviceDir],
				[recruitPos, recruitDir],
				detected (bool)
			],
			[
				campPos,
				campDir,
				[],
				[]
			]
		],
		1 service point data
	]

	2 = [
		[objectiveName, state]
	]
*/

// Allow players to join while this is all happening.
PUBLIC(INT_global_playerList,[INT_unit_invisibleMan]);
PUBLIC(INT_global_canJoin,false);
PUBLIC(INT_global_campExists,false);

// Retrieve mission data from its piggy back ride.
private ["_data"];

waitUntil {!isNil "ALiVE_globalForcePool"};
waitUntil {!isNil {[ALiVE_globalForcePool, "missionData"] call ALiVE_fnc_hashGet}};
_data = [ALiVE_globalForcePool, "missionData"] call ALiVE_fnc_hashGet;
INT_server_persistentData = _data call compile preprocessFileLineNumbers "server\convertPersistenceData.sqf";

// Look for mission data, and fill in blanks if anything is missing.
private ["_camps"];

// --- Stats
if (count INT_server_persistentData >= 1) then {
	INT_server_statData = INT_server_persistentData select 0;
};

if (isNil "INT_server_statData") then {
	"INTERDICTION: Mission stats not found in persistent data." call BIS_fnc_log;
	INT_server_persistentData set [0, [0,0,0,0,1,false]];
	INT_server_statData = INT_server_persistentData select 0;
};

// --- Camps
if (count INT_server_persistentData >= 2) then {
	_camps = INT_server_persistentData select 1;
};

if (isNil "_camps") then {
	"INTERDICTION: Mission camps not found in persistent data." call BIS_fnc_log;
	INT_server_persistentData set [1, [[],[]]];
	_camps = INT_server_persistentData select 1;
};

// --- Objectives
if (count INT_server_persistentData >= 3) then {
	INT_server_persistentObjectives = INT_server_persistentData select 2;
};

if (isNil "INT_server_persistentObjectives") then {
	"INTERDICTION: Mission objectives not found in persistent data." call BIS_fnc_log;
	INT_server_persistentData set [2, []];
	INT_server_persistentObjectives = INT_server_persistentData select 2;
};

// Server-side variables.
INT_server_campData = _camps select 0;
INT_server_servicePointData = _camps select 1;

// Rebuild camps.
INT_global_camps = [];
INT_global_servicePoints = [];
INT_global_recruitmentTents = [];

private ["_campId"];
_campId = 1;
{
	private ["_pos", "_rot", "_service", "_recruit", "_detected", "_building", "_campMarker"];

	_pos = _x select 0;
	_rot = _x select 1;
	_service = _x select 2;
	_recruit = _x select 3;
	_detected = _x select 4;

	// Spawn camp HQ.
	_building = ["hq", _pos, _rot, false] call INT_fnc_spawnComposition;
	{_x setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];} forEach _building;

	_campMarker = createMarker [format ["INT_mkr_resistanceCamp%1", _campId], _pos];
	_campMarker setMarkerType "b_hq";
	_campMarker setMarkerText "Camp";

	INT_global_camps pushBack _pos;
	[missionNamespace, _pos] call BIS_fnc_addRespawnPosition;

	if (count _service == 2) then {
		_building = ["service", _service select 0, _service select 1, false] call INT_fnc_spawnComposition;
		{_x setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];} forEach _building;
		INT_global_servicePoints pushBack (_service select 0);
	};

	if (count _recruit == 2) then {
		_building = ["recruitment", _recruit select 0, _recruit select 1, false] call INT_fnc_spawnComposition;
		{_x setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];} forEach _building;
		INT_global_recruitmentTents pushBack (_recruit select 0);
	};

	if (!_detected) then {
		private ["_objectiveParams"];
		_objectiveParams = [format ["ResistanceCamp%1", _campId], _pos, 50, "MIL", 30];
		[INT_server_faction_enemy, 150, _objectiveParams, _campId - 1] call INT_fnc_triggerOpcomObjective;
	};

	_campId = _campId + 1;
} forEach INT_server_campData;

// Set objective states.
waitUntil {!isNil "INT_server_objectivesLoaded"};
{
	switch (_x select 1) do {
		case 1:	{	// STATUS_FRIENDLY
			["setState", [_x select 0, 1]] call INT_fnc_objectiveManager;
			["triggerObjective", [_x select 0, true]] call INT_fnc_objectiveManager;
		};

		case 3: {	// STATUS_DESTROYED
			["forceDestroy", [_x select 0]] call INT_fnc_objectiveManager;
		};
	};
} forEach INT_server_persistentObjectives;

// Broadcast variables that need to be global.
publicVariable "INT_global_camps";
publicVariable "INT_global_servicePoints";
publicVariable "INT_global_recruitmentTents";

PUBLIC(INT_global_crewAvailable,INT_server_statData select 3);
PUBLIC(INT_global_campsAvailable,INT_server_statData select 4);
PUBLIC(INT_global_tech1,INT_server_statData select 5);

if (count INT_server_campData > 0) then {
	PUBLIC(INT_global_campExists,true);
};

[] call INT_fnc_updatePersistence;

// Start the objective manager.
["manage"] spawn INT_fnc_objectiveManager;

[["ResistanceMovement","MissionPersistence","LoadedSave"]] call INT_fnc_broadcastHint;
