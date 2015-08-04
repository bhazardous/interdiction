scriptName "fn_setGear";
/*
	Author: Bhaz

	Description:
	Uses the variables from ITD_fnc_storeGear to restore gear.

	Parameter(s):
	#0 OBJECT - Unit

    Example:
    n/a

	Returns:
	Nothing
*/

// Check: Not currently being used.

if (isNil "ITD_local_playerWeapons") exitWith {nil;};
params ["_unit"];

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;
removeUniform _unit;
removeVest _unit;

_unit addUniform ITD_local_playerUniform;
_unit addVest ITD_local_playerVest;

// Largest backpack in the game.
// Temporary, otherwise ammo like AA rounds are too large for vest and won't add.
_unit addBackpack "B_Carryall_ocamo";
clearAllItemsFromBackpack _unit;

// Add magazines that were loaded first.
private ["_playerAmmo"];
_playerAmmo = ITD_local_playerAmmo;
{
    // If magazine is loaded.
    if (_x select 2) then {
        // If magazine type is an actual weapon (not a grenade).
        if (_x select 4 in ITD_local_playerWeapons || {_x select 4 in ITD_local_playerMuzzles}) then {
            // Add the loaded mag.
            _unit addMagazine [_x select 0, _x select 1];

            // Wipe this mag from the array.
            _playerAmmo = _playerAmmo - [_x];
        };
    };
} forEach _playerAmmo;

{_unit addWeapon _x} forEach ITD_local_playerWeapons;

removeAllPrimaryWeaponItems _unit;
removeAllHandgunItems _unit;
{_unit addPrimaryWeaponItem _x} forEach ITD_local_playerWeaponItems;
{_unit addSecondaryWeaponItem _x} forEach ITD_local_playerSecWeaponItems;
{_unit addHandgunItem _x} forEach ITD_local_playerHandgunItems;

removeBackpack _unit;
_unit addBackpack ITD_local_playerBackpack;
clearAllItemsFromBackpack _unit;

// Get remaining magazines.
private ["_backpackMags", "_otherMags"];
_backpackMags = [];
_otherMags = [];
{
    if (_x select 4 == "Backpack") then {
        _backpackMags pushBack [_x select 0, _x select 1];
    } else {
        _otherMags pushBack [_x select 0, _x select 1];
    };

    // Remove the magazine type from cargo arrays.
    ITD_local_playerUniformItems = ITD_local_playerUniformItems - [_x select 0];
    ITD_local_playerVestItems = ITD_local_playerVestItems - [_x select 0];
    ITD_local_playerBackpackItems = ITD_local_playerBackpackItems - [_x select 0];
} forEach _playerAmmo;

// What we're left with now are arrays full of items.
// These need to be added first, or the uniform might fill with magazines and block them.
{_unit addItemToUniform _x} forEach ITD_local_playerUniformItems;
{_unit addItemToVest _x} forEach ITD_local_playerVestItems;
{_unit addItemToBackpack _x} forEach ITD_local_playerBackpackItems;

// Now add the magazines.
{_unit addMagazine [_x select 0, _x select 1];} forEach _otherMags;
{(unitBackpack _unit) addMagazineAmmoCargo [_x select 0, 1, _x select 1];} forEach _backpackMags;

// Items, headgear, goggles.
{_unit addItem _x; _unit assignItem _x;} forEach ITD_local_playerItems;
_unit addHeadgear ITD_local_playerHeadgear;
_unit addGoggles ITD_local_playerGoggles;
