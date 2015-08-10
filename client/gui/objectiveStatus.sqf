scriptName "objectiveStatus";
/*
	Author: Bhaz

	Description:
	Low level GUI control for ITD_ObjectiveStatus. Function only available on player clients.
	Use ITD_fnc_guiAction rather than calling this directly.

	Parameter(s):
	#0 STRING - Action
	#1 ANY (Optional) - Parameters (default: Nothing)

	Example:
	["show"] call ITD_local_ui_objStatus_fn;
	["objectiveStatus", "show"] call ITD_fnc_guiAction;

	Returns:
	Nothing
*/

#include "gui_macros.hpp"

params ["_action", "_params"];
private ["_textCtrl", "_progressCtrl", "_iconCtrl", "_iconBackCtrl", "_progressBackCtrl"];

_getControls = {
	disableSerialization;

	private ["_display"];
	_display = uiNamespace getVariable "ITD_local_ui_objStatus";
	if (!isNull _display) exitWith {
		_textCtrl = _display displayCtrl 1001;
		_progressCtrl = _display displayCtrl 1002;
		_iconCtrl = _display displayCtrl 1003;
		_iconBackCtrl = _display displayCtrl 2201;
		_progressBackCtrl = _display displayCtrl 2202;
		true
	};

	["ITD_IconObjectiveStatus - failed to get controls: %1", _action] call BIS_fnc_error;
	false
};

switch (_action) do {
	case "show": {
		("ITD_ObjectiveStatus" call BIS_fnc_rscLayer) cutRsc ["ITD_ObjectiveStatus", "PLAIN"];
	};

	case "showFull": {
		["show"] call ITD_local_ui_objStatus_fn;
		["extend"] call ITD_local_ui_objStatus_fn;
	};

	case "hide": {
		["fadeOut"] call ITD_local_ui_objStatus_fn;
		("ITD_ObjectiveStatus" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	};

	case "extend": {
		if (!call _getControls) exitWith {};

		private ["_topPos", "_botPos"];
		_topPos = ctrlPosition _textCtrl;
		_botPos = ctrlPosition _progressCtrl;

		// Snap to defaults.
		_topPos set [3, 0.475 * GUI_GRID_H];
		_botPos set [2, 3.15 * GUI_GRID_W];
		_textCtrl ctrlSetPosition _topPos;
		_progressCtrl ctrlSetPosition _botPos;
		_progressBackCtrl ctrlSetPosition _botPos;
		_textCtrl ctrlSetText "SECURE";
		{_x ctrlCommit 0} forEach [_textCtrl, _progressCtrl, _progressBackCtrl];

		// Set new positions.
		_topPos set [2, 3.15 * GUI_GRID_W];
		_botPos set [3, 0.5 * GUI_GRID_H];

		// Animate.
		_textCtrl ctrlSetPosition _topPos;
		_textCtrl ctrlCommit 0.4;
		waitUntil {ctrlCommitted _textCtrl};
		{
			_x ctrlSetPosition _botPos;
			_x ctrlCommit 0.4;
		} forEach [_progressCtrl, _progressBackCtrl];
		waitUntil {ctrlCommitted _progressCtrl};
	};

	case "shrink": {
		if (!call _getControls) exitWith {};

		private ["_topPos", "_botPos"];
		_topPos = ctrlPosition _textCtrl;
		_botPos = ctrlPosition _progressCtrl;

		// Set new positions.
		_progressCtrl progressSetPosition 0;
		{_x set [2, 0]; _x set [3, 0]} forEach [_topPos, _botPos];

		// Animate.
		{
			_x ctrlSetPosition _botPos;
			_x ctrlCommit 0.25;
		} forEach [_progressCtrl, _progressBackCtrl];
		waitUntil {ctrlCommitted _progressCtrl};
		_textCtrl ctrlSetText "";
		_textCtrl ctrlSetPosition _topPos;
		_textCtrl ctrlCommit 0.25;
		waitUntil {ctrlCommitted _textCtrl};
	};

	case "setText": {
		if (!call _getControls) exitWith {};
		_textCtrl ctrlSetText _params;
	};

	case "setProgress": {
		if (!call _getControls) exitWith {};
		_progressCtrl progressSetPosition _params;
	};

	case "fadeOut": {
		if (!call _getControls) exitWith {};
		_iconCtrl ctrlSetTextColor [0, 0, 0, 0];

		private ["_time"];
		_time = time;
		waitUntil {
			_iconBackCtrl ctrlSetBackgroundColor [-1,-1,-1, 0.75 - 0.75 * ((time - _time) / 0.25)];
			time > (_time + 0.25)
		};
	};

	case "setSide": {
		if (!call _getControls) exitWith {};

		_iconCtrl ctrlSetTextColor (switch _params do {
			case "ColorEAST": {[
				profileNamespace getVariable ['Map_OPFOR_R',0],
				profileNamespace getVariable ['Map_OPFOR_G',1],
				profileNamespace getVariable ['Map_OPFOR_B',1],
				profileNamespace getVariable ['Map_OPFOR_A',0.8]]};
			case "ColorWEST": {[
				profileNamespace getVariable ['Map_BLUFOR_R',0],
				profileNamespace getVariable ['Map_BLUFOR_G',1],
				profileNamespace getVariable ['Map_BLUFOR_B',1],
				profileNamespace getVariable ['Map_BLUFOR_A',0.8]]};
			case "ColorUNKNOWN": {[
				profileNamespace getVariable ['Map_Unknown_R',0],
				profileNamespace getVariable ['Map_Unknown_G',1],
				profileNamespace getVariable ['Map_Unknown_B',1],
				profileNamespace getVariable ['Map_Unknown_A',0.8]]};
			default {[1,1,1,1]};
		});
	};

	case "setIcon": {
		if (!call _getControls) exitWith {};

		_iconCtrl ctrlSetText (switch (_params) do {
			case "n_hq": {"\A3\ui_f\data\map\markers\nato\n_hq.paa"};
			case "n_installation": {"\A3\ui_f\data\map\markers\nato\n_installation.paa"};
			case "loc_Transmitter": {"\A3\ui_f\data\map\mapcontrol\Transmitter_CA.paa"};
			default {_params};
		});
	};

	default {["ITD_ObjectiveStatus - invalid action: %1", _action] call BIS_fnc_error};
};
