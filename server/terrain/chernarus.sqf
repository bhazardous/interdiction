scriptName "chernarus";
/*--------------------------------------------------------------------
	file: chernarus.sqf
	==================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "chernarus.sqf"

// TAOR markers.
private ["_taorMarker"];
_taorMarker = createMarkerLocal ["INT_mkr_taor", [7537.29,8288.76,0]];	// OPFOR. (entire terrain)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [7500,7000];

_taorMarker = createMarkerLocal ["INT_mkr_indfor_taor", [12116.7,12649.7,0]];	// INDFOR. (one area)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [700,500];

// OPFOR force size + HQ position.
INT_module_alive_opfor_mil setVariable ["size", "650"];
INT_module_alive_opfor_mil setVariable ["priorityFilter", "10"];
INT_module_alive_opfor_civ setVariable ["size", "1500"];
INT_module_alive_opfor_mil setPosATL [1829.99,5612.28,0.00143862];

// INDFOR size + HQ.
INT_module_alive_indfor_mil setVariable ["size", "400"];
INT_module_alive_indfor_mil setPosATL [12116.7,12649.7,0];

// CQB settings.
INT_module_alive_opfor_cqb_civ setVariable ["CQB_spawn_setting", 0.1];	// Percentage.
INT_module_alive_opfor_cqb_mil setVariable ["CQB_spawn_setting", 0.4];
INT_module_alive_opfor_cqb_civ setVariable ["CQB_DENSITY", 250];	// Distance between spawns. 99999 = off.
INT_module_alive_opfor_cqb_mil setVariable ["CQB_DENSITY", 99999];
INT_module_alive_opfor_cqb_civ setVariable ["CQB_amount", 4];		// Number of units per group.
INT_module_alive_opfor_cqb_mil setVariable ["CQB_amount", 2];

// Spawn type.
INT_server_spawn_type = 1;

// Spawn markers.
INT_server_spawn_markers = 0;
{
	private ["_marker"];
	_marker = createMarkerLocal [format ["INT_mkr_spawn%1", INT_server_spawn_markers], _x select 0];
	_marker setMarkerDirLocal (_x select 1);
	_marker setMarkerSizeLocal (_x select 2);
	INT_server_spawn_markers = INT_server_spawn_markers + 1;
} forEach [
	[[5106.29,939.32,0],0,[5000,100]],
	[[14799.9,8391.01,0],0,[100,4000]]
];

// Location markers.
INT_server_location_markers = [];
{
	private ["_marker"];
	_marker = createMarkerLocal [format ["INT_mkr_loc_%1", count INT_server_location_markers], _x];
	INT_server_location_markers pushBack _marker;
} forEach [
	[4673.49,10686.8,0],
	[2784.99,9842.33,0],
	[3907.45,8812.17,0],
	[3137.21,8056.05,0],
	[4641.51,6362.61,0],
	[2580.75,5226.28,0],
	[1722.77,3768.67,0],
	[1684.11,2193.96,0],
	[4589.95,2416.04,0],
	[6345.02,2604.49,0],
	[9472.3,1977.8,0],
	[10126.4,5392,0],
	[4470.34,4596.32,0],
	[6543.01,6076.64,0],
	[7016.68,7652.1,0],
	[6277.25,7821.17,0],
	[13512.2,6309.05,0],
	[12933.4,6961.51,0],
	[11976.1,12663.2,0],
	[11265.8,12168.3,0],
	[8670.92,11865.9,0],
	[6947.06,11336.8,0],
	[9787.98,8739.13,0],
	[10264.6,9539.47,0],
	[5037.34,12465.9,0],
	[11924.7,3455.55,0],
	[12830.1,9746.31,0]
];

// Built-up civilian areas, and important areas close by.
private ["_bua"];
INT_server_civ_markers = [];
_bua = 0;
{
	private ["_marker"];
	_marker = createMarkerLocal [format ["INT_mkr_civ_%1", _bua], _x select 0];
	_marker setMarkerDirLocal (_x select 1);
	_marker setMarkerShapeLocal (_x select 2);
	_marker setMarkerSizeLocal (_x select 3);
	_marker setMarkerAlphaLocal 0;
	INT_server_civ_markers pushBack _marker;
	_bua = _bua + 1;
} forEach [
	[[11103.9,12349.1,0],30.0069,"RECTANGLE",[220,120]],
	[[12857.3,10052.4,0],109.848,"RECTANGLE",[200,100]],
	[[12330,9572.66,0],10.4658,"RECTANGLE",[200,120]],
	[[12137.4,9422.98,0],133.805,"RECTANGLE",[100,80]],
	[[11974.7,9103.26,0],0,"ELLIPSE",[240,240]],
	[[13366.5,6209.35,0],0,"RECTANGLE",[120,200]],
	[[10505.5,2243.55,0],0,"RECTANGLE",[180,240]],
	[[10179.4,1870.22,0],0,"RECTANGLE",[250,300]],
	[[6766.49,2581.23,0],0,"RECTANGLE",[500,420]],
	[[6144.91,7750.35,0],42.26,"RECTANGLE",[350,100]],
	[[2741.41,5259.99,0],20.5161,"RECTANGLE",[140,300]]
];

// Scale down roadblocks / camps for this terrain.
INT_module_alive_opfor_civ setVariable ["roadblocks", "35"];
INT_module_alive_opfor_mil setVariable ["randomcamps", "2500"];
INT_module_alive_indfor_mil setVariable ["randomcamps", "2500"];
