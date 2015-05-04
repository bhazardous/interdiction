scriptName "fn_spectate";
/*
	Author: Bhaz

	Description:
	Forced spectate while waiting to respawn / join. Runs clientside.

	Parameter(s):
	#1 BOOL - Waiting in a spawn queue

	Returns:
	nil
*/

private ["_inQueue"];
_inQueue = [_this, 0, false, [false]] call BIS_fnc_param;

if (!hasInterface) exitWith {nil;};

if (isNil "ITD_local_spectating") then {
	ITD_local_spectating = false;
};

// Allow only one instance.
if (ITD_local_spectating) exitWith {nil;};
ITD_local_spectating = true;

// Disable player.
player setCaptive true;
player hideObject true;
player enableSimulation false;
1 fadeSound 0;

waitUntil {!isNull player};
waitUntil {!isNil "ITD_global_playerList"};
waitUntil {!isNil "ITD_global_campExists"};
waitUntil {!isNil "ITD_global_canJoin"};

ITD_local_stopSpectating = false;
if (!_inQueue) then {
	[] spawn {
		while {!ITD_local_stopSpectating} do {
			if (ITD_global_campExists || ITD_global_canJoin) then {
				ITD_local_stopSpectating = true;
			};

			sleep 1;
		};
	};
};

// Start spectating.
if (_inQueue) then {
	[ITD_global_playerList, "Preparing vehicle", 200, 300, 90, 1, [], 0,
	[[], {ITD_local_stopSpectating}]] call ALiVE_fnc_establishingShotCustom;
} else {
	[ITD_global_playerList, "Tracking resistance", 200, 300, 90, 1, [], 0,
	[[], {ITD_local_stopSpectating}]] call ALiVE_fnc_establishingShotCustom;
};
ITD_local_spectating = false;

if (!_inQueue) then {
	["respawning"] call BIS_fnc_blackOut;
	sleep 2;
	[player] call ITD_fnc_respawn;
};

nil;
