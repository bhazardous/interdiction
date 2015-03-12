scriptName "fn_spectate";
/*
	Author: Bhaz

	Description:
	Forced spectate while waiting to respawn / join. Runs clientside.

	Parameter(s):
	NONE

	Returns:
	nil
*/

if (!hasInterface) exitWith {nil;};

if (isNil "ITD_local_spectating") then {
	ITD_local_spectating = false;
};

// Allow only one instance.
if (ITD_local_spectating) exitWith {nil;};
ITD_local_spectating = true;

// Disable player.
player setCaptive true;
player enableSimulation false;
player hideObject true;
1 fadeSound 0;

waitUntil {!isNull player};
waitUntil {!isNil "ITD_global_playerList"};
waitUntil {!isNil "ITD_global_campExists"};

// Start spectating.
[ITD_global_playerList, "Tracking resistance", 200, 300, 90, 1, [], 0,
	[[], {ITD_global_campExists;}]] call ALiVE_fnc_establishingShotCustom;

// Unlock player.
["respawning"] call BIS_fnc_blackOut;
player setCaptive false;
player enableSimulation true;
player hideObject false;
1 fadeSound 1;

// Force respawn.
sleep 2;
[player] call ITD_fnc_respawn;

// Add player to the playerList again.
if (!(player in ITD_global_playerList)) then {
	ITD_global_playerList pushBack player;
	publicVariable "ITD_global_playerList";
};

ITD_local_spectating = false;

nil;
