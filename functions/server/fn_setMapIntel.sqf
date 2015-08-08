scriptName "fn_setMapIntel";
/*
	Author: Bhaz

	Description:
	Enables / disables ALiVE intel markers.

	Parameter(s):
	#0 NUMBER - Intel radius

	Example:
	n/a

	Returns:
	Nothing
*/

if (!params [["_radius", 0, [0]]]) exitWith {["Invalid params"] call BIS_fnc_error};
private ["_jobs", "_intelJob", "_args"];
waitUntil {!isNil "ALiVE_liveAnalysis"};

_jobs = [ALiVE_liveAnalysis, "analysisJobs"] call ALiVE_fnc_hashGet;
_intelJob = [_jobs, "showFriendlies"] call ALiVE_fnc_hashGet;
_args = [_intelJob, "args"] call ALiVE_fnc_hashGet;

if (typeName _args == "ARRAY") then {
	(_args select 4) set [0, _radius];
};
