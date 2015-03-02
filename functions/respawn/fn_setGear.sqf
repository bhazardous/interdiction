scriptName "fn_setGear";
/*
	Author: Bhaz

	Description:
	Uses the variables from INT_fnc_storeGear to restore gear.

	Parameter(s):
	#0 OBJECT - Unit

	Returns:
	nil
*/

if (isNil "INT_local_playerWeapons") exitWith {nil;};

_unit = _this select 0;

// Remove everything.
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;
removeUniform _unit;
removeVest _unit;

// Vest / uniform.
_unit addUniform INT_local_playerUniform;
_unit addVest INT_local_playerVest;

// Largest backpack in the game.
// (Temporary, otherwise ammo like AA rounds are too large for vest and won't add.)
_unit addBackpack "B_Carryall_ocamo";
clearAllItemsFromBackpack _unit;

// Add magazines that were loaded first.
private ["_playerAmmo"];

_playerAmmo = INT_local_playerAmmo;
{
    // If magazine is loaded.
    if (_x select 2) then {
        // If magazine type is an actual weapon (not a grenade).
        if (_x select 4 in INT_local_playerWeapons || {_x select 4 in INT_local_playerMuzzles}) then {
            // Add the loaded mag.
            _unit addMagazine [_x select 0, _x select 1];

            // Wipe this mag from the array.
            _playerAmmo = _playerAmmo - [_x];
        };
    };
} forEach _playerAmmo;

// Add weapons.
{_unit addWeapon _x} forEach INT_local_playerWeapons;

// Weapon attachments.
removeAllPrimaryWeaponItems _unit;
removeAllHandgunItems _unit;
{_unit addPrimaryWeaponItem _x} forEach INT_local_playerWeaponItems;
{_unit addSecondaryWeaponItem _x} forEach INT_local_playerSecWeaponItems;
{_unit addHandgunItem _x} forEach INT_local_playerHandgunItems;

// Backpack.
removeBackpack _unit;
_unit addBackpack INT_local_playerBackpack;
clearAllItemsFromBackpack _unit;

// Get remaining magazines.
private ["_backpackMags", "_otherMags"];
_backpackMags = [];
_otherMags = [];
{
    if (_x select 4 == "Backpack") then {
        _backpackMags pushBack [_x select 0, _x select 1];
    } else {
        // TODO: impossible to add partial mags directly to vest / uniform?
        _otherMags pushBack [_x select 0, _x select 1];
    };

    // Remove the magazine type from cargo arrays.
    INT_local_playerUniformItems = INT_local_playerUniformItems - [_x select 0];
    INT_local_playerVestItems = INT_local_playerVestItems - [_x select 0];
    INT_local_playerBackpackItems = INT_local_playerBackpackItems - [_x select 0];
} forEach _playerAmmo;

// What we're left with now are arrays full of items.
// These need to be added first, or the uniform might fill with magazines and block them.
{_unit addItemToUniform _x} forEach INT_local_playerUniformItems;
{_unit addItemToVest _x} forEach INT_local_playerVestItems;
{_unit addItemToBackpack _x} forEach INT_local_playerBackpackItems;

// Now add the magazines.
{_unit addMagazine [_x select 0, _x select 1];} forEach _otherMags;
{(unitBackpack _unit) addMagazineAmmoCargo [_x select 0, 1, _x select 1];} forEach _backpackMags;

// Items, headgear, goggles.
{_unit addItem _x; _unit assignItem _x;} forEach INT_local_playerItems;
_unit addHeadgear INT_local_playerHeadgear;
_unit addGoggles INT_local_playerGoggles;

nil;
