scriptName "fn_interdictionMenu";
/*
	Author: Bhaz

	Description:
	Wrapper for CBA flexi menu.
	Designed using this post as a guide:
	forums.unitedoperations.net/index.php/topic/22731-tutorial-adding-ace-interact-options-to-missions/

	Parameter(s):
	#0 STRING - Menu name
	#1 NUMBER - (Optional) Menu resource

	Returns:
	ARRAY - CBA Fleximenu definition, empty array on error.
*/

private ["_params", "_menuName", "_menuRsc", "_target"];
_params = [_this, 1, [], [[], ""]] call BIS_fnc_param;
_menuName = "";
_menuRsc = "popup";
_target = cursorTarget;

// Menu name and rsc.
if (typeName _params == "ARRAY" && {count _params == 0}) exitWith {
	["Called with no params"] call BIS_fnc_error;
	[];
};

if (typeName _params == "ARRAY") then {
	_menuName = _params select 0;
	if (count _params > 1) then {
		_menuRsc = _params select 1;
	};
} else {
	_menuName = _params;
};

/* Menu array:
	[ menu name, menu title, rsc ],
	[ text, code, icon, tooltip, submenu, hotkey, active condition, visible condition ] */

// MENU >
private ["_menu"];
_menu = [];
if (_menuName == "main") then {
	// Service params.
	private ["_canService", "_nearService", "_checkService", "_nearRecruit", "_supportVeh"];
	_nearService = [player, ITD_global_servicePoints, 10] call ITD_fnc_nearby;
	_canService = _target isKindOf "AllVehicles" && {[player, _target, 6] call ITD_fnc_nearby};
	_checkService = [player, ITD_global_servicePoints, 5] call ITD_fnc_nearby;
	if (_canService) then {
		private ["_config"];
		_config = (configFile >> "cfgVehicles" >> typeOf _target >> "displayName");
		ITD_local_serviceTarget = _target;
		ITD_local_serviceType = getText _config;
		ITD_local_serviceName = format ["Service %1", ITD_local_serviceType];
	} else {
		if (_checkService) then {
			_canService = true;
			ITD_local_serviceTarget = player;
			ITD_local_serviceName = "Service";
		};
	};

	// Recruitment params.
	_nearRecruit = [player, ITD_global_recruitmentTents, 10] call ITD_fnc_nearby;
	_supportVeh = _target isKindOf "AllVehicles" &&
		{alive _target} &&
		{count crew _target == 0} &&
		{[player, _target, 5] call ITD_fnc_nearby} &&
		{[_target, ITD_global_recruitmentTents, 40] call ITD_fnc_nearby};
	_recruitMenu = _supportVeh || _nearRecruit;

	// Menu.
	_menu =
	[
			["main", "Interdiction", _menuRsc],
			[
					[
							"Build",
							"",
							"",
							"",
							["call ITD_fnc_interdictionMenu", "build", 0],
							-1,
							(ITD_global_buildingEnabled),
							(true)
					],
					[
							"Service",
							"",
							"",
							"",
							["call ITD_fnc_interdictionMenu", "service", 0],
							-1,
							(_canService),
							(_nearService)
					],
					[
							"Recruitment",
							"",
							"",
							"",
							["call ITD_fnc_interdictionMenu", "recruitment", 0],
							-1,
							(_recruitMenu),
							(_recruitMenu)
					],
					[
							"Debug",
							"",
							"",
							"",
							["call ITD_fnc_interdictionMenu", "debug", 1],
							-1,
							(ITD_global_debugEnabled),
							(ITD_global_debugEnabled)
					]
			]
	];
};

// MENU > BUILD >
if (_menuName == "build") then {
	private ["_nearService"];

	_nearService = [player, ITD_global_servicePoints, 10] call ITD_fnc_nearby;

	_menu =
	[
			["build", "Build", _menuRsc],
			[
					[
							"Resistance HQ",
							{["hq"] call ITD_fnc_build;},
							"",
							"Establish a camp, also acts as a respawn point.",
							"",
							-1,
							(ITD_global_campsAvailable > 0),
							(true)
					],
					[
							"Recruitment",
							{["recruitment"] call ITD_fnc_build;},
							"",
							"Where new resistance recruits are processed.",
							"",
							-1,
							(ITD_global_tech1),
							(true)
					],
					[
							"Service Point",
							{["service"] call ITD_fnc_build;},
							"",
							"Strip down vehicles for parts or make repairs.",
							"",
							-1,
							(ITD_global_tech1),
							(true)
					],
					[
							"Fortifications",
							"",
							"",
							"",
							["call ITD_fnc_interdictionMenu", "buildFort", 1],
							-1,
							(_nearService),
							(true)
					]
			]
	];
};

