scriptName "serverInit";
/*--------------------------------------------------------------------
	file: serverInit.sqf
	====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "serverInit.sqf"
#define PUBLIC(var,value) var = value; publicVariable #var

// If using persistence, determine if this is a new game or loading from DB.
INT_server_newGame = true;
if (INT_server_persistence) then {
	waitUntil {!isNil "ALiVE_sys_data_dictionaryLoaded"};
	if (ALiVE_sys_data_dictionaryLoaded) then {
		INT_server_newGame = false;
	};
};

// General mission variables.
INT_server_killThreshold = 15;			// Number of OPFOR killed for civilians to join resistance movement.
INT_server_crewThreshold = 5;			// Reach the kill threshold x times to unlock support crew.
INT_server_campThreshold = 10;			// Unlocks extra camps.

PUBLIC(INT_global_buildingEnabled,true);// Global toggle for building.

// (TEMPORARY) Random convoy spawner.
[] spawn {
	// Every 10-30 mins.
	while {true} do {
		private ["_sleepTime"];
		_sleepTime = 10 + floor (random (20));
		_sleepTime = _sleepTime * 60;
		sleep _sleepTime;
		[] call INT_fnc_spawnConvoy;
	};
};

// Disable grid sectors.
[false, true] call INT_fnc_setSectorIntel;

if (INT_server_newGame) then {
	call compile preprocessFileLineNumbers "server\newGame.sqf";
} else {
	call compile preprocessFileLineNumbers "server\loadGame.sqf";
};
