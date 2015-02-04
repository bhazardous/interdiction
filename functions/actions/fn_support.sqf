scriptName "fn_support";
/*
	Author: Bhaz

	Description:
	Client selecting a vehicle to convert into support.

	Parameter(s):
	#0 STRING - Support type

	Returns:
	nil
*/
#define VEHICLE_DISTANCE 40

private ["_type"];
_type = _this select 0;
_vehicle = INT_local_supportTarget;

if (isNull _vehicle) exitWith {
	["Vehicle is null"] call BIS_fnc_error;
	nil;
};

if (!([_vehicle, INT_global_recruitmentTents, VEHICLE_DISTANCE] call INT_fnc_nearby)) exitWith {
	// Vehicle not close enough to tent.
	[["ResistanceMovement","CombatSupport","SupportErrDistance"], 5, "", 5, "", true, true] call BIS_fnc_advHint;
};

if (count crew _vehicle > 0) then {
	// Vehicle not empty.
	[["ResistanceMovement","CombatSupport","SupportErrCrew"], 5, "", 5, "", true, true] call BIS_fnc_advHint;
};

// Send the request to the server.
[[_vehicle, _type, player], "INT_fnc_addSupport", false] call BIS_fnc_MP;

nil;
