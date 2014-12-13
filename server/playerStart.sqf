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
//_spawnMarker setMarkerAlphaLocal 0;

_spawnMarker = createMarkerLocal ["INT_mkr_spawn1", [736.397,2423.59]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [200,2000];
_spawnMarker setMarkerDirLocal 0;
//_spawnMarker setMarkerAlphaLocal 0;

_spawnMarker = createMarkerLocal ["INT_mkr_spawn2", [6524.6,7084.68]];
_spawnMarker setMarkerShapeLocal "RECTANGLE";
_spawnMarker setMarkerSizeLocal [1500,200];
_spawnMarker setMarkerDirLocal 33;
//_spawnMarker setMarkerAlphaLocal 0;

// Get a random position from the above markers.
private ["_marker", "_position"];
_marker = format ["INT_mkr_spawn%1", floor(random 2)];
_position = [_marker] call BIS_fnc_randomPosTrigger;
if (DEBUG) then {
	hint format ["Spawn position: %1", _position];
	copyToClipboard format ["%1", _position];
};

// Count players.
private ["_players"];
_players = [];
{
	if (!isNull _x) then {
		_players pushBack _x;
	};
} forEach [INT_unit_player1, INT_unit_player2, INT_unit_player3, INT_unit_player4, INT_unit_player5];

// Spawn starting vehicle(s).
private ["_vehicleCount", "_vehicles"];
_vehicleCount = ceil (count _players / 3);
_vehicles = [];

for "_i" from 1 to _vehicleCount do {
	private ["_vehicle"];
	_vehicle = "C_Boat_Civil_01_F" createVehicle _position;
	_vehicle setDir (random 360);
	_vehicles pushBack _vehicle;
	_position set [0, (_position select 0) + 10];
};

// Throw players in the vehicle.
private ["_vehicleHasDriver", "_vehicleRoom", "_vehicleIndex"];
_vehicleHasDriver = false;
_vehicleRoom = 3;
_vehicleIndex = 0;
{
	if (!_vehicleHasDriver) then {
		_x moveInDriver (_vehicles select _vehicleIndex);
		_vehicleHasDriver = true;
	} else {
		_x moveInCargo (_vehicles select _vehicleIndex);
	};
	_vehicleRoom = _vehicleRoom - 1;

	if (_vehicleRoom == 0) then {
		_vehicleIndex = _vehicleIndex + 1;
		_vehicleRoom = 3;
		_vehicleHasDriver = false;
	};
} forEach _players;

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

// Add camp action to current players.
[[true], "INT_fnc_toggleCampConstruction", true, false, false] call BIS_fnc_MP;
INT_server_buildingEnabled = true;
