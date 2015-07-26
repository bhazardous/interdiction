scriptName "service";
/*--------------------------------------------------------------------
	file: service.sqf
	===========================
	Author: Bhaz <>
	Description: Display actions for ITD_Service
--------------------------------------------------------------------*/
#define __filename "service.sqf"
#include "gui_macros.hpp"

disableSerialization;
_anim = _this select 0;
_params = [_this, 1, []] call BIS_fnc_param;

// UI controls.
private ["_display", "_fuelCtrl", "_partsCtrl", "_milPartsCtrl", "_iconCtrl", "_iconBackCtrl"];
_getControls = {
	_display = uiNamespace getVariable "ITD_local_ui_service";
	_fuelCtrl = _display displayCtrl 1001;
	_partsCtrl = _display displayCtrl 1002;
	_milPartsCtrl = _display displayCtrl 1003;
	_iconCtrl = _display displayCtrl 1004;

	_iconBackCtrl = _display displayCtrl 2201;
};

switch (_anim) do {
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
		call _getControls;
		_fuelPos = ctrlPosition _fuelCtrl;
		_partsPos = ctrlPosition _partsCtrl;
		_milPartsPos = ctrlPosition _milPartsCtrl;

		// Snap to defaults.
		_fuelPos set [3, 0.35 * GUI_GRID_H];
		_partsPos set [3, 0.35 * GUI_GRID_H];
		_milPartsPos set [3, 0.35 * GUI_GRID_H];

		_fuelCtrl ctrlSetPosition _fuelPos;
		_partsCtrl ctrlSetPosition _partsPos;
		_milPartsCtrl ctrlSetPosition _milPartsPos;
		_fuelCtrl ctrlCommit 0;
		_partsCtrl ctrlCommit 0;
		_milPartsCtrl ctrlCommit 0;

		// Set new positions.
		{_x set [2, 0.8 * GUI_GRID_W]} forEach [_fuelPos, _partsPos, _milPartsPos];
		_fuelCtrl ctrlSetPosition _fuelPos;
		_partsCtrl ctrlSetPosition _partsPos;
		_milPartsCtrl ctrlSetPosition _milPartsPos;

		// Animate.
		_fuelCtrl ctrlCommit 0.3;
		waitUntil {ctrlCommitted _fuelCtrl}; sleep 0.1;
		_partsCtrl ctrlCommit 0.3;
		waitUntil {ctrlCommitted _partsCtrl}; sleep 0.1;
		_milPartsCtrl ctrlCommit 0.3;
		waitUntil {ctrlCommitted _milPartsCtrl}; sleep 0.1;
	};

	case "shrink": {
		call _getControls;
		_fuelPos = ctrlPosition _fuelCtrl;
		_partsPos = ctrlPosition _partsCtrl;
		_milPartsPos = ctrlPosition _milPartsCtrl;

		// Set new positions.
		{_x set [2, 0]; _x set [3, 0];} forEach [_fuelPos, _partsPos, _milPartsPos];
		_fuelCtrl ctrlSetPosition _fuelPos;
		_partsCtrl ctrlSetPosition _partsPos;
		_milPartsCtrl ctrlSetPosition _milPartsPos;

		// Animate.
		_milPartsCtrl ctrlSetText "";
		_milPartsCtrl ctrlCommit 0.1;
		waitUntil {ctrlCommitted _milPartsCtrl};
		_partsCtrl ctrlSetText "";
		_partsCtrl ctrlCommit 0.1;
		waitUntil {ctrlCommitted _partsCtrl};
		_fuelCtrl ctrlSetText "";
		_fuelCtrl ctrlCommit 0.1;
		waitUntil {ctrlCommitted _fuelCtrl};
	};

	case "setFuel": {
		call _getControls;
		_fuelCtrl ctrlSetText _params;
	};

	case "setParts": {
		call _getControls;
		_partsCtrl ctrlSetText _params;
	};

	case "setMilParts": {
		call _getControls;
		_milPartsCtrl ctrlSetText _params;
	};

	case "fadeOut": {
		call _getControls;
		_iconCtrl ctrlSetTextColor [0, 0, 0, 0];

		// Animate.
		_time = time;
		while {time < (_time + 0.25)} do {
			_alpha = 0.75 + (0 - 0.75) * ((time - _time) / 0.25);
			_iconBackCtrl ctrlSetBackgroundColor [-1, -1, -1, _alpha];
			sleep 0.01;
		};

		_iconBackCtrl ctrlSetBackgroundColor [-1, -1, -1, 0];
	};
};
