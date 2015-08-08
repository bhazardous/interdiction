scriptName "fn_createInsurgentBuilding";
/*
	Author: Bhaz

	Description:
	Converts a building to an active ALiVE asymmetric insurgency building.

	Parameter(s):
	#0 STRING - Type
	#1 NUMBER - Building ID
	#2 ARRAY - OPCOM objective hash

	Example:
	n/a

	Returns:
	Nothing
*/

// Check: Not in use.

if (!params [["_type", "", [""]], ["_building", 0, [0]], ["_objective", [], [[]]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_center", "_id", "_size", "_agents", "_cqb", "_params"];

if (_building <= 0) exitWith {["No building ID given"] call BIS_fnc_error};
if (count _objective == 0) exitWith {["No OPCOM objective provided"] call BIS_fnc_error};

_center = [_objective, "center"] call ALiVE_fnc_hashGet;
_id = [_objective, "objectiveID"] call ALiVE_fnc_hashGet;
_size = [_objective, "size"] call ALiVE_fnc_hashGet;
_agents = [_objective, "agents", []] call ALiVE_fnc_hashGet;
_cqb = [ITD_module_alive_blufor_opcom getVariable "handler", "CQB", []] call ALiVE_fnc_hashGet;

_params = [time, _center, _id, _size, ITD_server_faction_blufor, [_center, _building], ITD_server_faction_enemy, _agents, +_cqb];

switch (_type) do {
	case "factory": {_params spawn ALiVE_fnc_INS_factory};
	case "hq": {_params spawn ALiVE_fnc_INS_recruit};
	case "depot": {_params spawn ALiVE_fnc_INS_depot};
};
