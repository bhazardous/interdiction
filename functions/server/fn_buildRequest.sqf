scriptName "fn_buildRequest";
/*
	Author: Bhaz

	Description:
	Request sent from players to construct a campsite.

	Parameter(s):
	#0 ARRAY - Params sent from BIS_fnc_MP
		#0 OBJECT - Player sending the request

	Returns:
	nil
*/

private ["_player"];
_player = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
hint format ["%1", _player];

if (isNull _player) exitWith {
	"Build request sent from objNull" call BIS_fnc_log;
	nil;
};

if (INT_server_buildingEnabled) then {
	// Make sure the position is valid.
	private ["_campPosition"];
	_campPosition = _player modelToWorld [0,1,0];
	_campPosition = _campPosition isFlatEmpty [0,0,1.0,7,0, false, _player];
	if (count _campPosition == 0) exitWith {
		hint "Invalid position";
		[[true], "INT_fnc_toggleCampConstruction", _player, false, false] call BIS_fnc_MP;
	};

	// Position is valid - create object.
	private ["_tent", "_campMarker", "_spawnMarker"];
	_tent = "Land_TentDome_F" createVehicle _campPosition;
	_tent setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];
	[[false], "INT_fnc_toggleCampConstruction", true, false, false] call BIS_fnc_MP;

	// Enable respawning at this camp.
	_campMarker = createMarker ["INT_mkr_resistanceCamp", _campPosition];
	_campMarker setMarkerType "b_hq";
	_campMarker setMarkerText "Camp";

	_spawnMarker = createMarker ["INT_mkr_resistanceCampSpawn", _campPosition];
	_spawnMarker setMarkerAlpha 0;
	_spawnMarker setMarkerShape "RECTANGLE";
	_spawnMarker setMarkerSize [25,25];
	"respawn_west" setMarkerPos _campPosition;

	INT_global_campExists = true;
	publicVariable "INT_global_campExists";
} else {
	"Build request arrived, but INT_server_buildingEnabled is false" call BIS_fnc_log;
};

nil;
