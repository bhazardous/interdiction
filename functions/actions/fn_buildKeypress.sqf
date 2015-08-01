scriptName "fn_buildKeypress";
/*
	Author: Bhaz

	Description:
	Grabs keypresses when building.

	Parameter(s):
	#0 ARRAY - Output from CBA event

	Example:
	n/a

	Returns:
	Boolean - Swallow the CBA keypress
*/

if (!ITD_local_building) exitWith {false};

private ["_ctrl"];
_ctrl = param [3, false, [true]];

if (_ctrl) then {
	ITD_local_building_action = "abort";
} else {
	ITD_local_building_action = "build";
};

ITD_local_building = false;
true;
