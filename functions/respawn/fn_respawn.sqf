scriptName "fn_respawn";
/*
	Author: Bhaz

	Description:
	Called on respawn

	Parameter(s):
	#0 OBJECT - Unit respawning

	Returns:
	nil
*/

private ["_unit"];
_unit = _this select 0;

if (isNil "INT_local_playerStarted") exitWith {};
waitUntil {!isNil "INT_global_campExists"};
waitUntil {!isNil "INT_global_playerList"};

// Save or restore gear.
if (alive _unit) then {
	[_unit] call INT_fnc_setGear;
} else {
	[_unit] call INT_fnc_storeGear;
	[_unit] spawn {
		private ["_unit"];
		_unit = _this select 0;

		sleep 5;
		waitUntil {!isPlayer _unit};
		deleteVehicle _unit;
	};
};

// Handle spawn if possible, otherwise spectate.
if (INT_global_campExists) then {
	sleep 0.5;
	_this call BIS_fnc_respawnMenuPosition;
} else {
	if (!isNull _unit && {_unit in INT_global_playerList} && {count INT_global_playerList > 1}) then {
		INT_global_playerList = INT_global_playerList - [_unit];
		publicVariable "INT_global_playerList";
	};

	if (alive _unit && isPlayer _unit) then {
		[] spawn INT_fnc_spectate;
	};
};

nil;
