scriptName "fn_getClosestObjective";
/*
	Author: Bhaz

	Description:
	Gets the closest ALiVE objective to the given position.

	Parameter(s):
	#0 OBJECT - OPCOM module
	#1 POSITION - Position to search

	Example:
	_objective = [opcom_module, _pos] call ITD_fnc_getClosestObjective;

	Returns:
	Array - ALiVE objective
*/

if (!isServer) exitWith {};

if (!params [["_opcom", objNull, [objNull]], ["_position", [], [[]], [2,3]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_handler", "_objectives", "_result"];
if (isNull _opcom) exitWith {["Null OPCOM"] call BIS_fnc_error};

_handler = _opcom getVariable "handler";
_objectives = [_handler, "objectives"] call ALiVE_fnc_hashGet;

// Thanks highhead xD.
(([_objectives, [_position], {_input0 distance ([_x, "center"] call ALiVE_fnc_hashGet)}, "ASCEND"] call BIS_fnc_sortBy) select 0)
