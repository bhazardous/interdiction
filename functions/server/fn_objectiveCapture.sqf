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

private ["_objectiveName", "_objective", "_side", "_loop", "_success", "_friendlies", "_enemies"];
_objectiveName = _this select 0;
_objective = [[INT_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet, _objectiveName] call CBA_fnc_hashGet;
_side = _this select 1;
_loop = 0;
_success = true;

// Objective is now contested.
_objective set [5, "contested"];
if (getMarkerColor _objectiveName != "") then {
	_objectiveName setMarkerColor "ColorBlack";
};

while {_loop < LOOPS} do {
	// Friendly presence?
	_friendlies = [INT_server_side_blufor, _objective select 0, _objective select 1] call INT_fnc_checkPresence;

	// Enemy presence?
	_enemies = [INT_server_side_opfor, _objective select 0, _objective select 1] call INT_fnc_checkPresence;
	if (!_enemies) then {
		_enemies = [INT_server_side_indfor, _objective select 0, _objective select 1] call INT_fnc_checkPresence;
	};

	if (_side) then {
		// Resistance capturing enemy objective.
		if (_friendlies && _enemies) then {
			// Friendlies and enemies present, reset loops to 0.
			_loop = 0;
		};
		if (!_friendlies) then {
			// Friendlies no longer present, capture failed.
			_success = false;
			_loop = LOOPS;
		};
	} else {
		// Enemy recapturing resistance held objective.
	};

	_loop = _loop + 1;
	sleep SLEEP_TIME;
};

if (_success) then {
	if (_side) then {
		// Objective switched from enemy to friendly.
		_objective set [5, "friendly"];
	} else {
		// Objective switched from friendly enemy.
		_objective set [5, "enemy"];
	};

	// Call function attached to objective.
	["triggerObjective", [_objectiveName, _side]] call INT_fnc_objectiveManager;
} else {
	if (_side) then {
		// Contest failed, objective remains enemy.
		_objective set [5, "enemy"];
	} else {
		// Contest failed, objective remains friendly
		_objective set [5, "friendly"];
	};
};

if (getMarkerColor _objectiveName != "") then {
	switch (_objective select 5) do {
		case "friendly": { _objectiveName setMarkerColor "ColorBlue";};
		case "enemy": {_objectiveName setMarkerColor "ColorRed";};
	};
};

nil;
