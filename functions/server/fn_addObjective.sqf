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
	#6 ARRAY - Object IDs, objective void if destroyed
	#7 BOOL - Add to OPCOM

	Returns:
	nil
*/
#define DEBUG true

private ["_objName", "_position", "_radius", "_function", "_paramsCapture", "_paramsLost", "_objArray",
	"_obj", "_opcom", "_objectives"];
_objName = [_this, 0, "", [""]] call BIS_fnc_param;
_position = [_this, 1, [0,0], [[]], [2,3]] call BIS_fnc_param;
_radius = [_this, 2, 100, [0]] call BIS_fnc_param;
_function = [_this, 3, "BIS_fnc_error", [""]] call BIS_fnc_param;
_paramsCapture = [_this, 4, [], [[]]] call BIS_fnc_param;
_paramsLost = [_this, 5, [], [[]]] call BIS_fnc_param;
_obj = [_this, 6, [], [[]]] call BIS_fnc_param;
_opcom = [_this, 7, false, [false]] call BIS_fnc_param;

// Add objective to the manager.
/* _objArray:
		0 - name
		1 - position
		2 - radius
		3 - function
		4 - params (captured)
		5 - params (lost)
		6 - status
		7 - bound object */
_objArray = [_objName, _position, _radius, _function, _paramsCapture, _paramsLost, 0, _obj];
_objectives = [ITD_server_objectiveMgr, "objectives"] call CBA_fnc_hashGet;
if (!isNil "_objectives") then {
	_objectives pushBack _objArray;

	if (_opcom) then {
		[objNull, [("obj_" + _objName), _position, _radius, "MIL", 0]] call ITD_fnc_addOpcomObjective;
	};

	if (DEBUG) then {
		private ["_marker"];
		_marker = createMarker [_objName, _position];
		_marker setMarkerShape "ELLIPSE";
		_marker setMarkerSize [_radius, _radius];
		_marker setMarkerColor "ColorEAST";
	};
};

nil;
