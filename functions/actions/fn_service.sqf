scriptName "fn_service";
/*
	Author: Bhaz

	Description:
	Handles selections from the service menu.

	Parameter(s):
	#0 STRING - Action

	Example:
	n/a

	Returns:
	Nothing
*/

if (!params [["_action", "", [""]]]) exitWith {["Invalid action"] call BIS_fnc_error};
if (isNull ITD_local_serviceTarget) exitWith {["Vehicle is null"] call BIS_fnc_error};

[[player, _action, ITD_local_serviceTarget], "ITD_fnc_serviceRequest", false] call BIS_fnc_MP;
