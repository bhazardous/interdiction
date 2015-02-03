scriptName "fn_captureMapIntel";
/*
	Author: Bhaz

	Description:
	Simple tracking of map intel objectives.

	Parameter(s):
	#0 BOOL - True for captured, false for lost

	Returns:
	nil
*/
#define RADIUS_MULTIPLIER 500

private ["_captured"];
_captured = _this select 0;

if (isNil "INT_server_mapIntel") then {
	INT_server_mapIntel = false;
	INT_server_mapIntelCount = 0;
};

if (_captured) then {
	INT_server_mapIntelCount = INT_server_mapIntelCount + 1;
	if (!INT_server_mapIntel) then {
		INT_server_mapIntel = true;
	};
} else {
	if (INT_server_mapIntelCount > 0) then {
		INT_server_mapIntelCount = INT_server_mapIntelCount - 1;
	};
	if (INT_server_mapIntelCount == 0 && INT_server_mapIntel) then {
		INT_server_mapIntel = false;
	};
};

[INT_server_mapIntelCount * RADIUS_MULTIPLIER] call INT_fnc_setMapIntel;

nil;