// MENU > BUILD > FORTIFICATIONS
if (_menuName == "buildFort") then {
	_menu =
	[
			["buildFort", "Fortifications", _menuRsc],
			[
					[
							"[2] Sandbag",
							{["fort_sandbag"] call ITD_fnc_build;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"[1] Sandbag (Short)",
							{["fort_sandbag_short"] call ITD_fnc_build;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"[2] Sandbag (Round)",
							{["fort_sandbag_round"] call ITD_fnc_build;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"[1] Sandbag (Corner)",
							{["fort_sandbag_corner"] call ITD_fnc_build;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"[1] Sandbag (End)",
							{["fort_sandbag_end"] call ITD_fnc_build;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"[2] H-Barrier",
							{["fort_barrier"] call ITD_fnc_build;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"[6] H-Barrier, 3-Length",
							{["fort_barrier_3"] call ITD_fnc_build;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"[10] H-Barrier, 5-Length",
							{["fort_barrier_5"] call ITD_fnc_build;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					]
			]
	];
};

// MENU > SERVICE >
if (_menuName == "service") then {
	private ["_isVehicle", "_needsService", "_needsFuel", "_hasFuel", "_canStrip"];
	if (ITD_local_serviceTarget != player) then {
		_isVehicle = true;
	} else {
		_isVehicle = false;
	};
	_needsService = damage ITD_local_serviceTarget >= 0.05;
	_needsFuel = fuel ITD_local_serviceTarget <= 0.95;
	_hasFuel = fuel ITD_local_serviceTarget >= 0.05;
	_canStrip = alive ITD_local_serviceTarget;

	_menu =
	[
			["service", ITD_local_serviceName, _menuRsc],
			[
					[
							"Assess Damage",
							{["assess"] call ITD_fnc_service;},
							"",
							"",
							"",
							-1,
							(true),
							(_isVehicle)
					],
					[
							"Repair",
							{["repair"] call ITD_fnc_service;},
							"",
							"Use spare parts from the service point to make repairs.",
							"",
							-1,
							(_needsService),
							(_isVehicle)
					],
					[
							"Refuel",
							{["refuel"] call ITD_fnc_service;},
							"",
							"",
							"",
							-1,
							(_needsFuel),
							(_isVehicle)
					],
					[
							"Strip Down",
							{["strip"] call ITD_fnc_service;},
							"",
							"Strip the vehicle down for spare parts.",
							"",
							-1,
							(_canStrip),
							(_isVehicle)
					],
					[
							"Siphon Fuel",
							{["siphon"] call ITD_fnc_service;},
							"",
							"Store the fuel in the service point for use elsewhere.",
							"",
							-1,
							(_hasFuel),
							(_isVehicle)
					],
					[
							"Check Stock",
							{["check"] call ITD_fnc_service;},
							"",
							"See how many resources are available at this service point.",
							"",
							-1,
							(true),
							(true)
					]
			]
	];
};

// MENU > RECRUITMENT >
if (_menuName == "recruitment") then {
	private ["_supportVeh"];
	_supportVeh = _target isKindOf "AllVehicles" && {alive _target} && {count crew _target == 0};
	if (_supportVeh) then {
		private ["_config", "_name"];
		ITD_local_supportTarget = _target;
		_config = (configFile >> "cfgVehicles" >> typeOf _target >> "displayName");
		_name = getText _config;
		ITD_local_supportName = format ["Support: %1", _name];
	};

	_menu =
	[
			["recruitment", "Recruitment", _menuRsc],
			[
					[
							"Request Reinforcements",
							{[-3] call ITD_fnc_reinforcements;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"Support Vehicle",
							"",
							"",
							"Turn this vehicle into a support vehicle.",
							["call ITD_fnc_interdictionMenu", "supportVeh", 1],
							-1,
							(_supportVeh),
							(_supportVeh)
					]
			]
	];
};

// MENU > RECRUITMENT > SUPPORT VEHICLE >
if (_menuName == "supportVeh") then {
	_menu =
	[
			["supportVeh", "Support Vehicle", _menuRsc],
			[
					[
							"Transport",
							{["transport"] call ITD_fnc_support;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"Combat",
							{["combat"] call ITD_fnc_support;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					]
			]
	];
};

// MENU > DEBUG >
if (_menuName == "debug") then {
	_menu =
	[
			["debug", "Debug", _menuRsc],
			[
					[
							"Unlock Tech",
							{ITD_global_tech1 = true; publicVariable "ITD_global_tech1";},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"Spawn Resistance",
							{[[], "ITD_fnc_spawnResistance", false] call BIS_fnc_MP;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"Add Support Crew",
							{ITD_global_crewAvailable = ITD_global_crewAvailable + 1; publicVariable "ITD_global_crewAvailable";},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"Spawn Vehicle",
							"",
							"",
							"",
							["call ITD_fnc_interdictionMenu", "debug_spawn", 1],
							-1,
							(true),
							(true)
					]
			]
	];
};

// MENU > DEBUG > SPAWN >
if (_menuName == "debug_spawn") then {
	_menu =
	[
			["debug_spawn", "Spawn", _menuRsc],
			[
					[
							"Ghosthawk",
							{"B_Heli_Transport_01_F" createVehicle (position player);},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"MRAP",
							{"B_MRAP_01_F" createVehicle (position player);},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"M5 Sandstorm",
							{"B_MBT_01_mlrs_F" createVehicle (position player);},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					]
			]
	];
};

// Return the menu.
if (count _menu == 0) then {
	["Couldn't find menu - %1", _menuName] call BIS_fnc_error;
};
_menu;
