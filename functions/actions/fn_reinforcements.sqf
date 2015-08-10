scriptName "fn_reinforcements";
/*
	Author: Bhaz

	Description:
	Client action for requesting reinforcements.

	RemoteExec: Server

	Parameter(s):
	NUMBER (Optional) - Used by the server as a response (default: -3)

	Example:
	n/a

	Returns:
	Nothing
*/

params [["_index", -3, [0]]];

switch (_index) do {
	case -3: {[[player], "ITD_fnc_reinforceRequest", false] call BIS_fnc_MP};
	case -2: {["iconReinf", "hide"] call ITD_fnc_guiAction};
	case -1: {[["ITD_Recruitment","Error_Queue"], 5] call ITD_fnc_advHint};

	default {
		["iconReinf", "show"] call ITD_fnc_guiAction;

		private ["_colour"];
		if (_index > 0) then {
			_colour = [
				profileNamespace getVariable ['Map_Unknown_R',0],
				profileNamespace getVariable ['Map_Unknown_G',1],
				profileNamespace getVariable ['Map_Unknown_B',1],
				profileNamespace getVariable ['Map_Unknown_A',0.8]];
		} else {
			_colour = [
				profileNamespace getVariable ['Map_BLUFOR_R',0],
				profileNamespace getVariable ['Map_BLUFOR_G',1],
				profileNamespace getVariable ['Map_BLUFOR_B',1],
				profileNamespace getVariable ['Map_BLUFOR_A',0.8]];
		};

		["iconReinf", "setColour", _colour] call ITD_fnc_guiAction;
	};
};
