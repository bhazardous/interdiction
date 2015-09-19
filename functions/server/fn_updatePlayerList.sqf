scriptName "fn_updatePlayerList";
/*
	Author: Bhaz

	Description:
	Adds or removes and entry from the global player list.

	Parameter(s):
	#0 OBJECT - Player to add / remove.
	#1 BOOL - Add / remove

	Example:
	n/a

	Returns:
	Nothing
*/

if (!isServer) exitWith {};

if (!params [["_player", objNull, [objNull]], ["_action", "", [""]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_modified"];
_modified = false;

switch (_action) do {
	case "add": {
		// Add - don't allow duplicates.
		if !(_player in ITD_global_playerList) then {
			ITD_global_playerList pushBack _player;
			_modified = true;
		};

		if (ITD_global_playerList select 0 == ITD_unit_invisibleMan) then {
			ITD_global_playerList deleteAt 0;
			_modified = true;
		};
	};

	case "remove": {
		if (_player in ITD_global_playerList) then {
			if (count ITD_global_playerList == 1) then {
				ITD_global_playerList = [ITD_unit_invisibleMan];
			} else {
				ITD_global_playerList = ITD_global_playerList - [_player];
			};
			_modified = true;
		};
	};
};

if (_modified) then {publicVariable "ITD_global_playerList"};
