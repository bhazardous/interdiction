scriptName "takistan";
/*--------------------------------------------------------------------
	file: takistan.sqf
	==================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "takistan.sqf"

// TAOR markers.
private ["_taorMarker"];
_taorMarker = createMarkerLocal ["INT_mkr_taor", [6380.06,6398,0]];	// OPFOR. (entire terrain)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [6500,6400];

_taorMarker = createMarkerLocal ["INT_mkr_indfor_taor", [5733.1,11366.3,0]];	// INDFOR. (one area)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [300,700];
_taorMarker setMarkerDirLocal 43;

// OPFOR force size + HQ position.
INT_module_alive_opfor_mil setVariable ["size", "600"];
INT_module_alive_opfor_civ setVariable ["size", "1250"];
INT_module_alive_opfor_mil setPosATL [1829.99,5612.28,0.00143862];

// INDFOR size + HQ.
INT_module_alive_indfor_mil setVariable ["size", "350"];
INT_module_alive_indfor_mil setPosATL [5733.1,11366.3,0];

// CQB settings.
INT_module_alive_opfor_cqb_civ setVariable ["CQB_spawn_setting", 0.1];	// Percentage.
INT_module_alive_opfor_cqb_mil setVariable ["CQB_spawn_setting", 0.4];
INT_module_alive_opfor_cqb_civ setVariable ["CQB_DENSITY", 500];	// Distance between spawns. 99999 = off.
INT_module_alive_opfor_cqb_mil setVariable ["CQB_DENSITY", 99999];
INT_module_alive_opfor_cqb_civ setVariable ["CQB_amount", 4];		// Number of units per group.
INT_module_alive_opfor_cqb_mil setVariable ["CQB_amount", 4];

// Spawn type.
INT_server_spawn_type = 0;

// Spawn markers.
INT_server_spawn_markers = 0;
{
	private ["_marker"];
	_marker = createMarkerLocal [format ["INT_mkr_spawn%1", INT_server_spawn_markers], _x select 0];
	_marker setMarkerDirLocal (_x select 1);
	_marker setMarkerSizeLocal (_x select 2);
	INT_server_spawn_markers = INT_server_spawn_markers + 1;
} forEach [
	[[874.974,1528.12,0],330,[150,800]],
	[[5992.6,158.157,0],0,[800,100]],
	[[10888.5,1151.19,0],352,[1500,100]],
	[[10555.6,4558.59,0],0,[100,1000]],
	[[11220.1,12581.1,0],0,[1500,100]],
	[[662.8,12191.5,0],25,[100,600]],
	[[3545.68,12629.1,0],0,[700,100]],
	[[8207.25,12591.2,0],0,[800,100]],
	[[391.086,9476.75,0],0,[100,800]],
	[[337.373,5544.05,0],0,[100,700]],
	[[12554.8,7095.67,0],0,[100,650]],
	[[12554.8,7095.67,0],0,[100,650]]
];

// Location markers.
INT_server_location_markers = [];
{
	private ["_marker"];
	_marker = createMarkerLocal [format ["INT_mkr_loc_%1", count INT_server_location_markers], _x];
	INT_server_location_markers pushBack _marker;
} forEach [
	[2114.51,363.674,0],
	[4426.77,833.028,0],
	[6491.06,1202.88,0],
	[6765.68,1906.54,0],
	[8070.38,2190.04,0],
	[10432.9,2376.8,0],
	[1330.87,3428.46,0],
	[1688.26,5685.36,0],
	[3567.82,4293.13,0],
	[8780.91,5237.35,0],
	[5017.59,6084.97,0],
	[10450,6336.73,0],
	[2054.49,7685.89,0],
	[6035.14,7342.15,0],
	[8355.2,7681.88,0],
	[5648.68,9101.32,0],
	[3132.27,9962.96,0],
	[2028.83,11747.7,0],
	[6015.55,11512.8,0],
	[9596.93,11729.6,0],
	[12632.4,9852.36,0],
	[11533.1,8404.7,0]
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
	[[5281.84,6134.81,0],0,"ELLIPSE",[220,220]],
	[[10676.7,6368.67,0],0,"RECTANGLE",[400,150]],
	[[5624.54,9120.97,0],0,"RECTANGLE",[120,300]],
	[[6297.35,11264.6,0],32.9636,"RECTANGLE",[100,250]],
	[[3017.76,9944.9,0],0,"ELLIPSE",[220,220]],
	[[1829.87,11754.2,0],0,"ELLIPSE",[320,320]],
	[[3506.54,4055.91,0],31.5289,"RECTANGLE",[175,620]],
	[[4460.42,663.035,0],0,"ELLIPSE",[290,290]],
	[[8465.05,2415.51,0],0,"RECTANGLE",[170,190]]
];

// Scale down roadblocks / camps for this terrain.
INT_module_alive_opfor_civ setVariable ["roadblocks", "50"];
INT_module_alive_opfor_civ setVariable ["sizeFilter", "225"];

INT_module_alive_opfor_mil setVariable ["sizeFilter", "100"];
INT_module_alive_opfor_mil setVariable ["randomcamps", "2500"];
INT_module_alive_indfor_mil setVariable ["randomcamps", "2500"];

INT_server_objectivesLoaded = true;
