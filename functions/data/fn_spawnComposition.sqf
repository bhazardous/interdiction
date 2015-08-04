scriptName "fn_spawnComposition";
/*
	Author: Bhaz

	Description:
	Spawns object composition using BIS_fnc_objectGrabber data.

	Parameter(s):
	#0 STRING - Composition name
	#1 POSITION - Anchor point
	#2 NUMBER - Anchor direction
	#3 BOOL (Optional) - Create local only (default: true)

	Returns:
	Array - Objects that were created
*/

if (!params [
	["_name", "", [""]],
	["_pos", [], [[]], [2,3]],
	["_dir", 0, [0]],
	["_local", true, [true]]] exitWith {["Invalid params"] call BIS_fnc_error; []}

private ["_objects", "_fort", "_composition"];
_objects = [];
_fort = ([_name, "fort_"] call CBA_fnc_find != -1);
_composition = [_name] call ITD_fnc_getComposition;

if (count _composition == 0) exitWith {[]};

{
	_x params ["_class", "_objPos", "_objDir"];
	private ["_object"];

	if (_local) then {
		_object = _class createVehicleLocal _objPos;
	} else {
		_object = _class createVehicle _objPos;
	};

	if (isNull _object) exitWith {
		["Failed to create object - %1", _class] call BIS_fnc_error;
	};

	_objPos = [_objPos, _dir] call ITD_fnc_rotateRelative;
	_objPos set [0, (_objPos select 0) + (_pos select 0)];
	_objPos set [1, (_objPos select 1) + (_pos select 1)];
	_objPos set [2, 0];

	_object setPos _objPos;
	_object setDir ((_dir + _objDir) % 360);
	_object setVectorUp (surfaceNormal _objPos);

	// TODO: Make sure ghost buildings can't damage other objects.
	if (!_fort) then {
		_object allowDamage false;
	};

	_objects pushBack _object;
} forEach _composition;

_objects
