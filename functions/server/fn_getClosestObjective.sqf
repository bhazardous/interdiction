scriptName "fn_getClosestObjective";
/*
	Author: Bhaz

	Description:
	Gets the closest ALiVE objective to the given position.

	Parameter(s):
	#0 OBJECT - OPCOM module
	#1 POSITION - Position to search

	Returns:
	? - TRUE when done
*/

private ["_opcom", "_position", "_handler", "_objectives", "_result"];
_opcom = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_position = [_this, 1, [], [[]], [2,3]] call BIS_fnc_param;

if (isNull _opcom) exitWith {
	["_opcom is null"] call BIS_fnc_error;
};

_handler = _opcom getVariable "handler";
_objectives = [_handler, "objectives"] call ALiVE_fnc_hashGet;
// Thanks highhead xD.
_result = ([_objectives, [_position], {_input0 distance ([_x, "center"] call ALiVE_fnc_hashGet)}, "ASCEND"] call BIS_fnc_sortBy) select 0;

_result;
