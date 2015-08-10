scriptName "fn_simulateComposition";
/*
	Author: Bhaz

	Description:
	Runs enableSimulation for an entire composition.

	Parameter(s):
	#0 ARRAY - Composition objects
	#1 BOOL - Simulation (default: true)
	#2 BOOL - Damage (default: true)
	#3 BOOL - Global (default: false)

	Example:
	[_composition, false, false, true] call ITD_fnc_simulateComposition;

	Returns:
	Nothing
*/

if (!params [
	["_composition", [], [[]]],
	["_sim", true, [true]],
	["_damage", true, [true]],
	["_global", false, [true]]]) exitWith {["Invalid params"] call BIS_fnc_error};
if (count _composition == 0) exitWith {};

if (!_global) then {
	{_x enableSimulation _sim} forEach _composition;
} else {
	if (!isServer) exitWith {["enableSimulationGlobal attempted on client"] call BIS_fnc_error};
	{_x enableSimulationGlobal _sim} forEach _composition;
};

{_x allowDamage _damage} forEach _composition;
