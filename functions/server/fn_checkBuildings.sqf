scriptName "fn_checkBuildings";
/*
	Author: Bhaz

	Description:
	Checks if any of the given buildings are alive.

	Parameter(s):
	#0 ARRAY - List of buildings [object ids, position]
	#1 POSITION - Objective position (used to optimize object search)

	Example:
	n/a

	Returns:
	Bool - all buildings destroyed (true), buildings alive (false)
*/

if (!isServer) exitWith {};

if (!params [["_buildings", [], [[]]], ["_position", [], [[]], [2,3]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_ret"];
_ret = true;

{
	private ["_building"];
	_building = _position nearestObject _x;
	if (getDammage _building < 1) exitWith {_ret = false};
} forEach _buildings;

_ret
