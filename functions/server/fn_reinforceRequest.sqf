scriptName "fn_reinforceRequest";
/*
	Author: Bhaz

	Description:
	Request received by clients for reinforcements.

	Parameter(s):
	#0 OBJECT - Player

	Returns:
	nil
*/

private ["_player"];
_player = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _player) exitWith {};

if (!(_player in ITD_server_reinforceQueue)) then {
	private ["_index"];
	_index = ITD_server_reinforceQueue pushBack _player;

	// Signal success.
	[[_index], "ITD_fnc_reinforcements", _player] call BIS_fnc_MP;
} else {
	// Signal error: already in queue.
	[[-1], "ITD_fnc_reinforcements", _player] call BIS_fnc_MP;
};

nil;
