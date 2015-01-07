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
