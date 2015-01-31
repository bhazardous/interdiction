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

// Player and vehicle in position.
_markerName = format ["INT_mkr_servicePoint%1", _id];
if (_player distance (markerPos _markerName) > 10) then {
	// Player not close enough to service point.
	hint "player <--> servicepoint";
};
if (_vehicle distance (markerPos _markerName) > 5) then {
	// Vehicle not close enough to service point.
	hint "vehicle <--> servicepoint";
};
if (_player distance _vehicle > 4) then {
	// Player not close enough to vehicle.
	hint "player <--> vehicle";
};

// Change marker ID into array position.
_id = _id - 1;

// Grab the data for this service point.
// _data = [fuel, parts]
_data = INT_server_servicePointData select _id;

switch (_action) do {
		case "repair": {
				private ["_damage", "_partsRequired"];
				_damage = damage _vehicle;
				_partsRequired = ceil ((_damage * 100) / 5);

				if (_partsRequired == 0) exitWith {
					// No repairs needed.
				};

				if (_data select 1 >= _partsRequired) then {
					// Full repair.
					_data set [1, (_data select 1) - _partsRequired];
					_vehicle setDamage 0;
				} else {
					// Partial repair.
					private ["_repair"];
					_repair = _damage - ((_data select 1) * 0.05);
					_data set [1, 0];
					_vehicle setDamage _repair;
				};

				hint format ["Repaired, new damage value = %1", damage _vehicle];
		};

		case "refuel": {
				private ["_fuel", "_fuelRequired"];
				_fuel = fuel _vehicle;
				_fuelRequired = ceil (((1 - _fuel) * 100) / 5);

				if (_fuelRequired == 0) exitWith {
					// No fuel required.
				};

				if (_data select 0 >= _fuelRequired) then {
					// Full refuel.
					_data set [0, (_data select 0) - _fuelRequired];
					_vehicle setFuel 1;
				} else {
					// Partial refuel.
					private ["_refuel"];
					_refuel = _fuel + ((_data select 0) * 0.05);
					_data set [0, 0];
					_vehicle setFuel _refuel;
				};

				hint format ["Refuelled, new fuel value = %1", fuel _vehicle];
		};

		case "strip": {
				private ["_value"];
				_value = ceil (((1 - (damage _vehicle)) * 100) / 5);
				_data set [1, (_data select 1) + _value];
				deleteVehicle _vehicle;
				hint format ["Stripped for %1 parts", _value];
		};

		case "siphon": {
				private ["_siphon"];
				_value = ceil (((fuel _vehicle) * 100) / 5);
				_data set [0, (_data select 0) + _value];
				_vehicle setFuel 0;
				hint format ["Siphoned %1 fuel", _value];
		};
};

nil;
