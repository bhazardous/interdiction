scriptName "fn_guiAction";
/*
	Author: Bhaz

	Description:
	Handles dialogs and resources.

	Parameter(s):
	#0 STRING - GUI element name
	#1 STRING - Action
	#2 ANY - Params if required

	Returns:
	BOOL - TRUE when done
*/

private ["_element", "_action", "_params"];
_element = [_this, 0, "", [""]] call BIS_fnc_param;
_action = [_this, 1, "", [""]] call BIS_fnc_param;
_params = [_this, 2, []] call BIS_fnc_param;

switch (_element) do {
		case "objectiveStatus": {
				switch (_action) do {
					case "show": {
						// Ignore if already active.
						if (!ITD_local_ui_objStatus) then {
							ITD_local_ui_objStatus = true;
							ITD_local_ui_objStatus_full = false;
							["show"] call ITD_local_ui_objStatus_fn;
						};
					};

					case "showFull": {
						if (!ITD_local_ui_objStatus) then {
							ITD_local_ui_objStatus = true;
							ITD_local_ui_objStatus_full = true;
							["showFull"] call ITD_local_ui_objStatus_fn;
						};
					};

					case "hide": {
						// Ignore if inactive.
						if (ITD_local_ui_objStatus) then {
							ITD_local_ui_objStatus = false;
							if (ITD_local_ui_objStatus_full) then {
								ITD_local_ui_objStatus_full = false;
								["shrink"] call ITD_local_ui_objStatus_fn;
							};
							["hide"] call ITD_local_ui_objStatus_fn;
						};
					};

					case "extend": {
						if (ITD_local_ui_objStatus) then {
							if (!ITD_local_ui_objStatus_full) then {
								ITD_local_ui_objStatus_full = true;
								["extend"] call ITD_local_ui_objStatus_fn;
							};
						};
					};

					case "shrink": {
						if (ITD_local_ui_objStatus) then {
							if (ITD_local_ui_objStatus_full) then {
								ITD_local_ui_objStatus_full = false;
								["shrink"] call ITD_local_ui_objStatus_fn;
							};
						};
					};

					case "setIcon": {
						if (ITD_local_ui_objStatus) then {
							["setIcon", _params] call ITD_local_ui_objStatus_fn;
						};
					};

					case "setSide": {
						if (ITD_local_ui_objStatus) then {
							["setSide", _params] call ITD_local_ui_objStatus_fn;
						};
					};

					case "setText": {
						if (ITD_local_ui_objStatus) then {
							["setText", _params] call ITD_local_ui_objStatus_fn;
						};
					};

					case "setProgress": {
						if (ITD_local_ui_objStatus) then {
							["setProgress", _params] call ITD_local_ui_objStatus_fn;
						};
					};

					case "animateProgress": {
						if (ITD_local_ui_objStatus) then {
							["animateProgress", _params] call ITD_local_ui_objStatus_fn;
						};
					};
				};
		};
};
