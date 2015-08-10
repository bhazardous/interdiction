scriptName "iconReinf";
/*
	Author: Bhaz

	Description:
	Low level GUI control for ITD_IconReinf. Function only available on player clients.
	Use ITD_fnc_guiAction rather than calling this directly.

	Parameter(s):
	#0 STRING - Action
	#1 ANY (Optional) - Parameters (default: Nothing)

	Example:
	["show"] call ITD_local_ui_iconReinf_fn;
	["iconReinf", "show"] call ITD_fnc_guiAction;

	Returns:
	Nothing
*/

params ["_action", "_params"];
private ["_iconCtrl", "_backCtrl"];

_getControls = {
	disableSerialization;

	private ["_display"];
	_display = uiNamespace getVariable "ITD_local_ui_iconReinf";
	if (!isNull _display) exitWith {
		_iconCtrl = _display displayCtrl 1001;
		_backCtrl = _display displayCtrl 2201;
		true
	};

	["ITD_IconReinf - failed to get controls: %1", _action] call BIS_fnc_error;
	false
};

switch (_action) do {
	case "show": {
		("ITD_IconReinf" call BIS_fnc_rscLayer) cutRsc ["ITD_IconReinf", "PLAIN"];
	};

	case "hide": {
		["fadeOut"] call ITD_local_ui_iconReinf_fn;
		("ITD_IconReinf" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	};

	case "fadeOut": {
		if (!call _getControls) exitWith {};

		private ["_time"];
		_iconCtrl ctrlSetTextColor [0,0,0,0];
		_time = time;
		waitUntil {
			_backCtrl ctrlSetBackgroundColor [-1,-1,-1, 0.75 - 0.75 * ((time - _time) / 0.25)];
			time > (_time + 0.25)
		};
	};

	case "setColour": {
		if (!call _getControls) exitWith {};
		_iconCtrl ctrlSetTextColor _params;
	};

	default {["ITD_IconReinf - invalid action: %1", _action] call BIS_fnc_error};
};
