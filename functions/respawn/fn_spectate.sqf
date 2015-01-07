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

// Disable player.
player setCaptive true;
player enableSimulation false;
player hideObject true;
1 fadeSound 0;

waitUntil {!isNull player};
waitUntil {!isNil "INT_global_playerList"};
waitUntil {!isNil "INT_global_campExists"};

// Start spectating.
[INT_global_playerList, "Tracking resistance", 300, 300, 90, 1, [], 0,
	[[], {INT_global_campExists;}]] call ALiVE_fnc_establishingShotCustom;

// Unlock player.
player setCaptive false;
player enableSimulation true;
player hideObject false;
1 fadeSound 1;

// Move player to spawn point.
player setPos (["respawn_west"] call BIS_fnc_randomPosTrigger);

// Add player to the playerList again.
if (!(player in INT_global_playerList)) then {
	INT_global_playerList pushBack player;
	publicVariable "INT_global_playerList";
};

nil;
