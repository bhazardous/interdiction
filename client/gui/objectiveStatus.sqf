scriptName "objectiveStatus";
/*--------------------------------------------------------------------
	file: objectiveStatus.sqf
	===========================
	Author: Bhaz <>
	Description: Display actions for ITD_ObjectiveStatus
--------------------------------------------------------------------*/
#define __filename "objectiveStatus.sqf"

disableSerialization;
_anim = _this select 0;
_params = [_this, 1, []] call BIS_fnc_param;

// UI controls.
private ["_display", "_textCtrl", "_progressCtrl", "_iconCtrl", "_iconBackCtrl", "_progressBackCtrl"];
_getControls = {
	_display = uiNamespace getVariable "ITD_local_ui_objStatus";
	_textCtrl = _display displayCtrl 1001;
	_progressCtrl = _display displayCtrl 1002;
	_iconCtrl = _display displayCtrl 1003;

	_iconBackCtrl = _display displayCtrl 2201;
	_progressBackCtrl = _display displayCtrl 2202;
};

_killAnim = {
	if (!scriptDone ITD_local_ui_objStatus_anim) then {
		terminate ITD_local_ui_objStatus_anim;
	};
};

switch (_anim) do {
	case "show": {
		("ITD_ObjectiveStatus" call BIS_fnc_rscLayer) cutRsc ["ITD_ObjectiveStatus", "PLAIN"];
	};

	case "showFull": {
		// Brings the progress bar out straight away.
		["show"] call ITD_local_ui_objStatus_fn;
		["extend"] call ITD_local_ui_objStatus_fn;
	};

	case "hide": {
		["fadeOut"] call ITD_local_ui_objStatus_fn;
		("ITD_ObjectiveStatus" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	};

	case "extend": {
		call _getControls;
		_topPos = ctrlPosition _textCtrl;
		_botPos = ctrlPosition _progressCtrl;

		// Snap to defaults.
		_topPos set [3, 0.475 * (safeZoneH / 25)];
		_botPos set [2, 3.15 * (safeZoneW / 40)];
		_textCtrl ctrlSetPosition _topPos;
		_progressCtrl ctrlSetPosition _botPos;
		_progressBackCtrl ctrlSetPosition _botPos;
		_textCtrl ctrlSetText "SECURE";
		_textCtrl ctrlCommit 0;
		_progressCtrl ctrlCommit 0;
		_progressBackCtrl ctrlCommit 0;

		// Set new positions.
		_topPos set [2, 3.15 * (safeZoneW / 40)];
		_botPos set [3, 0.5 * (safeZoneH / 25)];

		// Animate.
		_textCtrl ctrlSetPosition _topPos;
		_textCtrl ctrlCommit 0.4;
		waitUntil {ctrlCommitted _textCtrl};
		_progressCtrl ctrlSetPosition _botPos;
		_progressBackCtrl ctrlSetPosition _botPos;
		_progressCtrl ctrlCommit 0.4;
		_progressBackCtrl ctrlCommit 0.4;
		waitUntil {ctrlCommitted _progressCtrl};
	};

	case "shrink": {
		call _killAnim;
		call _getControls;
		_topPos = ctrlPosition _textCtrl;
		_botPos = ctrlPosition _progressCtrl;

		// Set new positions.
		_progressCtrl progressSetPosition 0;
		_topPos set [2, 0];
		_topPos set [3, 0];
		_botPos set [2, 0];
		_botPos set [3, 0];

		// Animate.
		_progressCtrl ctrlSetPosition _botPos;
		_progressBackCtrl ctrlSetPosition _botPos;
		_progressCtrl ctrlCommit 0.25;
		_progressBackCtrl ctrlCommit 0.25;
		waitUntil {ctrlCommitted _progressCtrl};
		_textCtrl ctrlSetText "";
		_textCtrl ctrlSetPosition _topPos;
		_textCtrl ctrlCommit 0.25;
		waitUntil {ctrlCommitted _textCtrl};
	};

	case "setText": {
		call _getControls;
		_textCtrl ctrlSetText _params;
	};

	case "setProgress": {
		call _killAnim;
		call _getControls;
		_progressCtrl progressSetPosition _params;
	};

	case "animateProgress": {
		call _killAnim;
		call _getControls;

		_params pushBack _progressCtrl;
		ITD_local_ui_objStatus_anim = _params spawn {
			disableSerialization;

			_start = _this select 0;
			_finish = _this select 1;
			_time = _this select 2;
			_progressCtrl = _this select 3;
			_startTime = time;

			while {time < (_startTime + _time)} do {
				_percent = (time - _startTime) / _time;
				_progress = _start + (_finish - _start) * _percent;
				_progressCtrl progressSetPosition _progress;
				sleep 0.01;
			};

			_progressCtrl progressSetPosition _finish;
		};
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

	case "setSide": {
		call _getControls;

		switch (_params) do {
			case "ColorEAST": {
				_colour = [
					profileNamespace getVariable ['Map_OPFOR_R',0],
					profileNamespace getVariable ['Map_OPFOR_G',1],
					profileNamespace getVariable ['Map_OPFOR_B',1],
					profileNamespace getVariable ['Map_OPFOR_A',0.8]];
				_iconCtrl ctrlSetTextColor _colour;
			};
			case "ColorWEST": {
				_colour = [
					profileNamespace getVariable ['Map_BLUFOR_R',0],
					profileNamespace getVariable ['Map_BLUFOR_G',1],
					profileNamespace getVariable ['Map_BLUFOR_B',1],
					profileNamespace getVariable ['Map_BLUFOR_A',0.8]];
				_iconCtrl ctrlSetTextColor _colour;
			};
			case "ColorUNKNOWN": {
				_colour = [
					profileNamespace getVariable ['Map_Unknown_R',0],
					profileNamespace getVariable ['Map_Unknown_G',1],
					profileNamespace getVariable ['Map_Unknown_B',1],
					profileNamespace getVariable ['Map_Unknown_A',0.8]];
				_iconCtrl ctrlSetTextColor _colour;
			};
		};
	};

	case "setIcon": {
		call _getControls;

		switch (_params) do {
			case "n_hq": {
				_iconCtrl ctrlSetText "\A3\ui_f\data\map\markers\nato\n_hq.paa";
			};
			case "n_installation": {
				_iconCtrl ctrlSetText "\A3\ui_f\data\map\markers\nato\n_installation.paa";
			};
			case "loc_Transmitter": {
				_iconCtrl ctrlSetText "\A3\ui_f\data\map\mapcontrol\Transmitter_CA.paa";
			};
			default {
				_iconCtrl ctrlSetText "";
			};
		};
	};
};
