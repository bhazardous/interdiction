scriptName "fn_nearby";
/*
	Author: Bhaz

	Description:
	Check distance between two points. First param can be an object, marker or position.
	Second param can be an object, marker, position, or an array containing any of the three.
	If an array is used, only one test needs to pass to return true.

	Parameter(s):
	#0 OBJECT, STRING, POSITION - Position to test
	#1 OBJECT, STRING, POSITION, (ARRAY) - Position/s to test against
	#2 NUMBER - Distance

	Returns:
	BOOL - true if within distance
*/

private ["_obj", "_test", "_distance", "_ret", "_objPos"];
_obj = [_this, 0, objNull, [objNull, "", []]] call BIS_fnc_param;
_test = [_this, 1, objNull, [objNull, "", []]] call BIS_fnc_param;
_distance = [_this, 2, -1, [0]] call BIS_fnc_param;
_ret = false;

// Get position from _obj.
switch (typeName _obj) do {
	case "OBJECT": {
		if (!isNull _obj) then {
			_objPos = position _obj;
		} else {
			_objPos = nil;
		};
	};

	case "STRING": {
		if (getMarkerColor _obj != "") then {
			_objPos = markerPos _obj;
		} else {
			_objPos = nil;
		};
	};

	case "ARRAY": {
		if (typeName (_obj select 0) in ["NUMBER","SCALAR"]) then {
			_objPos = _obj;
		} else {
			_objPos = nil;
		};
	};
};

if (isNil "_objPos") exitWith {
	["Invalid object, marker or position - %1", _obj] call BIS_fnc_error;
	false;
};

// Is _distance valid?
if (_distance < 0) exitWith {
	["Distance not provided or negative distance"] call BIS_fnc_error;
	false;
};

switch (typeName _test) do {
	case "OBJECT": {
		if (!isNull _test) then {
			if (_objPos distance _test <= _distance) then {
				_ret = true;
			};
		} else {
			["Object passed is null - %1", _test] call BIS_fnc_error;
		};
	};

	case "STRING": {
		if (getMarkerColor _test != "") then {
			private ["_markerPos"];
			_markerPos = markerPos _test;
			if (_objPos distance _markerPos <= _distance) then {
				_ret = true;
			};
		} else {
			["Marker doesn't exist - %1", _test] call BIS_fnc_error;
		};
	};

	case "ARRAY": {
		// Empty array - return false without error.
		if (count _test == 0) exitWith {};

		if (typeName (_test select 0) in ["NUMBER","SCALAR"]) then {
			// Testing a position.
			if (_objPos distance _test <= _distance) then {
				_ret = true;
			};
		} else {
			// Not a position, assume its an array of objects / markers / positions.
			// Test against all.
			{
				if ([_obj, _x, _distance] call INT_fnc_nearby) then {
					_ret = true;
				};

				if (_ret) exitWith {};
			} forEach _test;
		};
	};
};

_ret;
