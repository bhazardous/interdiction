scriptName "fn_preInitServer";
/*
	Author: Bhaz

	Description:
	Required to init markers and set up ALiVE modules before they start up.

	Parameter(s):
	None

	Returns:
	nil
*/

if (!isServer) exitWith {nil;};

// Factions.
INT_server_faction_blufor = switch (paramsArray select 6) do {
	case 0: {"BLU_G_F"};
	case 1: {"rhs_faction_insurgents"};
};
INT_global_unit_override = switch (paramsArray select 6) do {
	case 0: {""};
	case 1: {"rhs_g_Soldier_F"}
};
publicVariable "INT_global_unit_override";
INT_server_faction_opfor = switch (paramsArray select 4) do {
	case 0: {"OPF_F"};
	case 1: {"rhs_faction_vdv"};
};
INT_server_faction_indfor = switch (paramsArray select 5) do {
	case 0: {"IND_F"};
	case 1: {"rhs_faction_msv"};
};

INT_server_faction_enemy = [INT_server_faction_opfor, INT_server_faction_indfor];
INT_server_side_blufor = west;

// Set up module factions.
INT_module_alive_blufor_opcom setVariable ["factions", [INT_server_faction_blufor]];
INT_module_alive_opfor_opcom setVariable ["factions", [INT_server_faction_opfor]];
INT_module_alive_indfor_opcom setVariable ["factions", [INT_server_faction_indfor]];
INT_module_alive_opfor_mil setVariable ["faction", INT_server_faction_opfor];
INT_module_alive_opfor_civ setVariable ["faction", INT_server_faction_opfor];
INT_module_alive_indfor_mil setVariable ["faction", INT_server_faction_indfor];
INT_module_alive_opfor_cqb_mil setVariable ["CQB_FACTIONS", INT_server_faction_opfor];
INT_module_alive_opfor_cqb_civ setVariable ["CQB_FACTIONS", INT_server_faction_opfor];

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
private ["_locality"];
switch (paramsArray select 8) do {
	case 0: {_locality = "server";};
	case 1: {_locality = "HC";};
	case 2: {_locality = "client"};
};
INT_module_alive_opfor_cqb_civ setVariable ["CQB_locality_setting", _locality];
INT_module_alive_opfor_cqb_mil setVariable ["CQB_locality_setting", _locality];

// BLUFOR logistics.
INT_module_alive_blufor_logistics setVariable ["forcePool", "0"];

// Weather.
INT_module_alive_weather setVariable ["weather_override_setting", paramsArray select 1];

// OPCOM.
INT_module_alive_blufor_opcom setVariable ["reinforcements", "0"];

// Workaround for OPCOM divide by zero error.
[] spawn {
	private ["_handler"];

	waitUntil {!isNil {INT_module_alive_blufor_opcom getVariable "handler"}};
	_handler = INT_module_alive_blufor_opcom getVariable "handler";

	waitUntil {count ([_handler, "startForceStrength", []] call ALiVE_fnc_hashGet) == 8};
	[_handler, "startForceStrength", [1,0,0,0,0,0,0,0]] call ALiVE_fnc_hashSet;
};

nil;
