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
ITD_local_playerWeapons = weapons _unit;
ITD_local_playerAmmo = magazinesAmmoFull _unit;
ITD_local_playerWeaponItems = primaryWeaponItems _unit;
ITD_local_playerSecWeaponItems = secondaryWeaponItems _unit;
ITD_local_playerHandgunItems = handgunItems _unit;

// Get all muzzles (grenade launcher attachments etc.)
ITD_local_playerMuzzles = [];
{
    private ["_muzzles"];
    _muzzles = getArray (configFile >> "cfgWeapons" >> _x >> "muzzles");
    {
        if (_x != "this") then {
            ITD_local_playerMuzzles pushBack _x;
        };
    } forEach _muzzles;
} forEach ITD_local_playerWeapons;

// Uniform / gear.
ITD_local_playerItems = assignedItems _unit;
ITD_local_playerUniform = uniform _unit;
ITD_local_playerUniformItems = uniformItems _unit;
ITD_local_playerVest = vest _unit;
ITD_local_playerVestItems = vestItems _unit;
ITD_local_playerBackpack = backpack _unit;
ITD_local_playerBackpackItems = backpackItems _unit;
ITD_local_playerHeadgear = headgear _unit;
ITD_local_playerGoggles = goggles _unit;

nil;
