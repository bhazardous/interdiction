scriptName "fn_serviceRequest";
/*
	Author: Bhaz

	Description:
	Handles service requests sent from clients.

	RemoteExec: Client

	Parameter(s):
	#0 OBJECT - Player sending the request
	#0 STRING - Action
	#1 NUMBER - Service point ID
	#2 OBJECT - Vehicle being serviced

	Example:
	n/a

	Returns:
	Nothing

*/

#include "persistentData.hpp"

if (!isServer) exitWith {};

params [
	["_player", objNull, [objNull]],
	["_action", "", [""]],
	["_vehicle", objNull, [objNull]]];
private ["_id", "_pos", "_data", "_update"];
_id = [_player, ITD_global_camps] call ITD_fnc_closestPosition;
_pos = DB_CAMPS_SERVICE_POSITION;
_data = DB_CAMPS_SERVICE_DATA;
_update = false;

if (_player distance _pos > 25) exitWith {
	[[["ITD_Service","Error_DistancePlayer"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
};
if (_vehicle distance _pos > 25) exitWith {
	[[["ITD_Service","Error_DistanceVehicle"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
};
if (_player distance _vehicle > 6) exitWith {
	[[["ITD_Service","Error_DistanceClose"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
};

[[_player, "AinvPknlMstpSnonWnonDr_medicUp1"], "ITD_fnc_playAnimation", _player] call BIS_fnc_MP;
sleep 5;

// Repair and refuel actions.
switch (_action) do {
	case "repair": {
		private ["_partial", "_damage", "_milValue", "_partsRequired", "_milRequired",
			"_partsCoef"];
		_partial = false;
		_damage = damage _vehicle * 100;
		_milValue = (count ([_vehicle] call ITD_fnc_getRealTurrets)) * 2;

		if (_damage == 0) exitWith {
			[[["ITD_Service","Info_AssessDamageNone"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		};

		if (_milValue > 0) then {
			private ["_partsDamage", "_milDamage", "_milCoef"];
			_partsDamage = 60 min _damage;
			_milDamage = 0 max (_damage - 60);
			_milCoef = (40 / _milValue);
			_milRequired = ceil (_milDamage / _milCoef);

			if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
				_partsRequired = ceil (_partsDamage / 3);
				_partsCoef = 3;
			} else {
				_partsRequired = ceil (_partsDamage / 6);
				_partsCoef = 6;
			};

			if (_milRequired > 0) then {
				if (_data select 2 >= _milRequired) then {
					_damage = _damage - (_milRequired * _milCoef);
					_data set [2, (_data select 2) - _milRequired];
					_update = true;
					[["ITD_local_militaryUsed", _milRequired], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
				} else {
					private ["_milUsed"];
					_milUsed = _data select 2;
					_data set [2, 0];
					_update = true;
					_damage = _damage - (_milUsed * _milCoef);
					_partial = true;

					if (_milUsed > 0) then {
						[["ITD_local_militaryUsed", _milUsed], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
						[[["ITD_Service","Info_RepairPartialMil"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
					} else {
						[[["ITD_Service","Info_RepairPartsMil"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
					};
				};
			};
		} else {
			_milRequired = 0;
			if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
				_partsRequired = ceil (_damage / 5);
				_partsCoef = 5;
			} else {
				_partsRequired = ceil (_damage / 10);
				_partsCoef = 10;
			};
		};

		if (_partial) exitWith {_vehicle setDamage ((0 max _damage) / 100)};

		if (_partsRequired > 0) then {
			if (_data select 1 >= _partsRequired) then {
				_damage = _damage - (_partsRequired * _partsCoef);
				_data set [1, (_data select 1) - _partsRequired];
				_update = true;
				[["ITD_local_partsUsed", _partsRequired], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
			} else {
				private ["_partsUsed"];
				_partsUsed = _data select 1;
				_data set [1, 0];
				_update = true;
				_damage = _damage - (_partsUsed * _partsCoef);
				_partial = true;

				if (_milRequired > 0 || {_partsUsed > 0}) then {
					[["ITD_local_partsUsed", _partsUsed], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
				};

				if (_milRequired > 0) then {
					[[["ITD_Service","Info_RepairPartialBoth"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
				} else {
					if (_partsUsed > 0) then {
						[[["ITD_Service","Info_RepairPartial"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
					} else {
						[[["ITD_Service","Info_RepairParts"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
					};
				};
			};
		};

		_vehicle setDamage ((0 max _damage) / 100);
		if (_partial) exitWith {};

		if (_milRequired > 0) then {
			[[["ITD_Service","Info_RepairCompleteMil"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		} else {
			[[["ITD_Service","Info_RepairComplete"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		};
	};

	case "refuel": {
		private ["_fuel", "_fuelRequired"];
		_fuel = fuel _vehicle;
		if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
			_fuelRequired = ceil (((1 - _fuel) * 100) / 5);
		} else {
			_fuelRequired = ceil (((1 - _fuel) * 100) / 10);
		};

		if (_fuelRequired == 0) exitWith {};

		[["ITD_local_fuelUsed", _fuelRequired], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;

		if (_data select 0 >= _fuelRequired) then {
			_data set [0, (_data select 0) - _fuelRequired];
			_update = true;
			_vehicle setFuel 1;
			[[["ITD_Service","Info_RefuelFull"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		} else {
			private ["_refuel"];
			_refuel = _fuel + ((_data select 0) * 0.05);
			_data set [0, 0];
			_update = true;
			_vehicle setFuel _refuel;
			[[["ITD_Service","Info_RefuelPartial"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		};
	};

	case "strip": {
		private ["_value", "_siphon", "_milValue"];

		_milValue = (count ([_vehicle] call ITD_fnc_getRealTurrets)) * 2;

		if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
			_siphon = ceil (((fuel _vehicle) * 100) / 5);
		} else {
			_siphon = ceil (((fuel _vehicle) * 100) / 10);
		};

		if (_milValue == 0) then {
			if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
				_value = ceil (((1 - (damage _vehicle)) * 100) / 5);
			} else {
				_value = ceil (((1 - (damage _vehicle)) * 100) / 10);
			};
		} else {
			private ["_damage", "_partsDamage", "_milDamage", "_milCoef"];

			_damage = damage _vehicle * 100;
			_partsDamage = 60 min _damage;
			_milDamage = 0 max (_damage - 60);
			_milCoef = (40 / _milValue);
			_milValue = _milValue - (ceil (_milDamage / _milCoef));

			if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
				_value = 20 - (ceil (_partsDamage / 3));
			} else {
				_value = 10 - (ceil (_partsDamage / 6));
			};
		};

		_data set [0, (_data select 0) + _siphon];
		_data set [1, (_data select 1) + _value];
		_data set [2, (_data select 2) + _milValue];
		_update = true;

		deleteVehicle _vehicle;
		[["ITD_local_partsUsed", _value], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;

		if (_milValue == 0) then {
			if (_siphon > 0) then {
				[["ITD_local_fuelUsed", _siphon], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
				[[["ITD_Service","Info_StripSiphon"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
			} else {
				[[["ITD_Service","Info_Strip"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
			};
		} else {
			if (_siphon > 0) then {
				[["ITD_local_militaryUsed", _milValue], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
				[["ITD_local_fuelUsed", _siphon], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
				[[["ITD_Service","Info_StripMilSiphon"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
			} else {
				[["ITD_local_militaryUsed", _milValue], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
				[[["ITD_Service","Info_StripMil"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
			};
		};
	};

	case "siphon": {
		private ["_siphon"];
		if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
			_siphon = ceil (((fuel _vehicle) * 100) / 5);
		} else {
			_siphon = ceil (((fuel _vehicle) * 100) / 10);
		};

		if (_siphon > 0) then {
			_data set [0, (_data select 0) + _siphon];
			_update = true;
			_vehicle setFuel 0;
			[["ITD_local_fuelUsed", _siphon], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
			[[["ITD_Service","Info_Siphon"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		} else {
			[[["ITD_Service","Info_SiphonNone"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		};
	};
};

if (_update) then {
	ITD_global_serviceData set [_id, (DB_CAMPS_SERVICE_DATA)];
	publicVariable "ITD_global_serviceData";
};
