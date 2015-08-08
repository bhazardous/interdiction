scriptName "fn_joinRequest";
/*
	Author: Bhaz

	Description:
	Request sent to server when a player joins.

	RemoteExec: Client

	Parameter(s):
	#0 OBJECT - Player

	Example:
	n/a

	Returns:
	Nothing
*/

if (!params [["_player", objNull, [objNull]]]) exitWith {["Invalid params"] call BIS_fnc_error};
if (isNull _player) exitWith {["Null player"] call BIS_fnc_error};

ITD_server_spawnQueue pushBack (_player);
