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

if (isNil "ITD_server_sectorIntel") then {
	ITD_server_sectorIntel = false;
	ITD_server_sectorIntelCount = 0;
};

if (_captured) then {
	ITD_server_sectorIntelCount = ITD_server_sectorIntelCount + 1;
	if (!ITD_server_sectorIntel) then {
		ITD_server_sectorIntel = true;
		[ITD_server_sectorIntel] call ITD_fnc_setSectorIntel;
	};
} else {
	if (ITD_server_sectorIntelCount > 0) then {
		ITD_server_sectorIntelCount = ITD_server_sectorIntelCount - 1;
	};
	if (ITD_server_sectorIntelCount == 0 && ITD_server_sectorIntel) then {
		ITD_server_sectorIntel = false;
		[ITD_server_sectorIntel] call ITD_fnc_setSectorIntel;
	};
};

nil;
