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

private ["_vehicle", "_type", "_player", "_success"];
_vehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;
_player = [_this, 2, objNull, [objNull]] call BIS_fnc_param;
_success = false;

if (isNull _player) exitWith {
	["Request sent from objNull?"] call BIS_fnc_error;
	nil;
};

if (INT_global_crewAvailable <= 0) exitWith {
	[["ResistanceMovement","CombatSupport","SupportErrNoCrew"], true, true, false, _player, true] call INT_fnc_broadcastHint;
	nil;
};

switch (_type) do {
		case "transport": {
				// Vehicle dead or invalid.
				if (isNull _vehicle || !alive _vehicle) exitWith {
					["Vehicle dead or doesn't exist"] call BIS_fnc_error;
				};

				// Lock vehicle to players.
				_vehicle lock 3;

				// ALiVE's transport data.
				private ["_pos", "_dir", "_class", "_tasks"];
				_pos = getPosATL _vehicle;
				_dir = getDir _vehicle;
				_class = typeOf _vehicle;
				if (_vehicle isKindOf "Helicopter") then {
					_tasks = ["Pickup", "Land", "land (Eng off)", "Move", "Circle", "Insertion"];
				} else {
					_tasks = ["Move"];
				};

				// Get closest recruitment tent.
				private ["_id", "_spawnPos"];
				_id = [_vehicle, "INT_mkr_recruitment", INT_global_recruitmentTentCount] call INT_fnc_closest;
				_spawnPos = markerPos (format ["INT_mkr_recruitment%1", _id]);

				// Prepare group.
				private ["_turrets", "_group", "_unit"];
				_group = createGroup INT_server_side_blufor;
				[_group, 0] setWaypointPosition [_pos, 0];
				_turrets = [_vehicle] call INT_fnc_getRealTurrets;

				// Spawn driver and crew.
				_unit = _group createUnit [INT_server_blufor_unit, _spawnPos, [], 0, "NONE"];
				_unit assignAsDriver _vehicle;
				{
					private ["_unit"];
					_unit = _group createUnit [INT_server_blufor_unit, _spawnPos, [], 0, "NONE"];
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
					[["ResistanceMovement","CombatSupport","SupportErrDead"], true, true, false, _player, true] call INT_fnc_broadcastHint;
					_vehicle lock 0;
				};
				if (!alive _vehicle) exitWith {
					// Vehicle destroyed.
					[["ResistanceMovement","CombatSupport","SupportErrVDead"], true, true, false, _player, true] call INT_fnc_broadcastHint;
					_vehicle lock 0;
				};

				// Patch in ALiVE support data.
				private ["_variable", "_transportArray"];
				_vehicle setVariable ["ALiVE_combatSupport", true];
				_vehicle setVariable ["NEO_transportAvailableTasks", _tasks, true];
				SUP_TRANSPORTARRAYS pushBack [_pos, _dir, _class, CALLSIGN,	_tasks, "", FLIGHT_HEIGHT];
				publicVariable "SUP_TRANSPORTARRAYS";

				_variable = format ["NEO_radioTrasportArray_%1", INT_server_side_blufor];
				_transportArray = NEO_radioLogic getVariable _variable;
				if (isNil "_transportArray") then {
					_transportArray = [];
				};
				_transportArray pushBack [_vehicle, _group, CALLSIGN];
				NEO_radioLogic setVariable [_variable, _transportArray, true];

				// Exec the ALiVE fsm file.
				[_vehicle, _group, CALLSIGN, _pos, _dir, FLIGHT_HEIGHT, _class, CS_RESPAWN] execFSM "\x\alive\addons\sup_combatSupport\scripts\NEO_radio\fsms\transport.fsm";

				// Unlock.
				_vehicle lock 0;
				_success = true;
		};

		case "artillery": {
				// TODO
		};

		case "combat": {
				// TODO
		};

		default {
				["Invalid support type - %1", _type] call BIS_fnc_error;
		};
};

if (_success) then {
	[["ResistanceMovement","CombatSupport","SupportAvailable"]] call INT_fnc_broadcastHint;
};

nil;
