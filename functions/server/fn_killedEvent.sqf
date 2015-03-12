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

if (_faction in ITD_server_faction_enemy) then {
	if (!(_killer isKindOf "Man")) then {
		_killer = effectiveCommander _killer;
	};

	// Kill value.
	private ["_value"];
	if (([position _man, ITD_server_civ_markers] call ITD_fnc_insideMarkers)) then {
		_value = 2;
	} else {
		_value = 1;
	};

	if (faction _killer == ITD_server_faction_blufor) then {
		private ["_kills"];

		_kills = ITD_server_statData select 0;
		_kills = _kills + _value;
		if (_kills >= ITD_server_killThreshold) then {
			_kills = _kills - ITD_server_killThreshold;
			["kills"] call ITD_fnc_resistanceActivity;
		};

		ITD_server_statData set [0, _kills];
		[] call ITD_fnc_updatePersistence;
	};
};

nil;
