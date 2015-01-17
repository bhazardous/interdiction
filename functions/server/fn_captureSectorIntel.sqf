scriptName "fn_captureSectorIntel";
/*
	Author: Bhaz

	Description:
	Simple tracking of sector intel objectives.

	Parameter(s):
	#0 BOOL - True for captured, false for lost

	Returns:
	nil
*/

private ["_captured"];
_captured = _this select 0;

if (isNil "INT_server_sectorIntel") then {
	INT_server_sectorIntel = false;
	INT_server_sectorIntelCount = 0;
};

if (_captured) then {
	INT_server_sectorIntelCount = INT_server_sectorIntelCount + 1;
	if (!INT_server_sectorIntel) then {
		INT_server_sectorIntel = true;
		[INT_server_sectorIntel] call INT_fnc_setSectorIntel;
	};
} else {
	if (INT_server_sectorIntelCount > 0) then {
		INT_server_sectorIntelCount = INT_server_sectorIntelCount - 1;
	};
	if (INT_server_sectorIntelCount == 0 && INT_server_sectorIntel) then {
		INT_server_sectorIntel = false;
		[INT_server_sectorIntel] call INT_fnc_setSectorIntel;
	};
};

nil;
