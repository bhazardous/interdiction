scriptName "fn_joinRequest";
/*
	Author: Bhaz

	Description:
	Request sent to server when a player joins.

	Parameter(s):
	#0 OBJECT - Player

	Returns:
	nil
*/

ITD_server_spawnQueue pushBack (_this select 0);

nil;
