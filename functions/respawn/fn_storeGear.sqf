scriptName "fn_storeGear";
/*
	Author: Bhaz

	Description:
	Stores a copy of all gear to local variables.

	Parameter(s):
	#0 OBJECT - Unit

	Returns:
	nil
*/

_unit = _this select 0;

// Weapons and ammo.
INT_local_playerWeapons = weapons _unit;
INT_local_playerAmmo = magazinesAmmoFull _unit;
INT_local_playerWeaponItems = primaryWeaponItems _unit;
INT_local_playerSecWeaponItems = secondaryWeaponItems _unit;
INT_local_playerHandgunItems = handgunItems _unit;

// Get all muzzles (grenade launcher attachments etc.)
INT_local_playerMuzzles = [];
{
    private ["_muzzles"];
    _muzzles = getArray (configFile >> "cfgWeapons" >> _x >> "muzzles");
    {
        if (_x != "this") then {
            INT_local_playerMuzzles pushBack _x;
        };
    } forEach _muzzles;
} forEach INT_local_playerWeapons;

// Uniform / gear.
INT_local_playerItems = assignedItems _unit;
INT_local_playerUniform = uniform _unit;
INT_local_playerUniformItems = uniformItems _unit;
INT_local_playerVest = vest _unit;
INT_local_playerVestItems = vestItems _unit;
INT_local_playerBackpack = backpack _unit;
INT_local_playerBackpackItems = backpackItems _unit;
INT_local_playerHeadgear = headgear _unit;
INT_local_playerGoggles = goggles _unit;

nil;
