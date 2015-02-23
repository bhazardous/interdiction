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

	// Kill value.
	private ["_value"];
	if (([position _man, INT_server_civ_markers] call INT_fnc_insideMarkers)) then {
		_value = 2;
	} else {
		_value = 1;
	};

	if (isPlayer _killer) then {
		private ["_stats", "_kills"];

		_stats = [INT_server_persistentData, "stats"] call CBA_fnc_hashGet;
		_kills = _stats select 0;
		_kills = _kills + _value;
		if (_kills >= INT_server_killThreshold) then {
			_kills = _kills - INT_server_killThreshold;
			["kills"] call INT_fnc_resistanceActivity;
		};

		_stats set [0, _kills];
	};
};

nil;
