scriptName "fn_reinforceRequest";
/*
	Author: Bhaz

	Description:
	Request received by clients for reinforcements.

	RemoteExec: Client

	Parameter(s):
	#0 OBJECT - Player

	Example:
	n/a

	Returns:
	Nothing
*/

if (!isServer) exitWith {};

if (!params [["_player", objNull, [objNull]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};
if (isNull _player) exitWith {};

if (!(_player in ITD_server_reinforceQueue)) then {
	private ["_index"];
	_index = ITD_server_reinforceQueue pushBack _player;
	[[_index], "ITD_fnc_reinforcements", _player] call BIS_fnc_MP;
} else {
	[[-1], "ITD_fnc_reinforcements", _player] call BIS_fnc_MP;
};
