scriptName "fn_guiAction";
/*
	Author: Bhaz

	Description:
	Handles dialogs and resources.
	Usage - ["uiName", "action", params] call ITD_fnc_guiAction;

	Parameter(s):
	#0 STRING - GUI element name
	#1 STRING - Action
	#2 ANY - Params if required

	Returns:
	nil
*/

private ["_element", "_action", "_params"];
_element = [_this, 0, "", [""]] call BIS_fnc_param;
_action = [_this, 1, "", [""]] call BIS_fnc_param;
_params = [_this, 2, []] call BIS_fnc_param;

switch (_element) do {
		// ITD_ObjectiveStatus
		// Actions: show, showFull, hide, extend, shrink, setIcon, setSide, setText, setProgress, animateProgress
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

					default {
						["%1 isn't a valid action for gui 'objectiveStatus'", _action] call BIS_fnc_error;
					};
				};
		};

		// ITD_Service
		// Actions: show, showFull, hide, extend, shrink, setFuel, setParts, setMilParts
		case "service": {
				switch (_action) do {
					case "show": {
						if (!ITD_local_ui_service) then {
							ITD_local_ui_service = true;
							ITD_local_ui_service_full = false;
							["show"] call ITD_local_ui_service_fn;
						};
					};

					case "showFull": {
						if (!ITD_local_ui_service) then {
							ITD_local_ui_service = true;
							ITD_local_ui_service_full = true;
							["showFull"] call ITD_local_ui_service_fn;
						};
					};

					case "hide": {
						if (ITD_local_ui_service) then {
							ITD_local_ui_service = false;
							if (ITD_local_ui_service_full) then {
								ITD_local_ui_service_full = false;
								["shrink"] call ITD_local_ui_service_fn;
							};
							["hide"] call ITD_local_ui_service_fn;
						};
					};

					case "extend": {
						if (ITD_local_ui_service) then {
							if (!ITD_local_ui_service_full) then {
								ITD_local_ui_service_full = true;
								["extend"] call ITD_local_ui_service_fn;
							};
						};
					};

					case "shrink": {
						if (ITD_local_ui_service) then {
							if (ITD_local_ui_service_full) then {
								ITD_local_ui_service_full = false;
								["shrink"] call ITD_local_ui_service_fn;
							};
						};
					};

					case "setFuel": {
						if (ITD_local_ui_service) then {
							["setFuel", _params] call ITD_local_ui_service_fn;
						};
					};

					case "setParts": {
						if (ITD_local_ui_service) then {
							["setParts", _params] call ITD_local_ui_service_fn;
						};
					};

					case "setMilParts": {
						if (ITD_local_ui_service) then {
							["setMilParts", _params] call ITD_local_ui_service_fn;
						};
					};

					default {
						["%1 isn't a valid action for gui 'service'", _action] call BIS_fnc_error;
					};
				};
		};

		default {
				["%1 isn't a valid gui element", _element] call BIS_fnc_error;
		};
};

nil;
