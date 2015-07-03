scriptName "fn_closestMarker";
/*
	Author: Bhaz

	Description:
	Return the marker closest to the given object.

	Parameter(s):
	#0 OBJECT - Any object
	#1 STRING - Marker prefix
	#2 NUMBER - Marker suffix, testing from 1 to number

	Returns:
	NUMBER - marker number closest to object
*/

private ["_object", "_marker", "_number", "_closest", "_distance", "_markerPos"];
_object = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_marker = [_this, 1, "", [""]] call BIS_fnc_param;
_number = [_this, 2, 0, [0]] call BIS_fnc_param;
_distance = 99999;

for "_i" from 1 to _number do {
	_markerPos = markerPos (format ["%1%2", _marker, _i]);
	if (_object distance _markerPos < _distance) then {
		_closest = _i;
		_distance = _object distance _markerPos;
	};
};

_closest;
