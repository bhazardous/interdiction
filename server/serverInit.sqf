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
ITD_server_newGame = true;
if (ITD_global_persistence) then {
	// Verify the DB is working properly.

	// ALiVE_sys_data_disabled is hugely unreliable since it defaults to false, then
	// potentially gets toggled a few seconds later.
	// We're going to wait until the last possible moment, then wait a few more seconds
	// to make sure the script has completed.
	waitUntil {!isNil "ALiVE_dataDictionary"};
	waitUntil {!isNil "ALiVE_sys_data_disabled"};
	sleep 5;

	if (ALiVE_sys_data_disabled) then {
		// DB not working / server failed to authorize etc.
		// The mission will never start, continuously display this error.
		while {true} do {
			[["ResistanceMovement","MissionPersistence","ServerSetup"]] call ITD_fnc_broadcastHint;
			sleep 30;
		};
	};

	// Determine whether this is a new save or loaded from DB.
	waitUntil {!isNil "ALiVE_sys_data_dictionaryLoaded"};
	waitUntil {!isNil "ALiVE_sys_data_mission_data"};
	sleep 2;
	if (ALiVE_sys_data_dictionaryLoaded) then {
		ITD_server_newGame = false;
	};
};

// General mission variables.
ITD_server_killThreshold = 15;			// Number of OPFOR killed for civilians to join resistance movement.
ITD_server_crewThreshold = 5;			// Reach the kill threshold x times to unlock support crew.
ITD_server_campThreshold = 10;			// Unlocks extra camps.

PUBLIC(ITD_global_buildingEnabled,true);// Global toggle for building.
PUBLIC(ITD_global_playerList,[ITD_unit_invisibleMan]);

// (TEMPORARY) Random convoy spawner.
[] spawn {
	scriptName "serverInit_convoy";
	// Every 10-30 mins.
	while {true} do {
		private ["_sleepTime"];
		_sleepTime = 10 + floor (random (20));
		_sleepTime = _sleepTime * 60;
		sleep _sleepTime;
		[] call ITD_fnc_spawnConvoy;
	};
};

// Disable grid sectors.
[false, true] call ITD_fnc_setSectorIntel;

if (ITD_server_newGame) then {
	call compile preprocessFileLineNumbers "server\newGame.sqf";
} else {
	call compile preprocessFileLineNumbers "server\loadGame.sqf";
};
