scriptName "fn_captureMapIntel";
/*
	Author: Bhaz

	Description:
	Simple tracking of map intel objectives.

	Parameter(s):
	#0 BOOL - True for captured, false for lost

	Example:
	n/a

	Returns:
	Nothing
*/

if (!isServer) exitWith {};

#define RADIUS_MULTIPLIER 500

if (!params [["_captured", false, [true]]]) exitWith {["Invalid params"] call BIS_fnc_error};

if (isNil "ITD_server_mapIntel") then {
	ITD_server_mapIntel = false;
	ITD_server_mapIntelCount = 0;
};

if (_captured) then {
	ITD_server_mapIntelCount = ITD_server_mapIntelCount + 1;
	if (!ITD_server_mapIntel) then {
		ITD_server_mapIntel = true;
	};
} else {
	if (ITD_server_mapIntelCount > 0) then {
		ITD_server_mapIntelCount = ITD_server_mapIntelCount - 1;
	};
	if (ITD_server_mapIntelCount == 0 && ITD_server_mapIntel) then {
		ITD_server_mapIntel = false;
	};
};

[ITD_server_mapIntelCount * RADIUS_MULTIPLIER] call ITD_fnc_setMapIntel;
