scriptName "fn_objectiveCapture";
/*
	Author: Bhaz

	Description:
	Tracks a contested objective until its captured.

	Parameter(s):
	#0 STRING - Objective name from objective manager.
	#1 BOOL - True if resistance is capturing, false if enemy is recapturing.

	Returns:
	nil
*/
#define SLEEP_TIME 2
#define LOOPS 10
#define STATUS_ENEMY		0
#define STATUS_FRIENDLY		1
#define STATUS_CONTESTED	2
#define STATUS_DESTROYED	3

private ["_objectiveName", "_objective", "_side", "_loop", "_success", "_friendlies", "_enemies", "_signal"];
_objectiveName = _this select 0;
_objective = ["getObjective", [_objectiveName]] call ITD_fnc_objectiveManager;
_side = _this select 1;
_loop = 0;
_success = true;
_signal = false;

// Objective is now contested.
["setState", [_objectiveName, STATUS_CONTESTED]] call ITD_fnc_objectiveManager;

while {_loop < LOOPS} do {
	// Friendly presence?
	_friendlies = [ITD_global_side_blufor, _objective select 1, _objective select 2] call ITD_fnc_checkPresence;

	// Enemy presence?
	_enemies = [ITD_server_side_opfor, _objective select 1, _objective select 2] call ITD_fnc_checkPresence;
	if (!_enemies) then {
		_enemies = [ITD_server_side_indfor, _objective select 1, _objective select 2] call ITD_fnc_checkPresence;
	};

	if (_side) then {
		// Resistance capturing enemy objective.
		if (_friendlies && _enemies) then {
			// Friendlies and enemies present, reset loops to 0.
			_loop = 0;
			if (_signal) then {
				[[_objectiveName, true], "ITD_fnc_objectiveTimer", true] call BIS_fnc_MP;
				_signal = false;
			};
		} else {
			// If this loop 0, signal that capturing has started.
			if (_friendlies && _loop == 0) then {
				if (!_signal) then {
					[[_objectiveName], "ITD_fnc_objectiveTimer", true] call BIS_fnc_MP;
					_signal = true;
				};
			};
		};
		if (!_friendlies) then {
			// Friendlies no longer present, capture failed.
			_success = false;
			_loop = LOOPS;
			if (_signal) then {
				[[_objectiveName, true], "ITD_fnc_objectiveTimer", true] call BIS_fnc_MP;
				_signal = false;
			};
		};
	} else {
		// Enemy recapturing resistance held objective.
		if (_friendlies && _enemies) then {
			// Friendlies and enemies present, reset loops to 0.
			_loop = 0;
		};
		if (!_enemies) then {
			// Enemy no longer present, capture failed.
			_success = false;
			_loop = LOOPS;
		};
	};

	_loop = _loop + 1;
	sleep SLEEP_TIME;
};

if (_success) then {
	if (_side) then {
		// Objective switched from enemy to friendly.
		["setState", [_objectiveName, STATUS_FRIENDLY]] call ITD_fnc_objectiveManager;
	} else {
		// Objective switched from friendly enemy.
		["setState", [_objectiveName, STATUS_ENEMY]] call ITD_fnc_objectiveManager;
	};

	// Call function attached to objective.
	["triggerObjective", [_objectiveName, _side]] call ITD_fnc_objectiveManager;
} else {
	if (_side) then {
		// Contest failed, objective remains enemy.
		["setState", [_objectiveName, STATUS_ENEMY]] call ITD_fnc_objectiveManager;
	} else {
		// Contest failed, objective remains friendly
		["setState", [_objectiveName, STATUS_FRIENDLY]] call ITD_fnc_objectiveManager;
	};
};

nil;
