scriptName "fn_objectiveManager";
/*
	Author: Bhaz

	Description:
	Keeps track of all secondary objectives in the mission.

	Parameter(s):
	#0 STRING - Action
	#1 ARRAY - Optional params

	Example:
	["action", _params] call ITD_fnc_objectiveManager;

	Returns:
	Bool - success
*/

#include "persistentData.hpp"
#define SLEEP_TIME 1
#define STATUS_ENEMY		0
#define STATUS_FRIENDLY		1
#define STATUS_CONTESTED	2
#define STATUS_DESTROYED	3

if (!params [["_action", "", [""]], "_params"]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_ret"];
_ret = true;

switch (_action) do {
	case "init": {
		if (!isNil "ITD_server_objectiveMgr") exitWith {_ret = false};

		ITD_server_objectiveMgr = [] call CBA_fnc_hashCreate;
		[ITD_server_objectiveMgr, "objectives", []] call CBA_fnc_hashSet;
		[ITD_server_objectiveMgr, "status", "idle"] call CBA_fnc_hashSet;

		ITD_global_objectivesList = [];
	};

	case "manage": {
		if ([ITD_server_objectiveMgr, "status"] call CBA_fnc_hashGet != "idle") exitWith {_ret = false};
		[ITD_server_objectiveMgr, "status", "running"] call CBA_fnc_hashSet;

		waitUntil {!isNil "ALiVE_profileHandler"};

		private ["_quit", "_objectives"];
		_quit = false;
		_objectives = [ITD_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;
		waitUntil {!isNil "ITD_server_objectivesLoaded"};
		publicVariable "ITD_global_objectivesList";

		while {!_quit} do {
			{
				private ["_friendlies", "_enemies"];

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
						_friendlies = [ITD_global_side_blufor, _x select 1, _x select 2]
							call ITD_fnc_checkPresence;

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

					if (_x select 7 != STATUS_FRIENDLY) then {
						private ["_closest", "_distance", "_opacity"];
						_closest = [_x select 1, ITD_global_playerList] call ITD_fnc_closestObject;
						if (!isNull _closest) then {
							_distance = (_x select 1) distance _closest;
						} else {
							_distance = 9999;
						};
						if (_distance <= 100) then {
							_opacity = 1.0;
						} else {
							// 100m = 100% opacity, 1100m+ = invisible, rounded to 10%.
							_distance = (round (_distance - 100) / 100) / 10;
							_opacity = 0.0 max (1.0 - _distance);
						};

						// Only set opacity if it's changed to avoid network traffic.
						if (_x select 9 != _opacity) then {
							("ITD_mkr_obj_" + (_x select 0)) setMarkerAlpha _opacity;
							_x set [9, _opacity];
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
		} else {
			_ret = false;
		};
	};

	case "objectiveDestroyed": {
		private ["_obj"];
		_obj = ["getObjective", _params] call ITD_fnc_objectiveManager;

		if (_obj select 7 == STATUS_FRIENDLY) then {
			call compile format ["%1 call %2", _obj select 5, _obj select 3];
		};
		["setState", [_obj select 0, STATUS_DESTROYED]] call ITD_fnc_objectiveManager;

		if (count (_obj select 6) > 0) then {
			call compile format ["%1 call %2", _obj select 6, _obj select 3];
		};

		["softDeleteObjective", _params] call ITD_fnc_objectiveManager;
	};

	case "softDeleteObjective": {
		// REMINDER: This function doesn't delete the objective marker
		// or the info from clients. It only deletes data from the server
		// to make sure it doesn't loop on destroyed objectives!
		private ["_objectives"];
		_objectives = [ITD_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;

		{
			if (_x select 0 == _params select 0) exitWith {
				_objectives deleteAt _forEachIndex;
			};
		} forEach _objectives;
	};

	case "deleteObjective": {
		// REMINDER: This will delete ALL traces of an objective, on both
		// server and clients.
		private ["_objectives", "_markerName"];
		_objectives = [ITD_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;

		_markerName = "ITD_mkr_obj_" + (_params select 0);
		if (markerColor _markerName != "") then {
			deleteMarker _markerName;
		};

		{
			if (_x select 0 == _params select 0) exitWith {
				_objectives deleteAt _forEachIndex;
			};
		} forEach _objectives;

		{
			if (_x select 0 == _params select 0) exitWith {
				ITD_global_objectivesList deleteAt _forEachIndex;
				publicVariable "ITD_global_objectivesList";
			};
		} forEach ITD_global_objectivesList;
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
		_params params ["_objectiveName", "_state"];
		private ["_obj", "_markerName"];
		_obj = ["getObjective", [_objectiveName]] call ITD_fnc_objectiveManager;
		_obj set [7, _state];

		if (_state != STATUS_CONTESTED) then {
			private ["_success"];
			_success = false;

			{
				if (_x select 0 == _objectiveName) exitWith {
					if (_state != STATUS_ENEMY) then {
						_x set [1, _state];
						_success = true;
					} else {
						DB_OBJECTIVES deleteAt _forEachIndex;
					};
				};
			} forEach DB_OBJECTIVES;

			if (!_success && {_state != STATUS_ENEMY}) then {
				DB_OBJECTIVES pushBack [_objectiveName, _state];
			};
		};

		_markerName = "ITD_mkr_obj_" + _objectiveName;
		if (getMarkerColor _markerName != "") then {
			switch (_state) do {
				case STATUS_FRIENDLY: {
					_markerName setMarkerColor "ColorWEST";
					_markerName setMarkerAlpha 1;
					_objective set [9, 1];
				};
				case STATUS_ENEMY: {_markerName setMarkerColor "ColorEAST";};
				case STATUS_CONTESTED: {_markerName setMarkerColor "ColorUNKNOWN";};
				case STATUS_DESTROYED: {
					_markerName setMarkerColor "ColorGrey";
					_markerName setMarkerAlpha 1;
					_objective set [9, 1];
				};
			};
		};
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
	};

	case "exit": {
		if ([ITD_server_objectiveMgr, "status"] call CBA_fnc_hashGet == "running") then {
			[ITD_server_objectiveMgr, "status", "exit"] call CBA_fnc_hashSet;
		} else {
			_ret = false;
		};
	};
};

_ret
