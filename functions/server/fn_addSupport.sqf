scriptName "fn_addSupport";
/*
	Author: Bhaz

	Description:
	Spawns a crew, and adds a vehicle to the ALiVE support module.

	Parameter(s):
	#0 OBJECT - Vehicle to add
	#1 STRING - Type of support
	#2 OBJECT - Player sending the request

	Returns:
	nil
*/
#define FLIGHT_HEIGHT 100
#define CALLSIGN "RESISTANCE TRANSPORT"
#define CALLSIGN_C "COMBAT SUPPORT"

private ["_vehicle", "_type", "_player", "_success", "_callsign", "_turrets"];
_vehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;
_player = [_this, 2, objNull, [objNull]] call BIS_fnc_param;
_success = false;
_turrets = [_vehicle] call ITD_fnc_getRealTurrets;

if (isNull _player) exitWith {
	["Request sent from objNull?"] call BIS_fnc_error;
	nil;
};

if (ITD_global_crewAvailable <= 0) exitWith {
	[["ResistanceMovement","CombatSupport","SupportErrNoCrew"], true, true, false, _player, true] call ITD_fnc_broadcastHint;
	nil;
};

// Decrement crew.
ITD_global_crewAvailable = ITD_global_crewAvailable - 1;
publicVariable "ITD_global_crewAvailable";
ITD_server_statData set [3, ITD_global_crewAvailable];
[] call ITD_fnc_updatePersistence;

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

				// If number of turrets = 0, this can't possibly be a combat vehicle.
				if (count _turrets == 0) then {
					[["ResistanceMovement","CombatSupport","SupportErrNonCombat"], true, true, false, _player, true] call ITD_fnc_broadcastHint;
					_type = "abort";
				};
		};
};

if (_type == "abort") exitWith {
	nil;
};

private ["_pos", "_dir", "_class"];
_pos = getPosATL _vehicle;
_dir = direction _vehicle;
_class = typeOf _vehicle;

// Vehicle dead or invalid.
if (isNull _vehicle || !alive _vehicle) exitWith {
	["Vehicle dead or doesn't exist"] call BIS_fnc_error;
};

// Lock vehicle to players.
_vehicle lock 3;

// Get closest recruitment tent.
private ["_id", "_spawnPos"];
_id = ([_player, "ITD_mkr_resistanceCamp", count ITD_global_camps] call ITD_fnc_closest) - 1;
if (count (ITD_server_campData select _id select 3) == 0) exitWith {
	["ITD_fnc_addSupport called at a camp without a recruitment tent."] call BIS_fnc_error;
};
_spawnPos = ITD_server_campData select _id select 3 select 0;

// Prepare group.
private ["_turrets", "_group", "_unit"];
_group = createGroup ITD_global_side_blufor;
[_group, 0] setWaypointPosition [_pos, 0];

// Spawn driver and crew.
_unit = _group createUnit [ITD_server_blufor_unit, _spawnPos, [], 0, "NONE"];
_unit assignAsDriver _vehicle;
{
	private ["_unit"];
	_unit = _group createUnit [ITD_server_blufor_unit, _spawnPos, [], 0, "NONE"];
	_unit assignAsTurret [_vehicle, _x];
} forEach _turrets;
(units _group) orderGetIn true;

private ["_crewSize"];
_crewSize = count _turrets + 1;
waitUntil {count (crew _vehicle) == _crewSize ||
	{{alive _x} count units _group < _crewSize} ||
	{!alive _vehicle}};
if ({alive _x} count units _group < _crewSize) exitWith {
	// Unit died.
	[["ResistanceMovement","CombatSupport","SupportErrDead"], true, true, false, _player, true] call ITD_fnc_broadcastHint;
	_vehicle lock 0;
	nil;
};
if (!alive _vehicle) exitWith {
	// Vehicle destroyed.
	[["ResistanceMovement","CombatSupport","SupportErrVDead"], true, true, false, _player, true] call ITD_fnc_broadcastHint;
	_vehicle lock 0;
	nil;
};

// Type specific code.
switch (_type) do {
		case "transport": {
				// ALiVE's transport data.
				private ["_tasks"];
				if (_vehicle isKindOf "Helicopter") then {
					_tasks = ["Pickup", "Land", "land (Eng off)", "Move", "Circle", "Insertion"];
				} else {
					_tasks = ["Move"];
				};

				// Patch in ALiVE support data.
				private ["_variable", "_transportArray"];
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

				// Exec the ALiVE fsm file.
				[_vehicle, _group, _callsign, _pos, _dir, FLIGHT_HEIGHT, _class, CS_RESPAWN] execFSM "\x\alive\addons\sup_combatSupport\scripts\NEO_radio\fsms\transport.fsm";

				// Unlock.
				_vehicle lock 0;
				_success = true;
		};

		case "cas": {
				private ["_airport", "_variable", "_casArray"];
				_airport = [_pos] call ALiVE_fnc_getNearestAirportID;

				// ALiVE support data.
				_vehicle setVariable ["ALiVE_combatSupport", true];
				_variable = format ["NEO_radioCasArray_%1", ITD_global_side_blufor];
				_casArray = NEO_radioLogic getVariable _variable;
				_casArray pushBack [_vehicle, _group, _callsign];
				NEO_radioLogic setVariable [_variable, _casArray, true];

				// Exec ALiVE fsm.
				[_vehicle, _group, _callsign, _pos, _airport, _dir, FLIGHT_HEIGHT, _class, CS_RESPAWN] execFSM "\x\alive\addons\sup_combatSupport\scripts\NEO_radio\fsms\cas.fsm";
		};

		default {
				["Invalid support type - %1", _type] call BIS_fnc_error;
		};
};

if (_success) then {
	[["ResistanceMovement","CombatSupport","SupportAvailable"]] call ITD_fnc_broadcastHint;
};

nil;
