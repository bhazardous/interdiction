scriptName "fn_setSectorIntel";
/*
	Author: Bhaz

	Description:
	Enables / disables ALiVE intel sector display.
	Current status - ([[[ALiVE_liveAnalysis, "analysisJobs"] call ALiVE_fnc_hashGet, "gridProfileEntity"] call ALiVE_fnc_hashGet, "args"] call ALiVE_fnc_hashGet) select 4 select 0;

	Parameter(s):
	#0 BOOL - Enable / disable
	#1 BOOL (OPTIONAL) - Special case for mission init, don't use elsewhere.

	Returns:
	nil
*/

private ["_enabled", "_override", "_jobs", "_gridJob", "_args"];

_enabled = [_this, 0, false, [false]] call BIS_fnc_param;
_override = [_this, 1, false, [false]] call BIS_fnc_param;

// Grab a reference to the args.
waitUntil {!isNil "ALiVE_liveAnalysis"};
waitUntil {!isNil {_jobs = [ALiVE_liveAnalysis, "analysisJobs"] call ALiVE_fnc_hashGet; _jobs}};
waitUntil {!isNil {_gridJob = [_jobs, "gridProfileEntity"] call ALiVE_fnc_hashGet; _gridJob}};
waitUntil {!isNil {_args = [_gridJob, "args"] call ALiVE_fnc_hashGet; _args}};

// Special case - the array is filled with defaults before ALiVE overwrites with real values.
// Any value set during init would be overwritten.
if (_override) exitWith {
	waitUntil {(_args select 4 select 0)};
	[_enabled] call INT_fnc_setSectorIntel;
	nil;
};

// Set the new value.
(_args select 4) set [0, _enabled];

if (!_enabled) then {
	// Force a clean up of the grid markers.
	[ALIVE_sectorPlotterEntities, "clear"] call ALIVE_fnc_plotSectors;

	// Do it again, just incase this happened in the middle of an update.
	[] spawn {
		sleep 15;
		[ALIVE_sectorPlotterEntities, "clear"] call ALIVE_fnc_plotSectors;
	};
};

nil;
