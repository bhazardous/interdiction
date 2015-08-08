scriptName "serverPreInit";
/*--------------------------------------------------------------------
	file: serverPreInit.sqf
	=======================
	Author: Bhaz
	Description: Init markers and set up ALiVE modules.
--------------------------------------------------------------------*/
#define __filename "serverPreInit.sqf"

if (!isServer) exitWith {};

if (isDedicated) then {
	if (paramsArray select 6 == 1) then {
		ITD_global_persistence = true;

		// Enable persistence related options for all modules.
		ITD_module_alive_data setVariable ["saveDateTime", "true", true];
		ITD_module_alive_profile setVariable ["persistent", "true", true];
		ITD_module_alive_playerOptions setVariable ["enablePlayerPersistence", "true"];
		ITD_module_alive_playerOptions setVariable ["saveLoadout", "true"];
		ITD_module_alive_playerOptions setVariable ["saveAmmo", "true"];
		ITD_module_alive_playerOptions setVariable ["saveHealth", "true"];
		ITD_module_alive_playerOptions setVariable ["savePosition", "true"];
		ITD_module_alive_playerOptions setVariable ["saveScores", "true"];
		ITD_module_alive_playerOptions setVariable ["storeToDB", "true"];
		ITD_module_alive_blufor_opcom setVariable ["persistent", "true", true];
		ITD_module_alive_opfor_opcom setVariable ["persistent", "true", true];
		ITD_module_alive_indfor_opcom setVariable ["persistent", "true", true];
		ITD_module_alive_indfor_logistics setVariable ["persistent", "true", true];
		ITD_module_alive_opfor_cqb_mil setVariable ["CQB_persistent", "true", true];
		ITD_module_alive_opfor_cqb_civ setVariable ["CQB_persistent", "true", true];
	} else {
		ITD_global_persistence = false;
	};
} else {
	ITD_global_persistence = false;
};

publicVariable "ITD_global_persistence";

// Factions.
private ["_indepEastAllies"];
_indepEastAllies = true;
switch (paramsArray select 3) do {
	case 0: {		// Vanilla (FIA, CSAT, AAF)
		// Factions, sides.
		ITD_server_faction_blufor = "BLU_G_F";
		ITD_global_side_blufor = west;
		ITD_server_faction_opfor = "OPF_F";
		ITD_server_side_opfor = east;
		ITD_server_faction_indfor = "IND_F";
		ITD_server_side_indfor = independent;

		// Unit classnames.
		ITD_global_unit_override = "";
		ITD_server_opfor_supply = ["O_Truck_03_ammo_F", "O_Truck_02_Ammo_F", "O_Truck_03_fuel_F",
			"O_Truck_02_fuel_F", "O_Truck_03_repair_F", "O_Truck_02_box_F"];
		ITD_global_blufor_unit = "B_G_Soldier_F";
		ITD_server_opfor_unit = "O_Soldier_F";
		ITD_server_spawn_land = ["B_G_Offroad_01_F","B_G_Van_01_transport_F"];
		ITD_server_spawn_sea = ["B_Boat_Transport_01_F"];
		ITD_server_spawn_capacity = [[6,13],[5]];
		ITD_server_ammoCrate = "Box_East_Wps_F";
	};
	case 1: {		// RHS_USRF (Insurgent, MSV, VDV)
		// Factions, sides.
		ITD_server_faction_blufor = "rhs_faction_insurgents";
		ITD_global_side_blufor = independent;
		ITD_server_faction_opfor = "rhs_faction_msv";
		ITD_server_side_opfor = east;
		ITD_server_faction_indfor = "rhs_faction_vdv";
		ITD_server_side_indfor = east;
		_indepEastAllies = false;

		// Unit classnames.
		ITD_global_unit_override = "rhs_g_Soldier_F";
		ITD_server_opfor_supply = ["rhs_gaz66_ammo_msv", "RHS_Ural_Fuel_MSV_01", "rhs_gaz66_repair_msv"];
		ITD_global_blufor_unit = "rhs_g_Soldier_F";
		ITD_server_opfor_unit = "rhs_msv_rifleman";
		ITD_server_spawn_land = ["RHS_Ural_MSV_01","RHS_Ural_Civ_01","RHS_Ural_Open_Civ_01","RHS_Ural_Civ_03","RHS_Ural_Open_Civ_03","RHS_Ural_Civ_02","RHS_Ural_Open_Civ_02"];
		ITD_server_spawn_sea = ["B_Boat_Transport_01_F"];
		ITD_server_spawn_capacity = [[15,15,15,15,15,15,15],[5]];
		ITD_server_ammoCrate = "rhs_weapons_crate_ak_standard";
	};
};
publicVariable "ITD_global_side_blufor";
publicVariable "ITD_global_unit_override";
publicVariable "ITD_global_blufor_unit";
ITD_server_faction_enemy = [ITD_server_faction_opfor, ITD_server_faction_indfor];

if (!_indepEastAllies) then {
	east setFriend [resistance, 0];
	resistance setFriend [east, 0];
};

// Set up module factions.
ITD_module_alive_blufor_opcom setVariable ["factions", [ITD_server_faction_blufor], true];
ITD_module_alive_opfor_opcom setVariable ["factions", [ITD_server_faction_opfor], true];
ITD_module_alive_indfor_opcom setVariable ["factions", [ITD_server_faction_indfor], true];
ITD_module_alive_opfor_mil setVariable ["faction", ITD_server_faction_opfor, true];
ITD_module_alive_opfor_civ setVariable ["faction", ITD_server_faction_opfor, true];
ITD_module_alive_indfor_mil setVariable ["faction", ITD_server_faction_indfor, true];
ITD_module_alive_opfor_cqb_mil setVariable ["CQB_FACTIONS", ITD_server_faction_opfor, true];
ITD_module_alive_opfor_cqb_civ setVariable ["CQB_FACTIONS", ITD_server_faction_opfor, true];

// Island specific settings.
["init"] call ITD_fnc_objectiveManager;
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

// CQB locality.
private ["_locality"];
switch (paramsArray select 5) do {
	case 0: {_locality = "server";};
	case 1: {_locality = "HC";};
	case 2: {_locality = "client"};
};
ITD_module_alive_opfor_cqb_civ setVariable ["CQB_locality_setting", _locality, true];
ITD_module_alive_opfor_cqb_mil setVariable ["CQB_locality_setting", _locality, true];

// Weather.
ITD_module_alive_weather setVariable ["weather_override_setting", paramsArray select 1, true];

// OPCOM.
ITD_module_alive_blufor_opcom setVariable ["reinforcements", "0", true];

// Workaround for OPCOM divide by zero error.
[] spawn {
	private ["_handler"];

	waitUntil {!isNil {ITD_module_alive_blufor_opcom getVariable "handler"}};
	_handler = ITD_module_alive_blufor_opcom getVariable "handler";

	waitUntil {count ([_handler, "startForceStrength", []] call ALiVE_fnc_hashGet) == 8};
	[_handler, "startForceStrength", [1,0,0,0,0,0,0,0]] call ALiVE_fnc_hashSet;
};

// Workaround for OPCOM complaining there are no profiles.
// Give OPCOM a single lone unit.
if (ITD_global_unit_override != "") then {
	private ["_group", "_unit"];
	_group = createGroup ITD_global_side_blufor;
	_unit = _group createUnit [ITD_global_unit_override, markerPos "ITD_mkr_taor", [], 0, "NONE"];
};

// TFAR.
if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
	tf_no_auto_long_range_radio = false;
};
