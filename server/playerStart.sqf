scriptName "playerStart";
/*--------------------------------------------------------------------
	file: playerStart.sqf
	=====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "playerStart.sqf"

#define DEBUG false

// Marker data for Stratis.
private ["_spawnMarker"];
_spawnMarker = createMarkerLocal ["INT_mkr_spawn0", [5800,2500]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [2900,200];
_spawnMarker setMarkerDirLocal 132;
_spawnMarker setMarkerAlphaLocal 0;

_spawnMarker = createMarkerLocal ["INT_mkr_spawn1", [736.397,2423.59]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [200,2000];
_spawnMarker setMarkerDirLocal 0;
_spawnMarker setMarkerAlphaLocal 0;

_spawnMarker = createMarkerLocal ["INT_mkr_spawn2", [6524.6,7084.68]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [1500,200];
_spawnMarker setMarkerDirLocal 33;
_spawnMarker setMarkerAlphaLocal 0;

"respawn_west" setMarkerAlpha 0;

// Get a random position from the above markers.
private ["_marker", "_position"];
_marker = format ["INT_mkr_spawn%1", floor(random 3)];
_position = [_marker] call BIS_fnc_randomPosTrigger;
INT_server_startPosition = _position;

if (DEBUG) then {
	hint format ["Spawn position: %1", _position];
	copyToClipboard format ["%1", _position];
};

// Allow some players to load late.
[] spawn {
	INT_global_canJoin = true;
	publicVariable "INT_global_canJoin";
	sleep 30;
	INT_global_canJoin = false;
	publicVariable "INT_global_canJoin";
};

// Switch to debug unit if in the editor.
if (DEBUG) then {
	if (hasInterface) then {
		selectPlayer INT_unit_testPlayer;
	} else {
		deleteVehicle INT_unit_testPlayer;
	};
} else {
	deleteVehicle INT_unit_testPlayer;
};

// Enable building for players.
INT_global_buildingEnabled = true;
publicVariable "INT_global_buildingEnabled";
INT_global_campExists = false;
publicVariable "INT_global_campExists";
