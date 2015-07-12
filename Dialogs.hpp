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
			class LeftBorder : IGUIBorder
			{
				idc = 2203;
				x = 0 * GUI_SCREEN_X;
				y = 15 * GUI_SCREEN_Y;
				w = 0.8 * GUI_GRID_W;
				h = 1 * GUI_GRID_H;
				colorText[] = {0.5,0.5,0.5,0.75};
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
};
