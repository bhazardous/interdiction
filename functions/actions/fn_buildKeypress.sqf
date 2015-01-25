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

private ["_shift", "_ctrl"];
_shift = _this select 2;
_ctrl = _this select 3;

if (_shift) exitWith {
	// Toggle terrain snapping.
	INT_local_building_snap = !INT_local_building_snap;
	nil;
};

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
