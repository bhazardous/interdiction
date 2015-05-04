scriptName "altis";
/*--------------------------------------------------------------------
	file: altis.sqf
	==================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "altis.sqf"

// TAOR markers.
private ["_taorMarker"];
_taorMarker = createMarkerLocal ["ITD_mkr_taor", [15281.2,15468.7,0]];	// OPFOR. (entire terrain)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [15000,11000];

_taorMarker = createMarkerLocal ["ITD_mkr_indfor_taor", [11589.3,11738.2,0]];	// INDFOR. (one area)
_taorMarker setMarkerShapeLocal "RECTANGLE";
_taorMarker setMarkerSizeLocal [1000,1000];

// OPFOR force size + HQ position.
ITD_module_alive_opfor_mil setVariable ["size", "800"];
ITD_module_alive_opfor_civ setVariable ["size", "1200"];
ITD_module_alive_opfor_mil setPosATL [14734.9,16392.7,0];

// INDFOR size + HQ.
ITD_module_alive_indfor_mil setVariable ["size", "250"];
ITD_module_alive_indfor_mil setPosATL [11589.3,11738.2,0];

// BLUFOR insurgency centre.
ITD_module_alive_blufor_opcom setPosATL [3514.11,13001.5,0];

// CQB settings.
ITD_module_alive_opfor_cqb_civ setVariable ["CQB_spawn_setting", 0.05];	// Percentage.
ITD_module_alive_opfor_cqb_mil setVariable ["CQB_spawn_setting", 0.2];
ITD_module_alive_opfor_cqb_civ setVariable ["CQB_DENSITY", 700];	// Distance between spawns. 99999 = off.
ITD_module_alive_opfor_cqb_mil setVariable ["CQB_DENSITY", 300];
ITD_module_alive_opfor_cqb_civ setVariable ["CQB_amount", 3];		// Number of units per group.
ITD_module_alive_opfor_cqb_mil setVariable ["CQB_amount", 2];

// Spawn type.
ITD_server_spawn_type = 1;

// Spawn markers.
ITD_server_spawn_markers = 0;
{
	private ["_marker"];
	_marker = createMarkerLocal [format ["ITD_mkr_spawn%1", ITD_server_spawn_markers], _x select 0];
	_marker setMarkerDirLocal (_x select 1);
	_marker setMarkerSizeLocal (_x select 2);
	ITD_server_spawn_markers = ITD_server_spawn_markers + 1;
} forEach [
	[[5106.29,939.32,0],0,[5000,100]],
	[[14799.9,8391.01,0],0,[100,4000]],
	[[4856.43,7025.81,0],22,[3000,100]],
	[[16637.3,5086.07,0],0,[2000,100]],
	[[24648.3,11393.7,0],6,[100,3000]],
	[[20088.9,22159.6,0],142,[1500,100]],
	[[11831,24894.4,0],0,[1500,100]],
	[[4943.62,24498.7,0],166,[2000,100]],
	[[770.575,18561.5,0],0,[100,4000]]
];

// Location markers.
ITD_server_location_markers = [];
{
	private ["_marker"];
	_marker = createMarkerLocal [format ["ITD_mkr_loc_%1", count ITD_server_location_markers], _x];
	ITD_server_location_markers pushBack _marker;
} forEach [
	[9270.71,8069.34,0],
	[11558.1,9450.75,0],
	[3650.96,10238.6,0],
	[3121.1,12531.7,0],
	[3675.55,13437.8,0],
	[3045.21,18457.7,0],
	[4928.04,21893.5,0],
	[4406.64,20633.9,0],
	[4743.43,16145.2,0],
	[4570.42,15468,0],
	[4288.56,11419.8,0],
	[5259.46,11507.3,0],
	[5386.58,14526.7,0],
	[6170.29,16310.3,0],
	[8344.79,10117.4,0],
	[8969.56,11696.9,0],
	[9181.69,15911.6,0],
	[8429.56,18251.6,0],
	[9328.33,20261.8,0],
	[10549.3,12263.9,0],
	[10819.2,13345.4,0],
	[10454.4,19112.8,0],
	[11415.5,14204.9,0],
	[11780.1,11876.8,0],
	[12783,14270.6,0],
	[12711.2,16315.9,0],
	[13965.6,18980.3,0],
	[14148.9,16330.6,0],
	[14204.5,21164.7,0],
	[16214.2,16960.4,0],
	[17514.1,13208.7,0],
	[18158.4,15539.8,0],
	[20858.1,6561.52,0],
	[21654.7,7438.98,0],
	[20275.4,8897.26,0],
	[21865.6,10945.6,0],
	[20004.8,11625.9,0],
	[19443.3,13371,0],
	[19108.2,16530.5,0],
	[17865.2,18197.1,0],
	[21214.3,16914,0],
	[26676.1,24609.4,0],
	[25325.1,21766.1,0],
	[21666.9,21212.3,0],
	[27267,23479.2,0],
	[22951,18868.7,0]
];

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
	[[3648.56,13266.2,0],21.7215,"RECTANGLE",[300,700]],
	[[9019.43,11987.4,0],14.1191,"ELLIPSE",[220,220]],
	[[9391.87,11703.8,0],165.659,"RECTANGLE",[130,240]],
	[[9347.28,15918.9,0],157.259,"RECTANGLE",[400,150]],
	[[12498.1,14343.6,0],66,"RECTANGLE",[300,300]],
	[[14018.7,18702.2,0],0,"ELLIPSE",[300,300]],
	[[25627.8,21347.4,0],137.178,"RECTANGLE",[300,250]],
	[[16815,12682.1,0],0,"ELLIPSE",[400,400]],
	[[20794.4,6722.12,0],0,"ELLIPSE",[175,175]],
	[[18157.6,15245.6,0],0,"RECTANGLE",[250,200]],
	[[20973.5,16968.3,0],0,"RECTANGLE",[250,275]]
];

// Scale down objectives / presence.
ITD_module_alive_opfor_civ setVariable ["sizeFilter", "400"];
ITD_module_alive_opfor_civ setVariable ["priorityFilter", "10"];
ITD_module_alive_opfor_civ setVariable ["roadblocks", "15"];

ITD_module_alive_opfor_mil setVariable ["sizeFilter", "200"];
ITD_module_alive_opfor_mil setVariable ["randomcamps", "2500"];
ITD_module_alive_indfor_mil setVariable ["randomcamps", "0"];

ITD_server_objectivesLoaded = true;
