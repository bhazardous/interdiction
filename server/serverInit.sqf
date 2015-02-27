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

/* DEBUG - TESTING PERSISTENCE */
/*
INT_server_newGame = false;
waitUntil {!isNil "ALiVE_globalForcePool"};
INT_server_persistentData = [] call CBA_fnc_hashCreate;
[ALiVE_globalForcePool, "missionData", INT_server_persistentData] call ALiVE_fnc_hashSet;
[INT_server_persistentData, "stats", [5,5,5,5,5,true]] call CBA_fnc_hashSet;
[INT_server_persistentData, "camps", [[[[2099.27,4161.88,0],0,[[2096.86,4157.08,0],195.242],[],false]],[[0,96,0]]]] call CBA_fnc_hashSet;
[INT_server_persistentData, "objectives", [["RadioCompound",3],["EasternRadioTowers",1],["AgiaMarinaRadio",1]]] call CBA_fnc_hashSet;
*/

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

if (INT_server_newGame) then {
	call compile preprocessFileLineNumbers "server\newGame.sqf";
} else {
	call compile preprocessFileLineNumbers "server\loadGame.sqf";
};
