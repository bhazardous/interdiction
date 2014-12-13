scriptName "onPlayerRespawn";
/*--------------------------------------------------------------------
	file: onPlayerRespawn.sqf
	=========================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "onPlayerRespawn.sqf"

// Don't run for HC or beginning of mission.
if (!hasInterface) exitWith {};
if (isNull (_this select 1) exitWith {};

// Respawning players spectate if there is no camp.
waitUntil {!isNil "INT_global_campExists"};
if (!INT_global_campExists) then {
	[] spawn INT_fnc_spectate;
};
