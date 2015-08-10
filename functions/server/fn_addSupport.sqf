scriptName "fn_addSupport";
/*
	Author: Bhaz

	Description:
	Spawns a crew, and adds the vehicle to the ALiVE support module.

	RemoteExec: Client

	Parameter(s):
	#0 OBJECT - Vehicle to add
	#1 STRING - Type of support
	#2 OBJECT - Player sending the request

	Example:
	n/a

	Returns:
	Nothing
*/

#include "persistentData.hpp"
#define FLIGHT_HEIGHT 100
#define CALLSIGN "RESISTANCE TRANSPORT"
#define CALLSIGN_C "COMBAT SUPPORT"

if (!params [
	["_vehicle", objNull, [objNull]],
	["_type", "", [""]],
	["_player", objNull, [objNull]]]) exitWith ["Invalid params"] call BIS_fnc_error;

private ["_success", "_callsign", "_turrets"];
_success = false;
_turrets = [_vehicle] call ITD_fnc_getRealTurrets;

if (isNull _player) exitWith {["Request sent from objNull?"] call BIS_fnc_error};

if (ITD_global_crewAvailable <= 0) exitWith {
	[[["ITD_CombatSupport","Error_NoCrew", 5]], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
};

ITD_global_crewAvailable = ITD_global_crewAvailable - 1;
publicVariable "ITD_global_crewAvailable";
SET_DB_PROGRESS_CREW_AVAILABLE(ITD_global_crewAvailable);

switch (_type) do {
		case "transport": {
				_callsign = CALLSIGN;
		};

		case "combat": {
				// ALiVE only supports CAS, ground vehicles are added to transport.
				_callsign = CALLSIGN_C;
				if (!(_vehicle isKindOf "Air")) then {
					_type = "transport";
				} else {
					_type = "cas";
				};

				if (count _turrets == 0) then {
					[[["ITD_CombatSupport","Error_NonCombat"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
					_type = "abort";
				};
		};
};

if (_type == "abort") exitWith {};

private ["_pos", "_dir", "_class"];
_pos = getPosATL _vehicle;
_dir = direction _vehicle;
_class = typeOf _vehicle;

if (isNull _vehicle || !alive _vehicle) exitWith {
	["Vehicle dead or doesn't exist"] call BIS_fnc_error;
};

private ["_id", "_spawnPos"];
_vehicle lock 3;
_id = [_player, ITD_global_camps] call ITD_fnc_closestPosition;
if (count (DB_CAMPS_RECRUIT) == 0) exitWith {
	["ITD_fnc_addSupport called at a camp without a recruitment tent"] call BIS_fnc_error;
};
_spawnPos = DB_CAMPS_RECRUIT_POSITION;

private ["_group", "_unit"];
_group = createGroup ITD_global_side_blufor;
[_group, 0] setWaypointPosition [_pos, 0];

_unit = _group createUnit [ITD_global_blufor_unit, _spawnPos, [], 0, "NONE"];
_unit assignAsDriver _vehicle;
{
	private ["_unit"];
	_unit = _group createUnit [ITD_global_blufor_unit, _spawnPos, [], 0, "NONE"];
	_unit assignAsTurret [_vehicle, _x];
} forEach _turrets;
(units _group) orderGetIn true;

private ["_crewSize"];
_crewSize = count _turrets + 1;
waitUntil {count (crew _vehicle) == _crewSize ||
	{{alive _x} count units _group < _crewSize} ||
	{!alive _vehicle}};
if ({alive _x} count units _group < _crewSize) exitWith {
	[[["ITD_CombatSupport","Error_Dead"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
	_vehicle lock 0;
};
if (!alive _vehicle) exitWith {
	[[["ITD_CombatSupport","Error_Destroyed"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
	_vehicle lock 0;
};

switch (_type) do {
		case "transport": {
				private ["_tasks", "_variable", "_transportArray"];
				if (_vehicle isKindOf "Helicopter") then {
					_tasks = ["Pickup", "Land", "land (Eng off)", "Move", "Circle", "Insertion"];
				} else {
					_tasks = ["Move"];
				};

				_vehicle setVariable ["ALiVE_combatSupport", true];
				_vehicle setVariable ["NEO_transportAvailableTasks", _tasks, true];
				SUP_TRANSPORTARRAYS pushBack [_pos, _dir, _class, _callsign, _tasks, "", FLIGHT_HEIGHT];
				publicVariable "SUP_TRANSPORTARRAYS";

				_variable = format ["NEO_radioTrasportArray_%1", ITD_global_side_blufor];
				_transportArray = NEO_radioLogic getVariable _variable;
				if (isNil "_transportArray") then {
					_transportArray = [];
				};
				_transportArray pushBack [_vehicle, _group, _callsign];
				NEO_radioLogic setVariable [_variable, _transportArray, true];

				[_vehicle, _group, _callsign, _pos, _dir, FLIGHT_HEIGHT, _class, CS_RESPAWN] execFSM "\x\alive\addons\sup_combatSupport\scripts\NEO_radio\fsms\transport.fsm";

				_vehicle lock 0;
				_success = true;
		};

		case "cas": {
				private ["_airport", "_variable", "_casArray"];
				_airport = [_pos] call ALiVE_fnc_getNearestAirportID;

				_vehicle setVariable ["ALiVE_combatSupport", true];
				_variable = format ["NEO_radioCasArray_%1", ITD_global_side_blufor];
				_casArray = NEO_radioLogic getVariable _variable;
				_casArray pushBack [_vehicle, _group, _callsign];
				NEO_radioLogic setVariable [_variable, _casArray, true];

				[_vehicle, _group, _callsign, _pos, _airport, _dir, FLIGHT_HEIGHT, _class, CS_RESPAWN] execFSM "\x\alive\addons\sup_combatSupport\scripts\NEO_radio\fsms\cas.fsm";

				_success = true;
		};

		default {["Invalid support type: %1", _type] call BIS_fnc_error};
};

if (_success) then {
	[[["ITD_Guide","CombatSupport","Info_Available"], 10], "ITD_fnc_advHint"] call BIS_fnc_MP;
};
