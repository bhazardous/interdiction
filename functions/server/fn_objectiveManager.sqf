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
				if (!isNil "INT_server_objectiveMgr") exitWith {_ret = false;};

				// Create objectives hash.
				INT_server_objectiveMgr = [] call CBA_fnc_hashCreate;
				[INT_server_objectiveMgr, "objectives", []] call CBA_fnc_hashSet;
				[INT_server_objectiveMgr, "status", "idle"] call CBA_fnc_hashSet;
				_ret = true;
		};

		case "manage": {
				if ([INT_server_objectiveMgr, "status"] call CBA_fnc_hashGet != "idle") exitWith {_ret = false;};
				[INT_server_objectiveMgr, "status", "running"] call CBA_fnc_hashSet;

				waitUntil {!isNil "ALiVE_profileHandler"};

				private ["_quit", "_objectives"];
				_quit = false;
				_objectives = [INT_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;

				while {!_quit} do {
					{
						private ["_friendlies", "_enemies"];
						_friendlies = false;
						_enemies = false;

						if (_x select 6 != STATUS_DESTROYED) then {
							// Remove object if attached buildings are destroyed.
							if (count (_x select 7) > 0) then {
								private ["_destroyed"];
								_destroyed = [_x select 7, _x select 1] call INT_fnc_checkBuildings;
								if (_destroyed) then {
									["objectiveDestroyed", [_x select 0]] call INT_fnc_objectiveManager;
								};
							};

							if (_x select 6 != STATUS_CONTESTED) then {
								// Friendly presence?
								_friendlies = [INT_server_side_blufor, _x select 1, _x select 2]
									call INT_fnc_checkPresence;

								// Enemy presence?
								_enemies = [INT_server_side_opfor, _x select 1, _x select 2]
									call INT_fnc_checkPresence;
								if (!_enemies) then {
									_enemies = [INT_server_side_indfor, _x select 1, _x select 2]
										call INT_fnc_checkPresence;
								};

								switch (_x select 6) do {
									case STATUS_ENEMY: {
										if (_friendlies && !_enemies) then {
											[_x select 0, true] spawn INT_fnc_objectiveCapture;
										};
									};
									case STATUS_FRIENDLY: {
										if (!_friendlies && _enemies) then {
											[_x select 0, false] spawn INT_fnc_objectiveCapture;
										};
									};
								};
							};
						};

						sleep SLEEP_TIME;
					} forEach _objectives;
					sleep SLEEP_TIME;

					if ([INT_server_objectiveMgr, "status"] call CBA_fnc_hashGet == "exit") then {
						_quit = true;
					};
				};

				_ret = true;
		};

		case "triggerObjective": {
				private ["_friendly", "_objective"];

				_friendly = _params select 1;
				_objective = ["getObjective", _params] call INT_fnc_objectiveManager;

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
				// Move objective to destroyed list.
				private ["_obj"];

				_obj = ["getObjective", _params] call INT_fnc_objectiveManager;

				// Objective is now held by nobody.
				if (_obj select 6 == STATUS_FRIENDLY) then {
					call compile format ["%1 call %2", _obj select 5, _obj select 3];
				};
				_obj set [6, STATUS_DESTROYED];

				if (getMarkerColor (_obj select 0) != "") then {
					deleteMarker (_obj select 0);
				};
				_ret = true;
		};

		case "getObjective": {
				private ["_objectives"];

				_ret = [];
				_objectives = [INT_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;

				{
					if (_x select 0 == _params select 0) exitWith {
						_ret = _x;
					};
				} forEach _objectives;
		};

		case "exit": {
				if ([INT_server_objectiveMgr, "status"] call CBA_fnc_hashGet == "running") then {
					[INT_server_objectiveMgr, "status", "exit"] call CBA_fnc_hashSet;
					_ret = true;
				} else {
					_ret = false;
				};
		};
};

_ret;
