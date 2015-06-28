scriptName "playerStart";
/*--------------------------------------------------------------------
	file: playerStart.sqf
	=====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "playerStart.sqf"
#define DEBUG_BLUFOR false
#define DEBUG_OPFOR false

// Get a random position from the spawn markers.
private ["_marker", "_position"];
_marker = format ["ITD_mkr_spawn%1", floor(random ITD_server_spawn_markers)];
_position = [_marker] call BIS_fnc_randomPosTrigger;
ITD_server_startPosition = _position;

// Start a spawn wave.
ITD_server_spawnQueue = [];
[] spawn {
	scriptName "playerStart_spawner";

	// Spawn waves begin when all players are dead, and are no longer required
	// after a camp is built.
	while {!ITD_global_campExists} do {
		if (count ITD_global_playerList == 1
			&& {ITD_global_playerList select 0 == ITD_unit_invisibleMan}) then {
			[] call ITD_fnc_spawnQueue;
		};
		sleep 15;
	};
};

// Switch to debug unit if in the editor.
if (DEBUG_OPFOR) then {
	if (hasInterface) then {
		selectPlayer ITD_unit_testPlayer;
	} else {
		deleteVehicle ITD_unit_testPlayer;
	};
} else {
	deleteVehicle ITD_unit_testPlayer;
};

if (DEBUG_BLUFOR) then {
	if (hasInterface) then {
		[] spawn {
			waitUntil {time > 2};
			player setPos [2099.27,4161.88,0];
		};
	};
};
