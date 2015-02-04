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

// Find the closest service point.
private ["_servicePointId"];
_servicePointId = [player, "INT_mkr_servicePoint", INT_global_servicePointCount] call INT_fnc_closest;

// Send request to server.
[[player, _action, _servicePointId, _vehicle], "INT_fnc_serviceRequest", false] call BIS_fnc_MP;

nil;
