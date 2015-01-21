scriptName "fn_addSupport";
/*
	Author: Bhaz

	Description:
	Spawns a crew, and adds a vehicle to the ALiVE support module.

	Parameter(s):
	#0 OBJECT - Vehicle to add
	#1 STRING - Type of support

	Returns:
	nil
*/
#define FLIGHT_HEIGHT 100
#define CALLSIGN "RESISTANCE TRANSPORT"

private ["_vehicle", "_type"];
_vehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;

switch (_type) do {
		case "transport": {
				// Vehicle dead or invalid.
				if (isNull _vehicle || !alive _vehicle) exitWith {
					hint "ERROR- vehicle dead or doesn't exist";
					nil;
				};

				// ALiVE's transport data.
				private ["_pos", "_dir", "_class", "_tasks"];
				_pos = getPosATL _vehicle;
				_dir = getDir _vehicle;
				_class = typeOf _vehicle;
				_tasks = ["Pickup", "Land", "land (Eng off)", "Move", "Circle", "Insertion"];

				// Temporary - spawn crew.
				private ["_group"];
				_group = createGroup INT_server_side_blufor;
				[_vehicle, _group] call BIS_fnc_spawnCrew;
				[_group, 0] setWaypointPosition [_pos, 0];

				// Patch in ALiVE support data.
				private ["_variable", "_transportArray"];
				_vehicle setVariable ["ALiVE_combatSupport", true];
				_vehicle setVariable ["NEO_transportAvailableTasks", _tasks];
				SUP_TRANSPORTARRAYS pushBack [_pos, _dir, _class, CALLSIGN,	_tasks, "", FLIGHT_HEIGHT];
				publicVariable "SUP_TRANSPORTARRAYS";

				_variable = format ["NEO_radioTrasportArray_%1", INT_server_side_blufor];
				hint format ["%1", _variable];
				_transportArray = NEO_radioLogic getVariable _variable;
				if (isNil "_transportArray") then {
					_transportArray = [];
				};
				_transportArray pushBack [_vehicle, _group, CALLSIGN];
				NEO_radioLogic setVariable [_variable, _transportArray, true];

				// Exec the ALiVE fsm file.
				[_vehicle, _group, CALLSIGN, _pos, _dir, FLIGHT_HEIGHT, _class, CS_RESPAWN] execFSM "\x\alive\addons\sup_combatSupport\scripts\NEO_radio\fsms\transport.fsm";
		};

		case "artillery": {
				// TODO
		};

		case "cas": {
				// TODO
		};

		default {
				["Invalid support type - %1", _type] call BIS_fnc_error;
		};
};

nil;
