scriptName "init";
/*--------------------------------------------------------------------
	file: init.sqf
	==============
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "init.sqf"

INT_global_debugEnabled = true;

if (isServer) then {
	call compile preprocessFileLineNumbers "server\serverInit.sqf";
};

if (hasInterface) then {
	call compile preprocessFileLineNumbers "client\clientInit.sqf";
};
