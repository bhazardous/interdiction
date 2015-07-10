scriptName "fn_objectiveTimer";
/*
	Author: Bhaz

	Description:
	Script runs on clients to handle objective capture progress.

	Parameter(s):
	#0 STRING - Objective name
	#1 BOOL (OPTIONAL) - Abort signal

	Returns:
	nil
*/

// TODO: Currently objective timer is hardcoded.
// Only required on player machines.
if (!hasInterface) exitWith {nil};

private ["_objName", "_abort", "_scriptName"];
_objName = _this select 0;
_abort = [_this, 1, false] call BIS_fnc_param;
_scriptName = "ITD_local_obj_" + _objName + "_scr";

if (isNil _scriptName) then {missionNamespace setVariable [_scriptName, scriptNull]};

if (!_abort) then {
	// Fire up a new script for this objective.
	private ["_progressName", "_newScript"];
	_progressName = "ITD_local_obj_" + _objName + "_progress";
	_newScript = _progressName spawn {
		_start = 0;
		_finish = 1;
		_time = 20;
		_startTime = time;

		while {time < (_startTime + _time)} do {
			_percent = (time - _startTime) / _time;
			_progress = _start + (_finish - _start) * _percent;
			missionNamespace setVariable [_this, _progress];
			sleep 0.01;
		};

		missionNamespace setVariable [_this, _finish];
	};

	// Attach script to variable.
	missionNamespace setVariable [_scriptName, _newScript];
} else {
	// Abort a currently running script if it's still running.
	if (!scriptDone (missionNamespace getVariable _scriptName)) then {
		terminate (missionNamespace getVariable _scriptName);
	};
};

nil;
