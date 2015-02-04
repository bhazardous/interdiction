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
	_nearService = [player, INT_global_servicePoints, 10] call INT_fnc_nearby;
	_canService = _target isKindOf "AllVehicles" && {[player, _target, 4] call INT_fnc_nearby};
	_checkService = _target in INT_global_servicePoints;
	if (_canService) then {
		private ["_config"];
		_config = (configFile >> "cfgVehicles" >> typeOf _target >> "displayName");
		INT_local_serviceTarget = _target;
		INT_local_serviceType = getText _config;
		INT_local_serviceName = format ["Service %1", INT_local_serviceType];
	} else {
		if (_target in INT_global_servicePoints) then {
			_canService = true;
			INT_local_serviceTarget = player;
			INT_local_serviceName = "Service";
		};
	};

	// Recruitment params.
	_nearRecruit = [player, INT_global_recruitmentTents, 10] call INT_fnc_nearby;
	_supportVeh = _target isKindOf "AllVehicles" &&
		{alive _target} &&
		{count crew _target == 0} &&
		{[player, _target, 5] call INT_fnc_nearby} &&
		{[_target, INT_global_recruitmentTents, 40] call INT_fnc_nearby};
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
							["call INT_fnc_interdictionMenu", "build", 0],
							-1,
							(INT_global_buildingEnabled),
							(true)
					],
					[
							"Service",
							"",
							"",
							"",
							["call INT_fnc_interdictionMenu", "service", 0],
							-1,
							(_canService),
							(_nearService)
					],
					[
							"Recruitment",
							"",
							"",
							"",
							["call INT_fnc_interdictionMenu", "recruitment", 0],
							-1,
							(_recruitMenu),
							(_recruitMenu)
					],
					[
							"Debug",
							"",
							"",
							"",
							["call INT_fnc_interdictionMenu", "debug", 1],
							-1,
							(INT_global_debugEnabled),
							(INT_global_debugEnabled)
					]
			]
	];
};

// MENU > BUILD >
if (_menuName == "build") then {
	_menu =
	[
			["build", "Build", _menuRsc],
			[
					[
							"Resistance HQ",
							{["hq"] call INT_fnc_build;},
							"",
							"Establish a camp, also acts as a respawn point.",
							"",
							-1,
							(!INT_global_campExists),
							(true)
					],
					[
							"Recruitment",
							{["recruitment"] call INT_fnc_build;},
							"",
							"Where new resistance recruits are processed.",
							"",
							-1,
							(INT_global_tech1),
							(true)
					],
					[
							"Service Point",
							{["service"] call INT_fnc_build;},
							"",
							"Strip down vehicles for parts or make repairs.",
							"",
							-1,
							(INT_global_tech1),
							(true)
					]
			]
	];
};

// MENU > SERVICE >
if (_menuName == "service") then {
	private ["_isVehicle", "_needsService", "_needsFuel", "_hasFuel", "_canStrip"];
	if (INT_local_serviceTarget != player) then {
		_isVehicle = true;
	} else {
		_isVehicle = false;
	};
	_needsService = damage INT_local_serviceTarget >= 0.05;
	_needsFuel = fuel INT_local_serviceTarget <= 0.95;
	_hasFuel = fuel INT_local_serviceTarget >= 0.05;
	_canStrip = alive INT_local_serviceTarget;

	_menu =
	[
			["service", INT_local_serviceName, _menuRsc],
			[
					[
							"Repair",
							{["repair"] call INT_fnc_service;},
							"",
							"Use spare parts from the service point to make repairs.",
							"",
							-1,
							(_needsService),
							(_isVehicle)
					],
					[
							"Refuel",
							{["refuel"] call INT_fnc_service;},
							"",
							"",
							"",
							-1,
							(_needsFuel),
							(_isVehicle)
					],
					[
							"Strip Down",
							{["strip"] call INT_fnc_service;},
							"",
							"Strip the vehicle down for spare parts.",
							"",
							-1,
							(_canStrip),
							(_isVehicle)
					],
					[
							"Siphon Fuel",
							{["siphon"] call INT_fnc_service;},
							"",
							"Store the fuel in the service point for use elsewhere.",
							"",
							-1,
							(_hasFuel),
							(_isVehicle)
					],
					[
							"Check Stock",
							{["check"] call INT_fnc_service;},
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
		INT_local_supportTarget = _target;
		_config = (configFile >> "cfgVehicles" >> typeOf _target >> "displayName");
		_name = getText _config;
		INT_local_supportName = format ["Support: %1", _name];
	};

	_menu =
	[
			["recruitment", "Recruitment", _menuRsc],
			[
					[
							"Support Vehicle",
							"",
							"",
							"Turn this vehicle into a support vehicle.",
							["call INT_fnc_interdictionMenu", "supportVeh", 1],
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
							{["transport"] call INT_fnc_support;},
							"",
							"",
							"",
							-1,
							(true),
							(true)
					],
					[
							"Combat",
							{["combat"] call INT_fnc_support;},
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
							{INT_global_tech1 = true; publicVariable "INT_global_tech1";},
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
