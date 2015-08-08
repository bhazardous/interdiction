scriptName "fn_captureFOB";
/*
	Author: Bhaz

	Description:
	Script triggered by capture, loss and destruction of an FOB.

	Parameter(s):
	#0 BOOL or STRING - true (captured), false (lost), "destroyed"
	#1 NUMBER - FOB objective ID
	#2 ARRAY - If captured, add this respawn position

	Example:
	n/a

	Returns:
	Nothing
*/

// TODO: Use objective name instead of unique ID, remove ID's completely

if (!params [["_captured", false, [true]], ["_id", 0, [0]]]) exitWith {
	["Invalid params"] call BIS_fnc_error;
};

private ["_position", "_varName", "_spawnId"];
_position = param [2, [], [[]]];
_varName = format ["ITD_server_fobSpawn%1", _id];
_spawnId = missionNamespace getVariable _varName;

if (count _position == 2) then {_position pushBack 0};
if (typeName _captured == "STRING") then {_captured = false};

if (_captured) then {
	_spawnId = [missionNamespace, _position] call BIS_fnc_addRespawnPosition;
	missionNamespace setVariable [_varName, _spawnId];
} else {
	if (!isNil _varName) then {
		[missionNamespace, _spawnId] call BIS_fnc_removeRespawnPosition;
	};
};
