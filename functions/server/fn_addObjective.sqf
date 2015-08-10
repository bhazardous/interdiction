scriptName "fn_addObjective";
/*
	Author: Bhaz

	Description:
	Adds a secondary objective.

	Parameter(s):
	#0 STRING - Objective name
	#1 POSITION - Centre of objective
	#2 NUMBER - Radius
	#3 STRING - Marker type
	#4 STRING - Function to call
	#5 ARRAY - Captured params
	#6 ARRAY - Lost params
	#7 ARRAY - Destroyed params (empty array [] = function not called)
	#8 ARRAY - Object IDs, objective void if destroyed
	#9 BOOL (Optional) - Add to OPCOM (default: false)

	Example:
	n/a

	Returns:
	Nothing
*/

if (!params [
	["_objName", "", [""]],
	["_position", [], [[]], [2,3]],
	["_radius", 0, [0]],
	["_markerType", "hd_unknown", [""]],
	["_function", "BIS_fnc_error", [""]],
	["_paramsCapture", [], [[]]],
	["_paramsLost", [], [[]]],
	["_paramsDestroy", [], [[]]],
	["_obj", [], [[]]]]) exitWith {["Invalid params"] call BIS_fnc_error};

private ["_opcom", "_objArray", "_objectives", "_marker"];
_opcom = param [9, false, [false]];

// Add objective to the manager.
/* _objArray:
		0 - name
		1 - position
		2 - radius
		3 - function
		4 - params (captured)
		5 - params (lost)
		6 - params (destroyed)
		7 - status
		8 - bound objects
		9 - marker opacity
		10 - marker type */
_objArray = [_objName, _position, _radius, _function, _paramsCapture, _paramsLost, _paramsDestroy, 0, _obj, 0, _markerType];
_objectives = [ITD_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;
if (isNil "_objectives") exitWith {["Objective manager not initialized"] call BIS_fnc_error};

_objectives pushBack _objArray;
ITD_global_objectivesList pushBack [_objName, _radius];

if (_opcom) then {
	[objNull, [("obj_" + _objName), _position, _radius, "MIL", 0]] call ITD_fnc_addOpcomObjective;
};

_marker = createMarker ["ITD_mkr_obj_" + _objName, _position];
_marker setMarkerShape "ICON";
_marker setMarkerType _markerType;
_marker setMarkerColor "ColorEAST";
_marker setMarkerAlpha 0.0;
