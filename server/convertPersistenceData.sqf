scriptName "convertPersistenceData";
/*--------------------------------------------------------------------
	file: convertPersistenceData.sqf
	==================================
	Author: Bhaz <>
	Description: Converts array returned from persistence to usable data.
--------------------------------------------------------------------*/
#define __filename "convertPersistenceData.sqf"

private ["_data", "_newArray"];
_data = _this;
_newArray = [];

{
	if (typeName _x == "ARRAY") then {
		if (count _x == 0) then {
			_newArray pushBack [];
		} else {
			private ["_result"];
			_result = _x call compile preprocessFileLineNumbers "server\convertPersistenceData.sqf";
			_newArray pushBack _result;
		};
	} else {
		_newArray pushBack (call compile _x);
	};
} forEach _data;

_newArray;
