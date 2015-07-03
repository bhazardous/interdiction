scriptName "fn_closestObject";
/*
	Author: Bhaz

	Description:
	Gets the closest object from an array to a given position.

	Parameter(s):
	#0 POSITION - Position to compare to
	#1 ARRAY - Array of objects

	Returns:
	OBJECT - Closest object to position
*/

private ["_position", "_objects", "_closest", "_distance"];
_position = [_this, 0, [0,0,0], [[]], [2,3]] call BIS_fnc_param;
_objects = [_this, 1, [], [[]]] call BIS_fnc_param;
_distance = 999999;

{
	if ((_x distance _position) < _distance) then {
		_closest = _x;
		_distance = _x distance _position;
	};
} forEach _objects;

_closest;
