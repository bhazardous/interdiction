scriptName "init";
/*--------------------------------------------------------------------
	file: init.sqf
	==============
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "init.sqf"

ITD_global_debugEnabled = true;
if (isServer) then {execVM "server\serverInit.sqf"};
if (hasInterface) then {execVM "client\clientInit.sqf"};
