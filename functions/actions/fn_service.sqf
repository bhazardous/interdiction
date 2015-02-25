scriptName "fn_service";
/*
	Author: Bhaz

	Description:
	Handles selections from the service menu.

	Parameter(s):
	#0 STRING - Action

	Returns:
	nil
*/

private ["_action", "_vehicle"];
_action = _this select 0;
_vehicle = INT_local_serviceTarget;

if (isNull _vehicle) exitWith {
	["Vehicle is null"] call BIS_fnc_error;
	nil;
};

// Send request to server.
[[player, _action, _vehicle], "INT_fnc_serviceRequest", false] call BIS_fnc_MP;

nil;
