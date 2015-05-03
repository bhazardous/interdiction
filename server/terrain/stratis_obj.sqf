scriptName "stratis_obj";
/*--------------------------------------------------------------------
	file: stratis_obj.sqf
	=====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "stratis_obj.sqf"
#define ICON_MIL	"n_hq"
#define ICON_RADAR	"n_installation"
#define ICON_RADIO	"loc_Transmitter"

/* Objective format:
["ObjectiveName",
	[position], radius,
	map marker,
	function + params, captured, lost, destroyed,
	world objects (object ID),
	add to OPCOM (optional)] call ITD_fnc_addObjective;
*/

// Radar objectives.
["AirStationMike",
	[4355.77,3852.6], 200,
	ICON_RADAR,
	"ITD_fnc_captureSectorIntel", [true], [false], [],
	[122613]] call ITD_fnc_addObjective;

// Radio objectives.
["EasternRadioTowers",
	[5230.04,5010.62], 150,
	ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [],
	[31939, 31966, 32009],
	true] call ITD_fnc_addObjective;
["RadioCompound",
	[3497.47,4916.27], 50,
	ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [],
	[82837],
	true] call ITD_fnc_addObjective;
["AgiaMarinaRadio",
	[3064.28,6189.8], 50,
	ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [],
	[69296],
	true] call ITD_fnc_addObjective;

// Military installations.
["CampMaxwell",
	[3271.56,2949.52], 65,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 0, [3271.56,2949.52]], [false, 0], ["destroyed", 0],
	[117492]] call ITD_fnc_addObjective;
["CampTempest",
	[1971.3,3506.98], 60,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 1, [1971.3,3506.98]], [false, 1], ["destroyed", 1],
	[103156]] call ITD_fnc_addObjective;
["CampRogain",
	[4987.81,5920.04], 85,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 2, [4987.81,5920.04]], [false, 2], ["destroyed", 2],
	[19226]] call ITD_fnc_addObjective;
["KaminoRange",
	[6452.12,5376.88], 100,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 3, [6452.12,5376.88]], [false, 3], ["destroyed", 3],
	[29461]] call ITD_fnc_addObjective;

ITD_server_objectivesLoaded = true;
