scriptName "stratis";
/*--------------------------------------------------------------------
	file: stratis.sqf
	=================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "stratis.sqf"

// Create TAOR markers.
private ["_taorMarker"];
_taorMarker = createMarkerLocal ["INT_mkr_taor", [4259.12,4131.65,0]];	// OPFOR. (entire terrain)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [3000,4000];

_taorMarker = createMarkerLocal ["INT_mkr_indfor_taor", [6459.77,5376.24,0]];	// INDFOR. (one area)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [500,500];

// OPFOR force size + HQ position.
INT_module_alive_opfor_mil setVariable ["size", "600"];
INT_module_alive_opfor_civ setVariable ["size", "250"];
INT_module_alive_opfor_mil setPosATL [1829.99,5612.28,0.00143862];

// INDFOR size + HQ.
INT_module_alive_indfor_mil setVariable ["size", "200"];
INT_module_alive_indfor_mil setPosATL [6459.77,5376.24,0];

// CQB settings.
INT_module_alive_opfor_cqb_civ setVariable ["CQB_spawn_setting", 0.2];	// Percentage.
INT_module_alive_opfor_cqb_mil setVariable ["CQB_spawn_setting", 0.4];
INT_module_alive_opfor_cqb_civ setVariable ["CQB_DENSITY", 99999];	// Distance between spawns. 99999 = off.
INT_module_alive_opfor_cqb_mil setVariable ["CQB_DENSITY", 99999];
INT_module_alive_opfor_cqb_civ setVariable ["CQB_amount", 4];		// Number of units per group.
INT_module_alive_opfor_cqb_mil setVariable ["CQB_amount", 4];

// Spawn markers.
INT_server_spawn_markers = 3;

private ["_spawnMarker"];
_spawnMarker = createMarkerLocal ["INT_mkr_spawn0", [5800,2500]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [2900,200];
_spawnMarker setMarkerDirLocal 132;
_spawnMarker setMarkerAlphaLocal 0;

_spawnMarker = createMarkerLocal ["INT_mkr_spawn1", [736.397,2423.59]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [200,2000];
_spawnMarker setMarkerDirLocal 0;
_spawnMarker setMarkerAlphaLocal 0;

_spawnMarker = createMarkerLocal ["INT_mkr_spawn2", [6524.6,7084.68]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [1500,200];
_spawnMarker setMarkerDirLocal 33;
_spawnMarker setMarkerAlphaLocal 0;

// Location markers.
INT_server_location_markers = [];

_spawnMarker = createMarkerLocal ["INT_mkr_loc_0", [2071.91,5439.47]];
INT_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["INT_mkr_loc_1", [3246.21,5886.05]];
INT_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["INT_mkr_loc_2", [4996.07,5852.19]];
INT_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["INT_mkr_loc_3", [6457,5306.13]];
INT_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["INT_mkr_loc_4", [4344.64,3787.79]];
INT_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["INT_mkr_loc_5", [1948.61,3583.07]];
INT_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["INT_mkr_loc_6", [4391.07,4356.35]];
INT_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["INT_mkr_loc_7", [1996.13,2704.85]];
INT_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["INT_mkr_loc_8", [3468.4,2632.78]];
INT_server_location_markers pushBack _spawnMarker;

// Objectives.
[] spawn {
	waitUntil {time > 10};
	call compile preprocessFileLineNumbers "server\terrain\stratis_obj.sqf";
};
