scriptName "guiInit";
/*--------------------------------------------------------------------
	file: guiInit.sqf
	=================
	Author: Bhaz <>
	Description: Compiling gui script files for use and setting vars.
--------------------------------------------------------------------*/
#define __filename "guiInit.sqf"

ITD_local_ui_objStatus = false;
ITD_local_ui_objStatus_anim = scriptNull;
ITD_local_ui_objStatus_full = false;
ITD_local_ui_objStatus_fn = compile preprocessFileLineNumbers "client\gui\objectiveStatus.sqf";

ITD_local_ui_service = false;
ITD_local_ui_service_full = false;
ITD_local_ui_service_fn = compile preprocessFileLineNumbers "client\gui\service.sqf";
