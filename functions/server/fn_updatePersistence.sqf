scriptName "fn_updatePersistence";
/*
	Author: Bhaz

	Description:
	Updates the persistence string.

	Parameter(s):
	None

	Returns:
	nil
*/

[ALiVE_globalForcePool, "missionData", str INT_server_persistentData] call ALiVE_fnc_hashSet;

nil;
