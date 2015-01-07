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
INT_server_side_blufor = switch (paramsArray select 6) do {
	case 0: {west};
	case 1: {independent};
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

// Island specific settings.
switch (worldName) do {
	case "Stratis": {call compile preprocessFileLineNumbers "server\terrain\stratis.sqf";};
	default {
		[format ["%1 is not compatible with this mission.", worldName]] call BIS_fnc_error;
		["end1", false, 0] call BIS_fnc_endMission;
	};
};

// CQB locality.
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

// Workaround for OPCOM complaining there are no profiles.
if (INT_global_unit_override != "") then {
	// Give OPCOM a single lone unit.
	private ["_group", "_unit"];
	_group = createGroup INT_server_side_blufor;
	_unit = _group createUnit [INT_global_unit_override, markerPos "INT_mkr_taor", [], 0, "NONE"];
};

nil;
