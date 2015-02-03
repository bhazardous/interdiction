scriptName "fn_setMapIntel";
/*
	Author: Bhaz

	Description:
	Enables / disables ALiVE intel markers.

	Parameter(s):
	#0 NUMBER - Intel radius

	Returns:
	nil
*/

private ["_radius", "_jobs", "_intelJob", "_args"];
_radius = _this select 0;

waitUntil {!isNil "ALiVE_liveAnalysis"};

// Find the intel job.
_jobs = [ALiVE_liveAnalysis, "analysisJobs"] call ALiVE_fnc_hashGet;
_intelJob = [_jobs, "showFriendlies"] call ALiVE_fnc_hashGet;
_args = [_intelJob, "args"] call ALiVE_fnc_hashGet;

// Throw the new radius in.
if (typeName _args == "ARRAY") then {
	_args set [0, _radius];
};

nil;
