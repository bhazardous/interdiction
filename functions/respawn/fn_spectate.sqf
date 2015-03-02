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

if (isNil "INT_local_spectating") then {
	INT_local_spectating = false;
};

// Allow only one instance.
if (INT_local_spectating) exitWith {nil;};
INT_local_spectating = true;

// Disable player.
player setCaptive true;
player enableSimulation false;
player hideObject true;
1 fadeSound 0;

waitUntil {!isNull player};
waitUntil {!isNil "INT_global_playerList"};
waitUntil {!isNil "INT_global_campExists"};

// Start spectating.
[INT_global_playerList, "Tracking resistance", 200, 300, 90, 1, [], 0,
	[[], {INT_global_campExists;}]] call ALiVE_fnc_establishingShotCustom;

// Unlock player.
player setCaptive false;
player enableSimulation true;
player hideObject false;
1 fadeSound 1;

// Force respawn.
sleep 0.5;
[player] call INT_fnc_respawn;

// Add player to the playerList again.
if (!(player in INT_global_playerList)) then {
	INT_global_playerList pushBack player;
	publicVariable "INT_global_playerList";
};

INT_local_spectating = false;

nil;
