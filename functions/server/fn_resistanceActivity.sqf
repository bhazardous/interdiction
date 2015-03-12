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
		[1] call ITD_fnc_spawnResistance;

		// Tick counters for unlocks.
		private ["_crewCounter", "_campCounter"];

		_crewCounter = ITD_server_statData select 1;
		_campCounter = ITD_server_statData select 2;

		_crewCounter = _crewCounter + 1;
		_campCounter = _campCounter + 1;

		// Unlocks.
		if (_crewCounter >= ITD_server_crewThreshold) then {
			ITD_global_crewAvailable = ITD_global_crewAvailable + 1;
			publicVariable "ITD_global_crewAvailable";
			_crewCounter = _crewCounter - ITD_server_crewThreshold;
			[["ResistanceMovement","CombatSupport","SupportCrew"]] call ITD_fnc_broadcastHint;

			ITD_server_statData set [3, ITD_global_crewAvailable];
		};

		if (_campCounter >= ITD_server_campThreshold) then {
			ITD_global_campsAvailable = ITD_global_campsAvailable + 1;
			publicVariable "ITD_global_campsAvailable";
			_campCounter = _campCounter - ITD_server_campThreshold;

			ITD_server_statData set [4, ITD_global_campsAvailable];
		};

		// Unlock tech1.
		if (!ITD_global_tech1) then {
			ITD_global_tech1 = true;
			publicVariable "ITD_global_tech1";
			[["ResistanceMovement", "BuildCamp", "UnlockTechOne"]] call ITD_fnc_broadcastHint;

			ITD_server_statData set [5, true];
		};

		ITD_server_statData set [1, _crewCounter];
		ITD_server_statData set [2, _campCounter];
		[] call ITD_fnc_updatePersistence;
	};

	default {
		["ITD_fnc_resistanceActivity called with invalid reason."] call BIS_fnc_log;
	};
};

nil;
