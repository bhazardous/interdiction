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

	Returns:
	BOOL - true if trigger was created
*/

private ["_factionList", "_triggerRadius", "_objectiveParams"];
_factionList = [_this, 0,  [], [[]]] call BIS_fnc_param;
_triggerRadius = [_this, 1, 400, [0]] call BIS_fnc_param;
_objectiveParams = [_this, 2, [], [[]], [5]] call BIS_fnc_param;
_campId = [_this, 3, -1, [0]] call BIS_fnc_param;

if (count _factionList == 0) exitWith {
	["No factions or sides given"] call BIS_fnc_error;
	false;
};

if (_campId < 0) exitWith {
	["Invalid camp ID"] call BIS_fnc_error;
};

private ["_opcomList"];
_opcomList = [];

{
	private ["_opcomInstance", "_opcomSide", "_opcomFactions", "_relevant"];
	_opcomInstance = _x;
	_opcomSide = [_opcomInstance, "side", ""] call ALiVE_fnc_hashGet;
	_opcomFactions = [_opcomInstance, "factions", ""] call ALiVE_fnc_hashGet;
	_relevant = false;

	// Side in _factionList?
	if (_opcomSide in _factionList) then {
		_relevant = true;
	};

	// One of this OPCOMs factions in _factionList?
	{
		if (_x in _opcomFactions) then {
			_relevant = true;
		};
	} forEach _factionList;

	// Take the OPCOM ID if its needed.
	if (_relevant) then {
		_opcomList pushBack ([_opcomInstance, "opcomID", ""] call ALiVE_fnc_hashGet);
	};
} forEach OPCOM_INSTANCES;

if (count _opcomList == 0) exitWith {
	["No OPCOMs found matching side / factions given"] call BIS_fnc_log;
	false;
};

// Convert faction to side.
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
	false;
};

// Create the trigger.
// Condition: this (units present) or any profiles from _triggerSide present in radius.
// Activation: add objective to each OPCOM in _opcomList, then delete the trigger.
private ["_triggerCondition", "_triggerActivation", "_trigger"];
_triggerCondition = format ["this || {count ([getPosATL thisTrigger, %1, ['%2', 'entity']] call ALiVE_fnc_getNearProfiles) > 0}",
	_triggerRadius, _triggerSide];
_triggerActivation = format ["[%1, %2] call ITD_fnc_addOpcomObjective; (ITD_server_campData select %3) set [4, true]; [] call ITD_fnc_updatePersistence; deleteVehicle thisTrigger;",
	_opcomList, _objectiveParams, _campId];
_trigger = createTrigger ["EmptyDetector", _objectiveParams select 1];
_trigger setTriggerArea [_triggerRadius, _triggerRadius, 0, false];
_trigger setTriggerStatements [_triggerCondition, _triggerActivation, ""];
_trigger setTriggerActivation [_triggerSide, "PRESENT", false];

true;
