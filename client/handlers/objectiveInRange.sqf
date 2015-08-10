scriptName "objectiveInRange";
/*
	Author: Bhaz

	Description:
	Client GUI control for secondary objectives.

	Parameter(s):
	#0 STRING - Internal objective name
	#1 NUMBER - Capture radius

	Example:
	n/a

	Returns:
	Nothing
*/

params ["_objName", "_radius"];
private ["_markerName", "_handle", "_progressVar", "_side"];

_markerName = "ITD_mkr_obj_" + _objName;
_handle = "ITD_local_obj_" + _objName + "_scr";
_progressVar = "ITD_local_obj_" + _objName + "_progress";
_side = "";
if (isNil _handle) then {missionNamespace setVariable [_handle, scriptNull]};

["objectiveStatus", "show"] call ITD_fnc_guiAction;
["objectiveStatus", "setIcon", markerType _markerName] call ITD_fnc_guiAction;

while {player distance (markerPos _markerName) <= _radius} do {
	if (markerColor _markerName != _side) then {
		_side = markerColor _markerName;
		["objectiveStatus", "setSide", _side] call ITD_fnc_guiAction;
	};

	if (!scriptDone (missionNamespace getVariable _handle)) then {
		["objectiveStatus", "extend"] call ITD_fnc_guiAction;

		waitUntil {
			["objectiveStatus", "setProgress", missionNamespace getVariable _progressVar] call ITD_fnc_guiAction;
			scriptDone (missionNamespace getVariable _handle) ||
			player distance (markerPos _markerName) > _radius
		};

		["objectiveStatus", "shrink"] call ITD_fnc_guiAction;
	};
	sleep 0.5;
};

["objectiveStatus", "hide"] call ITD_fnc_guiAction;
