scriptName "stratis_obj";
/*--------------------------------------------------------------------
	file: stratis_obj.sqf
	=====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "stratis_obj.sqf"

// Radar objectives.
["AirStationMike", [4355.77,3852.6], 200,
	"INT_fnc_captureSectorIntel", [true], [false], [122613]] call INT_fnc_addObjective;

// Radio objectives.
["EasternRadioTowers", [5230.04,5010.62], 150,
	"INT_fnc_captureMapIntel", [true], [false], [31939, 31966, 32009], true] call INT_fnc_addObjective;
["RadioCompound", [3497.47,4916.27], 50,
	"INT_fnc_captureMapIntel", [true], [false], [82837], true] call INT_fnc_addObjective;
["AgiaMarinaRadio", [3064.28,6189.8], 50,
	"INT_fnc_captureMapIntel", [true], [false], [69296], true] call INT_fnc_addObjective;