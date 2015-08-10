scriptName "fn_closestPosition";
/*
	Author: Bhaz

	Description:
	Returns the array index of the closest position from an array of given positions.

	Parameter(s):
	#0 OBJECT - Check distance to this object
	#1 ARRAY - List of positions

	Example:
	_index = [player, _positionsArray] call ITD_fnc_closestPosition;

	Returns:
	Number - Array index of closest position, -1 for nothing
*/

if (!params [["_object", objNull, [objNull]], ["_positions", [], [[]]]]) exitWith {
	["Invalid parameters"] call BIS_fnc_error;
};
if (isNull _object) exitWith {["Null object given"] call BIS_fnc_error};

private ["_closest", "_index"];
_closest = 9999999;
_index = -1;

{
	if (_object distance _x < _closest) then {
		_index = _forEachIndex;
		_closest = _object distance _x;
	};
} forEach _positions;

_index
