scriptName "onPlayerRespawn";
/*--------------------------------------------------------------------
	file: onPlayerRespawn.sqf
	=========================
	Author: Bhaz
	Description: Runs locally for respawning players.
--------------------------------------------------------------------*/
#define __filename "onPlayerRespawn.sqf"

// Don't run for HC or beginning of mission.
if (!hasInterface) exitWith {};
if (isNull (_this select 1)) exitWith {};

// If this is the first spawn (just joined), init scripts will take care of this.
if (isNil "INT_local_playerStarted") exitWith {};

// Respawning players spectate if there is no camp.
waitUntil {!isNil "INT_global_campExists"};
if (!INT_global_campExists) then {
	if (player in INT_global_playerList) then {
		INT_global_playerList = INT_global_playerList - [player];
		publicVariable "INT_global_playerList";
	};
	[] spawn INT_fnc_spectate;
};
