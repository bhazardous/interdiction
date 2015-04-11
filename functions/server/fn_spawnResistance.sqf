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

waitUntil {!isNil "ITD_global_campExists"};

[_groups] spawn {
	while {count ITD_global_recruitmentTents == 0} do {sleep 10;};
	waitUntil {!isNil "ALiVE_profileSystemInit"};

	private ["_count"];
	_count = _this select 0;

	for "_i" from 1 to _count do {
		// Get a random group.
		private ["_groupClass"];
		_groupClass = ["Infantry", ITD_server_faction_blufor] call ALiVE_fnc_configGetRandomGroup;
		if (_groupClass == "FALSE") exitWith {
			["ITD_fnc_spawnResistance - fatal error, no group"] call BIS_fnc_error;
		};

		// Select a random recruitment tent.
		private ["_position", "_profile"];
		_position = ITD_global_recruitmentTents select (floor (random count ITD_global_recruitmentTents));

		// Spawn the group.
		_profile = [_groupClass, _position, random 360] call ALiVE_fnc_createProfilesFromGroupConfig;

		sleep 10;
	};
};

nil;
