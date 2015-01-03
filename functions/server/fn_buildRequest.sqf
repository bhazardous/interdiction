scriptName "fn_buildRequest";
/*
	Author: Bhaz

	Description:
	Request sent from players to construct a campsite.

	Parameter(s):
	#0 ARRAY - Params sent from BIS_fnc_MP
		#0 OBJECT - Player sending the request

	Returns:
	nil
*/

private ["_player"];
_player = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _player) exitWith {
	"Build request sent from objNull" call BIS_fnc_log;
	nil;
};

if (INT_global_buildingEnabled) then {
	// Make sure the position is valid.
	private ["_campPosition"];
	_campPosition = _player modelToWorld [0,1,0];
	_campPosition = _campPosition isFlatEmpty [0,0,1.0,7,0, false, _player];
	if (count _campPosition == 0) exitWith {
		[[["ResistanceMovement", "BuildCamp", "InvalidPosition"], 10, "", 10, "", true, true], "BIS_fnc_advHint", _player] call BIS_fnc_MP;
		[[true], "INT_fnc_toggleCampConstruction", _player, false, false] call BIS_fnc_MP;
	};

	// Position is valid - create object.
	private ["_tent", "_campMarker", "_spawnMarker"];
	_tent = "Land_TentDome_F" createVehicle _campPosition;
	_tent setVariable ["ALiVE_SYS_LOGISTICS_DISABLE", true];
	[[false], "INT_fnc_toggleCampConstruction", true, false, false] call BIS_fnc_MP;

	// Enable respawning at this camp.
	_campMarker = createMarker ["INT_mkr_resistanceCamp", _campPosition];
	_campMarker setMarkerType "b_hq";
	_campMarker setMarkerText "Camp";

	_spawnMarker = createMarker ["INT_mkr_resistanceCampSpawn", _campPosition];
	_spawnMarker setMarkerAlpha 0;
	_spawnMarker setMarkerShape "RECTANGLE";
	_spawnMarker setMarkerSize [25,25];
	"respawn_west" setMarkerPos _campPosition;

	INT_global_campExists = true;
	publicVariable "INT_global_campExists";
	INT_global_buildingEnabled = false;
	publicVariable "INT_global_buildingEnabled";
	INT_global_campBuiltBy = name _player;
	publicVariable "INT_global_campBuiltBy";
	["objCamp", "Succeeded"] call BIS_fnc_taskSetState;

	// Add OPFOR detection trigger to camp position.
	private ["_objectiveParams"];
	_objectiveParams = ["ResistanceCamp", _campPosition, 50, "MIL", 30];
	[["EAST"], 200, _objectiveParams] call INT_fnc_triggerOpcomObjective;

	// Notify friendly OPCOM of camp.
	[INT_module_alive_blufor_opcom, _objectiveParams] call INT_fnc_addOpcomObjective;

	// Queue up gameplay hints.
	[] spawn {
		[[["ResistanceMovement", "BuildCamp", "CampBuilt"], 15, "", 35, "", true, true, true], "BIS_fnc_advHint"] call BIS_fnc_MP;
		sleep 60;
		[[["ResistanceMovement", "GuerrillaWarfare"], 15, "", 35, "", true, true, true], "BIS_fnc_advHint"] call BIS_fnc_MP;
		sleep 120;
		[[["ResistanceMovement", "Equipment"], 15, "", 35, "", true, true, true], "BIS_fnc_advHint"] call BIS_fnc_MP;
	};
} else {
	"Build request arrived, but INT_global_buildingEnabled is false" call BIS_fnc_log;
};

nil;
