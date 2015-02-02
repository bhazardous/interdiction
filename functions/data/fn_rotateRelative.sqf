scriptName "fn_rotateRelative";
/*
	Author: Bhaz

	Description:
	Rotates an X,Y relative position clockwise around the centre.

	Parameter(s):
	#0 POSITION - Relative position
	#1 NUMBER - Rotation in degrees

	Returns:
	POSITION - position after rotation
*/

private ["_pos", "_rot", "_rotMatrix", "_ret"];
_pos = [_this, 0, [0,0], [[]], [2,3]] call BIS_fnc_param;
_rot = [_this, 1, 0, [0]] call BIS_fnc_param;

/*
	R(-0) =	[cos 0	sin 0]
			[-sin 0	cos 0] */
_rotMatrix = [[cos _rot, sin _rot], [-(sin _rot), cos _rot]];

/*
	[cos 0	sin 0] [x]
	[-sin 0	cos 0] [y] */
_ret = [((_rotMatrix select 0 select 0) * (_pos select 0)) + ((_rotMatrix select 0 select 1) * (_pos select 1)),
	((_rotMatrix select 1 select 0) * (_pos select 0)) + ((_rotMatrix select 1 select 1) * (_pos select 1))];

_ret;
