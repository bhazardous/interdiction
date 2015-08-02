scriptName "fn_serviceRequest";
/*
	Author: Bhaz

	Description:
	Handles service requests sent from clients.

	Parameter(s):
	#0 OBJECT - Player sending the request
	#0 STRING - Action
	#1 NUMBER - Service point ID
	#2 OBJECT - Vehicle being serviced

	Returns:
	nil
*/
#include "persistentData.hpp"
// TODO: Lots of code duplication in this file.
// TODO: Also messy as fuck.

private ["_player", "_action", "_id", "_pos", "_vehicle", "_data"];
_player = _this select 0;
_action = _this select 1;
_vehicle = _this select 2;
_id = [_player, ITD_global_camps] call ITD_fnc_closestPosition;

if (_action == "check") exitWith {
	private ["_data", "_fuel", "_parts", "_military"];
	_data = DB_CAMPS_SERVICE_DATA;
	_fuel = _data select 0;
	_parts = _data select 1;
	_military = _data select 2;
	[["ITD_local_partsUsed", _parts], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
	[["ITD_local_fuelUsed", _fuel], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
	[["ITD_local_militaryUsed", _military], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;

	[[["ITD_Service","Info_Stock"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
};

if (_action == "assess") exitWith {
	private ["_damage", "_partsRequired", "_milRequired", "_militaryValue", "_partsDamage", "_milDamage"];

	_damage = damage _vehicle * 100;
	_militaryValue = (count ([_vehicle] call ITD_fnc_getRealTurrets)) * 2;

	if (_militaryValue > 0) then {
		_partsDamage = 60 min _damage;
		_milDamage = 0 max (_damage - 60);
		_milRequired = ceil (_milDamage / (40 / _militaryValue));

		if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
			_partsRequired = ceil (_partsDamage / 3);
		} else {
			_partsRequired = ceil (_partsDamage / 6);
		};
	} else {
		_milRequired = 0;
		if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
			_partsRequired = ceil (_damage / 5);
		} else {
			_partsRequired = ceil (_damage / 10);
		};
	};

	[["ITD_local_partsUsed", _partsRequired], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
	if (_milRequired > 0) then {
		[["ITD_local_militaryUsed", _milRequired], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
		[[["ITD_Service","Info_AssessDamageMil"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
	} else {
		if (_partsRequired > 0) then {
			[[["ITD_Service","Info_AssessDamage"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		} else {
			[[["ITD_Service","Info_AssessDamageNone"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
		};
	};
};

// Player and vehicle in position.
_pos = DB_CAMPS_SERVICE_POSITION;
if (_player distance _pos > 25) exitWith {
	// Player not close enough to service point.
	[[["ITD_Service","Error_DistancePlayer"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
	nil;
};
if (_vehicle distance _pos > 25) exitWith {
	// Vehicle not close enough to service point.
	[[["ITD_Service","Error_DistanceVehicle"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
	nil;
};
if (_player distance _vehicle > 6) exitWith {
	// Player not close enough to vehicle.
	[[["ITD_Service","Error_DistanceClose"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
	nil;
};

// Grab the data for this service point.
// _data = [fuel, parts. military]
_data = DB_CAMPS_SERVICE_DATA;

// Player animation.
[[_player, "AinvPknlMstpSnonWnonDr_medicUp1"], "ITD_fnc_playAnimation", _player] call BIS_fnc_MP;
sleep 5;

// Repair and refuel actions.
switch (_action) do {
		case "repair": {
				private ["_damage", "_militaryValue", "_partsRequired", "_milRequired",
					"_partsCoef", "_milCoef"];

				_damage = damage _vehicle * 100;
				_militaryValue = (count ([_vehicle] call ITD_fnc_getRealTurrets)) * 2;

				if (_militaryValue > 0) then {
					// Military vehicle.
					_partsDamage = 60 min _damage;
					_milDamage = 0 max (_damage - 60);
					_milCoef = (40 / _militaryValue);
					_milRequired = ceil (_milDamage / _milCoef);

					if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
						_partsRequired = ceil (_partsDamage / 3);
						_partsCoef = 3;
					} else {
						_partsRequired = ceil (_partsDamage / 6);
						_partsCoef = 6;
					};
				} else {
					// Non-military vehicle (unarmed), no military parts required.
					_milRequired = 0;
					if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
						_partsRequired = ceil (_damage / 5);
						_partsCoef = 5;
					} else {
						_partsRequired = ceil (_damage / 10);
						_partsCoef = 10;
					};
				};

				if (_partsRequired == 0 && {_milRequired == 0}) exitWith {
					// No repairs needed.
				};

				private ["_bailOut"];
				_bailOut = false;
				if (_milRequired > 0) then {
					if (_data select 2 >= _milRequired) then {
						// Enough milparts for full repair.
						_damage = _damage - (_milRequired * _milCoef);
						_data set [2, (_data select 2) - _milRequired];
						[["ITD_local_militaryUsed", _milRequired], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
					} else {
						// Not enough milparts for repair, perform partial then exit.
						private ["_milUsed"];
						_milUsed = _data select 2;
						_damage = _damage - (_milUsed * _milCoef);
						_data set [2, 0];
						_bailOut = true;

						if (_milUsed > 0) then {
							[["ITD_local_militaryUsed", _milUsed], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;

							[[["ITD_Service","Info_RepairPartialMil"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
						} else {
							[[["ITD_Service","Info_RepairPartsMil"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
						};
					};
				};

				if (_bailOut) exitWith {
					// Not enough parts to finish military repairs, can't continue.
					_vehicle setDamage ((0 max _damage) / 100);
				};

				if (_partsRequired > 0) then {
					if (_data select 1 >= _partsRequired) then {
						// Enough parts for full repair.
						_damage = _damage - (_partsRequired * _partsCoef);
						_data set [1, (_data select 1) - _partsRequired];
						[["ITD_local_partsUsed", _partsRequired], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
					} else {
						// Not enough parts for repair.
						private ["_partsUsed"];
						_partsUsed = _data select 1;
						_damage = _damage - (_partsUsed * _partsCoef);
						_data set [1, 0];
						_bailOut = true;

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

				if (_bailOut) exitWith {};

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

				[["ITD_local_fuelUsed", _fuelRequired], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;

				if (_fuelRequired == 0) exitWith {
					// No fuel required.
				};

				if (_data select 0 >= _fuelRequired) then {
					// Full refuel.
					_data set [0, (_data select 0) - _fuelRequired];
					_vehicle setFuel 1;
					[[["ITD_Service","Info_RefuelFull"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
				} else {
					// Partial refuel.
					private ["_refuel"];
					_refuel = _fuel + ((_data select 0) * 0.05);
					_data set [0, 0];
					_vehicle setFuel _refuel;
					[[["ITD_Service","Info_RefuelPartial"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
				};
		};

		case "strip": {
				private ["_value", "_siphon", "_militaryValue"];

				// Military value of vehicle (turrets * 2)
				_militaryValue = (count ([_vehicle] call ITD_fnc_getRealTurrets)) * 2;

				if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
					_siphon = ceil (((fuel _vehicle) * 100) / 5);
				} else {
					_siphon = ceil (((fuel _vehicle) * 100) / 10);
				};

				if (_militaryValue == 0) then {
					// Air vehicles / tanks are double value.
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
					_milCoef = (40 / _militaryValue);
					_militaryValue = _militaryValue - (ceil (_milDamage / _milCoef));

					if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
						_value = 20 - (ceil (_partsDamage / 3));
					} else {
						_value = 10 - (ceil (_partsDamage / 6));
					};
				};

				// Update variables.
				_data set [0, (_data select 0) + _siphon];
				_data set [1, (_data select 1) + _value];
				_data set [2, (_data select 2) + _militaryValue];

				deleteVehicle _vehicle;
				[["ITD_local_partsUsed", _value], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;

				if (_militaryValue == 0) then {
					if (_siphon > 0) then {
						[["ITD_local_fuelUsed", _siphon], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
						[[["ITD_Service","Info_StripSiphon"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
					} else {
						[[["ITD_Service","Info_Strip"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
					};
				} else {
					if (_siphon > 0) then {
						[["ITD_local_militaryUsed", _militaryValue], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
						[["ITD_local_fuelUsed", _siphon], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
						[[["ITD_Service","Info_StripMilSiphon"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
					} else {
						[["ITD_local_militaryUsed", _militaryValue], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
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
					_vehicle setFuel 0;
					[["ITD_local_fuelUsed", _siphon], "ITD_fnc_setVariable", _player] call BIS_fnc_MP;
					[[["ITD_Service","Info_Siphon"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
				} else {
					[[["ITD_Service","Info_SiphonNone"], 5], "ITD_fnc_advHint", _player] call BIS_fnc_MP;
				};
		};
};

// TODO: Only run this if something has changed.
ITD_global_serviceData set [_id, (DB_CAMPS_SERVICE_DATA)];
publicVariable "ITD_global_serviceData";

nil;
