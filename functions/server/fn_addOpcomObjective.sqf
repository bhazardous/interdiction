scriptName "fn_addOpcomObjective";
/*
	Author: Bhaz

	Description:
	Adds an objective to OPCOMs by their ID.

	Parameter(s):
	#0 ARRAY or OBJECT - List of OPCOM ID strings or an OPCOM module, objNull for all
	#1 ARRAY - Objective params
		#0 STRING - Objective name
		#1 POSITION - Objective position
		#2 NUMBER - Radius (size of objective used by ALiVE OPCOM)
		#3 STRING - Objective type ("MIL" or "CIV")
		#4 NUMBER - Objective priority (for use by ALiVE)

	Example:
	n/a

	Returns:
	Nothing
*/

if (!isServer) exitWith {};

if (!params [["_opcomList", [], [[], objNull]], ["_objectiveParams", [], [[]], [5]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

if (typeName _opcomList == "OBJECT") then {
	if (!isNull _opcomList) then {
		private ["_handler"];
		_handler = _opcomList getVariable "handler";
		_opcomList = [[_handler, "opcomID", ""] call ALiVE_fnc_hashGet];
	} else {
		_opcomList = [];
		{
			_opcomList pushBack ([_x, "opcomID", ""] call ALiVE_fnc_hashGet);
		} forEach OPCOM_INSTANCES;
	};
};

{
	private ["_opcomID", "_opcomInstance", "_success"];
	_opcomID = _x;
	_success = false;

	{
		if (_opcomID == [_x, "opcomID", ""] call ALiVE_fnc_hashGet) exitWith {
			_opcomInstance = _x;
			_success = true;
		};
	} forEach OPCOM_INSTANCES;

	if (_success) then {
		[_opcomInstance, "addObjective", _objectiveParams] call ALiVE_fnc_OPCOM;
	} else {
		["Couldn't match OPCOM ID to an instance of OPCOM"] call BIS_fnc_error;
	};
} forEach _opcomList;
