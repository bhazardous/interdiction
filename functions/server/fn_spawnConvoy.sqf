scriptName "fn_spawnConvoy";
/*
	Author: Bhaz

	Description:
	Spawns trucks with a random start / end point.

	Parameter(s):
	None

	Example:
	n/a

	Returns:
	Nothing
*/

#define DEBUG false

private ["_spawnPositions"];
_spawnPositions = [];
{
	private ["_markerPos"];
	_markerPos = markerPos _x;

	if ([_markerPos, 1000] call ALiVE_fnc_anyPlayersInRange == 0) then {
		_spawnPositions pushBack _markerPos;
	};
} forEach ITD_server_location_markers;
if (count _spawnPositions < 2) exitWith {};

private ["_posIndex", "_position", "_dest", "_vehicleCount", "_vehicles", "_crewGroup"];
_posIndex = floor (random (count _spawnPositions));
_position = _spawnPositions deleteAt _posIndex;
_dest = _spawnPositions select (floor (random (count _spawnPositions)));
_vehicleCount = (floor (random 3)) + 1;
_vehicles = [];
_crewGroup = createGroup ITD_server_side_opfor;

for "_i" from 1 to _vehicleCount do {
	private ["_vehicleClass", "_vehicle", "_driver"];
	_vehicleClass = (ITD_server_opfor_supply select (floor (random (count ITD_server_opfor_supply))));
	_vehicle = _vehicleClass createVehicle _position;
	_vehicles pushBack _vehicle;

	_driver = _crewGroup createUnit [ITD_server_opfor_unit, _position, [], 0, "NONE"];
	_driver moveInDriver _vehicle;
};

_crewGroup setFormation "COLUMN";
_crewGroup addWaypoint [_dest, 0];

[_crewGroup, _vehicles] spawn {
	params ["_grp", "_vehicles"];
	private ["_pos"];

	waitUntil {
		{alive _x} count _vehicles == 0 ||
		{currentWaypoint _grp == 2} ||
		{{alive _x} count units _grp == 0}};
	if ({alive _x} count _vehicles == 0) exitWith {};

	{
		if (alive _x) exitWith {
			_pos = getPos _x;
		};
	} forEach _vehicles;

	if ([_pos, 2000] call ALiVE_fnc_anyPlayersInRange == 0) then {
		{deleteVehicle _x} forEach _vehicles;
		{deleteVehicle _x} forEach units _grp;
	} else {
		(units _grp) orderGetIn false;
		sleep 3;
		[false, [_grp], _vehicles] call ALiVE_fnc_createProfilesFromUnitsRuntime;
	};
};

if (DEBUG) then {
	ITD_server_debug_convoyGroup = _crewGroup;
	ITD_server_debug_convoyVehicles = _vehicles;

	if (markerColor "ITD_mkr_convoyStart" == "") then {
		createMarker ["ITD_mkr_convoyStart", [0,0]];
		createMarker ["ITD_mkr_convoyFinish", [0,0]];
		"ITD_mkr_convoyStart" setMarkerType "mil_start";
		"ITD_mkr_convoyFinish" setMarkerType "mil_end";
	};

	"ITD_mkr_convoyStart" setMarkerPos _position;
	"ITD_mkr_convoyFinish" setMarkerPos _dest;
};
