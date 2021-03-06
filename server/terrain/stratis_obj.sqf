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

// -- RADAR OBJECTIVES --
// Land_Radar_F
// Land_Radar_Small_F

["AirStationMike",
	[4355.77,3852.6], 200,
	ICON_RADAR,
	"ITD_fnc_captureSectorIntel", [true], [false], [],
	[122613]] call ITD_fnc_addObjective;

// -- RADIO OBJECTIVES --
// Land_TTowerBig_1_F
// Land_TTowerBig_2_F

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

// -- MILITARY OBJECTIVES --

// ID 0
["CampMaxwell",
	[3271.56,2949.52], 65,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 0, [3271.56,2949.52]], [false, 0], ["destroyed", 0],
	[117492]] call ITD_fnc_addObjective;

// ID 1
["CampTempest",
	[1971.3,3506.98], 60,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 1, [1971.3,3506.98]], [false, 1], ["destroyed", 1],
	[103156]] call ITD_fnc_addObjective;

// ID 2
["CampRogain",
	[4987.81,5920.04], 85,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 2, [4987.81,5920.04]], [false, 2], ["destroyed", 2],
	[19226]] call ITD_fnc_addObjective;

// ID 3
["KaminoRange",
	[6452.12,5376.88], 100,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 3, [6452.12,5376.88]], [false, 3], ["destroyed", 3],
	[29461]] call ITD_fnc_addObjective;

// ID 4
["LZConnor",
	[2993.1,1912.09], 75,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 4, [2993.1,1912.09]], [false, 4], ["destroyed", 4],
	[145157]] call ITD_fnc_addObjective;

// ID 5
["StratisAirBase",
	[2159.17,5610.31], 265,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 5, [2159.17,5610.31]], [false, 5], ["destroyed", 5],
	[66671]] call ITD_fnc_addObjective;

ITD_server_objectivesLoaded = true;
