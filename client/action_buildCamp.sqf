scriptName "action_buildCamp";
/*--------------------------------------------------------------------
	file: action_buildCamp.sqf
	==========================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "action_buildCamp.sqf"

private ["_player", "_actionId"];
_player = _this select 1;
_actionId = _this select 2;

_player removeAction _actionId;
INT_local_campAction = false;

// Send build request to the server.
[[_player], "INT_fnc_buildRequest", false, false, false] call BIS_fnc_MP;
