scriptName "fn_objectiveManager";
/*
	Author: Bhaz

	Description:
	Keeps track of all secondary objectives in the mission.

	Parameter(s):
	#0 STRING - Action
	#1 ARRAY - Optional params

	Returns:
	bool - success
*/
#define SLEEP_TIME 1
#define STATUS_ENEMY		0
#define STATUS_FRIENDLY		1
#define STATUS_CONTESTED	2
#define STATUS_DESTROYED	3

private ["_action", "_ret"];
_action = _this select 0;
_params = [_this, 1, [], [[]]] call BIS_fnc_param;

switch (_action) do {
		case "init": {
				if (!isNil "ITD_server_objectiveMgr") exitWith {_ret = false;};

				// Create objectives hash.
				ITD_server_objectiveMgr = [] call CBA_fnc_hashCreate;
				[ITD_server_objectiveMgr, "objectives", []] call CBA_fnc_hashSet;
				[ITD_server_objectiveMgr, "status", "idle"] call CBA_fnc_hashSet;
				_ret = true;
		};

		case "manage": {
				if ([ITD_server_objectiveMgr, "status"] call CBA_fnc_hashGet != "idle") exitWith {_ret = false;};
				[ITD_server_objectiveMgr, "status", "running"] call CBA_fnc_hashSet;

				waitUntil {!isNil "ALiVE_profileHandler"};

				private ["_quit", "_objectives"];
				_quit = false;
				_objectives = [ITD_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;

				while {!_quit} do {
					{
						private ["_friendlies", "_enemies"];
						_friendlies = false;
						_enemies = false;

						if (_x select 7 != STATUS_DESTROYED) then {
							// Remove object if attached buildings are destroyed.
							if (count (_x select 8) > 0) then {
								private ["_destroyed"];
								_destroyed = [_x select 8, _x select 1] call ITD_fnc_checkBuildings;
								if (_destroyed) then {
									["objectiveDestroyed", [_x select 0]] call ITD_fnc_objectiveManager;
								};
							};

							if (_x select 7 != STATUS_CONTESTED) then {
								// Friendly presence?
								_friendlies = [ITD_server_side_blufor, _x select 1, _x select 2]
									call ITD_fnc_checkPresence;

								// Enemy presence?
								_enemies = [ITD_server_side_opfor, _x select 1, _x select 2]
									call ITD_fnc_checkPresence;
								if (!_enemies) then {
									_enemies = [ITD_server_side_indfor, _x select 1, _x select 2]
										call ITD_fnc_checkPresence;
								};

								switch (_x select 7) do {
									case STATUS_ENEMY: {
										if (_friendlies && !_enemies) then {
											[_x select 0, true] spawn ITD_fnc_objectiveCapture;
										};
									};
									case STATUS_FRIENDLY: {
										if (!_friendlies && _enemies) then {
											[_x select 0, false] spawn ITD_fnc_objectiveCapture;
										};
									};
								};
							};
						};

						sleep SLEEP_TIME;
					} forEach _objectives;
					sleep SLEEP_TIME;

					if ([ITD_server_objectiveMgr, "status"] call CBA_fnc_hashGet == "exit") then {
						_quit = true;
					};
				};

				_ret = true;
		};

		case "triggerObjective": {
				private ["_friendly", "_objective"];

				_friendly = _params select 1;
				_objective = ["getObjective", _params] call ITD_fnc_objectiveManager;

				if (count _objective > 0) then {
					if (_friendly) then {
						call compile format ["%1 call %2", _objective select 4, _objective select 3];
					} else {
						call compile format ["%1 call %2", _objective select 5, _objective select 3];
					};
					_ret = true;
				} else {
					_ret = false;
				};
		};

		case "objectiveDestroyed": {
				private ["_obj"];

				_obj = ["getObjective", _params] call ITD_fnc_objectiveManager;

				// Objective is now held by nobody.
				if (_obj select 7 == STATUS_FRIENDLY) then {
					call compile format ["%1 call %2", _obj select 5, _obj select 3];
				};
				["setState", [_obj select 0, STATUS_DESTROYED]] call ITD_fnc_objectiveManager;

				// Call destroy function.
				if (count (_obj select 6) > 0) then {
					call compile format ["%1 call %2", _obj select 6, _obj select 3];
				};

				_ret = true;
		};

		case "getObjective": {
				private ["_objectives"];

				_ret = [];
				_objectives = [ITD_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;

				{
					if (_x select 0 == _params select 0) exitWith {
						_ret = _x;
					};
				} forEach _objectives;
		};

		case "setState": {
				private ["_obj", "_objectiveName", "_state"];

				_objectiveName = _params select 0;
				_state = _params select 1;
				_obj = ["getObjective", [_objectiveName]] call ITD_fnc_objectiveManager;
				_obj set [7, _state];

				// Update persistence.
				if (_state != STATUS_CONTESTED) then {
					private ["_success"];
					_success = false;

					{
						if (_x select 0 == _objectiveName) then {
							if (_state != STATUS_ENEMY) then {
								_x set [1, _state];
								_success = true;
							} else {
								// Enemy held objectives don't need to be stored.
								ITD_server_persistentObjectives deleteAt _forEachIndex;
								[] call ITD_fnc_updatePersistence;
							};
						};
					} forEach ITD_server_persistentObjectives;

					if (!_success && {_state != STATUS_ENEMY}) then {
						ITD_server_persistentObjectives pushBack [_objectiveName, _state];
						[] call ITD_fnc_updatePersistence;
					};
				};

				if (getMarkerColor _objectiveName != "") then {
					switch (_state) do {
						case STATUS_FRIENDLY: { _objectiveName setMarkerColor "ColorWEST";};
						case STATUS_ENEMY: {_objectiveName setMarkerColor "ColorEAST";};
						case STATUS_CONTESTED: {_objectiveName setMarkerColor "ColorUNKNOWN";};
						case STATUS_DESTROYED: {deleteMarker _objectiveName;};
					};
				};

				_ret = true;
		};

		case "forceDestroy": {
				private ["_obj"];

				_obj = ["getObjective", [_params select 0]] call ITD_fnc_objectiveManager;

				if (count _obj > 0) then {
					private ["_position"];

					_position = _obj select 1;
					["objectiveDestroyed", [_params select 0]] call ITD_fnc_objectiveManager;
					{
						private ["_building"];
						_building = _position nearestObject _x;
						_building setDamage 1;
					} forEach (_obj select 8)
				};

				_ret = true;
		};

		case "exit": {
				if ([ITD_server_objectiveMgr, "status"] call CBA_fnc_hashGet == "running") then {
					[ITD_server_objectiveMgr, "status", "exit"] call CBA_fnc_hashSet;
					_ret = true;
				} else {
					_ret = false;
				};
		};
};

_ret;
