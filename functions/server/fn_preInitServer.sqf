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
private ["_indepEastAllies"];
_indepEastAllies = true;
switch (paramsArray select 3) do {
	case 0: {		// Vanilla (FIA, CSAT, AAF)
		// Factions, sides.
		INT_server_faction_blufor = "BLU_G_F";
		INT_server_side_blufor = west;
		INT_server_faction_opfor = "OPF_F";
		INT_server_side_opfor = east;
		INT_server_faction_indfor = "IND_F";
		INT_server_side_indfor = independent;

		// Unit classnames.
		INT_global_unit_override = "";
		INT_server_opfor_supply = ["O_Truck_03_ammo_F", "O_Truck_02_Ammo_F", "O_Truck_03_fuel_F",
			"O_Truck_02_fuel_F", "O_Truck_03_repair_F", "O_Truck_02_box_F"];
		INT_server_blufor_unit = "B_G_Soldier_F";
		INT_server_opfor_unit = "O_Soldier_F";
		INT_server_spawn_sea = ["B_Boat_Transport_01_F"];
		INT_server_spawn_land = ["B_G_Offroad_01_F","B_G_Van_01_transport_F"];
		INT_server_spawn_capacity = [[5],[6,13]];
	};
	case 1: {		// RHS_USRF (Insurgent, MSV, VDV)
		// Factions, sides.
		INT_server_faction_blufor = "rhs_faction_insurgents";
		INT_server_side_blufor = independent;
		INT_server_faction_opfor = "rhs_faction_msv";
		INT_server_side_opfor = east;
		INT_server_faction_indfor = "rhs_faction_vdv";
		INT_server_side_indfor = east;
		_indepEastAllies = false;

		// Unit classnames.
		INT_global_unit_override = "rhs_g_Soldier_F";
		INT_server_opfor_supply = ["rhs_gaz66_ammo_msv", "RHS_Ural_Fuel_MSV_01", "rhs_gaz66_repair_msv"];
		INT_server_blufor_unit = "rhs_g_Soldier_F";
		INT_server_opfor_unit = "rhs_msv_rifleman";
		INT_server_spawn_sea = ["B_Boat_Transport_01_F"];
		INT_server_spawn_land = ["RHS_Ural_MSV_01","RHS_Ural_Civ_01","RHS_Ural_Open_Civ_01","RHS_Ural_Civ_03","RHS_Ural_Open_Civ_03","RHS_Ural_Civ_02","RHS_Ural_Open_Civ_02"];
		INT_server_spawn_capacity = [[5],[15,15,15,15,15,15,15]];
	};
};
publicVariable "INT_global_unit_override";
INT_server_faction_enemy = [INT_server_faction_opfor, INT_server_faction_indfor];

if (!_indepEastAllies) then {
	east setFriend [resistance, 0];
	resistance setFriend [east, 0];
};

// Set up module factions.
INT_module_alive_blufor_opcom setVariable ["factions", [INT_server_faction_blufor]];
INT_module_alive_opfor_opcom setVariable ["factions", [INT_server_faction_opfor]];
INT_module_alive_indfor_opcom setVariable ["factions", [INT_server_faction_indfor]];
INT_module_alive_opfor_mil setVariable ["faction", INT_server_faction_opfor];
INT_module_alive_opfor_civ setVariable ["faction", INT_server_faction_opfor];
INT_module_alive_indfor_mil setVariable ["faction", INT_server_faction_indfor];
INT_module_alive_opfor_cqb_mil setVariable ["CQB_FACTIONS", INT_server_faction_opfor, true];
INT_module_alive_opfor_cqb_civ setVariable ["CQB_FACTIONS", INT_server_faction_opfor, true];

// Island specific settings.
["init"] call INT_fnc_objectiveManager;
switch (worldName) do {
	case "Stratis": {call compile preprocessFileLineNumbers "server\terrain\stratis.sqf";};
	case "Takistan": {call compile preprocessFileLineNumbers "server\terrain\takistan.sqf";};
	case "Chernarus": {call compile preprocessFileLineNumbers "server\terrain\chernarus.sqf";};
	case "Altis": {call compile preprocessFileLineNumbers "server\terrain\altis.sqf";};
	default {
		[format ["%1 is not compatible with this mission.", worldName]] call BIS_fnc_error;
		["end1", false, 0] call BIS_fnc_endMission;
	};
};
["manage"] spawn INT_fnc_objectiveManager;

// CQB locality.
private ["_locality"];
switch (paramsArray select 5) do {
	case 0: {_locality = "server";};
	case 1: {_locality = "HC";};
	case 2: {_locality = "client"};
};
INT_module_alive_opfor_cqb_civ setVariable ["CQB_locality_setting", _locality, true];
INT_module_alive_opfor_cqb_mil setVariable ["CQB_locality_setting", _locality, true];

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

// TFAR.
if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
	tf_no_auto_long_range_radio = false;
};

nil;
