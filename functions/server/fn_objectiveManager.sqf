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

private ["_action", "_ret"];
_action = _this select 0;
_params = [_this, 1, [], [[]]] call BIS_fnc_param;

switch (_action) do {
		case "init": {
				if (!isNil "INT_server_objectiveMgr") exitWith {_ret = false;};

				// Create objectives hash.
				INT_server_objectiveMgr = [] call CBA_fnc_hashCreate;
				[INT_server_objectiveMgr, "objectives", [] call CBA_fnc_hashCreate] call CBA_fnc_hashSet;
				[INT_server_objectiveMgr, "objectiveList", []] call CBA_fnc_hashSet;
				[INT_server_objectiveMgr, "objectiveDestroyed", []] call CBA_fnc_hashSet;
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
						private ["_objective", "_friendlies", "_enemies"];
						_objective = [_objectives, _x] call CBA_fnc_hashGet;
						_friendlies = false;
						_enemies = false;

						// Remove object if attached building is destroyed.
						if (_objective select 6 != 0) then {
							private ["_building"];
							_building = [0,0,0] nearestObject (_objective select 6);
							if (getDammage _building >= 1) then {
								["objectiveDestroyed", [_x]] call INT_fnc_objectiveManager;
							};
						};

						if (_objective select 5 != "contested" || _objective select 5 != "destroyed") then {
							// Friendly presence?
							_friendlies = [INT_server_side_blufor, _objective select 0, _objective select 1]
								call INT_fnc_checkPresence;

							// Enemy presence?
							_enemies = [INT_server_side_opfor, _objective select 0, _objective select 1]
								call INT_fnc_checkPresence;
							if (!_enemies) then {
								_enemies = [INT_server_side_indfor, _objective select 0, _objective select 1]
									call INT_fnc_checkPresence;
							};

							switch (_objective select 5) do {
								case "enemy": {
									if (_friendlies && !_enemies) then {
										[_x, true] spawn INT_fnc_objectiveCapture;
									};
								};
								case "friendly": {
									if (!_friendlies && _enemies) then {
										[_x, false] spawn INT_fnc_objectiveCapture;
									};
								};
							};
						};

						sleep SLEEP_TIME;
					} forEach ([INT_server_objectiveMgr, "objectiveList"] call CBA_fnc_hashGet);
					sleep SLEEP_TIME;

					if ([INT_server_objectiveMgr, "status"] call CBA_fnc_hashGet == "exit") then {
						_quit = true;
					};
				};

				_ret = true;
		};

		case "triggerObjective": {
				private ["_objectiveName", "_friendly", "_objective"];
				_objectiveName = _params select 0;
				_friendly = _params select 1;
				_objective = [[INT_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet, _objectiveName] call CBA_fnc_hashGet;
				if (count _objective > 0) then {
					if (_friendly) then {
						call compile format ["%1 call %2", _objective select 3, _objective select 2];
					} else {
						call compile format ["%1 call %2", _objective select 4, _objective select 2];
					};
					_ret = true;
				} else {
					_ret = false;
				};
		};

		case "objectiveDestroyed": {
				// Move objective to destroyed list.
				private ["_objName", "_objectiveList", "_objectives", "_obj"];
				_objName = _params select 0;
				_objectiveList = [INT_server_objectiveMgr, "objectiveList"] call CBA_fnc_hashGet;
				_objectives = [INT_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;
				_obj = [_objectives, _objName] call CBA_fnc_hashGet;

				_objectiveList deleteAt (_objectiveList find _objName);
				([INT_server_objectiveMgr, "objectiveDestroyed"] call CBA_fnc_hashGet) pushBack _objName;

				// Objective is now held by nobody.
				if (_obj select 5 == "friendly") then {
					call compile format ["%1 call %2", _obj select 4, _obj select 2];
				};
				_obj set [5, "destroyed"];

				if (getMarkerColor _objectiveName != "") then {
					deleteMarker _objName;
				};
				_ret = true;
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
