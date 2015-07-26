scriptName "fn_resistanceActivity";
/*
	Author: Bhaz

	Description:
	An event triggered by resistance activity.

	Parameter(s):
	#0 STRING - Reason / type of activity

	Returns:
	nil
*/
#include "persistentData.hpp"

private ["_reason"];
_reason = [_this, 0, "", [""]] call BIS_fnc_param;

switch (_reason) do {
	case "kills": {
		// Hit kill threshold.
		call ITD_fnc_spawnResistance;

		// Tick counters for unlocks.
		private ["_crewCounter", "_campCounter"];

		_crewCounter = DB_PROGRESS_SUPPORT_COUNTER;
		_campCounter = DB_PROGRESS_CAMP_COUNTER;

		_crewCounter = _crewCounter + 1;
		_campCounter = _campCounter + 1;

		// Unlocks.
		if (_crewCounter >= ITD_server_crewThreshold) then {
			ITD_global_crewAvailable = ITD_global_crewAvailable + 1;
			publicVariable "ITD_global_crewAvailable";
			_crewCounter = _crewCounter - ITD_server_crewThreshold;
			[["ResistanceMovement","CombatSupport","SupportCrew"]] call ITD_fnc_broadcastHint;

			SET_DB_PROGRESS_CREW_AVAILABLE(ITD_global_crewAvailable);
		};

		if (_campCounter >= ITD_server_campThreshold) then {
			ITD_global_campsAvailable = ITD_global_campsAvailable + 1;
			publicVariable "ITD_global_campsAvailable";
			_campCounter = _campCounter - ITD_server_campThreshold;

			SET_DB_PROGRESS_CAMPS_AVAILABLE(ITD_global_campsAvailable);
		};

		// Unlock tech1.
		if (!ITD_global_tech1) then {
			ITD_global_tech1 = true;
			publicVariable "ITD_global_tech1";
			[["ResistanceMovement", "BuildCamp", "UnlockTechOne"]] call ITD_fnc_broadcastHint;

			SET_DB_PROGRESS_TECH1(true);
		};

		SET_DB_PROGRESS_SUPPORT_COUNTER(_crewCounter);
		SET_DB_PROGRESS_CAMP_COUNTER(_campCounter);
	};

	default {
		["ITD_fnc_resistanceActivity called with invalid reason."] call BIS_fnc_log;
	};
};

nil;
