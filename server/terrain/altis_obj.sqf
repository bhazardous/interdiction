scriptName "altis_obj";
/*--------------------------------------------------------------------
	file: altis_obj.sqf
	=====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "altis_obj.sqf"
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

// 253-219
["SofiaRadar",
	[25306.4,21820.9], 100,
	ICON_RADAR,
	"ITD_fnc_captureSectorIntel", [true], [false], [],
	[1569703, 1569722]] call ITD_fnc_addObjective;

// 152-171
["AirbaseRadar",
	[15265.1,17087.8], 50,
	ICON_RADAR,
	"ITD_fnc_captureSectorIntel", [true], [false], [],
	[494129]] call ITD_fnc_addObjective;

["AirbaseRadarSouth",
	[14320.4,16190], 50,
	ICON_RADAR,
	"ITD_fnc_captureSectorIntel", [true], [false], [],
	[526035]] call ITD_fnc_addObjective;

// -- RADIO OBJECTIVES --
// Land_TTowerBig_1_F
// Land_TTowerBig_2_F

// 262-222 - both towers as a single objective
["SofiaTowers",
	[26376.3,22180.7], 150,
	ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [],
	[1564270, 1566941]] call ITD_fnc_addObjective;

// 193-097
["PanagiaRadio",
	[19350,9692.45], 50,
	ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [],
	[1002214]] call ITD_fnc_addObjective;

// 094-194
["GalatiRadio",
	[9495.72,19319.1], 50,
	ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [],
	[1345012]] call ITD_fnc_addObjective;

// 178-118
["PyrgosRadio",
	[17854.3,11732.8], 50,
	ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [],
	[943723]] call ITD_fnc_addObjective;

// 187-103
["EkaliRadio",
	[18711.5,10222.1], 50,
	ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [],
	[986657]] call ITD_fnc_addObjective;

// 045-154
["MagosRadio",
	[4568.17,15390.4], 75,
	ICON_RADIO,
	"ITD_fnc_captureMapIntel", [true], [false], [],
	[1074523, 1074524]] call ITD_fnc_addObjective;



// -- MILITARY OBJECTIVES --

// ID 0 - 038-123
["SouthKavalaTower",
	[3900.09,12294.3], 30,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 0, [3900.09,12294.3]], [false, 0], ["destroyed", 0],
	[1133055]] call ITD_fnc_addObjective;

// ID 1 - 068-161
["KoreCargoTower",
	[6829.02,16052.5], 30,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 1, [6829.02,16052.5]], [false, 1], ["destroyed", 1],
	[1070000]] call ITD_fnc_addObjective;

// ID 2 - 083-183
["SyrtaCompound",
	[8389.29,18247.6], 50,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 2, [8389.29,18247.6]], [false, 2], ["destroyed", 2],
	[580562]] call ITD_fnc_addObjective;

// ID 3 - 083-101
["ZarosBayTower",
	[8316.75,10062.1], 40,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 3, [8316.75,10062.1]], [false, 3], ["destroyed", 3],
	[832000]] call ITD_fnc_addObjective;

// ID 4 - 128-167
["LakkaCompound",
	[12809.9,16657.5], 75,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 4, [12809.9,16657.5]], [false, 4], ["destroyed", 4],
	[673154]] call ITD_fnc_addObjective;

// ID 5 - 124-153
["StavrosCompound",
	[12446.7,15200.6], 40,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 5, [12446.7,15200.6]], [false, 5], ["destroyed", 5],
	[681790]] call ITD_fnc_addObjective;

// ID 6 - 138-190
["AthiraCompound",
	[13820.2,18964], 40,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 6, [13820.2,18964]], [false, 6], ["destroyed", 6],
	[444542]] call ITD_fnc_addObjective;

// ID 7 - 142-213
["FriniCompound",
	[14211.6,21203.9], 80,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 7, [14211.6,21203.9]], [false, 7], ["destroyed", 7],
	[1295080]] call ITD_fnc_addObjective;

// ID 8 - 141-163
["Airbase",
	[14178,16271.6], 100,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 8, [14178,16271.6]], [false, 8], ["destroyed", 8],
	[524201]] call ITD_fnc_addObjective;

// ID 9 - 142-131
["SagonisiCompound",
	[14296.9,13031.3], 50,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 9, [14296.9,13031.3]], [false, 9], ["destroyed", 9],
	[884517]] call ITD_fnc_addObjective;

// ID 10 - 151-174
["GraviaMilitary",
	[15176.1,17346.9], 100,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 10, [15176.1,17346.9]], [false, 10], ["destroyed", 10],
	[490944]] call ITD_fnc_addObjective;

// ID 11 - 165-191
["ZeloranCompound",
	[16590.5,19043.4], 100,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 11, [16590.5,19043.4]], [false, 11], ["destroyed", 11],
	[470480]] call ITD_fnc_addObjective;

// ID 12 - 160-171
["ResearchBase",
	[16079.1,16999.5], 200,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 12, [16079.1,16999.5]], [false, 12], ["destroyed", 12],
	[499662, 499546, 499861, 499959, 501021, 500895]] call ITD_fnc_addObjective;

// ID 13 - 168-121
["PyrgosCompound",
	[16840.6,12042.9], 40,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 13, [16840.6,12042.9]], [false, 13], ["destroyed", 13],
	[927911]] call ITD_fnc_addObjective;

// ID 14 - 174-132
["PyrgosBase",
	[17426.7,13152.5], 150,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 14, [17426.7,13152.5]], [false, 14], ["destroyed", 14],
	[929892, 929712, 930154]] call ITD_fnc_addObjective;

// ID 15 - 206-202
["PefkasCompound",
	[20603.3,20130.4], 50,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 15, [20603.3,20130.4]], [false, 15], ["destroyed", 15],
	[1611616]] call ITD_fnc_addObjective;

// ID 16 - 209-193
["GeorgiosResearch",
	[20939.2,19250.3], 150,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 16, [20939.2,19250.3]], [false, 16], ["destroyed", 16],
	[1779133, 1779159]] call ITD_fnc_addObjective;

// ID 17 - 200-068
["SelakanoCompound",
	[20083.8,6723.04], 50,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 17, [20083.8,6723.04]], [false, 17], ["destroyed", 17],
	[419902]] call ITD_fnc_addObjective;

// ID 18 - 235-212
["DelfinakiMilitary",
	[23535.7,21116.1], 150,
	ICON_MIL,
	"ITD_fnc_captureFOB", [true, 18, [23535.7,21116.1]], [false, 18], ["destroyed", 18],
	[1545425]] call ITD_fnc_addObjective;

// [4826.23,21933.4,0.0010376] - 100 - ThronosCastle
// [5407.83,17907.8,0.00147247] - 50 - KiraCompound
// [6175.36,16246.8,0.00143814] - 150 - KoreFactory

ITD_server_objectivesLoaded = true;
