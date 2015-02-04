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
		INT_server_crewCounter = INT_server_crewCounter + 1;
		if (INT_server_crewCounter >= INT_server_crewThreshold) then {
			INT_global_crewAvailable = INT_global_crewAvailable + 1;
			publicVariable "INT_global_crewAvailable";
			INT_server_crewCounter = INT_server_crewCounter - INT_server_crewThreshold;
			[["ResistanceMovement","CombatSupport","SupportCrew"]] call INT_fnc_broadcastHint;
		};

		// Unlock tech1.
		if (!INT_global_tech1) then {
			INT_global_tech1 = true;
			publicVariable "INT_global_tech1";
			[["ResistanceMovement", "BuildCamp", "UnlockTechOne"]] call INT_fnc_broadcastHint;
		};
	};

	default {
		["INT_fnc_resistanceActivity called with invalid reason."] call BIS_fnc_log;
	};
};

nil;
