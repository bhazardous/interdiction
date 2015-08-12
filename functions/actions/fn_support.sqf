scriptName "fn_support";
/*
	Author: Bhaz

	Description:
	Client selected a vehicle to convert into support using the menu.

	Parameter(s):
	#0 STRING - Support type

	Example:
	n/a

	Returns:
	Nothing
*/

if (!params [["_type", "", [""]]]) exitWith {["Missing support type"] call BIS_fnc_error};
if !(_type in ["transport","combat"]) exitWith {["Invalid type: %1", _type] call BIS_fnc_error};
if (isNull ITD_local_supportTarget) exitWith {["Vehicle is null"] call BIS_fnc_error};

if (!([ITD_local_supportTarget, ITD_global_recruitmentTents, 40] call ITD_fnc_nearby)) exitWith {
	[["ITD_CombatSupport","Error_Distance"], 5] call ITD_fnc_advHint;
};

if (count crew ITD_local_supportTarget > 0) exitWith {
	[["ITD_CombatSupport","Error_NotEmpty"], 5] call ITD_fnc_advHint;
};

[[ITD_local_supportTarget, _type, player], "ITD_fnc_addSupport", false] call BIS_fnc_MP;
