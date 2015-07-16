/*--------------------------------------------------------------------
	file: Dialogs.hpp
	=================
	Author: Bhaz <>
	Description:
--------------------------------------------------------------------*/
#include "DialogsBase.hpp"

class RscTitles
{
	class ITD_ObjectiveStatus
	{
		idd = -1;
		duration = 999;
		onLoad = "uiNamespace setVariable ['ITD_local_ui_objStatus', (_this select 0)];";
		fadeIn = 0.25;
		class controls
		{
			class Text : RscText
			{
				idc = 1001;
				text = "SECURE";
				x = 0.8 * GUI_SCREEN_X;
				y = 15 * GUI_SCREEN_Y;
				// w = 3.15 * GUI_GRID_W;
				w = 0;
				// h = 0.475 * GUI_GRID_H;
				h = 0;
				colorBackground[] = {-1,-1,-1,0.75};
			};
			class Progress : StyledProgress
			{
				idc = 1002;
				x = 0.8 * GUI_SCREEN_X;
				y = 15.475 * GUI_SCREEN_Y;
				// w = 3.15 * GUI_GRID_W;
				w = 0;
				// h = 0.5 * GUI_GRID_H;
				h = 0;
				colorBackground[] = {0.2,0.2,0.2,0.4};
			};
			class Icon : RscPictureAspect
			{
				idc = 1003;
				text = "\A3\ui_f\data\map\mapcontrol\Transmitter_CA.paa";
				x = 0.07 * GUI_SCREEN_X;
				y = 15.15 * GUI_SCREEN_Y;
				w = 0.64 * GUI_GRID_W;
				h = 0.72 * GUI_GRID_H;
			};
		};
		class controlsBackground
		{
			class LeftBackground : IGUIBack
			{
				idc = 2201;
				x = 0 * GUI_SCREEN_X;
				y = 15 * GUI_SCREEN_Y;
				w = 0.8 * GUI_GRID_W;
				h = 1 * GUI_GRID_H;
				colorBackground[] = {-1,-1,-1,0.75};
			};
			class ProgressBackground : IGUIBack
			{
				idc = 2202;
				x = 0.8 * GUI_SCREEN_X;
				y = 15.475 * GUI_SCREEN_Y;
				// w = 3.15 * GUI_GRID_W;
				w = 0;
				// h = 0.5 * GUI_GRID_H;
				h = 0;
				colorBackground[] = {0.2,0.2,0.2,0.4};
			};
		};
	};
	class ITD_Service
	{
		idd = -1;
		duration = 999;
		onLoad = "uiNamespace setVariable ['ITD_local_ui_service', (_this select 0)];";
		fadeIn = 0.25;
		class controls
		{
			class Fuel : RscTextCentre
			{
				idc = 1001;
				text = "";
				x = 0.8 * GUI_SCREEN_X;
				y = 14.15 * GUI_SCREEN_Y;
				// w = 0.8 * GUI_GRID_W;
				w = 0;
				// h = 0.25 * GUI_GRID_H;
				h = 0;
				sizeEx = "(((1 / 1.2) / 20) * 0.7)";
				colorBackground[] = {-1,-1,-1,0.75};
			};
			class Parts : RscTextCentre
			{
				idc = 1002;
				text = "";
				x = 1.59 * GUI_SCREEN_X;
				y = 14.15 * GUI_SCREEN_Y;
				// w = 0.8 * GUI_GRID_W;
				w = 0;
				// h = 0.25 * GUI_GRID_H;
				h = 0;
				sizeEx = "(((1 / 1.2) / 20) * 0.7)";
				colorBackground[] = {-1,-1,-1,0.75};
			};
			class MilParts : RscTextCentre
			{
				idc = 1003;
				text = "";
				x = 2.38 * GUI_SCREEN_X;
				y = 14.15 * GUI_SCREEN_Y;
				// w = 0.8 * GUI_GRID_W;
				w = 0;
				// h = 0.25 * GUI_GRID_H;
				h = 0;
				sizeEx = "(((1 / 1.2) / 20) * 0.7)";
				colorBackground[] = {-1,-1,-1,0.75};
			};
			class Icon : RscPictureAspect
			{
				idc = 1004;
				text = "\A3\ui_f\data\map\markers\nato\b_maint.paa";
				colorText[] = {"(profileNamespace getVariable ['Map_BLUFOR_R',0])","(profileNamespace getVariable ['Map_BLUFOR_G',1])","(profileNamespace getVariable ['Map_BLUFOR_B',1])","(profileNamespace getVariable ['Map_BLUFOR_A',0.8])"};
				x = 0.07 * GUI_SCREEN_X;
				y = 13.65 * GUI_SCREEN_Y;
				w = 0.64 * GUI_GRID_W;
				h = 0.72 * GUI_GRID_H;
			};
		};
		class controlsBackground
		{
			class LeftBackground : IGUIBack
			{
				idc = 2201;
				x = 0 * GUI_SCREEN_X;
				y = 13.5 * GUI_SCREEN_Y;
				w = 0.8 * GUI_GRID_W;
				h = 1 * GUI_GRID_H;
				colorBackground[] = {-1,-1,-1,0.75};
			};
		};
	};
};
