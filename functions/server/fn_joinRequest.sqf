scriptName "fn_joinRequest";
/*
	Author: Bhaz

	Description:
	Request sent to server when a player joins. Server responds by telling
	the client what to do.

	Parameter(s):
	#0 OBJECT - Player

	Returns:
	nil
*/

private ["_player", "_class", "_capacity"];
_player = _this select 0;

if (isNil "INT_global_playerList") then {
	INT_global_playerList = [INT_unit_invisibleMan];
	INT_server_vehicleRoom = 0;
};

// Update joined player list.
INT_global_playerList pushBack _player;
publicVariable "INT_global_playerList";

// Get a vehicle slot for the player.
if (INT_server_vehicleRoom == 0) then {
	// Vehicle classname.
	waitUntil {!isNil "INT_server_spawn_type"};
	if (INT_server_spawn_type == 1) then {
		_class = INT_server_spawn_sea;
		_capacity = INT_server_spawn_capacity select 0;
	} else {
		_class = INT_server_spawn_land;
		_capacity = INT_server_spawn_capacity select 1;
	};

	if (count _class > 1) then {
		private ["_random"];
		_random = floor (random (count _class));
		_class = _class select _random;
		_capacity = _capacity select _random;
	} else {
		_class = _class select 0;
		_capacity = _capacity select 0;
	};
	INT_server_startVehicle = _class createVehicle INT_server_startPosition;
	INT_server_vehicleRoom = _capacity;
};

if (INT_server_vehicleRoom == _capacity) then {
	// Driver slot.
	[[INT_server_startVehicle, true], "INT_fnc_joinResponse", _player] call BIS_fnc_MP;
} else {
	// Cargo slot.
	[[INT_server_startVehicle], "INT_fnc_joinResponse", _player] call BIS_fnc_MP;
};

INT_server_vehicleRoom = INT_server_vehicleRoom - 1;

nil;
