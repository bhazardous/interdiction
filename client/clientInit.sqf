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

	["missionStart", false] call BIS_fnc_blackOut;
	waitUntil {!isNil "ITD_global_unit_override"};
	waitUntil {!isNull player};
	waitUntil {time > 0};

	if (ITD_global_unit_override != "") then {
		waitUntil {time > 0};
		private ["_oldUnit", "_unitName", "_newUnit"];
		_oldUnit = player;
		_unitName = format ["%1", player];

		// Create new player unit.
		_newUnit = (group player) createUnit [ITD_global_unit_override, [0,0,0], [], 0, "NONE"];
		selectPlayer _newUnit;
		deleteVehicle _oldUnit;

		// Broadcast new unit.
		call compile format ["%1 = _newUnit", _unitName];
		publicVariable _unitName;

		sleep 1;
	};

	waitUntil {!isNil "ITD_global_canJoin"};
	waitUntil {!isNil "ITD_global_campExists"};
	if (ITD_global_canJoin) then {
		// Mission is still starting (<30 sec)
		[[player], "ITD_fnc_joinRequest", false] call BIS_fnc_MP;

		// Wait for response from server.
		waitUntil {!isNil "ITD_local_playerReady"};
		ITD_local_playerStarted = true;
	} else {
		ITD_local_playerStarted = true;
		[player] call ITD_fnc_respawn;
	};

	2 fadeSound 1;
	2 fadeMusic 1;
	2 fadeRadio 1;
	["missionStart"] call BIS_fnc_blackIn;

	// Add the CBA menu. Using ALiVE's menu 'cause it looks nicer. :)
	ITD_local_flexiMenu = ["player", [[0x2F,[false,true,false]]], 0,
		["_this call ITD_fnc_interdictionMenu", "main"]];
	// ITD_local_flexiMenu call CBA_fnc_flexiMenu_add;
	ITD_local_flexiMenu call ALiVE_fnc_flexiMenu_add;

	// Hints.
	if (ITD_global_canJoin) then {
		sleep 15;
		[["ResistanceMovement", "Interdiction"], 15, "", 35, "", true, true, true] call BIS_fnc_advHint;
		sleep 60;
		if (!ITD_global_campExists) then {
			[["ResistanceMovement","BuildCamp","CampHint"],15,"",35,"",true,true,true] call BIS_fnc_advHint;
		};
	};
};
