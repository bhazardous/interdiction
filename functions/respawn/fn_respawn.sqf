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

waitUntil {!isNil "ITD_global_canJoin"};
waitUntil {!isNil "ITD_global_campExists"};
waitUntil {!isNil "ITD_global_playerList"};
waitUntil {!isNil "ITD_local_unitReady"};

["INTERDICTION: RESPAWN: %1 %2", time, alive _unit] call BIS_fnc_logFormat;

// This block only runs the first time a player joins.
if (isNil "ITD_local_firstSpawn" && ITD_global_persistence) exitWith {
	// Wait and see if ALiVE has player data to restore.
	ITD_local_firstSpawn = true;
	sleep 5;

	if (!isNil {player getVariable "ALiVE_sys_player_playerLoaded"}) then {
		// Data was restored, no respawn required.
		["respawning"] call BIS_fnc_blackIn;
		2 fadeSound 1;
		2 fadeMusic 1;
		2 fadeRadio 1;
		player setCaptive false;
		player hideObject false;
		player enableSimulation true;
		player switchMove "AidlPercMstpSrasWrfllOnon_G01";
	} else {
		// No data from DB, spawn normally.
		_this call ITD_fnc_respawn;
	};
};

if (alive _unit) then {
	// Unit just respawned.
	[_unit] call ITD_fnc_setGear;

	if (ITD_global_campExists) then {
		sleep 2;
		_this call BIS_fnc_respawnMenuPosition;
		["respawning"] call BIS_fnc_blackIn;
		[[_unit], "ITD_fnc_updatePlayerList", false] call BIS_fnc_MP;

		2 fadeSound 1;
		2 fadeMusic 1;
		2 fadeRadio 1;

		// Reactivate player.
		player setCaptive false;
		player hideObject false;
		player enableSimulation true;
		player switchMove "AidlPercMstpSrasWrfllOnon_G01";

		// TEMPORARY: Give player AI with a low player count.
		if (count ITD_global_playerList < 5) then {
			if ({alive _x} count (units group player) <= 1) then {
				for "_i" from 1 to 3 do {
					private ["_ai"];
					_ai = (group player) createUnit [ITD_global_blufor_unit, position player, [], 0, "NONE"];
					sleep 0.1;
				};
			};
		};
	} else {
		// Player has respawned, but isn't in the game yet.
		player setCaptive true;
		player hideObject true;
		player enableSimulation false;

		if (ITD_global_canJoin) then {
			// A new spawn wave started, join the queue.
			[[player], "ITD_fnc_joinRequest", false] call BIS_fnc_MP;
			[true] call ITD_fnc_spectate;
		} else {
			sleep 2;
			[] call ITD_fnc_spectate;
		};
	};
} else {
	// Unit just died.
	[_unit] call ITD_fnc_storeGear;
	[[_unit, false], "ITD_fnc_updatePlayerList", false] call BIS_fnc_MP;

	[_unit] spawn {
		private ["_unit"];

		// Dispose of old unit.
		_unit = _this select 0;
		sleep 5;
		waitUntil {!isPlayer _unit};
		deleteVehicle _unit;
	};

	sleep 2;
	2 fadeSound 0;
	2 fadeMusic 0;
	2 fadeRadio 0;
	["respawning"] call BIS_fnc_blackOut;
};

nil;
