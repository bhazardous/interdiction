scriptName "fn_updatePlayerList";
/*
	Author: Bhaz

	Description:
	Adds or removes and entry from the global player list.

	Parameter(s):
	#0 OBJECT - Player to add / remove.
	#1 BOOL - Add / remove

	Returns:
	nil
*/

private ["_player", "_add"];
_player = [_this, 0, [objNull], [objNull]] call BIS_fnc_param;
_add = [_this, 1, true, [true]] call BIS_fnc_param;

if (_add) then {
	// Add - don't allow duplicates.
	if !(_player in ITD_global_playerList) then {
		ITD_global_playerList pushBack _player;
	};

	if (ITD_global_playerList select 0 == ITD_unit_invisibleMan) then {
		ITD_global_playerList deleteAt 0;
	};
} else {
	// Remove.
	if (player in ITD_global_playerList) then {
		if (count ITD_global_playerList == 1) then {
			ITD_global_playerList = [ITD_unit_invisibleMan];

			// If all players are dead without a camp, start a new spawn wave.
			if (ITD_global_campExists) then {
				[] spawn ITD_fnc_spawnQueue;
			};
		};
	} else {
		ITD_global_playerList = ITD_global_playerList - [_player];
	};
};

publicVariable "ITD_global_playerList";

nil;
