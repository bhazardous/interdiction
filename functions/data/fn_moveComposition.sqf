scriptName "fn_moveComposition";
/*
	Author: Bhaz

	Description:
	Moves an existing composition to a new position.

	Parameter(s):
	#0 STRING - Composition name
	#1 ARRAY - Objects returned from INT_fnc_spawnComposition
	#2 ARRAY - New position
	#3 NUMBER - New direction

	Returns:
	nil
*/

private ["_compName", "_composition", "_objects", "_pos", "_dir"];
_compName = [_this, 0, "", [""]] call BIS_fnc_param;
_objects = [_this, 1, [], [[]]] call BIS_fnc_param;
_pos = [_this, 2, [0,0,0], [[]], [2,3]] call BIS_fnc_param;
_dir = [_this, 3, 0, [0]] call BIS_fnc_param;

// Get composition.
_composition = [_compName] call INT_fnc_getComposition;

if (count _composition != count _objects) exitWith {
	["Objects don't match composition %1", _compName] call BIS_fnc_error;
	nil;
};

private ["_i"];
_i = 0;

{
	private ["_objPos", "_objDir", "_object"];
	_objPos = _x select 1;
	_objDir = _x select 2;
	_object = _objects select _i;

	// Set position / direction.
	_objPos = [_objPos, _dir] call INT_fnc_rotateRelative;
	_objPos set [0, (_objPos select 0) + (_pos select 0)];
	_objPos set [1, (_objPos select 1) + (_pos select 1)];
	_objPos set [2, 0];

	_object setPos _objPos;
	_object setDir ((_dir + _objDir) % 360);

	_i = _i + 1;
} forEach _composition;

nil;
