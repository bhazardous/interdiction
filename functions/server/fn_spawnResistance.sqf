scriptName "fn_spawnResistance";
/*
	Author: Bhaz

	Description:
	Spawns OPCOM controlled resistance using ALiVE.

	Parameter(s):
	#0 NUMBER - Number of groups to spawn.

	Returns:
	nil
*/

private ["_groups"];
_groups = [_this, 0, 1, [0]] call BIS_fnc_param;

waitUntil {!isNil "INT_global_campExists"};

[] spawn {
	while {!INT_global_campExists} do {sleep 10;};

	private ["_forces", "_side", "_position", "_pool", "_event"];
	_forces = [_groups, 0,0,0,0,0];
	switch (getNumber (configFile >> "CfgFactionClasses" >> INT_server_faction_blufor >> "side")) do {
		case 0: {_side = "EAST";};
		case 1: {_side = "WEST";};
		case 2: {_side = "GUER";};
	};
	_position = markerPos "respawn_west";

	// Add to the force pool.
	_pool = [ALiVE_globalForcePool, INT_server_faction_blufor] call ALiVE_fnc_hashGet;
	[ALiVE_globalForcePool, INT_server_faction_blufor, _pool + _groups] call ALiVE_fnc_hashSet;

	// Send logistics request.
	_event = ["LOGCOM_REQUEST", [_position, INT_server_faction_blufor, _side, _forces, "AIRDROP"], "OPCOM"] call ALiVE_fnc_event;
	[ALiVE_eventLog, "addEvent", _event] call ALiVE_fnc_eventLog;
};

nil;
