scriptName "campService";
/*
	Author: Bhaz

	Description:
	Keeps the service GUI updated when a service point is in range.

	Parameter(s):
	#0 POSITION - Service point position

	Example:
	n/a

	Returns:
	Nothing
*/

#define SERVICE_DATA ITD_global_serviceData select _id
#define SERVICE_FUEL SERVICE_DATA select 0
#define SERVICE_PARTS SERVICE_DATA select 1
#define SERVICE_MILPARTS SERVICE_DATA select 2

params ["_pos"];
private ["_id"];
_id = [player, ITD_global_camps] call ITD_fnc_closestPosition;

["service", "showFull"] call ITD_fnc_guiAction;

while {player distance _pos <= 25} do {
	["service", "setFuel", str(SERVICE_FUEL)] call ITD_fnc_guiAction;
	["service", "setParts", str(SERVICE_PARTS)] call ITD_fnc_guiAction;
	["service", "setMilParts", str(SERVICE_MILPARTS)] call ITD_fnc_guiAction;
	sleep 1;
};

["service", "hide"] call ITD_fnc_guiAction;
