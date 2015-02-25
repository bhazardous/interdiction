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
// TODO: Lots of code duplication in this file.
// TODO: Also messy as fuck.

private ["_player", "_action", "_id", "_pos", "_vehicle", "_data"];
_player = _this select 0;
_action = _this select 1;
_vehicle = _this select 2;
_id = ([_player, "INT_mkr_resistanceCamp", count INT_global_camps] call INT_fnc_closest) - 1;

if (_action == "check") exitWith {
	private ["_fuel", "_parts", "_military"];
	_fuel = INT_server_servicePointData select _id select 0;
	_parts = INT_server_servicePointData select _id select 1;
	_military = INT_server_servicePointData select _id select 2;
	[["INT_local_partsUsed", _parts], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
	[["INT_local_fuelUsed", _fuel], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
	[["INT_local_militaryUsed", _military], "INT_fnc_setVariable", _player] call BIS_fnc_MP;

	[["ResistanceMovement","ServicePoint","SPStock"],true,true,false,_player,true] call INT_fnc_broadcastHint;
};

if (_action == "assess") exitWith {
	private ["_damage", "_partsRequired", "_milRequired", "_militaryValue", "_partsDamage", "_milDamage"];

	_damage = damage _vehicle * 100;
	_militaryValue = (count ([_vehicle] call INT_fnc_getRealTurrets)) * 2;

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

	[["INT_local_partsUsed", _partsRequired], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
	if (_milRequired > 0) then {
		[["INT_local_militaryUsed", _milRequired], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
		[["ResistanceMovement","ServicePoint","CheckDamageMil"],true,true,false,_player,true] call INT_fnc_broadcastHint;
	} else {
		if (_partsRequired > 0) then {
			[["ResistanceMovement","ServicePoint","CheckDamage"],true,true,false,_player,true] call INT_fnc_broadcastHint;
		} else {
			[["ResistanceMovement","ServicePoint","NoRepair"],true,true,false,_player,true] call INT_fnc_broadcastHint;
		};
	};
};

// Player and vehicle in position.
_pos = INT_server_campData select _id select 2 select 0;
if (_player distance _pos > 10) exitWith {
	// Player not close enough to service point.
	[["ResistanceMovement","ServicePoint","SPDistPlayer"],true,true,false,_player,true] call INT_fnc_broadcastHint;
	nil;
};
if (_vehicle distance _pos > 10) exitWith {
	// Vehicle not close enough to service point.
	[["ResistanceMovement","ServicePoint","SPDistVehicle"],true,true,false,_player,true] call INT_fnc_broadcastHint;
	nil;
};
if (_player distance _vehicle > 6) exitWith {
	// Player not close enough to vehicle.
	[["ResistanceMovement","ServicePoint","SPDistVehicleP"],true,true,false,_player,true] call INT_fnc_broadcastHint;
	nil;
};

// Grab the data for this service point.
// _data = [fuel, parts]
_data = INT_server_servicePointData select _id;

// Player animation.
[[_player, "AinvPknlMstpSnonWnonDr_medicUp1"], "INT_fnc_playAnimation", _player] call BIS_fnc_MP;
sleep 5;

// Repair and refuel actions.
switch (_action) do {
		case "repair": {
				private ["_damage", "_militaryValue", "_partsRequired", "_milRequired",
					"_partsCoef", "_milCoef"];

				_damage = damage _vehicle * 100;
				_militaryValue = (count ([_vehicle] call INT_fnc_getRealTurrets)) * 2;

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
						[["INT_local_militaryUsed", _milRequired], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
					} else {
						// Not enough milparts for repair, perform partial then exit.
						private ["_milUsed"];
						_milUsed = _data select 2;
						_damage = _damage - (_milUsed * _milCoef);
						_data set [2, 0];
						_bailOut = true;

						if (_milUsed > 0) then {
							[["INT_local_militaryUsed", _milUsed], "INT_fnc_setVariable", _player] call BIS_fnc_MP;

							[["ResistanceMovement","ServicePoint","MilRepairPartial"],true,true,false,_player,true] call INT_fnc_broadcastHint;
						} else {
							[["ResistanceMovement","ServicePoint","MilRepairNone"],true,true,false,_player,true] call INT_fnc_broadcastHint;
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
						[["INT_local_partsUsed", _partsRequired], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
					} else {
						// Not enough parts for repair.
						private ["_partsUsed"];
						_partsUsed = _data select 1;
						_damage = _damage - (_partsUsed * _partsCoef);
						_data set [1, 0];
						_bailOut = true;

						if (_milRequired > 0 || {_partsUsed > 0}) then {
							[["INT_local_partsUsed", _partsUsed], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
						};

						if (_milRequired > 0) then {
							[["ResistanceMovement","ServicePoint","MilPartRepairPartial"],true,true,false,_player,true] call INT_fnc_broadcastHint;
						} else {
							if (_partsUsed > 0) then {
								[["ResistanceMovement","ServicePoint","RepairPartial"],true,true,false,_player,true] call INT_fnc_broadcastHint;
							} else {
								[["ResistanceMovement","ServicePoint","RepairNone"],true,true,false,_player,true] call INT_fnc_broadcastHint;
							};
						};
					};
				};

				_vehicle setDamage ((0 max _damage) / 100);

				if (_bailOut) exitWith {};

				if (_milRequired > 0) then {
					[["ResistanceMovement","ServicePoint","MilRepairFull"],true,true,false,_player,true] call INT_fnc_broadcastHint;
				} else {
					[["ResistanceMovement","ServicePoint","RepairFull"],true,true,false,_player,true] call INT_fnc_broadcastHint;
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

				[["INT_local_fuelUsed", _fuelRequired], "INT_fnc_setVariable", _player] call BIS_fnc_MP;

				if (_fuelRequired == 0) exitWith {
					// No fuel required.
				};

				if (_data select 0 >= _fuelRequired) then {
					// Full refuel.
					_data set [0, (_data select 0) - _fuelRequired];
					_vehicle setFuel 1;
					[["ResistanceMovement","ServicePoint","RefuelFull"],true,true,false,_player,true] call INT_fnc_broadcastHint;
				} else {
					// Partial refuel.
					private ["_refuel"];
					_refuel = _fuel + ((_data select 0) * 0.05);
					_data set [0, 0];
					_vehicle setFuel _refuel;
					[["ResistanceMovement","ServicePoint","RefuelPartial"],true,true,false,_player,true] call INT_fnc_broadcastHint;
				};
		};

		case "strip": {
				private ["_value", "_siphon", "_militaryValue"];

				// Military value of vehicle (turrets * 2)
				_militaryValue = (count ([_vehicle] call INT_fnc_getRealTurrets)) * 2;

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
				[["INT_local_partsUsed", _value], "INT_fnc_setVariable", _player] call BIS_fnc_MP;

				if (_militaryValue == 0) then {
					if (_siphon > 0) then {
						[["INT_local_fuelUsed", _siphon], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
						[["ResistanceMovement","ServicePoint","StripSiphon"],true,true,false,_player,true] call INT_fnc_broadcastHint;
					} else {
						[["ResistanceMovement","ServicePoint","Stripped"],true,true,false,_player,true] call INT_fnc_broadcastHint;
					};
				} else {
					if (_siphon > 0) then {
						[["INT_local_militaryUsed", _militaryValue], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
						[["INT_local_fuelUsed", _siphon], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
						[["ResistanceMovement","ServicePoint","StripMilSiphon"],true,true,false,_player,true] call INT_fnc_broadcastHint;
					} else {
						[["INT_local_militaryUsed", _militaryValue], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
						[["ResistanceMovement","ServicePoint","StrippedMil"],true,true,false,_player,true] call INT_fnc_broadcastHint;
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
					[["INT_local_fuelUsed", _siphon], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
					[["ResistanceMovement","ServicePoint","Siphoned"],true,true,false,_player,true] call INT_fnc_broadcastHint;
				} else {
					[["ResistanceMovement","ServicePoint","SiphonNone"],true,true,false,_player,true] call INT_fnc_broadcastHint;
				};
		};
};

nil;
