scriptName "fn_spawnComposition";
/*
	Author: Bhaz

	Description:
	Spawns object composition using BIS_fnc_objectGrabber data.

	Parameter(s):
	#0 STRING - Composition name
	#1 POSITION - Anchor point
	#2 NUMBER - Anchor direction
	#3 BOOL (OPTIONAL) - Create local only (default: true)

	Returns:
	ARRAY - all the objects created
*/

private ["_objects", "_compName", "_composition", "_pos", "_dir", "_fort"];
_compName = [_this, 0, "", [""]] call BIS_fnc_param;
_pos = [_this, 1, [0,0,0], [[]], [2,3]] call BIS_fnc_param;
_dir = [_this, 2, 0, [0]] call BIS_fnc_param;
_local = [_this, 3, true, [true]] call BIS_fnc_param;
_objects = [];
_fort = ([_compName, "fort_"] call CBA_fnc_find != -1);

// Get composition.
_composition = [_compName] call INT_fnc_getComposition;
if (count _composition == 0) exitWith {
	["Composition not found - %1", _compName] call BIS_fnc_error;
	[];
};

// Spawn objects.
{
	private ["_class", "_objPos", "_objDir", "_object"];
	_class = _x select 0;
	_objPos = _x select 1;
	_objDir = _x select 2;

	// Create the object.
	if (_local) then {
		_object = _class createVehicleLocal _objPos;
	} else {
		_object = _class createVehicle _objPos;
	};

	if (isNull _object) exitWith {
		["Failed to create object - %1", _class] call BIS_fnc_error;
	};

	// Set position / direction.
	_objPos = [_objPos, _dir] call INT_fnc_rotateRelative;
	_objPos set [0, (_objPos select 0) + (_pos select 0)];
	_objPos set [1, (_objPos select 1) + (_pos select 1)];
	_objPos set [2, 0];

	_object setPos _objPos;
	_object setDir ((_dir + _objDir) % 360);
	_object setVectorUp (surfaceNormal _objPos);

	// Other.
	if (!_fort) then {
		// _object enableSimulation false;
		_object allowDamage false;
	};

	// Add to array.
	_objects pushBack _object;
} forEach _composition;

_objects;
