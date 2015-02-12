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

private ["_player", "_action", "_id", "_vehicle", "_markerName", "_data"];
_player = _this select 0;
_action = _this select 1;
_id = _this select 2;
_vehicle = _this select 3;

if (_action == "check") exitWith {
	private ["_fuel", "_parts", "_military"];
	_fuel = (INT_server_servicePointData select (_id - 1)) select 0;
	_parts = (INT_server_servicePointData select (_id - 1)) select 1;
	_military = (INT_server_servicePointData select (_id - 1)) select 2;
	[["INT_local_partsUsed", _parts], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
	[["INT_local_fuelUsed", _fuel], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
	[["INT_local_militaryUsed", _military], "INT_fnc_setVariable", _player] call BIS_fnc_MP;

	[["ResistanceMovement","ServicePoint","SPStock"],true,true,false,_player,true] call INT_fnc_broadcastHint;
};

// Player and vehicle in position.
_markerName = format ["INT_mkr_servicePoint%1", _id];
if (_player distance (markerPos _markerName) > 10) exitWith {
	// Player not close enough to service point.
	[["ResistanceMovement","ServicePoint","SPDistPlayer"],true,true,false,_player,true] call INT_fnc_broadcastHint;
	nil;
};
if (_vehicle distance (markerPos _markerName) > 10) exitWith {
	// Vehicle not close enough to service point.
	[["ResistanceMovement","ServicePoint","SPDistVehicle"],true,true,false,_player,true] call INT_fnc_broadcastHint;
	nil;
};
if (_player distance _vehicle > 6) exitWith {
	// Player not close enough to vehicle.
	[["ResistanceMovement","ServicePoint","SPDistVehicleP"],true,true,false,_player,true] call INT_fnc_broadcastHint;
	nil;
};

// Change marker ID into array position.
_id = _id - 1;

// Grab the data for this service point.
// _data = [fuel, parts]
_data = INT_server_servicePointData select _id;

// Player animation.
[[_player, "AinvPknlMstpSnonWnonDr_medicUp1"], "INT_fnc_playAnimation", _player] call BIS_fnc_MP;
sleep 5;

// Repair and refuel actions.
switch (_action) do {
		case "repair": {
				private ["_damage", "_partsRequired"];
				_damage = damage _vehicle;
				_partsRequired = ceil ((_damage * 100) / 5);
				[["INT_local_partsUsed", _partsRequired], "INT_fnc_setVariable", _player] call BIS_fnc_MP;

				if (_partsRequired == 0) exitWith {
					// No repairs needed.
				};

				if (_data select 1 >= _partsRequired) then {
					// Full repair.
					_data set [1, (_data select 1) - _partsRequired];
					_vehicle setDamage 0;
					[["ResistanceMovement","ServicePoint","RepairFull"],true,true,false,_player,true] call INT_fnc_broadcastHint;
				} else {
					// Partial repair.
					private ["_repair"];
					_repair = _damage - ((_data select 1) * 0.05);
					_data set [1, 0];
					_vehicle setDamage _repair;
					[["ResistanceMovement","ServicePoint","RepairPartial"],true,true,false,_player,true] call INT_fnc_broadcastHint;
				};
		};

		case "refuel": {
				private ["_fuel", "_fuelRequired"];
				_fuel = fuel _vehicle;
				_fuelRequired = ceil (((1 - _fuel) * 100) / 5);
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

				// Air vehicles / tanks are double value.
				if (_vehicle isKindOf "Air" || {_vehicle isKindOf "Tank"}) then {
					_value = ceil (((1 - (damage _vehicle)) * 100) / 5);
					_siphon = ceil (((fuel _vehicle) * 100) / 5);
				} else {
					_value = ceil (((1 - (damage _vehicle)) * 100) / 10);
					_siphon = ceil (((fuel _vehicle) * 100) / 10);
				};

				// Military value of vehicle (turrets * 2)
				_militaryValue = (count ([_vehicle] call INT_fnc_getRealTurrets)) * 2;

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
				_siphon = ceil (((fuel _vehicle) * 100) / 5);
				_data set [0, (_data select 0) + _siphon];
				_vehicle setFuel 0;
				[["INT_local_fuelUsed", _siphon], "INT_fnc_setVariable", _player] call BIS_fnc_MP;
				[["ResistanceMovement","ServicePoint","Siphoned"],true,true,false,_player,true] call INT_fnc_broadcastHint;
		};
};

nil;
