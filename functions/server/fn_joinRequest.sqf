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

private ["_player"];
_player = _this select 0;

if (isNil "INT_global_playerList") then {
	INT_global_playerList = [];
	INT_server_vehicleRoom = 0;
};

// Update joined player list.
INT_global_playerList pushBack _player;
publicVariable "INT_global_playerList";

// Get a vehicle slot for the player.
if (INT_server_vehicleRoom == 0) then {
	INT_server_startVehicle = "B_Boat_Transport_01_F" createVehicle INT_server_startPosition;
	INT_server_vehicleRoom = 5;
};

if (INT_server_vehicleRoom == 5) then {
	// Driver slot.
	[[INT_server_startVehicle, true], "INT_fnc_joinResponse", _player] call BIS_fnc_MP;
} else {
	// Cargo slot.
	[[INT_server_startVehicle], "INT_fnc_joinResponse", _player] call BIS_fnc_MP;
};

INT_server_vehicleRoom = INT_server_vehicleRoom - 1;

nil;
