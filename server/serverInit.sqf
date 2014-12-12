scriptName "serverInit";
/*--------------------------------------------------------------------
	file: serverInit.sqf
	====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "serverInit.sqf"

// Set up the starting position for players.
call compile preprocessFileLineNumbers "server\playerStart.sqf";
