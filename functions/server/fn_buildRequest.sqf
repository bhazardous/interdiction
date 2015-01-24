scriptName "fn_buildRequest";
/*
	Author: Bhaz

	Description:
	Request sent from players to construct a campsite.

	Parameter(s):
	#0 OBJECT - Player sending the request
	#1 STRING - Building type
	#2 POSITION - Building position
	#3 NUMBER - Direction

	Returns:
	nil
*/

private ["_player", "_type", "_pos", "_rot", "_class"];
_player = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;
_pos = [_this, 2, [0,0,0], [[]], [3]] call BIS_fnc_param;
_rot = [_this, 3, 0, [0]] call BIS_fnc_param;
_class = ([_type] call INT_fnc_lookupBuilding) select 0;

if (isNull _player) exitWith {
	"Build request sent from objNull" call BIS_fnc_log;
	nil;
};
if (_class == "") exitWith {
	["Somehow building is an invalid type - %1", _type] call BIS_fnc_error;
};

if (INT_global_buildingEnabled) then {
	// Place building.
	private ["_building"];
	_building = _class createVehicle _pos;
	_building setPosATL _pos;
	_building setDir _rot;
	_building setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];

	// Building specific script.
	switch (_type) do {
		case "hq": {
			private ["_campMarker", "_spawnMarker"];

			// Respawn marker.
			INT_server_campCount = INT_server_campCount + 1;

			if (!INT_global_campExists) then {
				INT_global_campExists = true;
				publicVariable "INT_global_campExists";

				// Show the first camp hint.
				INT_global_lastCampGrid = mapGridPosition _pos;
				INT_global_campBuiltBy = name _player;
				publicVariable "INT_global_lastCampGrid";
				publicVariable "INT_global_campBuiltBy";
				["objCamp", "Succeeded"] call BIS_fnc_taskSetState;

				// Show the camp hint, then field manual reminder.
				[] spawn {
					[["ResistanceMovement", "BuildCamp", "CampBuilt"]] call INT_fnc_broadcastHint;
					sleep 60;
					[["ResistanceMovement", "Interdiction", "FieldManual"]] call INT_fnc_broadcastHint;
				};
			} else {
				// TODO: Multiple camps hint.
			};

			// Map marker for HQ.
			_campMarker = createMarker [format ["INT_mkr_resistanceCamp%1", INT_server_campCount], _pos];
			_campMarker setMarkerType "b_hq";
			_campMarker setMarkerText "Camp";

			_spawnMarker = createMarker [format ["INT_mkr_resistanceSpawn%1", INT_server_campCount], _pos];
			_spawnMarker setMarkerAlpha 0;
			_spawnMarker setMarkerShape "RECTANGLE";
			_spawnMarker setMarkerSize [25,25];
			"respawn_west" setMarkerPos _pos;

			// Add OPFOR detection trigger to camp position.
			private ["_objectiveParams"];
			_objectiveParams = [format ["ResistanceCamp%1", INT_server_campCount], _pos, 50, "MIL", 30];
			[["EAST"], 150, _objectiveParams] call INT_fnc_triggerOpcomObjective;

			// Notify friendly OPCOM of camp.
			[INT_module_alive_blufor_opcom, _objectiveParams] call INT_fnc_addOpcomObjective;
		};
	};
} else {
	"Build request arrived, but INT_global_buildingEnabled is false" call BIS_fnc_log;
};

nil;
