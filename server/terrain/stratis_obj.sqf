scriptName "stratis_obj";
/*--------------------------------------------------------------------
	file: stratis_obj.sqf
	=====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "stratis_obj.sqf"

// Radar objectives.
// [4355.77,3852.6,0] air station mike (200)
["AirStationMike", [4355.77,3852.6], 200,
	"INT_fnc_captureMapIntel", [true], [false], 122613] call INT_fnc_addObjective;
