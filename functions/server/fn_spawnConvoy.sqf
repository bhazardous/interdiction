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

private ["_posIndex", "_position", "_dest", "_vehicleClass", "_vehicle", "_crewGroup", "_driver"];
_posIndex = floor (random (count _spawnPositions));
_position = _spawnPositions deleteAt _posIndex;
_dest = _spawnPositions select (floor (random (count _spawnPositions)));
_vehicleClass = (ITD_server_opfor_supply select (floor (random (count ITD_server_opfor_supply))));
_vehicle = _vehicleClass createVehicle _position;
_crewGroup = createGroup ITD_server_side_opfor;
_driver = _crewGroup createUnit [ITD_server_opfor_unit, _position, [], 0, "NONE"];
_driver moveInDriver _vehicle;

_crewGroup addWaypoint [_dest, 0];
[_crewGroup, _vehicle] spawn {
	params ["_grp", "_vehicle"];
	private ["_pos"];

	waitUntil {!alive _vehicle ||
		{currentWaypoint _grp == 2} ||
		{{alive _x} count units _grp == 0}};
	if (!alive _vehicle) exitWith {};

	_pos = getPos _vehicle;
	if ([_pos, 2000] call ALiVE_fnc_anyPlayersInRange == 0) then {
		deleteVehicle _vehicle;
		{deleteVehicle _x} forEach units _grp;
	} else {
		(units _grp) orderGetIn false;
		sleep 1;
		[false, [_grp], [_vehicle]] call ALiVE_fnc_createProfilesFromUnitsRuntime;
	};
};

if (DEBUG) then {
	ITD_server_debug_convoyGroup = _crewGroup;
	ITD_server_debug_convoyVehicle = _vehicle;

	if (markerColor "ITD_mkr_convoyStart" == "") then {
		createMarker ["ITD_mkr_convoyStart", [0,0]];
		createMarker ["ITD_mkr_convoyFinish", [0,0]];
		"ITD_mkr_convoyStart" setMarkerType "mil_start";
		"ITD_mkr_convoyFinish" setMarkerType "mil_end";
	};

	"ITD_mkr_convoyStart" setMarkerPos _position;
	"ITD_mkr_convoyFinish" setMarkerPos _dest;
};
