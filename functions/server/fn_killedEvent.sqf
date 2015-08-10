scriptName "fn_killedEvent";
/*
	Author: Bhaz

	Description:
	Server event for killed units, called by CBA.

	Parameter(s):
	#0 OBJECT - Killed unit of type "Man"
	#1 OBJECT - Killer (either man or vehicle)

	Example:
	n/a

	Returns:
	Nothing
*/

#include "persistentData.hpp"

if (!isServer) exitWith {};
params ["_man", "_killer", "_value"];
private ["_faction"];
_faction = faction _man;

if (_faction in ITD_server_faction_enemy) then {
	if (!(_killer isKindOf "Man")) then {
		_killer = effectiveCommander _killer;
	};

	if (([position _man, ITD_server_civ_markers] call ITD_fnc_insideMarkers)) then {
		_value = 2;
	} else {
		_value = 1;
	};

	if (faction _killer == ITD_server_faction_blufor) then {
		private ["_kills"];

		_kills = DB_PROGRESS_KILLS;
		_kills = _kills + _value;
		if (_kills >= ITD_server_killThreshold) then {
			_kills = _kills - ITD_server_killThreshold;
			["kills"] call ITD_fnc_resistanceActivity;
		};

		SET_DB_PROGRESS_KILLS(_kills);
	};
};
