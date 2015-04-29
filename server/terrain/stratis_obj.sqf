scriptName "stratis_obj";
/*--------------------------------------------------------------------
	file: stratis_obj.sqf
	=====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "stratis_obj.sqf"
#define ICON_RADAR "n_installation"
#define ICON_RADIO "loc_Transmitter"

// Radar objectives.
["AirStationMike", [4355.77,3852.6], 200, ICON_RADAR,
	"ITD_fnc_captureSectorIntel", [true], [false], [122613]] call ITD_fnc_addObjective;

// Radio objectives.
["EasternRadioTowers", [5230.04,5010.62], 150, ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [31939, 31966, 32009], true] call ITD_fnc_addObjective;
["RadioCompound", [3497.47,4916.27], 50, ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [82837], true] call ITD_fnc_addObjective;
["AgiaMarinaRadio", [3064.28,6189.8], 50, ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [69296], true] call ITD_fnc_addObjective;

ITD_server_objectivesLoaded = true;
