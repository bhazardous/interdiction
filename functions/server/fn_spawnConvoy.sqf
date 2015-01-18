scriptName "fn_spawnConvoy";
/*
	Author: Bhaz

	Description:
	Spawns trucks with a random start / end point.

	Parameter(s):
	#0 OBJECT - Description

	Returns:
	nil;
*/
// #define TRUCK_COUNT 1

// Look for positions with no resistance units nearby.
private ["_spawnPositions"];
_spawnPositions = [];
{
	private ["_markerPos"];
	_markerPos = markerPos _x;

	if ([_markerPos, 1000] call ALiVE_fnc_anyPlayersInRange == 0) then {
		_spawnPositions pushBack _markerPos;
	};
} forEach INT_server_location_markers;

// Don't spawn convoy if OPFOR lack map control.
if (count _spawnPositions < 2) exitWith {nil;};

// Spawn vehicle and driver.
private ["_posIndex", "_position", "_dest", "_vehicleClass", "_vehicle", "_crewGroup", "_driver"];
_posIndex = floor (random (count _spawnPositions));
_position = _spawnPositions deleteAt _posIndex;
_dest = _spawnPositions select (floor (random (count _spawnPositions)));
_vehicleClass = (INT_server_opfor_supply select (floor (random (count INT_server_opfor_supply))));
_vehicle = _vehicleClass createVehicle _position;
_crewGroup = createGroup INT_server_side_opfor;
_driver = _crewGroup createUnit [INT_server_opfor_unit, _position, [], 0, "NONE"];
_driver moveInDriver _vehicle;

testVehicle = _vehicle;

// Give vehicle a destination.
_crewGroup addWaypoint [_dest, 0];
[_crewGroup, _vehicle] spawn {
	private ["_grp", "_pos", "_vehicle"];
	_grp = _this select 0;
	_vehicle = _this select 1;

	// Wait for vehicle to reach waypoint or die.
	waitUntil {!alive _vehicle || currentWaypoint _grp == 2};
	if (!alive _vehicle) exitWith {};
	_pos = getPos _vehicle;

	// If convoy reached its destination, clean up if there's no players nearby.
	waitUntil {
		sleep 1;
		[_pos, 2000] call ALiVE_fnc_anyPlayersInRange == 0;
	};

	if (alive _vehicle) then {
		deleteVehicle _vehicle;
	};
};

nil;
