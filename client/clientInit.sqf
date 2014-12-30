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
};
