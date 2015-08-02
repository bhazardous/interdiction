scriptName "fn_getRealTurrets";
/*
	Author: Bhaz

	Description:
	Returns turret paths, ignoring FFV turrets.

	Parameter(s):
	#0 OBJECT - Vehicle

	Example:
	_turrets = [_truck] call ITD_fnc_getRealTurrets;

	Returns:
	Array - turret paths
*/

params [["_vehicle", objNull, [objNull]]];
private ["_turrets", "_turrentPaths", "_realTurrets"];

if (isNull _vehicle) exitWith {
	["Invalid vehicle"] call BIS_fnc_error;
	[]
};

_turrets = [_vehicle, configFile] call BIS_fnc_getTurrets;
_turretPaths = [_vehicle, []] call BIS_fnc_getTurrets;
_realTurrets = [];

for "_i" from 0 to (count _turrets - 1) do {
	private ["_turret", "_ffv"];
	_ffv = false;

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

_realTurrets
