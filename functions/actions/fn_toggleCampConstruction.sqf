scriptName "fn_toggleCampConstruction";
/*
	Author: Bhaz

	Description:
	Handles addAction / removeAction for clients for camp construction.

	Parameter(s):
	#0 BOOL - Enable / disable construction

	Returns:
	nil
*/

if (!hasInterface) exitWith {nil;};
waitUntil {!isNull player};

private ["_enable"];
_enable = [_this, 0, false, [true]] call BIS_fnc_param;
INT_local_campActionAllowed = _enable;

if (isNil "INT_local_campAction") then {
	INT_local_campAction = false;
};

if (_enable) then {
	if (!INT_local_campAction) then {
		if (alive player) then {
			INT_local_campActionId = player addAction ["Build camp", "client\action_buildCamp.sqf", nil, 1.5, false,
				true, "", "vehicle player == player"];
			INT_local_campAction = true;
		};
	};
} else {
	if (INT_local_campAction) then {
		player removeAction INT_local_campActionId;
		INT_local_campAction = false;
	};
};

nil;
