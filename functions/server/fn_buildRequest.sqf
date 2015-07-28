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
#include "persistentData.hpp"
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

if (_type == "hq" && {ITD_global_campsAvailable == 0}) exitWith {nil;};

// TODO: code duplication with fnc_build :(
// Buildings that require a camp need to be within MAX_DISTANCE.
private ["_valid"];
_valid = false;
if (_type in ["service","recruitment"]) then {
	for "_i" from 1 to (count ITD_global_camps) do {
		private ["_campPos"];
		_campPos = markerPos (format ["ITD_mkr_resistanceCamp%1", _i]);
		if (_campPos distance _pos < MAX_DISTANCE) exitWith {
			_valid = true;
		};
	};
} else {
	_valid = true;
};
if (!_valid) exitWith {
	[[["ITD_Camp","Error_Distance"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
};

// Get closest camp ID.
private ["_id"];
if (count ITD_global_camps > 0) then {
	_id = [_player, "ITD_mkr_resistanceCamp", count ITD_global_camps] call ITD_fnc_closestMarker;
	_id = _id - 1;
};

// One building per camp.
if (_type in ["service","recruitment"]) then {
	if (_type == "service") then {
		_valid = count (DB_CAMPS_SERVICE) == 0;
	} else {
		_valid = count (DB_CAMPS_RECRUIT) == 0;
	};
};
if (!_valid) exitWith {
	[[["ITD_Camp","Error_Duplicate"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
	nil;
};

if (ITD_global_buildingEnabled) then {
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

		_data = DB_CAMPS_SERVICE_DATA;

		if (_data select 1 >= _cost) then {
			_data set [1, (_data select 1) - _cost];
		} else {
			[[["ITD_Service","Error_FortParts"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
			_valid = false;
		};
	};

	if (!_valid) exitWith {};

	// Place building.
	private ["_building"];
	_building = [_type, _pos, _rot, false] call ITD_fnc_spawnComposition;

	// Keep ALiVE logitstics enabled for fortifications.
	if (!_fort) then {
		{_x setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];} forEach _building;
		// [[_building, false], "ITD_fnc_simulateComposition"] call BIS_fnc_MP;
	} else {
		[ITD_module_alive_required, "updateObject", _building] call ALiVE_fnc_logistics;
	};

	// Building specific script.
	switch (_type) do {
		case "hq": {
			private ["_campMarker", "_crate", "_cratePos"];

			// Camps available.
			ITD_global_campsAvailable = ITD_global_campsAvailable - 1;
			publicVariable "ITD_global_campsAvailable";
			SET_DB_PROGRESS_CAMPS_AVAILABLE(ITD_global_campsAvailable);

			// Respawn marker.
			ITD_global_lastCampGrid = mapGridPosition _pos;
			ITD_global_campBuiltBy = name _player;
			publicVariable "ITD_global_lastCampGrid";
			publicVariable "ITD_global_campBuiltBy";
			["objCamp", "Succeeded"] call BIS_fnc_taskSetState;
			[[["ITD_Camp","Info_Built"]], "ITD_fnc_advHint"] call BIS_fnc_MP;

			// Map marker for HQ.
			_campMarker = createMarker [format ["ITD_mkr_resistanceCamp%1", count ITD_global_camps + 1], _pos];
			_campMarker setMarkerType "b_hq";

			// Add camp position to array.
			ITD_global_camps pushBack _pos;
			publicVariable "ITD_global_camps";
			DB_CAMPS pushBack [_pos, _rot, false, [], []];

			// Make service point data public.
			ITD_global_serviceData pushBack [];
			publicVariable "ITD_global_serviceData";

			// Delete the respawn markers if they still exist.
			if (markerType "respawn_west" != "") then {
				deleteMarker "respawn_west";
				deleteMarker "respawn_east";
				deleteMarker "respawn_guerrila";
			};

			// Add respawn point.
			[missionNamespace, _campMarker] call BIS_fnc_addRespawnPosition;

			// Add OPFOR detection trigger to camp position.
			private ["_objectiveParams", "_id"];
			_objectiveParams = [format ["ResistanceCamp%1", count ITD_global_camps], _pos, 50, "MIL", 30];
			_id = (count ITD_global_camps) - 1;
			[ITD_server_faction_enemy, 150, _objectiveParams, _id] call ITD_fnc_triggerOpcomObjective;

			// Notify friendly OPCOM of camp.
			[ITD_module_alive_blufor_opcom, _objectiveParams] call ITD_fnc_addOpcomObjective;

			// If this was the first camp, enable respawns.
			if (!ITD_global_campExists) then {
				ITD_global_campExists = true;
				publicVariable "ITD_global_campExists";

				[] spawn {
					sleep 60;
					[[["ITD_Hints","Info_FieldManual"], -1, true], "ITD_fnc_advHint"] call BIS_fnc_MP;
				};
			};

			// Spawn additional empty ammo crate.
			_cratePos = [[0,6], _rot] call ITD_fnc_rotateRelative;
			_cratePos set [0, (_pos select 0) + (_cratePos select 0)];
			_cratePos set [1, (_pos select 1) + (_cratePos select 1)];
			_cratePos set [2, 0];
			_crate = ITD_server_ammoCrate createVehicle _cratePos;
			_crate setPos _cratePos;
			_crate setDir (random 360);
			clearWeaponCargoGlobal _crate;
			clearMagazineCargoGlobal _crate;
			clearItemCargoGlobal _crate;
			[ITD_module_alive_required, "updateObject", _crate] call ALiVE_fnc_logistics;
		};

		case "service": {
			// Add service point to camp data.
			_data = DB_CAMPS_ID;
			_data set [3, [_pos, _rot, [0,0,0]]];

			// Update global service data.
			ITD_global_serviceData set [_id, (DB_CAMPS_SERVICE_DATA)];
			publicVariable "ITD_global_serviceData";

			// Add new position to service point array.
			ITD_global_servicePoints pushBack _pos;
			publicVariable "ITD_global_servicePoints";
		};

		case "recruitment": {
			// Add new building to the recruitment array.
			ITD_global_recruitmentTents pushBack _pos;
			publicVariable "ITD_global_recruitmentTents";

			// Set camp data.
			_data = DB_CAMPS_ID;
			_data set [4, [_pos, _rot]];
		};
	};
} else {
	"Build request arrived, but ITD_global_buildingEnabled is false" call BIS_fnc_log;
};

nil;
