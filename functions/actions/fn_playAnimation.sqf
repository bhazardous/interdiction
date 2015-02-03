scriptName "fn_playAnimation";
/*
	Author: Bhaz

	Description:
	For playMove / playMoveNow calls that need to be executed locally.

	Parameter(s):
	#0 OBJECT - Unit
	#1 STRING - Animation
	#2 BOOL (OPTIONAL) - Now, default true

	Returns:
	nil
*/

private ["_unit", "_anim", "_now"];
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_anim = [_this, 1, "", [""]] call BIS_fnc_param;
_now = [_this, 2, true, [true]] call BIS_fnc_param;

if (isNull _unit) exitWith {
	["Unit is null - %1", _unit] call BIS_fnc_error;
	nil;
};
if (_anim == "") exitWith {
	["No animation"] call BIS_fnc_error;
	nil;
};

if (_now) then {
	_unit playMoveNow _anim;
} else {
	_unit playMove _anim;
};

nil;
