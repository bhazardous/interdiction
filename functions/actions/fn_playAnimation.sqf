scriptName "fn_playAnimation";
/*
	Author: Bhaz

	Description:
	For playMove / playMoveNow calls that need to be executed locally.

	RemoteExec: Server

	Parameter(s):
	#0 OBJECT - Unit
	#1 STRING - Animation
	#2 BOOL (Optional) - Play animation immediately (default: true)

	Example:
	n/a

	Returns:
	Nothing
*/

params [["_unit", objNull, [objNull]], ["_anim", "", [""]], ["_now", true, [true]]];

if (isNull _unit) exitWith {["Unit is null - %1", _unit] call BIS_fnc_error};
if (_anim == "") exitWith {["Invalid animation"] call BIS_fnc_error};

if (_now) then {
	_unit playMoveNow _anim;
} else {
	_unit playMove _anim;
};
