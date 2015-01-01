scriptName "fn_killedEvent";
/*
	Author: Bhaz

	Description:
	For server to handle killed units.

	Parameter(s):
	#0 OBJECT - Killed unit of type "Man"
	#1 OBJECT - Killer (either man or vehicle)

	Returns:
	nil
*/

if (!isServer) exitWith {nil;};

private ["_man", "_killer", "_faction"];
_man = _this select 0;
_killer = _this select 1;
_faction = faction _man;

lastKill = format ["%1 killed by %2", _man, _killer];

if (_faction in INT_server_faction_enemy) then {
	if (!(_killer isKindOf "Man")) then {
		_killer = effectiveCommander _killer;
	};

	if (isPlayer _killer) then {
		INT_server_kills = INT_server_kills + 1;
		if (INT_server_kills >= INT_server_killThreshold) then {
			INT_server_kills = INT_server_kills - INT_server_killThreshold;
			["kills"] call INT_fnc_resistanceActivity;
		};
	}
};

nil;
