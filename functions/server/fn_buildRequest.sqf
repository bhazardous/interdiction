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
	#4 ARRAY - Vector up

	Returns:
	nil
*/
#define MAX_DISTANCE 100		// Max distance a building can be from HQ.

private ["_player", "_type", "_pos", "_rot", "_class"];
_player = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;
_pos = [_this, 2, [0,0,0], [[]], [3]] call BIS_fnc_param;
_rot = [_this, 3, 0, [0]] call BIS_fnc_param;
_vec = [_this, 4, [0,0,0], [[]]] call BIS_fnc_param;
_class = ([_type] call INT_fnc_lookupBuilding) select 0;

if (isNull _player) exitWith {
	"Build request sent from objNull" call BIS_fnc_log;
	nil;
};
if (_class == "") exitWith {
	["Somehow building is an invalid type - %1", _type] call BIS_fnc_error;
};

// TODO: code duplication with fnc_build :(
// Buildings that require a camp need to be within MAX_DISTANCE.
private ["_valid"];
_valid = false;
if (_type in ["service"]) then {
	for "_i" from 1 to INT_global_campCount do {
		private ["_campPos"];
		_campPos = markerPos (format ["INT_mkr_resistanceCamp%1", _i]);
		if (_campPos distance _pos < MAX_DISTANCE) exitWith {
			_valid = true;
		};
	};
} else {
	_valid = true;
};
if (!_valid) exitWith {
	[["ResistanceMovement","BuildCamp","Distance"], true, true, false, _player, true] call INT_fnc_broadcastHint;
};

if (INT_global_buildingEnabled) then {
	// Place building.
	private ["_building"];
	_building = _class createVehicle _pos;
	_building setPosATL _pos;
	_building setDir _rot;
	_building setVectorUp _vec;
	_building setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];

	// Disable damage.
	_building allowDamage false;

	// Building specific script.
	switch (_type) do {
		case "hq": {
			private ["_campMarker", "_spawnMarker"];

			// Respawn marker.
			INT_global_campCount = INT_global_campCount + 1;
			publicVariable "INT_global_campCount";

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
			_campMarker = createMarker [format ["INT_mkr_resistanceCamp%1", INT_global_campCount], _pos];
			_campMarker setMarkerType "b_hq";
			_campMarker setMarkerText "Camp";

			_spawnMarker = createMarker [format ["INT_mkr_resistanceSpawn%1", INT_global_campCount], _pos];
			_spawnMarker setMarkerAlpha 0;
			_spawnMarker setMarkerShape "RECTANGLE";
			_spawnMarker setMarkerSize [25,25];
			"respawn_west" setMarkerPos _pos;

			// Add OPFOR detection trigger to camp position.
			private ["_objectiveParams"];
			_objectiveParams = [format ["ResistanceCamp%1", INT_global_campCount], _pos, 50, "MIL", 30];
			[["EAST"], 150, _objectiveParams] call INT_fnc_triggerOpcomObjective;

			// Notify friendly OPCOM of camp.
			[INT_module_alive_blufor_opcom, _objectiveParams] call INT_fnc_addOpcomObjective;
		};

		case "service": {
			// Add new building to service point array.
			INT_global_servicePoints pushBack _building;
			publicVariable "INT_global_servicePoints";
			INT_global_servicePointCount = INT_global_servicePointCount + 1;
			publicVariable "INT_global_servicePointCount";

			// Create a hidden marker for the service point.
			private ["_serviceMarker"];
			_serviceMarker = createMarker [format ["INT_mkr_servicePoint%1", INT_global_servicePointCount], _pos];
			_serviceMarker setMarkerType "Empty";

			// Init service point data.
			INT_server_servicePointData pushBack [0,0];
		};
	};
} else {
	"Build request arrived, but INT_global_buildingEnabled is false" call BIS_fnc_log;
};

nil;
