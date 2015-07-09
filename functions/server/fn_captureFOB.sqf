scriptName "fn_captureFOB";
/*
	Author: Bhaz

	Description:
	Script triggered by capture, loss and destruction of an FOB.

	Parameter(s):
	#0 BOOL or STRING - true (captured), false (lost), "destroyed"
	#1 NUMBER - FOB objective ID
	#2 ARRAY - If captured, add this respawn position

	Returns:
	nil
*/

// TODO: Use objective name instead of unique ID, remove ID's completely

private ["_captured", "_id", "_position", "_varName", "_spawnId"];
_captured = _this select 0;
_id = _this select 1;
_position = [_this, 2, [], [[]]] call BIS_fnc_param;

if (count _position == 2) then {_position pushBack 0};
_varName = format ["ITD_server_fobSpawn%1", _id];
_spawnId = missionNamespace getVariable _varName;

if (typeName _captured == "STRING") then {
	// FOB destroyed.
	if (!isNil _varName) then {
		[missionNamespace, _spawnId] call BIS_fnc_removeRespawnPosition;
	};
} else {
	if (_captured) then {
		// FOB captured.
		_spawnId = [missionNamespace, _position] call BIS_fnc_addRespawnPosition;
		missionNamespace setVariable [_varName, _spawnId];
	} else {
		if (!isNil _varName) then {
			[missionNamespace, _spawnId] call BIS_fnc_removeRespawnPosition;
		};
	};
};

nil;
