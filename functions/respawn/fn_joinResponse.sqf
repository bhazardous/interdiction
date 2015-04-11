scriptName "fn_joinResponse";
/*
	Author: Bhaz

	Description:
	Response sent from server containing a starting vehicle.

	Parameter(s):
	#0 OBJECT - Vehicle
	#1 BOOL - Is driver or cargo

	Returns:
	nil
*/

_vehicle = _this select 0;
_driver = [_this, 1, false, [false]] call BIS_fnc_param;

if (_driver) then {
	player moveInDriver _vehicle;
} else {
	player moveInCargo _vehicle;
};

ITD_local_playerReady = true;

nil;
