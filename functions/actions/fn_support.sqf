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
_vehicle = ITD_local_supportTarget;

if (isNull _vehicle) exitWith {
	["Vehicle is null"] call BIS_fnc_error;
	nil;
};

if (!([_vehicle, ITD_global_recruitmentTents, VEHICLE_DISTANCE] call ITD_fnc_nearby)) exitWith {
	// Vehicle not close enough to tent.
	[["ITD_CombatSupport","Error_Distance"], 5] call ITD_fnc_advHint;
};

if (count crew _vehicle > 0) then {
	// Vehicle not empty.
	[["ITD_CombatSupport","Error_NotEmpty"], 5] call ITD_fnc_advHint;
};

// Send the request to the server.
[[_vehicle, _type, player], "ITD_fnc_addSupport", false] call BIS_fnc_MP;

nil;
