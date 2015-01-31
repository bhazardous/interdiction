scriptName "fn_build";
/*
	Author: Bhaz

	Description:
	Handles client building placement and sends the request to the server.

	Parameter(s):
	#0 STRING - Type of building

	Returns:
	nil
*/
#define RUN_DISTANCE 8			// Distance players can move before cancelling build.
#define MAX_DISTANCE 100		// Max distance a building can be from HQ.

if (isNil "INT_local_building") then {
	INT_local_building = false;
	INT_local_building_snap = true;
};
if (INT_local_building) exitWith {};

private ["_type", "_buildingData", "_class", "_distance"];
_type = [_this, 0, "", [""]] call BIS_fnc_param;

// Get classname for building type.
_buildingData = [_type] call INT_fnc_lookupBuilding;
_class = (_buildingData select 0);
_distance = (_buildingData select 1);

if (_class == "") exitWith {
	["Called with invalid building type: %1", _type] call BIS_fnc_error;
};

// Start building placement.
private ["_pos", "_dir", "_building"];
_pos = player modelToWorld [0, _distance, 0];
_pos set [2, 0];
_dir = (getDir player + 180) % 360;

// Don't continue if the position is invalid.
_pos = _pos isFlatEmpty [0,0,1.0,7,0, false, player];
if (count _pos == 0) exitWith {
	[["ResistanceMovement", "BuildCamp", "InvalidPosition"], 5, "", 5, "", true, true] call BIS_fnc_advHint;
};

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
	[["ResistanceMovement", "BuildCamp", "Distance"], 5, "", 5, "", true, true] call BIS_fnc_advHint;
};

_building = _class createVehicleLocal _pos;
_building setDir _dir;
_building allowDamage false;
INT_local_building = true;
INT_local_building_object = _building;
if (isNull _building) exitWith {
	["Building is null"] call BIS_fnc_error;
};

// Building tutorial hint.
[["ResistanceMovement","BuildCamp","BuildInstructions"],10,"",30,"",true,true,true] call BIS_fnc_advHint;

// Placement loop.
[_building, _distance] spawn {
	private ["_building", "_distance", "_pos", "_startPos"];
	_building = _this select 0;
	_distance = _this select 1;
	_startPos = getPos player;

	// C to place or Ctrl+C to abort. Shift+C terrain snap.
	[0x2E, [false, false, false], {_this call INT_fnc_buildKeypress}, "keydown", "INT_buildPlace"] call CBA_fnc_addKeyHandler;
	[0x2E, [false, true, false], {_this call INT_fnc_buildKeypress}, "keydown", "INT_buildAbort"] call CBA_fnc_addKeyHandler;
	[0x2E, [true, false, false], {_this call INT_fnc_buildKeypress}, "keydown", "INT_buildSnap"] call CBA_fnc_addKeyHandler;

	// Position loop.
	while {INT_local_building} do {
		_pos = player modelToWorld [0, _distance, 0];
		_pos set [2, 0];
		_building setPos _pos;
		_building setDir ((getDir player + 180) % 360);
		if (INT_local_building_snap) then {
			_building setVectorUp (surfaceNormal _pos);
		};

		if (player distance _startPos > RUN_DISTANCE) then {
			INT_local_building_action = "abort";
			INT_local_building = false;
		};

		sleep 0.04;
	};
};

// Wait for placement and confirm.
[_type] spawn {
	private ["_type"];
	_type = _this select 0;

	waitUntil {!INT_local_building};

	// Remove keybinds.
	["INT_buildPlace"] call CBA_fnc_removeKeyHandler;
	["INT_buildAbort"] call CBA_fnc_removeKeyHandler;
	["INT_buildSnap"] call CBA_fnc_removeKeyHandler;

	switch (INT_local_building_action) do {
		case "abort": {
			// Aborted by distance or 'esc'.
			if (!isNull INT_local_building_object) then {
				deleteVehicle INT_local_building_object;
			};
		};

		case "build": {
			// Position confirmed, send request to server.
			if (!isNull INT_local_building_object) then {
				private ["_pos", "_rot", "_vec", "_checkPos"];

				// Delete the ghost object.
				_pos = getPosATL INT_local_building_object;
				_rot = getDir INT_local_building_object;
				_vec = vectorUp INT_local_building_object;
				deleteVehicle INT_local_building_object;

				// Confirm the final position is OK.
				// Position returned from isFlatEmpty can be slightly different, so don't use it.
				_checkPos = _pos isFlatEmpty [0,0,1.0,7,0, false, player];
				if (count _checkPos == 0) exitWith {
					[["ResistanceMovement", "BuildCamp", "InvalidPosition"], 5, "", 5, "", true, true] call BIS_fnc_advHint;
				};

				// Send the build request to the server.
				[[player, _type, _pos, _rot, _vec], "INT_fnc_buildRequest", false] call BIS_fnc_MP;
			};
		};

		default {
			// Invalid case.
			["Building action invalid - %1", INT_local_building_action] call BIS_fnc_error;
		};
	};
};

nil;
