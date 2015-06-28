scriptName "fn_spawnQueue";
/*
	Author: Bhaz

	Description:
	Spawns a wave of players when called.

	Parameter(s):
	None

	Returns:
	nil
*/

#define WAIT_TIME 15
#define SLEEP_TIME 1

ITD_global_canJoin = true;
publicVariable "ITD_global_canJoin";

waitUntil {!isNil "ITD_server_spawnQueue"};
waitUntil {count ITD_server_spawnQueue > 0};
sleep WAIT_TIME;

private ["_capacity", "_maxPlayers", "_vehicle"];
_capacity = 0;
_maxPlayers = 0;

while {count ITD_server_spawnQueue > 0} do {
	private ["_player", "_newVehicleRequired", "_spawnAI"];
	_player = ITD_server_spawnQueue select 0;
	_newVehicleRequired = false;

	// Take a max player count.
	if (count ITD_server_spawnQueue > _maxPlayers) then {
		_maxPlayers = count ITD_server_spawnQueue;
	};

	// Spawn a new vehicle if required.
	if (_maxPlayers < 5) then {
		if (_capacity < 4) then {
			_newVehicleRequired = true;
			_spawnAI = true;
		};
	} else {
		if (_capacity == 0) then {
			_newVehicleRequired = true;
			_spawnAI = false;
		};
	};

	if (_newVehicleRequired) then {
		private ["_vehicleInfo"];
		_vehicleInfo = [] call ITD_fnc_selectSpawnVehicle;
		_vehicle = (_vehicleInfo select 0) createVehicle ITD_server_startPosition;
		_capacity = _vehicleInfo select 1;

		// New vehicle, place player in driver.
		[[_vehicle, true], "ITD_fnc_joinResponse", _player] call BIS_fnc_MP;
	} else {
		// Old vehicle, player in cargo.
		[[_vehicle], "ITD_fnc_joinResponse", _player] call BIS_fnc_MP;
	};

	// Spawn AI if low player count.
	if (_spawnAI) then {
		for "_i" from 1 to 3 do {
			private ["_unit"];
			_unit = (group _player) createUnit [ITD_server_blufor_unit, [0,0,0], [], 0, "NONE"];
			_unit moveInCargo _vehicle;
			sleep 0.1;
		};

		_capacity = _capacity - 3;
	} else {
		_capacity = _capacity - 1;
	};

	// Remove _player from the queue.
	ITD_server_spawnQueue deleteAt 0;
	sleep SLEEP_TIME;

	// Add player to global player list.
	[_player] call ITD_fnc_updatePlayerList;

	// If the queue is empty, do a final wait for slow loaders.
	if (count ITD_server_spawnQueue == 0) then {
		sleep 30;
	};
};

ITD_global_canJoin = false;
publicVariable "ITD_global_canJoin";

nil;
