scriptName "fn_service";
/*
	Author: Bhaz

	Description:
	Handles selections from the service menu.

	Parameter(s):
	#0 STRING - Action

	Example:
	n/a

	Returns:
	Nothing
*/

if (!params [["_action", "", [""]]]) exitWith {["Invalid action"] call BIS_fnc_error};
if (isNull ITD_local_serviceTarget) exitWith {["Vehicle is null"] call BIS_fnc_error};

if (_action == "assess") exitWith {
	private ["_vehicle", "_damage", "_milValue"];
	_vehicle = ITD_local_serviceTarget;
	_damage = damage _vehicle * 100;
	_milValue = (count ([_vehicle] call ITD_fnc_getRealTurrets)) * 2;

	if (_milValue > 0) then {
		private ["_partsDamage", "_milDamage"];
		_partsDamage = 60 min _damage;		// Parts 0-60%
		_milDamage = 0 max (_damage - 60);	// Mil parts 60-100%
		ITD_local_militaryUsed = ceil (_milDamage / (40 / _milValue));

		if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
			ITD_local_partsUsed = ceil (_partsDamage / 3);
		} else {
			ITD_local_partsUsed = ceil (_partsDamage / 6);
		};
	} else {
		ITD_local_militaryUsed = 0;
		if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
			ITD_local_partsUsed = ceil (_damage / 5);
		} else {
			ITD_local_partsUsed = ceil (_damage / 10);
		};
	};

	if (ITD_local_militaryUsed > 0) then {
		[["ITD_Service","Info_AssessDamageMil"], 5] call ITD_fnc_advHint;
	} else {
		if (ITD_local_partsUsed > 0) then {
			[["ITD_Service","Info_AssessDamage"], 5] call ITD_fnc_advHint;
		} else {
			[["ITD_Service","Info_AssessDamageNone"], 5] call ITD_fnc_advHint;
		};
	};
};

[[player, _action, ITD_local_serviceTarget], "ITD_fnc_serviceRequest", false] call BIS_fnc_MP;
