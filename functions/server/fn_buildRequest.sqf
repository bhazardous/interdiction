scriptName "fn_buildRequest";
/*
	Author: Bhaz

	Description:
	Request sent from players to construct a campsite.

	RemoteExec: Client

	Parameter(s):
	#0 OBJECT - Player sending the request
	#1 STRING - Building type
	#2 POSITION - Building position
	#3 NUMBER - Direction

	Example:
	n/a

	Returns:
	Nothing
*/

#include "persistentData.hpp"
#define MAX_DISTANCE 100		// Max distance a building can be from HQ.

if (!params [
	["_player", objNull, [objNull]],
	["_type", "", [""]],
	["_pos", [], [[]], [3]],
	["_rot", 0, [0]]]) exitWith {["Invalid params"] call BIS_fnc_error};

private ["_class"];
if (isNull _player) exitWith {["Build request sent from objNull"] call BIS_fnc_error};
if (_type == "hq" && {ITD_global_campsAvailable == 0}) exitWith {};

private ["_valid", "_id"];
_valid = false;
_id = [_player, ITD_global_camps] call ITD_fnc_closestPosition;
if (_type in ["service","recruitment"]) then {
	if ([_pos, ITD_global_camps, MAX_DISTANCE] call ITD_fnc_nearby) then {
		if (_type == "service") then {
			_valid = count (DB_CAMPS_SERVICE) == 0;
		} else {
			_valid = count (DB_CAMPS_RECRUIT) == 0;
		};

		if (!_valid) then {
			[[["ITD_Camp","Error_Duplicate"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		};
	} else {
		[[["ITD_Camp","Error_Distance"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
	};
} else {
	_valid = true;
};
if (!_valid) exitWith {};

if (ITD_global_buildingEnabled) then {
	private ["_fort"];
	_fort = ([_type, "fort_"] call CBA_fnc_find != -1);

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

		if (DB_CAMPS_SERVICE_DATA_PARTS >= _cost) then {
			private ["_data"];
			_data = DB_CAMPS_SERVICE_DATA;
			_data set [1, (_data select 1) - _cost];
		} else {
			[[["ITD_Service","Error_FortParts"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
			_valid = false;
		};
	};
	if (!_valid) exitWith {};

	private ["_building"];
	_building = [_type, _pos, _rot, false] call ITD_fnc_spawnComposition;
	[_building, false, false, true] call ITD_fnc_simulateComposition;

	if (!_fort) then {
		{_x setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];} forEach _building;
	} else {
		[ITD_module_alive_required, "updateObject", _building] call ALiVE_fnc_logistics;
	};

	switch (_type) do {
		case "hq": {
			private ["_campMarker", "_objectiveParams", "_id", "_crate", "_cratePos"];

			ITD_global_campsAvailable = ITD_global_campsAvailable - 1;
			publicVariable "ITD_global_campsAvailable";
			SET_DB_PROGRESS_CAMPS_AVAILABLE(ITD_global_campsAvailable);

			ITD_global_lastCampGrid = mapGridPosition _pos;
			ITD_global_campBuiltBy = name _player;
			publicVariable "ITD_global_lastCampGrid";
			publicVariable "ITD_global_campBuiltBy";
			["objCamp", "Succeeded"] call BIS_fnc_taskSetState;
			[[["ITD_Camp","Info_Built"]], "ITD_fnc_advHint"] call BIS_fnc_MP;

			_campMarker = createMarker [format ["ITD_mkr_resistanceCamp%1", count ITD_global_camps + 1], _pos];
			_campMarker setMarkerType "b_hq";

			ITD_global_camps pushBack _pos;
			publicVariable "ITD_global_camps";
			DB_CAMPS pushBack [_pos, _rot, false, [], []];

			ITD_global_serviceData pushBack [];
			publicVariable "ITD_global_serviceData";

			if (markerType "respawn_west" != "") then {
				deleteMarker "respawn_west";
				deleteMarker "respawn_east";
				deleteMarker "respawn_guerrila";
			};

			[missionNamespace, _campMarker] call BIS_fnc_addRespawnPosition;

			_objectiveParams = [format ["ResistanceCamp%1", count ITD_global_camps], _pos, 50, "MIL", 30];
			_id = (count ITD_global_camps) - 1;
			[ITD_server_faction_enemy, 150, _objectiveParams, _id] call ITD_fnc_triggerOpcomObjective;
			[ITD_module_alive_blufor_opcom, _objectiveParams] call ITD_fnc_addOpcomObjective;

			if (!ITD_global_campExists) then {
				ITD_global_campExists = true;
				publicVariable "ITD_global_campExists";

				[] spawn {
					sleep 60;
					[[["ITD_Hints","Info_FieldManual"], -1, true], "ITD_fnc_advHint"] call BIS_fnc_MP;
				};
			};

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

			// Add spawn vehicles as persistent profiles.
			[false, [], ITD_server_spawnVehicles] call ALiVE_fnc_createProfilesFromUnitsRuntime;
			ITD_server_spawnVehicles = [];
		};

		case "service": {
			_data = DB_CAMPS_ID;
			_data set [3, [_pos, _rot, [0,0,0]]];

			ITD_global_serviceData set [_id, (DB_CAMPS_SERVICE_DATA)];
			publicVariable "ITD_global_serviceData";

			ITD_global_servicePoints pushBack _pos;
			publicVariable "ITD_global_servicePoints";
		};

		case "recruitment": {
			_data = DB_CAMPS_ID;
			_data set [4, [_pos, _rot]];

			ITD_global_recruitmentTents pushBack _pos;
			publicVariable "ITD_global_recruitmentTents";
		};
	};
};
