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
	private ["_canService", "_nearService", "_checkService"];
	_nearService = [player, INT_global_servicePoints, 10] call INT_fnc_nearby;
	_canService = _target isKindOf "AllVehicles" && {[player, _target, 4] call INT_fnc_nearby};
	_checkService = _target in INT_global_servicePoints;
	if (_canService) then {
		private ["_config"];
		_config = (configFile >> "cfgVehicles" >> typeOf _target >> "displayName");
		INT_local_serviceTarget = _target;
		INT_local_serviceName = format ["Service %1", getText _config];
	};

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
							"Service",
							"",
							"",
							"",
							["call INT_fnc_interdictionMenu", "serviceCHK", 0],
							-1,
							(_checkService),
							(_checkService)
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
							"Recruitment Tent",
							{[[player], "INT_fnc_buildRequest", false, false, false] call BIS_fnc_MP;},
							"",
							"Where new resistance recruits are processed.",
							"",
							-1,
							(false),
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
	private ["_needsService", "_needsFuel", "_hasFuel", "_canStrip"];
	_needsService = damage INT_local_serviceTarget >= 0.05;
	_needsFuel = fuel INT_local_serviceTarget <= 0.95;
	_hasFuel = fuel INT_local_serviceTarget >= 0.05;
	_canStrip = alive INT_local_serviceTarget;

	_menu =
	[
			["service", INT_local_serviceName, _menuRsc],
			[
					[
							"Check Stock",
							{["check"] call INT_fnc_service;},
							"",
							"Take stock of parts and fuel at this service point.",
							"",
							-1,
							(true),
							(true)
					]
			]
	];
};

// MENU > SERVICE (chk) >
if (_menuName == "serviceCHK") then {
	_menu =
	[
			["debug", "Debug", _menuRsc],
			[
					[
							"Test",
							{hint "test";},
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
							"Test",
							{hint "test";},
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
