scriptName "fn_objectiveTimer";
/*
	Author: Bhaz

	Description:
	Script runs on clients to handle objective capture progress.

	RemoteExec: Server

	Parameter(s):
	#0 STRING - Objective name
	#1 BOOL (Optional) - Abort an existing timer (default: false)

	Example:
	n/a

	Returns:
	Nothing
*/

if (!hasInterface) exitWith {};
params ["_objName", ["_abort", false, [true]]];
private ["_scriptName"];
_scriptName = "ITD_local_obj_" + _objName + "_scr";
if (isNil _scriptName) then {missionNamespace setVariable [_scriptName, scriptNull]};

if (!_abort) then {
	private ["_progressName", "_newScript"];
	_progressName = "ITD_local_obj_" + _objName + "_progress";
	_newScript = _progressName spawn {
		private ["_startTime"];
		_startTime = time;

		waitUntil {
			missionNamespace setVariable [_this, (time - _startTime) / 20];
			time > (_startTime + 20)
		};
	};

	missionNamespace setVariable [_scriptName, _newScript];
} else {
	if (!scriptDone (missionNamespace getVariable _scriptName)) then {
		terminate (missionNamespace getVariable _scriptName);
	};
};
