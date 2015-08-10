scriptName "fn_nearby";
/*
	Author: Bhaz

	Description:
	Check distance between two points. First param can be an object, marker or position.
	Second param can be an object, marker, position, or an array containing any of the three.
	If an array is used, only one test needs to pass to return true.

	Parameter(s):
	#0 OBJECT, STRING, POSITION - Position to test
	#1 OBJECT, STRING, POSITION, ARRAY - Position/s to test against
	#2 NUMBER - Distance

	Example:
	n/a

	Returns:
	Boolean - true if within distance
*/

if (!params [
		["_obj", objNull, [objNull, "", []]],
		["_test", objNull, [objNull, "", []]],
		["_distance", -1, [0]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
	false
};

private ["_ret", "_objPos"];
_ret = false;
_objPos = nil;

switch (typeName _obj) do {
	case "OBJECT": {
		if (!isNull _obj) then {_objPos = position _obj};
	};
	case "STRING": {
		if (getMarkerColor _obj != "") then {_objPos = markerPos _obj};
	};
	case "ARRAY": {
		if (typeName (_obj select 0) in ["NUMBER","SCALAR"]) then {_objPos = _obj};
	};
};

if (isNil "_objPos") exitWith {
	["Invalid object, marker or position - %1", _obj] call BIS_fnc_error;
	_ret
};
if (_distance < 0) exitWith {
	["Distance not provided or negative distance"] call BIS_fnc_error;
	_ret
};

switch (typeName _test) do {
	case "OBJECT": {
		if (!isNull _test) then {
			if (_objPos distance _test <= _distance) then {_ret = true};
		} else {
			["Object passed is null: %1", _test] call BIS_fnc_error;
		};
	};

	case "STRING": {
		if (getMarkerColor _test != "") then {
			if (_objPos distance (markerPos _test) <= _distance) then {_ret = true};
		} else {
			["Marker doesn't exist: %1", _test] call BIS_fnc_error;
		};
	};

	case "ARRAY": {
		if (count _test == 0) exitWith {};
		if (typeName (_test select 0) in ["NUMBER","SCALAR"]) then {
			// Testing a position.
			if (_objPos distance _test <= _distance) then {_ret = true};
		} else {
			// Not a position, assume an array of objects / markers / positions.
			{
				if ([_obj, _x, _distance] call ITD_fnc_nearby) exitWith {_ret = true};
			} forEach _test;
		};
	};
};

_ret
