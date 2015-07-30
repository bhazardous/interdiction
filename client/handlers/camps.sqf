scriptName "camps";
/*--------------------------------------------------------------------
	file: camps.sqf
	===============
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "camps.sqf"

_fncService = compile preprocessFileLineNumbers "client\handlers\campService.sqf";
waitUntil {!isNil "ITD_global_servicePoints"};
waitUntil {!isNil "ITD_global_serviceData"};

while {true} do {
	{
		if (player distance _x <= 25) then {[_x] call _fncService};
		sleep 0.5;
	} forEach ITD_global_servicePoints;
};
