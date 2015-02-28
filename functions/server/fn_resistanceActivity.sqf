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

private ["_reason"];
_reason = [_this, 0, "", [""]] call BIS_fnc_param;

switch (_reason) do {
	case "kills": {
		// Hit kill threshold.
		[1] call INT_fnc_spawnResistance;

		// Tick counters for unlocks.
		private ["_crewCounter", "_campCounter"];

		_crewCounter = INT_server_statData select 1;
		_campCounter = INT_server_statData select 2;

		_crewCounter = _crewCounter + 1;
		_campCounter = _campCounter + 1;

		// Unlocks.
		if (_crewCounter >= INT_server_crewThreshold) then {
			INT_global_crewAvailable = INT_global_crewAvailable + 1;
			publicVariable "INT_global_crewAvailable";
			_crewCounter = _crewCounter - INT_server_crewThreshold;
			[["ResistanceMovement","CombatSupport","SupportCrew"]] call INT_fnc_broadcastHint;

			INT_server_statData set [3, INT_global_crewAvailable];
		};

		if (_campCounter >= INT_server_campThreshold) then {
			INT_global_campsAvailable = INT_global_campsAvailable + 1;
			publicVariable "INT_global_campsAvailable";
			_campCounter = _campCounter - INT_server_campThreshold;

			INT_server_statData set [4, INT_global_campsAvailable];
		};

		// Unlock tech1.
		if (!INT_global_tech1) then {
			INT_global_tech1 = true;
			publicVariable "INT_global_tech1";
			[["ResistanceMovement", "BuildCamp", "UnlockTechOne"]] call INT_fnc_broadcastHint;

			INT_server_statData set [5, true];
		};

		INT_server_statData set [1, _crewCounter];
		INT_server_statData set [2, _campCounter];
		[] call INT_fnc_updatePersistence;
	};

	default {
		["INT_fnc_resistanceActivity called with invalid reason."] call BIS_fnc_log;
	};
};

nil;
