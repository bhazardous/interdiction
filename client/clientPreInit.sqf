scriptName "clientPreInit";
/*--------------------------------------------------------------------
	file: clientPreInit.sqf
	=======================
	Author: Bhaz
	Description: Required to set correct values for persistence.
--------------------------------------------------------------------*/
#define __filename "clientPreInit.sqf"

waitUntil {!isNil "INT_global_persistence"};

if (!isServer && {INT_global_persistence}) then {
	// Set player options module settings before it inits client side.
	INT_module_alive_playerOptions setVariable ["enablePlayerPersistence", "true"];
	INT_module_alive_playerOptions setVariable ["saveLoadout", "true"];
	INT_module_alive_playerOptions setVariable ["saveAmmo", "true"];
	INT_module_alive_playerOptions setVariable ["saveHealth", "true"];
	INT_module_alive_playerOptions setVariable ["savePosition", "true"];
	INT_module_alive_playerOptions setVariable ["saveScores", "true"];
	INT_module_alive_playerOptions setVariable ["storeToDB", "true"];
};
