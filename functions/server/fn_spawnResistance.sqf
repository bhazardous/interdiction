scriptName "fn_spawnResistance";
/*
	Author: Bhaz

	Description:
	Spawns OPCOM controlled resistance using ALiVE.

	Parameter(s):
	None

	Returns:
	nil
*/

if (count ITD_server_reinforceQueue == 0) then {
	[] spawn {
		waitUntil {!isNil "ITD_global_campExists"};
		while {count ITD_global_recruitmentTents == 0} do {sleep 10;};
		waitUntil {!isNil "ALiVE_profileSystemInit"};

		// Get a random group.
		private ["_groupClass"];
		_groupClass = ["Infantry", ITD_server_faction_blufor] call ALiVE_fnc_configGetRandomGroup;
		if (_groupClass == "FALSE") exitWith {
			["ITD_fnc_spawnResistance - fatal error, no group"] call BIS_fnc_error;
		};

		// Select a random recruitment tent.
		private ["_position", "_validPositon", "_profile"];
		_position = ITD_global_recruitmentTents select (floor (random count ITD_global_recruitmentTents));

		// Choose a position away from players.
		_validPosition = [];
		while {count _validPosition == 0} do {
			sleep 5;
			_validPosition = [_position, 1500] call ALiVE_fnc_getPositionDistancePlayers;
		};

		// Spawn the group.
		_profile = [_groupClass, _validPosition, random 360] call ALiVE_fnc_createProfilesFromGroupConfig;

		// Send the group to the camp.
		private ["_waypoint"];
		_waypoint = [_position] call ALiVE_fnc_createProfileWaypoint;
		[_profile select 0, "addWaypoint", _waypoint] call ALiVE_fnc_profileEntity;

		sleep 10;
	};
} else {
	// Spawning player requested reinforcements.
	// Get a random group.
	private ["_groupClass", "_group", "_player", "_waypoint", "_validPosition"];
	_groupClass = ["Infantry", ITD_server_faction_blufor] call ALiVE_fnc_configGetRandomGroup;
	if (_groupClass == "FALSE") exitWith {
		["ITD_fnc_spawnResistance - fatal error, no group"] call BIS_fnc_error;
	};

	// Get the player being reinforced.
	_player = ITD_server_reinforceQueue select 0;
	ITD_server_reinforceQueue deleteAt 0;

	// Update the queue for other players.
	{
		[[_forEachIndex], "ITD_fnc_reinforcements", _x] call BIS_fnc_MP;
	} forEach ITD_server_reinforceQueue;

	// Choose a position away from the player being reinforced.
	_validPosition = [];
	while {count _validPosition == 0} do {
		sleep 5;
		_validPosition = [position _player, 1250] call ALiVE_fnc_getPositionDistancePlayers;
	};

	// Spawn the group (unprofiled).
	_group = [_validPosition, ITD_global_side_blufor, _groupClass call ALiVE_fnc_configGetGroup] call BIS_fnc_spawnGroup;
	_waypoint = _group addWaypoint [position _player, 0];
	_waypoint waypointAttachVehicle _player;
	_waypoint setWaypointType "JOIN";

	// Groups sneak at night.
	if (dayTime <= 4.5 || {dayTime >= 21}) then {
		_group setBehaviour "STEALTH";
	} else {
		_group setBehaviour "AWARE";
	};

	[_group, _waypoint, _player] spawn {
		private ["_group", "_waypoint", "_player"];
		_group = _this select 0;
		_waypoint = _this select 1;
		_player = _this select 2;

		while {{alive _x} count units _group > 0} do {
			sleep 10;
			_waypoint setWaypointPosition [position _player, 0];
		};

		// TODO: Alert player to possibly dead reinforcements.
		[[-2], "ITD_fnc_reinforcements", _player] call BIS_fnc_MP;
	};
};

nil;
