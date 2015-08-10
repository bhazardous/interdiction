scriptName "fn_resistanceActivity";
/*
	Author: Bhaz

	Description:
	An event triggered by resistance activity.

	Parameter(s):
	#0 STRING - Reason / type of activity

	Example:
	n/a

	Returns:
	nil
*/

#include "persistentData.hpp"

if (!params [["_reason", "", [""]]]) exitWith {["Invalid params"] call BIS_fnc_error};

switch (_reason) do {
	case "kills": {
		call ITD_fnc_spawnResistance;

		private ["_crewCounter", "_campCounter"];
		_crewCounter = DB_PROGRESS_SUPPORT_COUNTER;
		_campCounter = DB_PROGRESS_CAMP_COUNTER;
		_crewCounter = _crewCounter + 1;
		_campCounter = _campCounter + 1;

		if (_crewCounter >= ITD_server_crewThreshold) then {
			ITD_global_crewAvailable = ITD_global_crewAvailable + 1;
			publicVariable "ITD_global_crewAvailable";
			_crewCounter = _crewCounter - ITD_server_crewThreshold;
			[[["ITD_Guide","CombatSupport","Info_Crew"], -1, true], "ITD_fnc_advHint"] call BIS_fnc_MP;

			SET_DB_PROGRESS_CREW_AVAILABLE(ITD_global_crewAvailable);
		};

		if (_campCounter >= ITD_server_campThreshold) then {
			ITD_global_campsAvailable = ITD_global_campsAvailable + 1;
			publicVariable "ITD_global_campsAvailable";
			_campCounter = _campCounter - ITD_server_campThreshold;

			SET_DB_PROGRESS_CAMPS_AVAILABLE(ITD_global_campsAvailable);
		};

		if (!ITD_global_tech1) then {
			ITD_global_tech1 = true;
			publicVariable "ITD_global_tech1";
			[[["ITD_Hints","Info_Unlock"], -1, true], "ITD_fnc_advHint"] call BIS_fnc_MP;

			SET_DB_PROGRESS_TECH1(true);
		};

		SET_DB_PROGRESS_SUPPORT_COUNTER(_crewCounter);
		SET_DB_PROGRESS_CAMP_COUNTER(_campCounter);
	};

	default {
		["ITD_fnc_resistanceActivity called with invalid reason."] call BIS_fnc_error;
	};
};
