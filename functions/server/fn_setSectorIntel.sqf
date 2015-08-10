scriptName "fn_setSectorIntel";
/*
	Author: Bhaz

	Description:
	Enables / disables ALiVE intel sector display and enemy movements.
	Current status - ([[[ALiVE_liveAnalysis, "analysisJobs"] call ALiVE_fnc_hashGet, "gridProfileEntity"] call ALiVE_fnc_hashGet, "args"] call ALiVE_fnc_hashGet) select 4 select 0;

	Parameter(s):
	#0 BOOL - Enable / disable
	#1 BOOL (OPTIONAL) - Special case for mission init, don't use elsewhere.

	Example:
	n/a

	Returns:
	Nothing
*/

if (!params [["_enabled", false, [true]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_override", "_intelChance", "_jobs", "_gridJob", "_args"];
_override = param [1, false, [true]];

if (_enabled) then {
	_intelChance = "1.0";
} else {
	_intelChance = "0.0";
};

waitUntil {!isNil "ALiVE_liveAnalysis"};
waitUntil {!isNil {_jobs = [ALiVE_liveAnalysis, "analysisJobs"] call ALiVE_fnc_hashGet; _jobs}};
waitUntil {!isNil {_gridJob = [_jobs, "gridProfileEntity"] call ALiVE_fnc_hashGet; _gridJob}};
waitUntil {!isNil {_args = [_gridJob, "args"] call ALiVE_fnc_hashGet; _args}};

// Special case - the array is filled with defaults before ALiVE overwrites with real values.
// Any value set during init would be overwritten.
if (_override) exitWith {
	waitUntil {(_args select 4 select 0)};
	[_enabled] call ITD_fnc_setSectorIntel;
};

// Set the new value.
(_args select 4) set [0, _enabled];
[ITD_module_alive_intel, "intelChance", _intelChance] call ALiVE_fnc_MI;

if (!_enabled) then {
	waitUntil {!isNil "ALIVE_sectorPlotterEntities"};

	// Force a clean up of the grid markers.
	[ALIVE_sectorPlotterEntities, "clear"] call ALIVE_fnc_plotSectors;
	[] spawn {
		sleep 15;
		[ALIVE_sectorPlotterEntities, "clear"] call ALIVE_fnc_plotSectors;
	};
};
