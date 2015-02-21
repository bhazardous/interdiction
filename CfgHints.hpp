/*--------------------------------------------------------------------
	file: CfgHints.hpp
	==================
	Author: Bhaz
	Description: Hints and in-game guide
--------------------------------------------------------------------*/

class CfgHints
{
	class ResistanceMovement
	{
		displayName = "Resistance Movement";
		class Interdiction
		{
			displayName = "Interdiction";
			description = "%3Interdiction%4 is a military term for the act of %3delaying%4, %3disrupting%4, or %3destroying%4 enemy forces or supplies en route to the battle area.%1- Wikipedia";
			tip = "You have arrived at %11 to stop enemy forces pushing closer to your homeland. Disrupt the enemy, take their resources and inspire the local populace to rise up and join the fight.";
			arguments[] = {
				"worldName"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\BasicStances_ca.paa";
			class FieldManual
			{
				displayName = "Field Manual";
				description = "A complete mission guide is available for new players.%1It's accessible by clicking on the %3[Field Manual]%4 option from the %3[Esc.]%4 menu.";
				image = "\a3\ui_f\data\gui\cfg\hints\miss_icon_ca.paa";
			};
		};
		class AmmoCache
		{
			displayName = "Ammo Cache";
			description = "The %3ammo cache%4 is used to store valuable weapons and ammo you've captured from the enemy.";
			tip = "You can place down a cache even without a camp nearby, allowing the resistance to hide equipment throughout %11 for easy access.";
			arguments[] = {
				"worldName"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\ammotype_ca.paa";
		};
		class CombatSupport
		{
			displayName = "Combat Support";
			description = "Later on in the mission, captured vehicles can be brought back to camp and turned into support assets.%1You will need to find a skilled crew to man the vehicle, keep recruiting new resistance members.%1Once a vehicle is manned, it can then be called as combat support or transport using the %3ALiVE Combat Support%4 menu.";
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclecommanding_ca.paa";
			class SupportCrew
			{
				displayName = "Combat Support";
				description = "You now have %3support crew%4 available, drive a vehicle back to a %3recruitment tent%4, then use the %3[Alt + V]%4 menu to add support crew to the vehicle.";
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclecommanding_ca.paa";
			};
			class SupportAvailable
			{
				displayName = "Combat Support";
				description = "Support is now available to the resistance, you can call it by opening the %3ALiVE menu%4 and selecting %3Player Combat Support%4.";
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclecommanding_ca.paa";
			};
			class SupportErrDistance
			{
				displayName = "Combat Support";
				description = "The vehicle needs to be closer to the recruitment tent. (<40 metres)";
			};
			class SupportErrCrew
			{
				displayName = "Vehicle not empty";
				description = "The vehicle needs to be empty before you can add it to support.";
			};
			class SupportErrDead
			{
				displayName = "Crew Casualties";
				description = "The support crew suffered casualities."
			};
			class SupportErrVDead
			{
				displayName = "Vehicle Destroyed";
				description = "The support vehicle was destroyed.";
			};
			class SupportErrNoCrew
			{
				displayName = "No Crew Available";
				description = "The resistance has no support crews available to man the vehicle.";
			};
			class SupportErrNonCombat
			{
				displayName = "Combat Support";
				description = "Cannot create combat support using a non-combat vehicle.";
			};
		};
		class Equipment
		{
			displayName = "Equipment";
			description = "The resistance has no weapon supplies or access to military vehicles, any OPFOR assets left intact are extremely valuable.";
			tip = "Any kind of supply truck (ammo, fuel, repair) should be treated like the holy grail, the ability to maintain your own equipment is a massive advantage.";
			image = "\a3\ui_f\data\gui\cfg\hints\Rifles_ca.paa";
		};
		class GuerrillaWarfare
		{
			displayName = "Guerrilla Warfare";
			description = "Weaken the enemy. Target their personnel, vehicles, equipment and strategic locations.";
			tip = "The enemy will respond to threats, constantly attacking the same location will cause it to be reinforced.";
			image = "\a3\ui_f\data\gui\cfg\hints\Annoucning_ca.paa";
		};
		class RecruitmentTent
		{
			displayName = "Recruitment Tent";
			description = "The %3recruitment tent%4 is where resistance recruits are processed. After making contact with the resistance, new forces will come here to grab a weapon and receive orders.";
			image = "\a3\ui_f\data\gui\cfg\hints\commanding_ca.paa";
		};
		class BuildCamp
		{
			displayName = "Resistance Camp";
			description = "A camp allows the resistance to stay organized; without it, new recruits won't be able to make contact.";
			tip = "Unless you've gathered alot of strength, it's wise to be subtle. The enemy force is much larger than yours; if they discover your camp the resistance will be easily overpowered.";
			image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
			class CampHint
			{
				displayName = "Resistance Camp";
				description = "The resistance needs a camp to survive and stay organized, set up a camp with the mission's menu %3[Ctrl + V]%4.";
				tip = "The enemy can discover your camp, try to keep it out of sight and away from OPFOR locations.";
				image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
			};
			class InvalidPosition
			{
				displayName = "Invalid Position";
				description = "Resistance camps cannot be built in water or on steep terrain.";
			};
			class CampBuilt
			{
				displayName = "Resistance Camp";
				description = "A camp has been established at %3%11%4 by %3%12%4.%1%2You can respawn at this camp.%1%2If the enemy discovers your camp, they may decide to attack.";
				tip = "The camp has been marked on your map.";
				arguments[] = {
					"INT_global_lastCampGrid",
					"INT_global_campBuiltBy"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
			};
			class MultipleCamp
			{
				displayName = "Resistance Camp";
				description = "Another resistance camp has been established at %3%11%4 by %3%12%4.";
				tip = "The new camp has been marked on your map.";
				arguments[] = {
					"INT_global_lastCampGrid",
					"Int_global_campBuiltBy"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
			};
			class BuildInstructions
			{
				displayName = "Building";
				description = "Use %3[C]%4 to place the building, or %3[Ctrl + C]%4 to cancel. You can also cancel by running away.";
				image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
			};
			class UnlockTechOne
			{
				displayName = "Resistance Camp";
				description = "Recent resistance activity has attracted attention from the locals, who want to join the fight. A new %3build option%4 has been unlocked to process these new recruits.%1You can also construct a %3service point%4 to strip vehicles down for parts, and use those parts to repair other vehicles.";
				tip = "You can only build near an existing resistance HQ.";
				image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
			};
			class Distance
			{
				displayName = "Invalid Position";
				description = "This building needs to be placed within a resistance camp.";
			};
			class HQDistance
			{
				displayName = "Invalid Position";
				description = "Resistance camps need to be at least 1.5km apart.";
			};
			class Duplicate
			{
				displayName = "Invalid Position";
				description = "This building has already been constructed at this camp.";
			};
			class FortParts
			{
				displayName = "Fortification";
				description = "Not enough spare parts available to construct this fortification.";
			};
		};
		class ResistanceHQ {
			displayName = "Resistance HQ";
			description = "The %3resistance HQ%4 is the primary camp building. It establishes a resistance camp in the area, allowing you to construct other buildings around it.%1The HQ also acts as a %3respawn point%4 for players.%1%1Once the resistance grows, you will be able to construct multiple camps, these camps need to be at least 1.5km apart.";
			image = "\a3\ui_f\data\gui\cfg\hints\unittype_ca.paa";
		};
		class ServicePoint
		{
			displayName = "Service Point";
			description = "The %3service point%4 is a resistance camp building used to maintain vehicles.%1You can bring any unwanted vehicles you have captured to this point to siphon fuel and strip them down for spare parts.%1You can then %3repair%4 and %3refuel%4 more important resistance assets.";
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			class CheckDamage
			{
				displayName = "Vehicle Repair";
				description = "%11 requires %12 spare parts for a complete repair.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_partsUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class CheckDamageMil
			{
				displayName = "Vehicle Repair";
				description = "%11 requires %12 military parts and %13 spare parts for a complete repair.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_militaryUsed",
					"INT_local_partsUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class NoRepair
			{
				displayName = "Vehicle Repair";
				description = "%11 doesn't require any repairs.";
				arguments[] = {
					"INT_local_serviceType"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class RepairFull
			{
				displayName = "Vehicle Repaired";
				description = "%11 has been repaired using %12 spare parts.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_partsUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class MilRepairFull
			{
				displayName = "Vehicle Repaired";
				description = "%11 has been repaired using %12 spare parts and %13 military parts.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_partsUsed",
					"INT_local_militaryUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class RepairPartial
			{
				displayName = "Vehicle Repaired";
				description = "%11 has been partially repaired using %12 spare parts. The service point has no more parts remaining.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_partsUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class MilRepairPartial
			{
				displayName = "Vehicle Repaired";
				description = "%11 has been partially repaired using %12 military parts, you need more military parts before continuing repairs.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_militaryUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class RepairNone
			{
				displayName = "Vehicle Repair";
				description = "Repairs on %11 cannot be started without spare parts.";
				arguments[] = {
					"INT_local_serviceType"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class MilRepairNone
			{
				displayName = "Vehicle Repair";
				description = "Repairs on %11 cannot be started without military parts.";
				arguments[] = {
					"INT_local_serviceType"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class MilPartRepairPartial
			{
				displayName = "Vehicle Repaired";
				description = "%11 has been partially repaired using %12 military parts and %13 parts, you need more parts to continue repairs.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_militaryUsed",
					"INT_local_partsUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class RefuelFull
			{
				displayName = "Vehicle Refuelled";
				description = "%11 has been refuelled using %12 fuel.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_fuelUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class RefuelPartial
			{
				displayName = "Vehicle Refuelled";
				description = "%11 has been partially refuelled using %12 fuel. The service point is out of fuel.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_fuelUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class Siphoned
			{
				displayName = "Fuel Siphoned";
				description = "%11 fuel has been siphoned from %12.";
				arguments[] = {
					"INT_local_fuelUsed",
					"INT_local_serviceType"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class SiphonNone
			{
				displayName = "Fuel Siphoned";
				description = "No fuel was siphoned from %11, the tank is alread empty.";
				arguments[] = {
					"INT_local_serviceType"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class Stripped
			{
				displayName = "Vehicle Stripped";
				description = "%11 was stripped down for %12 parts.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_partsUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class StripSiphon
			{
				displayName = "Vehicle Stripped";
				description = "%11 was stripped down for %12 parts and %13 fuel.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_partsUsed",
					"INT_local_fuelUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class StrippedMil
			{
				displayName = "Vehicle Stripped";
				description = "%11 was stripped down for %12 parts and %13 military parts.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_partsUsed",
					"INT_local_militaryUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class StripMilSiphon
			{
				displayName = "Vehicle Stripped";
				description = "%11 was stripped down for %12 parts, %14 military parts and %13 fuel.";
				arguments[] = {
					"INT_local_serviceType",
					"INT_local_partsUsed",
					"INT_local_fuelUsed",
					"INT_local_militaryUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
			class SPDistPlayer
			{
				displayName = "Service Point";
				description = "You are not close enough to the service point.";
			};
			class SPDistVehicle
			{
				displayName = "Service Point";
				description = "The vehicle is not close enough to the service point.";
			};
			class SPDistVehicleP
			{
				displayName = "Service Point";
				description = "You are not close enough to the vehicle.";
			};
			class SPStock
			{
				displayName = "Service Point";
				description = "%3Fuel%4: %11%1%3Spare parts%4: %12%1%3Military parts%4: %13";
				arguments[] = {
					"INT_local_fuelUsed",
					"INT_local_partsUsed",
					"INT_local_militaryUsed"
				};
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
			};
		};
	};
};
