scriptName "clientInit";
/*--------------------------------------------------------------------
	file: clientInit.sqf
	====================
	Author: Bhaz
	Description:
--------------------------------------------------------------------*/
#define __filename "clientInit.sqf"

call compile preprocessFileLineNumbers "client\gui\guiInit.sqf";

[] spawn {
	0 fadeSound 0;
	0 fadeMusic 0;
	0 fadeRadio 0;

	["respawning", false] call BIS_fnc_blackOut;
	waitUntil {!isNil "ITD_global_unit_override"};
	waitUntil {!isNil "ITD_global_canJoin"};
	waitUntil {!isNull player};
	waitUntil {time > 0};

	// Replace the player unit with the correct faction if required.
	if (ITD_global_unit_override != "") then {
		private ["_oldUnit", "_unitName", "_group", "_newUnit"];
		_oldUnit = player;
		_unitName = format ["%1", player];
		_group = createGroup ITD_global_side_blufor;
		_newUnit = _group createUnit [ITD_global_unit_override, [0,0,0], [], 0, "NONE"];

		selectPlayer _newUnit;
		deleteVehicle _oldUnit;
		call compile format ["%1 = _newUnit", _unitName];
		publicVariable _unitName;
		sleep 1;
	};

	ITD_local_unitReady = true;
	ITD_local_building = false;
	ITD_local_building_snap = true;

	// Assign menu to Ctrl+V.
	ITD_local_flexiMenu = [
		"player",
		[[0x2F,[false,true,false]]],
		0,
		["_this call ITD_fnc_interdictionMenu", "main"]];
	ITD_local_flexiMenu call ALiVE_fnc_flexiMenu_add;

	execVM "client\handlers\objectiveTracker.sqf";
	execVM "client\handlers\camps.sqf";

	if (ITD_global_canJoin) then {
		sleep 15;
		[["ITD_Guide","Interdiction"], -1, true] call ITD_fnc_advHint;
		sleep 60;
		if (!ITD_global_campExists) then {
			[["ITD_Guide","ResistanceCamp","Info_Camp"], -1, true] call ITD_fnc_advHint;
		};
	};
};
