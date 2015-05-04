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

player setCaptive false;
player enableSimulation true;
player hideObject false;
ITD_local_stopSpectating = true;

if (_driver) then {
	player moveInDriver _vehicle;
} else {
	player moveInCargo _vehicle;
};

2 fadeSound 1;
2 fadeMusic 1;
2 fadeRadio 1;

["respawning"] call BIS_fnc_blackIn;

nil;
