scriptName "fn_triggerOpcomObjective";
/*
	Author: Bhaz

	Description:
	Adds an objective to OPCOM when discovered by a unit or profile.
	The first faction will be used as the detecting side.
	i.e. ["OFP_F", "BLU_F"] will use EAST but won't be triggered by WEST.

	Parameter(s):
	#0 ARRAY - A list of side / faction OPCOMs to add the objective to.
	#1 NUMBER - Discovery radius (spotting distance)
	#2 ARRAY - Objective params
		#0 STRING - Objective name
		#1 POSITION - Objective position
		#2 NUMBER - Radius (size of objective used by ALiVE OPCOM)
		#3 STRING - Objective type ("MIL" or "CIV")
		#4 NUMBER - Objective priority (for use by ALiVE)
	#3 NUMBER - Camp ID

	Example:
	n/a

	Returns:
	Bool - true if trigger was created
*/

if (!isServer) exitWith {};

if (!params [
	["_factionList", [], [[]]],
	["_triggerRadius", 400, [0]],
	["_objectiveParams", [], [[]], [5]],
	["_campId", -1, [0]]]) exitWith {["Invalid params"] call BIS_fnc_error; false};

if (count _factionList == 0) exitWith {
	["No factions or sides given"] call BIS_fnc_error; false
};
if (_campId < 0) exitWith {["Invalid camp ID"] call BIS_fnc_error; false};

private ["_opcomList"];
_opcomList = [];

{
	private ["_opcomInstance", "_opcomSide", "_opcomFactions", "_relevant"];
	_opcomInstance = _x;
	_opcomSide = [_opcomInstance, "side", ""] call ALiVE_fnc_hashGet;
	_opcomFactions = [_opcomInstance, "factions", ""] call ALiVE_fnc_hashGet;
	_relevant = false;

	if (_opcomSide in _factionList) then {
		_relevant = true;
	};

	{
		if (_x in _opcomFactions) then {
			_relevant = true;
		};
	} forEach _factionList;

	if (_relevant) then {
		_opcomList pushBack ([_opcomInstance, "opcomID", ""] call ALiVE_fnc_hashGet);
	};
} forEach OPCOM_INSTANCES;

if (count _opcomList == 0) exitWith {
	["No OPCOMs found matching side / factions given"] call BIS_fnc_log;
	false
};

// Convert faction to side string.
private ["_triggerSide"];
_triggerSide = _factionList select 0;
if (!(_triggerSide in ["WEST", "EAST", "GUER"])) then {
	switch (getNumber (configFile >> "CfgFactionClasses" >> _triggerSide >> "side")) do {
		case 0: {_triggerSide = "EAST";};
		case 1: {_triggerSide = "WEST";};
		case 2: {_triggerSide = "GUER";};
		default {_triggerSide = "ERROR";};
	};
};
if (_triggerSide == "ERROR") exitWith {
	["Faction not found in config"] call BIS_fnc_error;
	false
};

// Create the trigger.
// Condition: this (units present) or any profiles from _triggerSide present in radius.
// Activation: add objective to each OPCOM in _opcomList, then delete the trigger.
private ["_triggerCondition", "_triggerActivation", "_trigger"];
_triggerCondition = format ["this || {count ([getPosATL thisTrigger, %1, ['%2', 'entity']] call ALiVE_fnc_getNearProfiles) > 0}",
	_triggerRadius, _triggerSide];
_triggerActivation = format ["[%1, %2] call ITD_fnc_addOpcomObjective; (ITD_server_db_camps select %3) set [2, true]; deleteVehicle thisTrigger;",
	_opcomList, _objectiveParams, _campId];
_trigger = createTrigger ["EmptyDetector", _objectiveParams select 1];
_trigger setTriggerArea [_triggerRadius, _triggerRadius, 0, false];
_trigger setTriggerStatements [_triggerCondition, _triggerActivation, ""];
_trigger setTriggerActivation [_triggerSide, "PRESENT", false];
_trigger setTriggerTimeout [20, 20, 20, true];

true
