scriptName "fn_reinforcements";
/*
	Author: Bhaz

	Description:
	Client action for requesting reinforcements.

	Parameter(s):
	NUMBER (OPTIONAL) - If a number is given, the server sent a response.

	Returns:
	nil
*/

#define GUI_NAME "iconReinf"
#define GUI_SHOW [GUI_NAME, "show"] call ITD_fnc_guiAction
#define GUI_HIDE [GUI_NAME, "hide"] call ITD_fnc_guiAction
#define GUI_SET_COLOUR(x) [GUI_NAME, "setColour", x] call ITD_fnc_guiAction

private ["_index"];
_index = [_this, 0, -3, [0]] call BIS_fnc_param;

if (_index == -3) then {
	// Display error if reinforcements unavailable.

	// Send reinforcement request to server.
	[[player], "ITD_fnc_reinforceRequest", false] call BIS_fnc_MP;
} else {
	// Response received from server.
	if (_index == -1) exitWith {
		[["ResistanceMovement","RecruitmentTent","AlreadyInQueue"], 5, "", 5, "", true, true] call BIS_fnc_advHint;
	};

	if (_index == -2) exitWith {
		// Received our reinforcements.
		GUI_HIDE;
	};

	GUI_SHOW;
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
	GUI_SET_COLOUR(_colour);
};

nil;
