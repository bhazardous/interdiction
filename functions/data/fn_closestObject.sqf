scriptName "fn_closestObject";
/*
	Author: Bhaz

	Description:
	Returns the closest object from an array to a given position.

	Parameter(s):
	#0 POSITION - Position to measure from
	#1 ARRAY - Array of objects

	Example:
	[[300,300,10], _objects] call ITD_fnc_closestObject;

	Returns:
	Object - Closest object to position, objNull on error
*/

if (!params [["_position", [], [[]], [2,3]], ["_objects", [], [[]]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
	objNull
};

private ["_closest", "_distance"];
_closest = objNull;
_distance = 999999;

{
	if (_x distance _position < _distance) then {
		_closest = _x;
		_distance = _x distance _position;
	};
} forEach _objects;

_closest;
