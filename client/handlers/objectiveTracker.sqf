scriptName "objectiveTracker";
/*--------------------------------------------------------------------
	file: objectiveTracker.sqf
	==========================
	Author: Bhaz <>
	Description: Keeps track of secondary states and handles local UI.
--------------------------------------------------------------------*/
#define __filename "objectiveTracker.sqf"

// Prepare scripts.
_inRange = compile preprocessFileLineNumbers "client\handlers\objectiveInRange.sqf";

waitUntil {!isNil "ITD_global_objectivesList"};

while {true} do {
	{
		// Player in range?
		if ((player distance (markerPos ("ITD_mkr_obj_" + (_x select 0)))) <= (_x select 1)) then {
			[_x select 0, _x select 1] call _inRange;
		};

		sleep 0.5;
	} forEach ITD_global_objectivesList;
};
