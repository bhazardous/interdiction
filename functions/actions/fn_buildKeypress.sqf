scriptName "fn_buildKeypress";
/*
	Author: Bhaz

	Description:
	Grabs keypresses when building.

	Parameter(s):
	#0 ARRAY - Output from CBA event

	Returns:
	nil
*/

private ["_ctrl"];
_ctrl = _this select 3;

if (_ctrl) then {
	// Abort.
	INT_local_building_action = "abort";
	INT_local_building = false;
} else {
	// Place.
	INT_local_building_action = "build";
	INT_local_building = false;
};

nil;
