/*--------------------------------------------------------------------
	file: DialogsBase.hpp
	=====================
	Author: Bhaz <>
	Description:
--------------------------------------------------------------------*/

// TYPES
#define CT_STATIC		0
#define CT_PROGRESS		8

// STYLES
// - CT_STATIC
#define ST_SINGLE			0x00
#define ST_PICTURE			0x30
#define ST_HUD_BACKGROUND	0x80
#define ST_KEEP_ASPECT_RATIO	0x800
// - CT_PROGRESS
#define ST_HORIZONTAL		0x00
#define ST_VERTICAL			0x01

// GUI GRID
#define GUI_GRID_X		(safezoneX)
#define GUI_GRID_Y		(safezoneY)
#define GUI_GRID_W		(safezoneW / 40)
#define GUI_GRID_H		(safezoneH / 25)
#define GUI_SCREEN_X	GUI_GRID_W + GUI_GRID_X
#define GUI_SCREEN_Y	GUI_GRID_H + GUI_GRID_Y

class IGUIBack
{
	idc = -1;
	type = CT_STATIC;
	style = ST_HUD_BACKGROUND;
	colorBackground[] = {0,0,0,1};
	colorText[] = {0,0,0,0};
	text = "";
	font = "PuristaMedium";
	sizeEx = 0;
};

class RscPicture
{
	idc = -1;
	type = CT_STATIC;
	style = ST_PICTURE;
	access = 0;
	deletable = 0;
	fade = 0;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	font = "PuristaMedium";
	sizeEx = 0;
	fixedWidth = 0;
};

class RscPictureAspect : RscPicture
{
	style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
};

class RscProgress
{
	type = CT_PROGRESS;
	style = ST_HORIZONTAL;
	colorFrame[] = {0,0,0,0};
	colorBar[] = {1,1,1,1};
	texture = "#(argb,8,8,3)color(1,1,1,1)";
};

class StyledProgress : RscProgress
{
	colorBar[] = {"(profileNamespace getVariable ['IGUI_WARNING_RGB_R',0.8])","(profileNamespace getVariable ['IGUI_WARNING_RGB_G',0.5])","(profileNamespace getVariable ['IGUI_WARNING_RGB_B',0.0])","(profileNamespace getVariable ['IGUI_WARNING_RGB_A',0.8])"};
};

class RscText
{
	idc = -1;
	type = CT_STATIC;
	style = ST_SINGLE;
	access = 0;
	deletable = 0;
	fade = 0;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	colorShadow[] = {0,0,0,0.5};
	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
	fixedWidth = 0;
	shadow = 1;
	font = "PuristaMedium";
	sizeEx = "(((1 / 1.2) / 20) * 0.9)";
	linespacing = 1;
};
