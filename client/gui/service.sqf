scriptName "objectiveStatus";
/*
	Author: Bhaz

	Description:
	Low level GUI control for ITD_Service. Function only available on player clients.
	Use ITD_fnc_guiAction rather than calling this directly.

	Parameter(s):
	#0 STRING - Action
	#1 ANY (Optional) - Parameters (default: Nothing)

	Example:
	["show"] call ITD_local_ui_service_fn;
	["service", "show"] call ITD_fnc_guiAction;

	Returns:
	Nothing
*/

#include "gui_macros.hpp"

params ["_action", "_params"];
private ["_fuelCtrl", "_partsCtrl", "_milPartsCtrl", "_iconCtrl", "_iconBackCtrl"];

_getControls = {
	disableSerialization;

	private ["_display"];
	_display = uiNamespace getVariable "ITD_local_ui_service";
	if (!isNull _display) exitWith {
		_fuelCtrl = _display displayCtrl 1001;
		_partsCtrl = _display displayCtrl 1002;
		_milPartsCtrl = _display displayCtrl 1003;
		_iconCtrl = _display displayCtrl 1004;
		_iconBackCtrl = _display displayCtrl 2201;
		true
	};

	["ITD_Service - failed to get controls: %1", _action] call BIS_fnc_error;
	false
};

switch (_action) do {
	case "show": {
		("ITD_Service" call BIS_fnc_rscLayer) cutRsc ["ITD_Service", "PLAIN"];
	};

	case "showFull": {
		["show"] call ITD_local_ui_service_fn;
		["extend"] call ITD_local_ui_service_fn;
	};

	case "hide": {
		["fadeOut"] call ITD_local_ui_service_fn;
		("ITD_Service" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	};

	case "extend": {
		if (!call _getControls) exitWith {};

		private ["_fuelPos", "_partsPos", "_milPartsPos"];
		_fuelPos = ctrlPosition _fuelCtrl;
		_partsPos = ctrlPosition _partsCtrl;
		_milPartsPos = ctrlPosition _milPartsCtrl;

		// Snap to defaults.
		{_x set [3, 0.35 * GUI_GRID_H]} forEach [_fuelPos, _partsPos, _milPartsPos];
		_fuelCtrl ctrlSetPosition _fuelPos;
		_partsCtrl ctrlSetPosition _partsPos;
		_milPartsCtrl ctrlSetPosition _milPartsPos;
		{_x ctrlCommit 0} forEach [_fuelCtrl, _partsCtrl, _milPartsCtrl];

		// Set new positions.
		{_x set [2, 0.8 * GUI_GRID_W]} forEach [_fuelPos, _partsPos, _milPartsPos];
		_fuelCtrl ctrlSetPosition _fuelPos;
		_partsCtrl ctrlSetPosition _partsPos;
		_milPartsCtrl ctrlSetPosition _milPartsPos;

		// Animate.
		{
			_x ctrlCommit 0.2;
			waitUntil {ctrlCommitted _x};
		} forEach [_fuelCtrl, _partsCtrl, _milPartsCtrl];
	};

	case "shrink": {
		if (!call _getControls) exitWith {};

		private ["_fuelPos", "_partsPos", "_milPartsPos"];
		_fuelPos = ctrlPosition _fuelCtrl;
		_partsPos = ctrlPosition _partsCtrl;
		_milPartsPos = ctrlPosition _milPartsCtrl;

		// Set new positions.
		{_x set [2, 0]; _x set [3, 0];} forEach [_fuelPos, _partsPos, _milPartsPos];
		_fuelCtrl ctrlSetPosition _fuelPos;
		_partsCtrl ctrlSetPosition _partsPos;
		_milPartsCtrl ctrlSetPosition _milPartsPos;

		// Animate.
		{
			_x ctrlSetText "";
			_x ctrlCommit 0.1;
			waitUntil {ctrlCommitted _x};
		} forEach [_milPartsCtrl, _partsCtrl, _fuelCtrl];
	};

	case "setFuel": {
		if (!call _getControls) exitWith {};
		_fuelCtrl ctrlSetText _params;
	};

	case "setParts": {
		if (!call _getControls) exitWith {};
		_partsCtrl ctrlSetText _params;
	};

	case "setMilParts": {
		if (!call _getControls) exitWith {};
		_milPartsCtrl ctrlSetText _params;
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

	default {["ITD_Service - invalid action: %1", _action] call BIS_fnc_error};
};
