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
#define MAX_DISTANCE 100		// Max distance a building can be from HQ.

private ["_player", "_type", "_pos", "_rot", "_class"];
_player = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;
_pos = [_this, 2, [0,0,0], [[]], [3]] call BIS_fnc_param;
_rot = [_this, 3, 0, [0]] call BIS_fnc_param;

if (isNull _player) exitWith {
	"Build request sent from objNull" call BIS_fnc_log;
	nil;
};

if (_type == "hq" && {INT_global_campsAvailable == 0}) exitWith {nil;};

// TODO: code duplication with fnc_build :(
// Buildings that require a camp need to be within MAX_DISTANCE.
private ["_valid"];
_valid = false;
if (_type in ["service","recruitment"]) then {
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

// Get closest camp ID.
private ["_campId"];
if (INT_global_campCount > 0) then {
	_campId = [_player, "INT_mkr_resistanceCamp", INT_global_campCount] call INT_fnc_closest;
	_campId = _campId - 1;
};

// One building per camp.
if (_type in ["service","recruitment"]) then {
	if (_type == "service") then {
		_valid = !(INT_server_campData select _campId select 0);
	} else {
		_valid = !(INT_server_campData select _campId select 1);
	};
};
if (!_valid) exitWith {
	[["ResistanceMovement","BuildCamp","Duplicate"],true,true,false,_player,true] call INT_fnc_broadcastHint;
	nil;
};

if (INT_global_buildingEnabled) then {
	private ["_fort"];
	_fort = ([_type, "fort_"] call CBA_fnc_find != -1);

	// Fortifications.
	if (_fort) then {
		private ["_cost"];

		_cost = switch (_type) do {
			case "fort_sandbag": {2};
			case "fort_sandbag_short": {1};
			case "fort_sandbag_round": {2};
			case "fort_sandbag_corner": {1};
			case "fort_sandbag_end": {1};

			case "fort_barrier": {2};
			case "fort_barrier_3": {6};
			case "fort_barrier_5": {10};

			default {0};
		};

		_servicePointId = ([_player, "INT_mkr_servicePoint", INT_global_servicePointCount] call INT_fnc_closest) - 1;
		_data = INT_server_servicePointData select _servicePointId;

		if (_data select 1 >= _cost) then {
			_data set [1, (_data select 1) - _cost];
		} else {
			[["ResistanceMovement","BuildCamp","FortParts"],true,true,false,_player,true] call INT_fnc_broadcastHint;
			_valid = false;
		};
	};

	if (!_valid) exitWith {};

	// Place building.
	private ["_building"];
	_building = [_type, _pos, _rot, false] call INT_fnc_spawnComposition;

	// Keep ALiVE logitstics enabled for fortifications.
	if (!_fort) then {
		{_x setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];} forEach _building;
	} else {
		[INT_module_alive_required, "updateObject", _building] call ALiVE_fnc_logistics;
	};

	// Building specific script.
	switch (_type) do {
		case "hq": {
			private ["_campMarker"];

			// Camps available.
			INT_global_campsAvailable = INT_global_campsAvailable - 1;
			publicVariable "INT_global_campsAvailable";

			// Respawn marker.
			INT_global_campCount = INT_global_campCount + 1;
			publicVariable "INT_global_campCount";

			// Show the camp hint.
			INT_global_lastCampGrid = mapGridPosition _pos;
			INT_global_campBuiltBy = name _player;
			publicVariable "INT_global_lastCampGrid";
			publicVariable "INT_global_campBuiltBy";
			["objCamp", "Succeeded"] call BIS_fnc_taskSetState;
			[["ResistanceMovement", "BuildCamp", "CampBuilt"], true, true, false] call INT_fnc_broadcastHint;

			// Map marker for HQ.
			_campMarker = createMarker [format ["INT_mkr_resistanceCamp%1", INT_global_campCount], _pos];
			_campMarker setMarkerType "b_hq";
			_campMarker setMarkerText "Camp";

			// Add camp position to array.
			INT_global_camps pushBack _pos;
			INT_server_campData pushBack [false,false];

			// Add respawn point.
			[missionNamespace, _pos] call BIS_fnc_addRespawnPosition;

			// Add OPFOR detection trigger to camp position.
			private ["_objectiveParams"];
			_objectiveParams = [format ["ResistanceCamp%1", INT_global_campCount], _pos, 50, "MIL", 30];
			[["EAST"], 150, _objectiveParams] call INT_fnc_triggerOpcomObjective;

			// Notify friendly OPCOM of camp.
			[INT_module_alive_blufor_opcom, _objectiveParams] call INT_fnc_addOpcomObjective;

			// If this was the first camp, enable respawns.
			if (!INT_global_campExists) then {
				INT_global_campExists = true;
				publicVariable "INT_global_campExists";

				[] spawn {
					sleep 60;
					[["ResistanceMovement", "Interdiction", "FieldManual"]] call INT_fnc_broadcastHint;
				};
			};
		};

		case "service": {
			// Add new building to service point array.
			INT_global_servicePoints pushBack (_building select 0);
			publicVariable "INT_global_servicePoints";
			INT_global_servicePointCount = INT_global_servicePointCount + 1;
			publicVariable "INT_global_servicePointCount";

			// Create a hidden marker for the service point.
			private ["_serviceMarker", "_data"];
			_serviceMarker = createMarker [format ["INT_mkr_servicePoint%1", INT_global_servicePointCount], _pos];
			_serviceMarker setMarkerType "Empty";

			// Init service point data.
			INT_server_servicePointData pushBack [0,0,0];
			_data = INT_server_campData select _campId;
			_data set [0, true];
		};

		case "recruitment": {
			// Add new building to the recruitment array.
			INT_global_recruitmentTents pushBack (_building select 0);
			publicVariable "INT_global_recruitmentTents";
			INT_global_recruitmentTentCount = INT_global_recruitmentTentCount + 1;
			publicVariable "INT_global_recruitmentTentCount";

			// Create a hidden marker for the recruitment tent.
			private ["_recruitMarker", "_data"];
			_recruitMarker = createMarker [format ["INT_mkr_recruitment%1", INT_global_recruitmentTentCount], _pos];
			_recruitMarker setMarkerType "Empty";

			// Set camp data.
			_data = INT_server_campData select _campId;
			_data set [1, true];
		};
	};
} else {
	"Build request arrived, but INT_global_buildingEnabled is false" call BIS_fnc_log;
};

nil;
