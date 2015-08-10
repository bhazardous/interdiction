scriptName "fn_insideMarkers";
/*
	Author: Bhaz

	Description:
	Checks if position is inside any of the given markers. Markers need to be rectangle / ellipse.

	Parameter(s):
	#0 POSITION - Position to check
	#1 ARRAY - List of markers to search

	Example:
	_inside = [[10,20,30], _markers] call ITD_fnc_insideMarkers;

	Returns:
	Bool - Position is inside
*/

if (!params [["_position", [], [[]], [2,3]], ["_markers", [], [[]]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_ret"];
_ret = false;
{
	if ([_x, _position] call BIS_fnc_inTrigger) exitWith {_ret = true};
} forEach _markers;

_ret
