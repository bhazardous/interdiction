scriptName "campService";
/*--------------------------------------------------------------------
	file: campService.sqf
	=====================
	Author: Bhaz <>
	Description:
--------------------------------------------------------------------*/
#define __filename "campService.sqf"

#define GUI_NAME "service"
#define GUI_SHOW [GUI_NAME, "showFull"] call ITD_fnc_guiAction
#define GUI_HIDE [GUI_NAME, "hide"] call ITD_fnc_guiAction
#define GUI_EXTEND [GUI_NAME, "extend"] call ITD_fnc_guiAction
#define GUI_SHRINK [GUI_NAME, "shrink"] call ITD_fnc_guiAction
#define GUI_SET_FUEL(x) [GUI_NAME, "setFuel", x] call ITD_fnc_guiAction
#define GUI_SET_PARTS(x) [GUI_NAME, "setParts", x] call ITD_fnc_guiAction
#define GUI_SET_MILPARTS(x) [GUI_NAME, "setMilParts", x] call ITD_fnc_guiAction

#define SERVICE_DATA ITD_global_serviceData select _id
#define SERVICE_FUEL SERVICE_DATA select 0
#define SERVICE_PARTS SERVICE_DATA select 1
#define SERVICE_MILPARTS SERVICE_DATA select 2

private ["_id", "_pos", "_radius"];
_id = ([player, "ITD_mkr_resistanceCamp", count ITD_global_camps] call ITD_fnc_closestMarker) - 1;
_pos = _this select 0;
_radius = 25;

GUI_SHOW;

// Display until out of range.
while {player distance _pos <= _radius} do {
	GUI_SET_FUEL(str(SERVICE_FUEL));
	GUI_SET_PARTS(str(SERVICE_PARTS));
	GUI_SET_MILPARTS(str(SERVICE_MILPARTS));
	sleep 2;
};

GUI_HIDE;
