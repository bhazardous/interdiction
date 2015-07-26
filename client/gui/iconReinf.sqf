scriptName "iconReinf";
/*--------------------------------------------------------------------
	file: iconReinf.sqf
	===================
	Author: Bhaz <>
	Description:
--------------------------------------------------------------------*/
#define __filename "iconReinf.sqf"

disableSerialization;
_anim = _this select 0;
_params = [_this, 1, []] call BIS_fnc_param;

// UI controls.
private ["_display", "_iconCtrl", "_backCtrl"];
_getControls = {
	_display = uiNamespace getVariable "ITD_local_ui_iconReinf";
	_iconCtrl = _display displayCtrl 1001;

	_backCtrl = _display displayCtrl 2201;
};

switch (_anim) do {
	case "show": {
		("ITD_IconReinf" call BIS_fnc_rscLayer) cutRsc ["ITD_IconReinf", "PLAIN"];
	};

	case "hide": {
		["fadeOut"] call ITD_local_ui_iconReinf_fn;
		("ITD_IconReinf" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	};

	case "fadeOut": {
		call _getControls;
		_iconCtrl ctrlSetTextColor [0, 0, 0, 0];

		// Animate.
		_time = time;
		while {time < (_time + 0.25)} do {
			_alpha = 0.75 + (0 - 0.75) * ((time - _time) / 0.25);
			_backCtrl ctrlSetBackgroundColor [-1, -1, -1, _alpha];
			sleep 0.01;
		};

		_backCtrl ctrlSetBackgroundColor [-1, -1, -1, 0];
	};

	case "setColour": {
		call _getControls;
		_iconCtrl ctrlSetTextColor _params;
	};
};
