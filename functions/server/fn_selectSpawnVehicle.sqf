scriptName "fn_selectSpawnVehicle";
/*
	Author: Bhaz

	Description:
	Returns a spawn vehicle type and its capacity.

	Parameter(s):
	None

	Example:
	n/a

	Returns:
	Array - [vehicle classname, capacity]
*/

if (!isServer) exitWith {};

private ["_class", "_index", "_capacity"];
waitUntil {!isNil "ITD_server_spawn_type"};

if (ITD_server_spawn_type == 1) then {
	_class = ITD_server_spawn_sea;
} else {
	_class = ITD_server_spawn_land;
};

_index = floor (random (count _class));
_class = _class select _index;
_capacity = ITD_server_spawn_capacity select ITD_server_spawn_type select _index;

[_class, _capacity]
