scriptName "fn_setVariable";
/*
	Author: Bhaz

	Description:
	Used to remotely set a local variable.

	Parameter(s):
	#0 STRING - Variable
	#1 ANY - Value

	Returns:
	nil
*/

private ["_variable", "_value"];
_variable = [_this, 0, "", [""]] call BIS_fnc_param;
_value = _this select 1;

if (_variable != "") then {
	call compile format ["missionNamespace setVariable ['%1', '%2']", _variable, _value];
} else {
	["No variable name"] call BIS_fnc_error;
};

nil;
