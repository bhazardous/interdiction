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

if (isNil "ITD_local_playerStarted") exitWith {};
waitUntil {!isNil "ITD_global_campExists"};
waitUntil {!isNil "ITD_global_playerList"};

["INTERDICTION: RESPAWN: %1 %2", time, alive _unit] call BIS_fnc_logFormat;

if (alive _unit) then {
	// Unit just respawned.
	[_unit] call ITD_fnc_setGear;

	if (ITD_global_campExists) then {
		sleep 2;
		_this call BIS_fnc_respawnMenuPosition;
		["respawning"] call BIS_fnc_blackIn;
	} else {
		sleep 2;
		[] call ITD_fnc_spectate;
	};
} else {
	// Unit just died.
	[_unit] call ITD_fnc_storeGear;
	if (!isNull _unit && {_unit in ITD_global_playerList} && {count ITD_global_playerList > 1}) then {
		ITD_global_playerList = ITD_global_playerList - [_unit];
		publicVariable "ITD_global_playerList";
	};

	[_unit] spawn {
		private ["_unit"];

		// Dispose of old unit.
		_unit = _this select 0;
		sleep 5;
		waitUntil {!isPlayer _unit};
		deleteVehicle _unit;
	};

	sleep 2;
	["respawning"] call BIS_fnc_blackOut;
};

nil;
