scriptName "objectiveInRange";
/*--------------------------------------------------------------------
	file: objectiveInRange.sqf
	====================
	Author: Bhaz <>
	Description: Takes control if a player is in range of an objective.
--------------------------------------------------------------------*/
#define __filename "objectiveInRange.sqf"

#define GUI_NAME "objectiveStatus"
#define GUI_SHOW [GUI_NAME, "show"] call ITD_fnc_guiAction
#define GUI_HIDE [GUI_NAME, "hide"] call ITD_fnc_guiAction
#define GUI_EXTEND [GUI_NAME, "extend"] call ITD_fnc_guiAction
#define GUI_SHRINK [GUI_NAME, "shrink"] call ITD_fnc_guiAction
#define GUI_SET_ICON(x) [GUI_NAME, "setIcon", x] call ITD_fnc_guiAction
#define GUI_SET_PROGRESS(x) [GUI_NAME, "setProgress", x] call ITD_fnc_guiAction
#define GUI_SET_SIDE(x) ["objectiveStatus", "setSide", x] call ITD_fnc_guiAction

private ["_objName", "_radius", "_markerName", "_contestScript", "_progressVar", "_progress", "_side"];
_objName = _this select 0;
_radius = _this select 1;
_markerName = "ITD_mkr_obj_" + _objName;
_contestScript = "ITD_local_obj_" + _objName + "_scr";
_progressVar = "ITD_local_obj_" + _objName + "_progress";

if (isNil _contestScript) then {missionNamespace setVariable [_contestScript, scriptNull]};

// Set up the UI.
GUI_SHOW;
GUI_SET_ICON(markerType _markerName);
_side = "";

// Display until out of range.
while {(player distance (markerPos _markerName)) <= _radius} do {
	// Has side changed?
	if (markerColor _markerName != _side) then {
		_side = markerColor _markerName;
		GUI_SET_SIDE(_side);
	};

	// Is the objective being secured by friendlies?
	if (!scriptDone (missionNamespace getVariable _contestScript)) then {
		GUI_EXTEND;

		while {!scriptDone (missionNamespace getVariable _contestScript)
			&& {(player distance (markerPos _markerName)) <= _radius}} do {
			_progress = missionNamespace getVariable [_progressVar, 0];
			GUI_SET_PROGRESS(_progress);
			sleep 0.01;
		};

		// Shrink immediately if player left radius.
		if ((player distance (markerPos _markerName)) <= _radius) exitWith {GUI_SHRINK};

		_progress = missionNamespace getVariable [_progressVar, 0];
		GUI_SET_PROGRESS(_progress);
		sleep 0.5;
		GUI_SHRINK;
	};
	sleep 0.5;
};

// Player left radius - kill the UI.
GUI_HIDE;
