scriptName "playerStart";
/*--------------------------------------------------------------------
	file: playerStart.sqf
	=====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "playerStart.sqf"
#define DEBUG_BLUFOR false
#define DEBUG_OPFOR false

// Start the spawner.
[] spawn ITD_fnc_spawnQueue;

// Switch to debug unit if in the editor.
if (DEBUG_OPFOR) then {
	if (hasInterface) then {
		selectPlayer ITD_unit_testPlayer;
	} else {
		deleteVehicle ITD_unit_testPlayer;
	};
} else {
	deleteVehicle ITD_unit_testPlayer;
};

if (DEBUG_BLUFOR) then {
	if (hasInterface) then {
		[] spawn {
			waitUntil {time > 2};
			player setPos [2099.27,4161.88,0];
		};
	};
};
