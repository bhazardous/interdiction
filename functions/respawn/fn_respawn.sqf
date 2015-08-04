scriptName "fn_respawn";
/*
	Author: Bhaz

	Description:
	Called automatically on death and respawn.

	Parameter(s):
	#0 OBJECT - Unit respawning

	Example:
	n/a

	Returns:
	Nothing
*/

params ["_unit"];

waitUntil {!isNil "ITD_global_canJoin"};
waitUntil {!isNil "ITD_global_campExists"};
waitUntil {!isNil "ITD_global_playerList"};
waitUntil {!isNil "ITD_local_unitReady"};

if (isNil "ITD_local_firstSpawn") exitWith {
	ITD_local_firstSpawn = true;
	if (ITD_global_persistence) then {
		// Wait for ALiVE player data.
		sleep 5;

		if (!isNil {player getVariable "ALiVE_sys_player_playerLoaded"}) then {
			["respawning"] call BIS_fnc_blackIn;
			2 fadeSound 1;
			2 fadeMusic 1;
			2 fadeRadio 1;
			player setCaptive false;
			player hideObject false;
			player enableSimulation true;
			player switchMove "AidlPercMstpSrasWrfllOnon_G01";
			ITD_local_firstSpawn = false;
		} else {
			_this call ITD_fnc_respawn;
		};
	} else {
		_this call ITD_fnc_respawn;
	};
};

if (alive _unit) then {
	if (!ITD_local_firstSpawn) then {
		[_unit, [missionNamespace, "playerInventory"]] call BIS_fnc_loadInventory;
	} else {
		ITD_local_firstSpawn = false;
	};

	if (ITD_global_campExists) then {
		sleep 2;
		_this call BIS_fnc_respawnMenuPosition;
		["respawning"] call BIS_fnc_blackIn;
		[[_unit, "add"], "ITD_fnc_updatePlayerList", false] call BIS_fnc_MP;

		2 fadeSound 1;
		2 fadeMusic 1;
		2 fadeRadio 1;

		player setCaptive false;
		player hideObject false;
		player enableSimulation true;
		player switchMove "AidlPercMstpSrasWrfllOnon_G01";

		// TODO: TEMPORARY: Give player AI with a low player count.
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
		player setCaptive true;
		player hideObject true;
		player enableSimulation false;

		if (ITD_global_canJoin) then {
			[[player], "ITD_fnc_joinRequest", false] call BIS_fnc_MP;
			[true] call ITD_fnc_spectate;
		} else {
			sleep 2;
			[] call ITD_fnc_spectate;
		};
	};
} else {
	[_unit, [missionNamespace, "playerInventory"]] call BIS_fnc_saveInventory;
	[[_unit, "remove"], "ITD_fnc_updatePlayerList", false] call BIS_fnc_MP;

	[_unit] spawn {
		params ["_unit"];
		sleep 5;
		waitUntil {!isPlayer _unit};
		deleteVehicle _unit;
	};

	sleep 2;
	2 fadeSound 0;
	2 fadeMusic 0;
	2 fadeRadio 0;
	["respawning"] call BIS_fnc_blackOut;

	if (ITD_global_campExists) then {
		_this call BIS_fnc_respawnMenuPosition;
	};
};
