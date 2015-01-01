scriptName "clientInit";
/*--------------------------------------------------------------------
	file: clientInit.sqf
	====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "clientInit.sqf"

// Camp action for joining players.
[] spawn {
	waitUntil {!isNil "INT_global_buildingEnabled"};
	[INT_global_buildingEnabled] call INT_fnc_toggleCampConstruction;

	sleep 15;
	[["ResistanceMovement", "Interdiction"], 15, "", 35, "", true, true, true] call BIS_fnc_advHint;
	sleep 60;
	if (INT_global_buildingEnabled) then {
		[["ResistanceMovement", "BuildCamp"], 15, "", 35, "", true, true, true] call BIS_fnc_advHint;
	};
};
