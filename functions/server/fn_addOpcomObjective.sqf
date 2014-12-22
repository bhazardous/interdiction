scriptName "fn_addOpcomObjective";
/*
	Author: Bhaz

	Description:
	Adds an objective to OPCOMs by their ID.

	Parameter(s):
	#0 ARRAY or OBJECT - List of OPCOM ID strings OR an OPCOM module
	#1 ARRAY - Objective params
		#0 STRING - Objective name
		#1 POSITION - Objective position
		#2 NUMBER - Radius (size of objective used by ALiVE OPCOM)
		#3 STRING - Objective type ("MIL" or "CIV")
		#4 NUMBER - Objective priority (for use by ALiVE)

	Returns:
	BOOL - true if successful
*/

private ["_objectiveParams", "_opcomList"];
_opcomList = [_this, 0, [], [[], objNull]] call BIS_fnc_param;
_objectiveParams = [_this, 1, [], [[]], [5]] call BIS_fnc_param;

if (typeName _opcomList == "OBJECT") then {
	// Convert ALiVE module to OPCOM ID.
	private ["_handler"];
	_handler = _opcomList getVariable "handler";
	_opcomList = [[_handler, "opcomID", ""] call ALiVE_fnc_hashGet];
};

{
	private ["_opcomID", "_opcomInstance", "_success"];
	_opcomID = _x;
	_success = false;

	// Match the OPCOM ID to an instance.
	{
		if (_opcomID == [_x, "opcomID", ""] call ALiVE_fnc_hashGet) then {
			_opcomInstance = _x;
			_success = true;
		};
	} forEach OPCOM_INSTANCES;

	// Add the objective.
	if (_success) then {
		[_opcomInstance, "addObjective", _objectiveParams] call ALiVE_fnc_OPCOM;
	} else {
		["Couldn't match OPCOM ID to an instance of OPCOM"] call BIS_fnc_log;
	};
} forEach _opcomList;

nil;
