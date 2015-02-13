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

if (INT_global_campExists) then {
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
