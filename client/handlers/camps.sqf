scriptName "camps";
/*--------------------------------------------------------------------
	file: camps.sqf
	===============
	Author: Bhaz <>
	Description:
--------------------------------------------------------------------*/
#define __filename "camps.sqf"
#define SERVICE_DISTANCE 25

waitUntil {!isNil "ITD_global_servicePoints"};
waitUntil {!isNil "ITD_global_serviceData"};

// Prepare scripts.
_fncService = compile preprocessFileLineNumbers "client\handlers\campService.sqf";

waitUntil {!isNil "ITD_global_objectivesList"};

while {true} do {
	{
		// Player in range?
		if (player distance _x <= SERVICE_DISTANCE) then {
			[_x] call _fncService;
		};

		sleep 0.5;
	} forEach ITD_global_servicePoints;
};
