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

[_groups] spawn {
	while {INT_global_recruitmentTentCount == 0} do {sleep 10;};
	waitUntil {!isNil "ALiVE_profileSystemInit"};

	private ["_count"];
	_count = _this select 0;

	for "_i" from 1 to _count do {
		// Get a random group.
		private ["_groupClass"];
		_groupClass = ["Infantry", INT_server_faction_blufor] call ALiVE_fnc_configGetRandomGroup;
		if (_groupClass == "FALSE") exitWith {
			["INT_fnc_spawnResistance - fatal error, no group"] call BIS_fnc_error;
		};

		// Select a random recruitment tent.
		private ["_tent", "_position", "_dir", "_profile"];
		_tent = INT_global_recruitmentTents select (floor (random INT_global_recruitmentTentCount));
		_position = position _tent;
		_dir = direction _tent;

		// Spawn the group.
		_profile = [_groupClass, _position, _dir] call ALiVE_fnc_createProfilesFromGroupConfig;

		sleep 10;
	};
};

nil;
