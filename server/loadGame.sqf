scriptName "loadGame";
/*--------------------------------------------------------------------
	file: loadGame.sqf
	==================
	Author: Bhaz <>
	Description:
--------------------------------------------------------------------*/
#define __filename "loadGame.sqf"
#define PUBLIC(var,value) var = value; publicVariable #var

/* -------------------------------------------------------
	PERSISTENT DATA ROAD MAP

	ITD_version - current version of save data

	ITD_progress - array of general mission vars
		0 - kill count,
		1 - support counter (for next unlock),
		2 - camp counter (for next unlock),
		3 - support crew available,				(global: ITD_global_crewAvailable)
		4 - additional camps available,			(global: ITD_global_campsAvailable)
		5 - tech1 available,					(global: ITD_global_tech1)

	ITD_camps - array of camp locations, one entry per camp
		0 - building array:
			0 - HQ position
			1 - HQ direction
			2 - detected by enemy (bool)
			3 - [service position, service direction, [serviceData]]
			4 - [recruit position, recruit direction]

	ITD_objectives - forEach array containing state of all objectives
		0 - objective name
		1 - objective state (integer)
------------------------------------------------------- */


/* -------------------------------------------------------
	PERSISTENT DATA CHANGE LOG

	v1
		- Service point data merged with camps array
------------------------------------------------------- */

// Allow players to join while this is all happening.
PUBLIC(ITD_global_playerList,[ITD_unit_invisibleMan]);
PUBLIC(ITD_global_canJoin,false);
PUBLIC(ITD_global_campExists,false);

// Wait for and validate data.
private ["_version"];
_version = ["ITD_version"] call ALiVE_fnc_getData;
if (!isNil "_version") then {
	if (_version > 1) then {
		// Not backwards compatible.
		while {true} do {
			[["ResistanceMovement","MissionPersistence","VersionError"], true, true, false] call ITD_fnc_broadcastHint;
			sleep 30;
		};
	};
} else {
	// Corrupt / missing data, or ALiVE data from another mission. (sharing pbo name etc.)
	while {true} do {
		[["ResistanceMovement","MissionPersistence","LoadError"], true, true, false] call ITD_fnc_broadcastHint;
		sleep 30;
	};
};

// Retrieve data.
ITD_server_db_progress = ["ITD_progress"] call ALiVE_fnc_getData;
ITD_server_db_camps = ["ITD_camps"] call ALiVE_fnc_getData;
ITD_server_db_objectives = ["ITD_objectives"] call ALiVE_fnc_getData;

// Rebuild camps.
ITD_global_camps = [];
ITD_global_servicePoints = [];
ITD_global_recruitmentTents = [];

private ["_campId"];
_campId = 1;
{
	private ["_pos", "_rot", "_service", "_recruit", "_detected", "_building", "_campMarker"];

	_pos = _x select 0;
	_rot = _x select 1;
	_detected = _x select 2;
	_service = _x select 3;
	_recruit = _x select 4;

	// Spawn camp HQ.
	_building = ["hq", _pos, _rot, false] call ITD_fnc_spawnComposition;
	{_x setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];} forEach _building;

	_campMarker = createMarker [format ["ITD_mkr_resistanceCamp%1", _campId], _pos];
	_campMarker setMarkerType "b_hq";
	_campMarker setMarkerText "Camp";

	ITD_global_camps pushBack _pos;
	[missionNamespace, _pos] call BIS_fnc_addRespawnPosition;

	if (count _service == 3) then {
		_building = ["service", _service select 0, _service select 1, false] call ITD_fnc_spawnComposition;
		{_x setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];} forEach _building;
		ITD_global_servicePoints pushBack (_service select 0);
	};

	if (count _recruit == 2) then {
		_building = ["recruitment", _recruit select 0, _recruit select 1, false] call ITD_fnc_spawnComposition;
		{_x setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];} forEach _building;
		ITD_global_recruitmentTents pushBack (_recruit select 0);
	};

	if (!_detected) then {
		private ["_objectiveParams"];
		_objectiveParams = [format ["ResistanceCamp%1", _campId], _pos, 50, "MIL", 30];
		[ITD_server_faction_enemy, 150, _objectiveParams, _campId - 1] call ITD_fnc_triggerOpcomObjective;
	};

	_campId = _campId + 1;
} forEach ITD_server_db_camps;

// If there are camps, delete the respawn markers.
if (count ITD_server_db_camps > 0) then {
	deleteMarker "respawn_west";
	deleteMarker "respawn_east";
	deleteMarker "respawn_guerrila";
};

// Set objective states.
waitUntil {!isNil "ITD_server_objectivesLoaded"};
{
	switch (_x select 1) do {
		case 1:	{	// STATUS_FRIENDLY
			["setState", [_x select 0, 1]] call ITD_fnc_objectiveManager;
			["triggerObjective", [_x select 0, true]] call ITD_fnc_objectiveManager;
		};

		case 3: {	// STATUS_DESTROYED
			["forceDestroy", [_x select 0]] call ITD_fnc_objectiveManager;
		};
	};
} forEach ITD_server_db_objectives;

// Broadcast variables that need to be global.
publicVariable "ITD_global_camps";
publicVariable "ITD_global_servicePoints";
publicVariable "ITD_global_recruitmentTents";

PUBLIC(ITD_global_crewAvailable,ITD_server_db_progress select 3);
PUBLIC(ITD_global_campsAvailable,ITD_server_db_progress select 4);
PUBLIC(ITD_global_tech1,ITD_server_db_progress select 5);

if (count ITD_server_db_camps > 0) then {
	PUBLIC(ITD_global_campExists,true);
};

// Start the objective manager.
["manage"] spawn ITD_fnc_objectiveManager;

[["ResistanceMovement","MissionPersistence","LoadedSave"]] call ITD_fnc_broadcastHint;
