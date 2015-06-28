scriptName "missionTasks";
/*--------------------------------------------------------------------
	file: missionTasks.sqf
	======================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "missionTasks.sqf"

case "objCamp": {
	if (_taskState == "") then {
		[
			ITD_global_side_blufor,
			_taskID,
			[
				"Set up a (preferably hidden) resistance camp.",
				"Build camp",
				""
			],
			objNull,
			true
		] call BIS_fnc_taskCreate;
	} else {
		if (_this == "Current") then {
			_taskID call BIS_fnc_taskSetCurrent;
		} else {
			[_taskID, _this] call BIS_fnc_taskSetState;
		};
	};
};

case "objLiberate": {
	if (_taskState == "") then {
		[
			ITD_global_side_blufor,
			_taskID,
			[
				"Gather supplies, vehicles and manpower; push the enemy out.",
				format ["Liberate %1", worldName],
				""
			],
			objNull
		] call BIS_fnc_taskCreate;
	} else {
		if (_this == "Current") then {
			_taskID call BIS_fnc_taskSetCurrent;
		} else {
			[_taskID, _this] call BIS_fnc_taskSetState;
		};
	};
};
