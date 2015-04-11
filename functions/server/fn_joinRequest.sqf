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

private ["_player", "_class"];
_player = _this select 0;

if (isNil "ITD_global_playerList") then {
	ITD_global_playerList = [ITD_unit_invisibleMan];
};

if (isNil "ITD_server_vehicleRoom") then {
	ITD_server_vehicleRoom = 0;
};

// Update joined player list.
ITD_global_playerList pushBack _player;
publicVariable "ITD_global_playerList";

// Get a vehicle slot for the player.
if (ITD_server_vehicleRoom == 0) then {
	// Vehicle classname.
	waitUntil {!isNil "ITD_server_spawn_type"};
	if (ITD_server_spawn_type == 1) then {
		_class = ITD_server_spawn_sea;
		ITD_server_vehicleCapacity = ITD_server_spawn_capacity select 0;
	} else {
		_class = ITD_server_spawn_land;
		ITD_server_vehicleCapacity = ITD_server_spawn_capacity select 1;
	};

	if (count _class > 1) then {
		private ["_random"];
		_random = floor (random (count _class));
		_class = _class select _random;
		ITD_server_vehicleCapacity = ITD_server_vehicleCapacity select _random;
	} else {
		_class = _class select 0;
		ITD_server_vehicleCapacity = ITD_server_vehicleCapacity select 0;
	};
	ITD_server_startVehicle = _class createVehicle ITD_server_startPosition;
	ITD_server_vehicleRoom = ITD_server_vehicleCapacity;
};

if (ITD_server_vehicleRoom == ITD_server_vehicleCapacity) then {
	// Driver slot.
	[[ITD_server_startVehicle, true], "ITD_fnc_joinResponse", _player] call BIS_fnc_MP;
} else {
	// Cargo slot.
	[[ITD_server_startVehicle], "ITD_fnc_joinResponse", _player] call BIS_fnc_MP;
};

ITD_server_vehicleRoom = ITD_server_vehicleRoom - 1;

nil;
