scriptName "fn_spectate";
/*
	Author: Bhaz

	Description:
	Forced spectate while waiting to respawn / join. Runs clientside.

	Parameter(s):
	#0 BOOL (Optional) - Waiting in a spawn queue (default: false)

	Example:
	n/a

	Returns:
	Nothing
*/

if (!hasInterface) exitWith {};

params [["_inQueue", false, [true]]];

if (isNil "ITD_local_spectating") then {
	ITD_local_spectating = false;
};

if (ITD_local_spectating) exitWith {};
ITD_local_spectating = true;

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
