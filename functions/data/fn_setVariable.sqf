scriptName "fn_setVariable";
/*
	Author: Bhaz

	Description:
	Used to remotely set a local variable.

	RemoteExec: Server

	Parameter(s):
	#0 STRING - Variable
	#1 ANY - Value

	Example:
	[["derp", 5], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;

	Returns:
	Nothing
*/

if (!params [["_variable", "", [""]], "_value"]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

if (_variable == "") exitWith {["Empty variable name"] call BIS_fnc_error};
missionNamespace setVariable [_variable, _value];
