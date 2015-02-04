scriptName "fn_getRealTurrets";
/*
	Author: Bhaz

	Description:
	Gets turret paths that aren't FFV.

	Parameter(s):
	#0 OBJECT - Vehicle

	Returns:
	ARRAY - turret paths
*/

private ["_vehicle", "_turrets", "_turrentPaths", "_realTurrets"];
_vehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

if (isNull _vehicle) exitWith {
	["Vehicle null"] call BIS_fnc_error;
	[];
};

_turrets = [_vehicle, configFile] call BIS_fnc_getTurrets;
_turretPaths = [_vehicle, []] call BIS_fnc_getTurrets;
_realTurrets = [];

for "_i" from 0 to (count _turrets - 1) do {
	private ["_turret", "_ffv"];
	_ffv = false;

	// Look for FFV turret.
	_turret = (_turrets select _i >> "isPersonTurret");
	if (isNumber _turret) then {
		if (getNumber _turret == 1) then {
			_ffv = true;
		};
	};

	if (!_ffv) then {
		_realTurrets pushBack (_turretPaths select _i);
	};
};

_realTurrets;
