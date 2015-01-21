scriptName "initPlayerServer";
/*--------------------------------------------------------------------
	file: initPlayerServer.sqf
	==========================
	Author: Bhaz
	Description: Runs serverside when a player joins.
--------------------------------------------------------------------*/
#define __filename "initPlayerServer.sqf"

private ["_player", "_jip"];
_player = _this select 0;
_jip = _this select 1;

waitUntil {!isNil "INT_global_campExists"};

// JIP players spectate if there's nowhere to spawn.
/*	Shouldn't need this anymore.
if (_jip) then {
	if (!INT_global_campExists) then {
		 [[], "INT_fnc_spectate", _player, false, false] call BIS_fnc_MP;
	};
};
*/
