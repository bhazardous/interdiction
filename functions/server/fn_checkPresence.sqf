scriptName "fn_checkPresence";
/*
	Author: Bhaz

	Description:
	Checks presence of a side at location, both real units and ALiVE profiles.

	Parameter(s):
	#0 SIDE - Presence for this side
	#1 POSITION - Centre
	#2 NUMBER - Radius

	Example:
	_present = [west, _pos, 200] call ITD_fnc_checkPresence;
	if ([west, _pos, 200] call ITD_fnc_checkPresence) then {

	Returns:
	Bool - Is present
*/

if (!isServer) exitWith {};

if (!params [["_side", west, [west]], ["_position", [], [[]], [2,3]], ["_radius", 0, [0]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_sideStr"];
_sideStr = switch (_side) do {
	case west: {"WEST"};
	case east: {"EAST"};
	case resistance: {"GUER"};
};

if ({side _x == _side} count nearestObjects [_position, ["Man", "Car", "Tank"], _radius] > 0) exitWith {true};
if (count ([_position, _radius, [_sideStr, "entity"]] call ALiVE_fnc_getNearProfiles) > 0) exitWith {true};

false
