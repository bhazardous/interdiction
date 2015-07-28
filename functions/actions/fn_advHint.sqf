scriptName "fn_advHint";
/*
	Author: Bhaz

	Description:
	Simplified use of BIS_fnc_advHint.

	RemoteExec: Server

	Parameter(s):
	#0 ARRAY - Class name inside CfgHints
	#1 NUMBER (Optional) - Full hint duration, < 0 for default (default: 35s)
	#2 BOOL (Optional) - Display hint only once (default: false)
	#3 BOOL (Optional) - Force full hint (default: true)

	Example:
	[["ITD_Guide","Interdiction"], -1, true] call ITD_fnc_advHint;

	Returns:
	Nothing
*/

if (!hasInterface) exitWith {};
if (!params [["_class", [], [[]], [2,3]]]) exitWith {
	["Invalid CfgHints class name"] call BIS_fnc_error;
};

private ["_duration", "_once", "_full"];
_duration = param [1, 35, [0]];
_once = param [2, false, [true]];
_full = param [3, true, [true]];

if (_duration < 0) then {_duration = 35};
[_class, 15, "", _duration, "", true, _full, _once] call BIS_fnc_advHint;
