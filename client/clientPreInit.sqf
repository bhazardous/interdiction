scriptName "clientPreInit";
/*--------------------------------------------------------------------
	file: clientPreInit.sqf
	=======================
	Author: Bhaz
	Description: Required to set correct values for persistence.
--------------------------------------------------------------------*/
#define __filename "clientPreInit.sqf"

while {isNil "ITD_global_persistence"} do {};

if (!isServer && ITD_global_persistence) then {
	ITD_module_alive_playerOptions setVariable ["enablePlayerPersistence", "true"];
	ITD_module_alive_playerOptions setVariable ["saveLoadout", "true"];
	ITD_module_alive_playerOptions setVariable ["saveAmmo", "true"];
	ITD_module_alive_playerOptions setVariable ["saveHealth", "true"];
	ITD_module_alive_playerOptions setVariable ["savePosition", "true"];
	ITD_module_alive_playerOptions setVariable ["saveScores", "true"];
	ITD_module_alive_playerOptions setVariable ["storeToDB", "true"];
};
