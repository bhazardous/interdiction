scriptName "fn_moveComposition";
/*
	Author: Bhaz

	Description:
	Moves an existing composition to a new position.

	Parameter(s):
	#0 STRING - Composition name
	#1 ARRAY - Composition objects
	#2 POSITION - New position
	#3 NUMBER - Direction

	Example:
	n/a

	Returns:
	Nothing
*/

if (!params [
		["_name", "", [""]],
		["_objects", [], [[]]],
		["_pos", [], [[]], [2,3]],
		["_dir", 0, [0]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_composition"];
_composition = [_name] call ITD_fnc_getComposition;

if (count _composition != count _objects) exitWith {
	["Objects don't match composition: %1", _name] call BIS_fnc_error;
};

{
	private ["_obj", "_objPos", "_objDir"];
	_obj = _objects select _forEachIndex;
	_objPos = _x select 1;
	_objDir = _x select 2;

	_objPos = [_objPos, _dir] call ITD_fnc_rotateRelative;
	_objPos set [0, (_objPos select 0) + (_pos select 0)];
	_objPos set [1, (_objPos select 1) + (_pos select 1)];
	_objPos set [2, 0];

	_obj setPos _objPos;
	_obj setDir ((_dir + _objDir) % 360);
	_obj setVectorUp (surfaceNormal _objPos);
} forEach _composition;
