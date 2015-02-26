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

"respawn_west" setMarkerAlpha 0;

// Get a random position from the spawn markers.
private ["_marker", "_position"];
_marker = format ["INT_mkr_spawn%1", floor(random INT_server_spawn_markers)];
_position = [_marker] call BIS_fnc_randomPosTrigger;
INT_server_startPosition = _position;

// Allow some players to load late.
[] spawn {
	INT_global_canJoin = true;
	publicVariable "INT_global_canJoin";
	sleep 30;
	INT_global_canJoin = false;
	publicVariable "INT_global_canJoin";
};

// Switch to debug unit if in the editor.
if (DEBUG_OPFOR) then {
	if (hasInterface) then {
		selectPlayer INT_unit_testPlayer;
	} else {
		deleteVehicle INT_unit_testPlayer;
	};
} else {
	deleteVehicle INT_unit_testPlayer;
};

if (DEBUG_BLUFOR) then {
	if (hasInterface) then {
		[] spawn {
			waitUntil {time > 2};
			player setPos [2099.27,4161.88,0];
		};
	};
};
