scriptName "fn_getComposition";
/*
	Author: Bhaz

	Description:
	Composition data.

	Parameter(s):
	#0 STRING - Composition name

	Returns:
	ARRAY - Composition
*/

private ["_name", "_comp"];
_name = [_this, 0, "", [""]] call BIS_fnc_param;

if (_name == "") exitWith {
	["No composition name given"] call BIS_fnc_error;
	[];
};

_comp = switch (_name) do {
	case "hq": {
		[
			["CamoNet_BLUFOR_open_Curator_F",[0.511719,8.02759,0],0,1,0,[],"","",true,false],
			["Land_CampingTable_small_F",[-2.65527,7.43677,9.53674e-007],217.056,1,0,[],"","",true,false],
			["Land_CampingChair_V2_F",[-1.8125,7.89551,2.09808e-005],53.1113,1,0,[],"","",true,false],
			["Land_CampingChair_V2_F",[-2.70703,8.29297,2.09808e-005],359.982,1,0,[],"","",true,false],
			["Land_MapBoard_F",[-3.92676,9.13452,-0.00220537],330.124,1,0,[],"","",true,false],
			["Land_PortableLight_single_F",[4.46045,10.7175,0],40.4398,1,0,[],"","",true,false],
			["Land_PowerGenerator_F",[2.70801,11.3516,0],100.9,1,0,[],"","",true,false]
		]
	};

	case "service": {
		[
			["Land_Workbench_01_F",[1.13232,4.07715,-0.0250001],356.433,1,0,[],"","",true,false],
			["Land_Tyres_F",[-1.50977,4.48291,0.00659752],90,1,0,[],"","",true,false],
			["Land_Slums02_pole",[-2.9624,4.10303,0],90,1,0,[],"","",true,false],
			["Land_ScrapHeap_1_F",[-0.157227,6.20654,0],90,1,0,[],"","",true,false],
			["Land_Slums02_4m",[-2.73535,6.0874,-0.582526],90,1,0,[],"","",true,false]
		]
	};

	case "recruitment": {
		[
			["CamoNet_BLUFOR_Curator_F",[0.09375,5.8479,0.813007],0,1,0,[],"","",true,false],
			["Land_CampingChair_V2_F",[-0.98584,4.26416,2.09808e-005],198.636,1,0,[],"","",true,false],
			["Land_CampingChair_V2_F",[2.32373,4.40015,2.0504e-005],136.624,1,0,[],"","",true,false],
			["Land_CampingChair_V2_F",[-2.3208,4.83398,2.14577e-005],257.089,1,0,[],"","",true,false],
			["Land_CampingTable_F",[-0.872559,5.51685,0],18.6799,1,0,[],"","",true,false],
			["Land_CampingTable_F",[1.75098,5.40967,-2.38419e-006],177.844,1,0,[],"","",true,false],
			["Land_CampingChair_V2_F",[1.34082,6.20215,2.14577e-005],359.836,1,0,[],"","",true,false],
			["Land_CampingChair_V2_F",[2.07813,6.11768,2.09808e-005],0.336982,1,0,[],"","",true,false],
			["Land_CampingChair_V2_F",[-1.10059,6.40112,2.09808e-005],0.00875864,1,0,[],"","",true,false]
		]
	};

	case "debug": {
		[
			["Land_TentDome_F",[0,2.5,0],180,1,0,[],"","",true,false]
		]
	};

	// ----------------------
	// FORTIFICATIONS
	// ----------------------
	// Sandbags.
	case "fort_sandbag": {
		[
			["Land_BagFence_Long_F",[0,2.5,0],180,1,0,[],"","",true,false]
		]
	};
	case "fort_sandbag_short": {
		[
			["Land_BagFence_Short_F",[0,2.5,0],180,1,0,[],"","",true,false]
		]
	};
	case "fort_sandbag_round": {
		[
			["Land_BagFence_Round_F",[0,2.5,0],180,1,0,[],"","",true,false]
		]
	};
	case "fort_sandbag_corner": {
		[
			["Land_BagFence_Corner_F",[0,2.5,0],180,1,0,[],"","",true,false]
		]
	};
	case "fort_sandbag_end": {
		[
			["Land_BagFence_End_F",[0,2.5,0],180,1,0,[],"","",true,false]
		]
	};

	// H-Barrier.
	case "fort_barrier": {
		[
			["Land_HBarrier_1_F",[0,2.5,0],180,1,0,[],"","",true,false]
		]
	};
	case "fort_barrier_3": {
		[
			["Land_HBarrier_3_F",[0,2.5,0],180,1,0,[],"","",true,false]
		]
	};
	case "fort_barrier_5": {
		[
			["Land_HBarrier_5_F",[0,2.5,0],180,1,0,[],"","",true,false]
		]
	};

	default {[]};
};

_comp;
