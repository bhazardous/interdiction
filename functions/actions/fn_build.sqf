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
#define MIN_CAMP_DISTANCE 1500	// Distance between resistance HQs.

private ["_type"];
_type = [_this, 0, "", [""]] call BIS_fnc_param;
if (_type == "") then {
	["No building type"] call BIS_fnc_error;
};

if (isNil "INT_local_building") then {
	INT_local_building = false;
	INT_local_building_snap = true;
};
if (INT_local_building) exitWith {};

// Start building placement.
private ["_pos", "_dir", "_building"];
_pos = position player;
_pos set [2, 0];
_dir = getDir player;

// Don't continue if the position is invalid.
_pos = _pos isFlatEmpty [0,0,1.0,7,0, false, player];
if (count _pos == 0) exitWith {
	[["ResistanceMovement", "BuildCamp", "InvalidPosition"], 5, "", 5, "", true, true] call BIS_fnc_advHint;
};

// Buildings that require a camp need to be within MAX_DISTANCE.
private ["_valid"];
_valid = false;
if (_type in ["service","recruitment"]) then {
	for "_i" from 1 to (count INT_global_camps) do {
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
	nil;
};

// Camp HQ requires min distance between camps.
if (_type == "hq") then {
	if ([_pos, INT_global_camps, MIN_CAMP_DISTANCE] call INT_fnc_nearby) then {
		_valid = false;
	};
};
if (!_valid) exitWith {
	[["ResistanceMovement","BuildCamp","HQDistance"], 5, "", 5, "", true, true] call BIS_fnc_advHint;
	nil;
};

_building = [_type, _pos, _dir] call INT_fnc_spawnComposition;
if (count _building == 0) exitWith {nil;};
INT_local_building = true;
INT_local_building_object = _building;

// Building tutorial hint.
[["ResistanceMovement","BuildCamp","BuildInstructions"],10,"",30,"",true,true,true] call BIS_fnc_advHint;

// Placement loop.
[_type, _building] spawn {
	private ["_type", "_building", "_startPos"];
	_type = _this select 0;
	_building = _this select 1;
	_startPos = getPos player;

	// C to place or Ctrl+C to abort. Shift+C terrain snap.
	[0x2E, [false, false, false], {_this call INT_fnc_buildKeypress}, "keydown", "INT_buildPlace"] call CBA_fnc_addKeyHandler;
	[0x2E, [false, true, false], {_this call INT_fnc_buildKeypress}, "keydown", "INT_buildAbort"] call CBA_fnc_addKeyHandler;

	// Position loop.
	while {INT_local_building} do {
		private ["_pos", "_dir"];
		_pos = getPos player;
		_pos set [2, 0];
		_dir = direction player;
		[_type, _building, _pos, _dir] call INT_fnc_moveComposition;
		INT_local_building_pos = _pos;
		INT_local_building_dir = _dir;

		/*if (INT_local_building_snap) then {
			_building setVectorUp (surfaceNormal _pos);
		};*/

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

	switch (INT_local_building_action) do {
		case "abort": {
			// Aborted by distance or 'esc'.
			if (count INT_local_building_object > 0) then {
				{deleteVehicle _x;} forEach INT_local_building_object;
				INT_local_building_object = [];
			};
		};

		case "build": {
			// Position confirmed, send request to server.
			if (count INT_local_building_object > 0) then {
				private ["_pos", "_rot", "_checkPos"];

				// Delete the ghost object.
				_pos = INT_local_building_pos;
				_rot = INT_local_building_dir;
				// _vec = vectorUp INT_local_building_object;
				{deleteVehicle _x;} forEach INT_local_building_object;
				INT_local_building_object = [];

				// Confirm the final position is OK.
				// Position returned from isFlatEmpty can be slightly different, so don't use it.
				_checkPos = _pos isFlatEmpty [0,0,1.0,7,0, false, player];
				if (count _checkPos == 0) exitWith {
					[["ResistanceMovement", "BuildCamp", "InvalidPosition"], 5, "", 5, "", true, true] call BIS_fnc_advHint;
				};

				// Send the build request to the server.
				[[player, _type, _pos, _rot], "INT_fnc_buildRequest", false] call BIS_fnc_MP;
			};
		};

		default {
			// Invalid case.
			["Building action invalid - %1", INT_local_building_action] call BIS_fnc_error;
		};
	};
};

nil;
