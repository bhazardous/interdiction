scriptName "fn_addObjective";
/*
	Author: Bhaz

	Description:
	Adds a secondary objective.

	Parameter(s):
	#0 STRING - Objective name
	#1 POSITION - Centre of objective
	#2 NUMBER - Radius
	#3 STRING - Function to call
	#4 ARRAY - Captured params
	#5 ARRAY - Lost params
	#6 NUMBER - Object ID, objective void if destroyed

	Returns:
	nil
*/
#define DEBUG true

private ["_objName", "_position", "_radius", "_function", "_paramsCapture", "_paramsLost", "_objArray",
	"_obj"];
_objName = [_this, 0, "", [""]] call BIS_fnc_param;
_position = [_this, 1, [0,0], [[]], [2,3]] call BIS_fnc_param;
_radius = [_this, 2, 100, [0]] call BIS_fnc_param;
_function = [_this, 3, "BIS_fnc_error", [""]] call BIS_fnc_param;
_paramsCapture = [_this, 4, [], [[]]] call BIS_fnc_param;
_paramsLost = [_this, 5, [], [[]]] call BIS_fnc_param;
_obj = [_this, 6, 0, [0]] call BIS_fnc_param;

// Add objective to the manager.
/* _objArray:
		0 - position
		1 - radius
		2 - function
		3 - params (captured)
		4 - params (lost)
		5 - status
		6 - bound object */
_objArray = [_position, _radius, _function, _paramsCapture, _paramsLost, "enemy", _obj];
[[INT_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet, _objName, _objArray] call CBA_fnc_hashSet;
([INT_server_objectiveMgr, "objectiveList"] call CBA_fnc_hashGet) pushBack _objName;

if (DEBUG) then {
	private ["_marker"];
	_marker = createMarker [_objName, _position];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerSize [_radius, _radius];
	_marker setMarkerColor "ColorRed";
};

nil;
