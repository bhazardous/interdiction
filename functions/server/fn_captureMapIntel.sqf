scriptName "fn_captureMapIntel";
/*
	Author: Bhaz

	Description:
	Simple tracking of map intel (radar) objectives.

	Parameter(s):
	#0 BOOL - True for captured, false for lost

	Returns:
	nil
*/

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
		[INT_server_mapIntel] call INT_fnc_setMapIntel;
	};
} else {
	if (INT_server_mapIntelCount > 0) then {
		INT_server_mapIntelCount = INT_server_mapIntelCount - 1;
	};
	if (INT_server_mapIntelCount == 0 && INT_server_mapIntel) then {
		INT_server_mapIntel = false;
		[INT_server_mapIntel] call INT_fnc_setMapIntel;
	};
};

hint format ["%1, %2", INT_server_mapIntel, INT_server_mapIntelCount];

nil;
