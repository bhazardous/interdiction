scriptName "clientInit";
/*--------------------------------------------------------------------
	file: clientInit.sqf
	====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "clientInit.sqf"

// Override faction unit.
[] spawn {
	0 fadeSound 0;
	0 fadeMusic 0;
	0 fadeRadio 0;

	["missionStart", true] call BIS_fnc_blackOut;
	waitUntil {!isNil "INT_global_unit_override"};
	waitUntil {!isNull player};

	if (INT_global_unit_override != "") then {
		waitUntil {time > 0};
		private ["_oldUnit", "_unitName", "_newUnit"];
		_oldUnit = player;
		_unitName = format ["%1", player];

		// Create new player unit.
		_newUnit = (group player) createUnit [INT_global_unit_override, [0,0,0], [], 0, "NONE"];
		selectPlayer _newUnit;
		deleteVehicle _oldUnit;

		// Broadcast new unit.
		call compile format ["%1 = _newUnit", _unitName];
		publicVariable _unitName;

		sleep 1;
	};

	waitUntil {!isNil "INT_global_canJoin"};
	if (INT_global_canJoin) then {
		// Mission is still starting (<30 sec)
		[[player], "INT_fnc_joinRequest", false] call BIS_fnc_MP;

		// Wait for response from server.
		waitUntil {!isNil "INT_local_playerReady"};
	} else {
		if (INT_global_campExists) then {
			// Camp exists, move to spawn.
			player setPos (["respawn_west"] call BIS_fnc_randomPosTrigger);
		} else {
			// No camp, start spectating.
			[] call INT_fnc_spectate;
		};
	};

	2 fadeSound 1;
	2 fadeMusic 1;
	2 fadeRadio 1;
	["missionStart"] call BIS_fnc_blackIn;
	INT_local_playerStarted = true;

	// Add the CBA menu. Using ALiVE's menu 'cause it looks nicer. :)
	INT_local_flexiMenu = ["player", [[0x2F,[false,true,false]]], 0,
		["_this call INT_fnc_interdictionMenu", "main"]];
	// INT_local_flexiMenu call CBA_fnc_flexiMenu_add;
	INT_local_flexiMenu call ALiVE_fnc_flexiMenu_add;

	// Hints.
	sleep 15;
	[["ResistanceMovement", "Interdiction"], 15, "", 35, "", true, true, true] call BIS_fnc_advHint;
	sleep 60;
	if (!INT_global_campExists) then {
		[["ResistanceMovement","BuildCamp","CampHint"],15,"",35,"",true,true,true] call BIS_fnc_advHint;
	};
};
