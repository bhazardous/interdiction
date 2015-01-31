scriptName "fn_buildingLookup";
/*
	Author: Bhaz

	Description:
	Matches building types to classnames.

	Parameter(s):
	#0 STRING - Building type

	Returns:
	ARRAY
		#0 STRING - Classname of object
		#1 NUMBER - Distance to use with building functions
*/

private ["_type", "_class", "_distance"];
_type = [_this, 0, "", [""]] call BIS_fnc_param;

// Vanilla objects.
_class = switch (_type) do {
	case "hq": {
		_distance = 2.5;
		"Land_TentDome_F"
	};
	case "service": {
		_distance = 2.5;
		"Land_TentDome_F"
	};
	default {
		_distance = 0;
		""
	};
};

[_class, _distance];
