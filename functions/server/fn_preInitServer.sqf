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
INT_server_faction_blufor = "BLU_G_F";
INT_server_faction_opfor = "OPF_F";
INT_server_faction_indfor = "IND_F";
INT_server_faction_enemy = [INT_server_faction_opfor, INT_server_faction_indfor];
INT_server_side_blufor = west;

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
// TODO: CQB mission param - CQB_locality_setting ("client", "server", "HC")

// BLUFOR logistics.
INT_module_alive_blufor_logistics setVariable ["forcePool", "0"];

nil;
