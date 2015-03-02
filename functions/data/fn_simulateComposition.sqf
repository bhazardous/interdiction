scriptName "fn_simulateComposition";
/*
	Author: Bhaz

	Description:
	Runs enableSimulation for a composition, since the effects are only local.

	Parameter(s):
	#0 ARRAY - Composition objects
	#1 BOOL - Simulated

	Returns:
	nil
*/

private ["_composition", "_enabled"];

_composition = [_this, 0, [], [[]]] call BIS_fnc_param;
_enabled = [_this, 1, true, [true]] call BIS_fnc_param;

{
	_x enableSimulation _enabled;
	_x allowDamage _enabled;
} forEach _composition;

nil;
