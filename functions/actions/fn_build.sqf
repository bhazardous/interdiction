scriptName "fn_build";
/*
	Author: Bhaz

	Description:
	Handles client building placement and sends the request to the server.

	Parameter(s):
	#0 STRING - Type of building

	Example:
	n/a

	Returns:
	Nothing
*/

#define RUN_DISTANCE 8			// Distance players can move before cancelling build.
#define MAX_DISTANCE 100		// Max distance from HQ.
#define MIN_HQ_DISTANCE 1500	// Min distance between HQs.

if (!params [["_type", "", [""]]]) exitWith {
	["Invalid building type: %1", _type] call BIS_fnc_error;
};
if (_type == "") exitWith {["Empty building type"] call BIS_fnc_error};
if (ITD_local_building) exitWith {};

private ["_playerPos", "_pos", "_dir", "_valid", "_building"];
_playerPos = position player;
_playerPos set [2, 0];
_dir = getDir player;
_valid = false;
_pos = _playerPos isFlatEmpty [0,0,1.0,7,0, false, player];
if (count _pos == 0) exitWith {[["ITD_Camp","Error_Position"], 5] call ITD_fnc_advHint};

switch (_type) do {
	case "hq": {
		if (!([_pos, ITD_global_camps, MIN_HQ_DISTANCE] call ITD_fnc_nearby)) then {
			_valid = true;
		} else {
			[["ITD_Camp","Error_DistanceHQ"], 5] call ITD_fnc_advHint;
		};
	};

	case "recruitment";
	case "service": {
		if ([_playerPos, ITD_global_camps, MAX_DISTANCE] call ITD_fnc_nearby) then {
			_valid = true;
		} else {
			[["ITD_Camp","Error_Distance"], 5] call ITD_fnc_advHint;
		};
	};

	default {_valid = true};
};
if (!_valid) exitWith {};

_building = [_type, _pos, _dir] call ITD_fnc_spawnComposition;
if (count _building == 0) exitWith {};
[_building, false, false] call ITD_fnc_simulateComposition;
ITD_local_building = true;
ITD_local_building_object = _building;
[["ITD_Hints","Info_Building"], -1, true] call ITD_fnc_advHint;

[_type, _building, _playerPos] spawn {
	params ["_type", "_building", "_startPos", "_pos", "_dir"];

	// C to place or Ctrl+C to abort.
	[0x2E, [false, false, false], {_this call ITD_fnc_buildKeypress}, "keydown", "ITD_buildPlace"] call CBA_fnc_addKeyHandler;
	[0x2E, [false, true, false], {_this call ITD_fnc_buildKeypress}, "keydown", "ITD_buildAbort"] call CBA_fnc_addKeyHandler;

	waitUntil {
		ITD_local_building_pos = getPos player;
		ITD_local_building_pos set [2, 0];
		ITD_local_building_dir = getDir player;

		[_type, _building, ITD_local_building_pos, ITD_local_building_dir] call ITD_fnc_moveComposition;

		if (player distance _startPos > RUN_DISTANCE) then {
			ITD_local_building_action = "abort";
			ITD_local_building = false;
		};

		!ITD_local_building
	};
};

[_type] spawn {
	params ["_type"];
	waitUntil {!ITD_local_building};

	["ITD_buildPlace"] call CBA_fnc_removeKeyHandler;
	["ITD_buildAbort"] call CBA_fnc_removeKeyHandler;

	switch (ITD_local_building_action) do {
		case "abort": {
			if (count ITD_local_building_object > 0) then {
				{deleteVehicle _x} forEach ITD_local_building_object;
				ITD_local_building_object = [];
			};
		};

		case "build": {
			if (count ITD_local_building_object > 0) then {
				private ["_checkPos"];

				{deleteVehicle _x;} forEach ITD_local_building_object;
				ITD_local_building_object = [];

				// Position returned from isFlatEmpty is slightly off, don't use it.
				_checkPos = ITD_local_building_pos isFlatEmpty [0,0,1.0,7,0, false, player];
				if (count _checkPos == 0) exitWith {
					[["ITD_Camp","Error_Position"], 5] call ITD_fnc_advHint;
				};

				[[player, _type, ITD_local_building_pos, ITD_local_building_dir], "ITD_fnc_buildRequest", false] call BIS_fnc_MP;
			};
		};

		default {
			["Building action invalid - %1", ITD_local_building_action] call BIS_fnc_error;
		};
	};
};
