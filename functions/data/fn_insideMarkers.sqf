scriptName "fn_insideMarkers";
/*
	Author: Bhaz

	Description:
	Checks if position is inside any of the given markers.

	Parameter(s):
	#0 POSITION - Position to check
	#1 ARRAY - List of markers to search

	Returns:
	BOOL - true if inside
*/

private ["_position", "_markers", "_ret"];
_position = [_this, 0, [0,0,0], [[]], [2,3]] call BIS_fnc_param;
_markers = [_this, 1, [], [[]]] call BIS_fnc_param;
_ret = false;

{
	_ret = [_x, _position] call BIS_fnc_inTrigger;
	if (_ret) exitWith {};
} forEach _markers;

_ret;
