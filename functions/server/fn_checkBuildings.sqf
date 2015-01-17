scriptName "fn_checkBuildings";
/*
	Author: Bhaz

	Description:
	Checks if any of the given buildings are alive.

	Parameter(s):
	#0 ARRAY - List of buildings [object ids, position]
	#1 POSITION - Objective position (used to optimize object search)

	Returns:
	bool - all buildings destroyed (true), buildings alive (false)
*/

private ["_buildings", "_position", "_ret"];
_buildings = [_this, 0, [], [[]]] call BIS_fnc_param;
_position = _this select 1;
_ret = true;

{
	private ["_building"];
	_building = _position nearestObject _x;
	if (getDammage _building < 1) then {
		_ret = false;
	};
} forEach _buildings;

_ret;
