scriptName "fn_spectate";
/*
	Author: Bhaz

	Description:
	Forced spectate while waiting to respawn / join. Runs clientside.

	Parameter(s):
	#0 OBJECT - Description

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

nil;
