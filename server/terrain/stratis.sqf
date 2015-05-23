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
_taorMarker = createMarkerLocal ["ITD_mkr_taor", [4259.12,4131.65,0]];	// OPFOR. (entire terrain)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [3000,4000];

_taorMarker = createMarkerLocal ["ITD_mkr_indfor_taor", [6459.77,5376.24,0]];	// INDFOR. (one area)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [500,500];

// OPFOR force size + HQ position.
ITD_module_alive_opfor_mil setVariable ["size", "600"];
ITD_module_alive_opfor_civ setVariable ["size", "250"];
ITD_module_alive_opfor_mil setPosATL [1829.99,5612.28,0.00143862];

// INDFOR size + HQ.
ITD_module_alive_indfor_mil setVariable ["size", "200"];
ITD_module_alive_indfor_mil setPosATL [6459.77,5376.24,0];

// CQB settings.
ITD_module_alive_opfor_cqb_civ setVariable ["CQB_spawn_setting", 0.2];	// Percentage.
ITD_module_alive_opfor_cqb_mil setVariable ["CQB_spawn_setting", 0.4];
ITD_module_alive_opfor_cqb_civ setVariable ["CQB_DENSITY", 99999];	// Distance between spawns. 99999 = off.
ITD_module_alive_opfor_cqb_mil setVariable ["CQB_DENSITY", 99999];
ITD_module_alive_opfor_cqb_civ setVariable ["CQB_amount", 3];		// Number of units per group.
ITD_module_alive_opfor_cqb_mil setVariable ["CQB_amount", 3];

// Spawn type.
ITD_server_spawn_type = 1;

// Spawn markers.
ITD_server_spawn_markers = 3;

private ["_spawnMarker"];
_spawnMarker = createMarkerLocal ["ITD_mkr_spawn0", [5800,2500]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [2900,200];
_spawnMarker setMarkerDirLocal 132;
_spawnMarker setMarkerAlphaLocal 0;

_spawnMarker = createMarkerLocal ["ITD_mkr_spawn1", [736.397,2423.59]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [200,2000];
_spawnMarker setMarkerDirLocal 0;
_spawnMarker setMarkerAlphaLocal 0;

_spawnMarker = createMarkerLocal ["ITD_mkr_spawn2", [6524.6,7084.68]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [1500,200];
_spawnMarker setMarkerDirLocal 33;
_spawnMarker setMarkerAlphaLocal 0;

// Location markers.
ITD_server_location_markers = [];

_spawnMarker = createMarkerLocal ["ITD_mkr_loc_0", [2071.91,5439.47]];
ITD_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["ITD_mkr_loc_1", [3246.21,5886.05]];
ITD_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["ITD_mkr_loc_2", [4996.07,5852.19]];
ITD_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["ITD_mkr_loc_3", [6457,5306.13]];
ITD_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["ITD_mkr_loc_4", [4344.64,3787.79]];
ITD_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["ITD_mkr_loc_5", [1948.61,3583.07]];
ITD_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["ITD_mkr_loc_6", [4391.07,4356.35]];
ITD_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["ITD_mkr_loc_7", [1996.13,2704.85]];
ITD_server_location_markers pushBack _spawnMarker;
_spawnMarker = createMarkerLocal ["ITD_mkr_loc_8", [3468.4,2632.78]];
ITD_server_location_markers pushBack _spawnMarker;

// Built-up civilian areas, and important areas close by.
private ["_bua"];
ITD_server_civ_markers = [];
_bua = 0;
{
	private ["_marker"];
	_marker = createMarkerLocal [format ["ITD_mkr_civ_%1", _bua], _x select 0];
	_marker setMarkerDirLocal (_x select 1);
	_marker setMarkerShapeLocal (_x select 2);
	_marker setMarkerSizeLocal (_x select 3);
	_marker setMarkerAlphaLocal 0;
	ITD_server_civ_markers pushBack _marker;
	_bua = _bua + 1;
} forEach [
	[[2986.47,6015.72,0],0,"ELLIPSE",[220,220]],
	[[2734.33,5770.2,0],0,"ELLIPSE",[80,80]],
	[[2135.4,5643.62,0],12,"RECTANGLE",[150,300]],
	[[2032.67,2717.25,0],0,"ELLIPSE",[120,120]],
	[[3254.74,5800.5,0],35,"RECTANGLE",[80,80]]
];

// Safe spawn.
{_x setMarkerPos [7095.98,5956.21]} forEach ["respawn_west", "respawn_east", "respawn_guerrila"];

// Objectives.
[] spawn {
	waitUntil {time > 10};
	call compile preprocessFileLineNumbers "server\terrain\stratis_obj.sqf";
};
