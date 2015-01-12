scriptName "fn_checkPresence";
/*
	Author: Bhaz

	Description:
	Checks presence of a side at location, both real units and ALiVE profiles.

	Parameter(s):
	#0 SIDE - Side to check for.
	#1 POSITION - Centre.
	#2 NUMBER - Radius.

	Returns:
	bool - Units of side present
*/

private ["_side", "_sideStr", "_position", "_radius", "_ret"];
_side = _this select 0;
_position = _this select 1;
_radius = _this select 2;

_sideStr = switch (_side) do {
	case west: {"WEST"};
	case east: {"EAST"};
	case resistance: {"GUER"};
};

_ret = ({side _x == _side} count nearestObjects [_position, ["Man", "Car", "Tank"], _radius] > 0);
if (!_ret) then {
	_ret = (count ([_position, _radius, [_sideStr, "entity"]] call ALiVE_fnc_getNearProfiles) > 0);
};

_ret;
