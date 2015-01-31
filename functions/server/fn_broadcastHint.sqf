scriptName "fn_broadcastHint";
/*
	Author: Bhaz

	Description:
	Broadcasts a BIS_fnc_advHint to all players.

	Parameter(s):
	#0 ARRAY - Hint classes from mission config
	#1 BOOL - (Optional) Force show, default true
	#2 BOOL - (Optional) Full hint, default true
	#3 BOOL - (Optional) Only once, default true
	#4 OBJECT, ARRAY[objects], BOOL, NUMBER, SIDE, GROUP - BIS_fnc_MP target (OPTIONAL)

	Returns:
	nil
*/

private ["_class", "_force", "_full", "_onlyOnce"];
_class = [_this, 0, [], [[]]] call BIS_fnc_param;
_force = [_this, 1, true, [true]] call BIS_fnc_param;
_full = [_this, 2, true, [true]] call BIS_fnc_param;
_onlyOnce = [_this, 3, true, [true]] call BIS_fnc_param;
_target = [_this, 4, false, [objNull, [], true, 0, west, grpNull]] call BIS_fnc_param;

// Send to all players.
[[_class, 15, "", 35, "", _force, _full, _onlyOnce], "BIS_fnc_advHint", _target] call BIS_fnc_MP;

nil;
