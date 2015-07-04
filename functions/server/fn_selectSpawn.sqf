scriptName "fn_selectSpawn";
/*
	Author: Bhaz

	Description:
	Grabs a random spawn position and handles the marker.

	Parameter(s):
	None

	Returns:
	nil
*/

private ["_marker", "_position"];

// Select a spawn point.
_marker = format ["ITD_mkr_spawn%1", floor(random ITD_server_spawn_markers)];
_position = [_marker] call BIS_fnc_randomPosTrigger;
ITD_server_startPosition = _position;

// Terminate current script if there was one.
if (!isNil "ITD_server_spawnMarkerScript") then {
	if (!scriptDone ITD_server_spawnMarkerScript) then {
		terminate ITD_server_spawnMarkerScript;
	};
};

// Handle the spawn marker.
[] spawn {
	// Create the marker if it doesn't exist.
	if (getMarkerColor "ITD_mkr_spawnPos" == "") then {
		createMarker ["ITD_mkr_spawnPos", ITD_server_startPosition];
		"ITD_mkr_spawnPos" setMarkerShape "ICON";
		"ITD_mkr_spawnPos" setMarkerColor "ColorWEST";
		"ITD_mkr_spawnPos" setMarkerType "c_ship";
	};

	private ["_opacity"];
	_opacity = 1.0;

	while {_opacity > 0.0} do {
		sleep 20;
		_opacity = _opacity - 0.05;
		"ITD_mkr_spawnPos" setMarkerAlpha _opacity;
	};

	deleteMarker "ITD_mkr_spawnPos";
};

nil;
