scriptName "fn_rotateRelative";
/*
	Author: Bhaz

	Description:
	Rotates an X,Y relative position clockwise around the centre.

	Parameter(s):
	#0 POSITION - Relative position
	#1 NUMBER - Rotation in degrees

	Example:
	n/a

	Returns:
	Position - position after rotation
*/

if (!params [["_pos", [], [[]], [2,3]], ["_rot", 0, [0]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
	[0,0,0]
};

_rot = _rot % 360;
if (_rot == 0) exitWith {_pos};
private ["_rotMatrix"];

/*
	R(-0) =	[cos 0	sin 0]
			[-sin 0	cos 0] */
_rotMatrix = [[cos _rot, sin _rot], [-(sin _rot), cos _rot]];
/*
	[cos 0	sin 0] [x]
	[-sin 0	cos 0] [y] */
[((_rotMatrix select 0 select 0) * (_pos select 0)) + ((_rotMatrix select 0 select 1) * (_pos select 1)),
 ((_rotMatrix select 1 select 0) * (_pos select 0)) + ((_rotMatrix select 1 select 1) * (_pos select 1))]
