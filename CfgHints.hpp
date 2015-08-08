/*--------------------------------------------------------------------
	file: CfgHints.hpp
	==================
	Author: Bhaz
	Description: Hints, popups, errors and in-game guide.
--------------------------------------------------------------------*/

class CfgHints
{
	class ITD_Guide
	{
		class Interdiction
		{
			displayName = "--- Interdiction";
			description = "%3Interdiction%4 is a military term for the act of %3delaying%4, %3disrupting%4, or %3destroying%4 enemy forces or supplies en route to the battle area.%1- Wikipedia";
			tip = "You have arrived at %11 to stop enemy forces pushing closer to your homeland. Disrupt the enemy, exploit their resources and inspire the local populace to rise up and join the fight.";
			arguments[] = {
				"worldName"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\BasicStances_ca.paa";
		};
		class AmmoCache
		{
			displayName = "Ammo Cache";
			description = "%3Not yet implemented%4%1The %3ammo cache%4 is used to store valuable weapons and ammo you've captured from the enemy.";
			tip = "You can place down a cache even without a camp nearby, allowing the resistance to hide equipment throughout %11 for easy access.";
			arguments[] = {
				"worldName"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\ammotype_ca.paa";
		};
		class CombatSupport
		{
			displayName = "Combat Support";
			description = "As your forces grow, captured vehicles can be brought back to camp and turned into support assets; This can be done at the %3recruitment tent%4.%1You will need to find a skilled crew to man the vehicle, keep recruiting new resistance members.%1Once a vehicle is manned, it can then be called as combat support or transport using the %3ALiVE Combat Support%4 menu.";
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclecommanding_ca.paa";
			class Info_Crew
			{
				displayName = "Combat Support";
				description = "You now have %3support crew%4 available, drive a vehicle back to a %3recruitment tent%4, then use the %3[Ctrl + V]%4 menu to add support crew to the vehicle.";
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclecommanding_ca.paa";
			};
			class Info_Available
			{
				displayName = "Combat Support";
				description = "Support is now available to the resistance, you can call it by opening the %3ALiVE menu%4 and selecting %3Player Combat Support%4.";
				image = "\a3\ui_f\data\gui\cfg\hints\vehiclecommanding_ca.paa";
			};
		};
		class Equipment
		{
			displayName = "Equipment";
			description = "The resistance has no advanced weapon supplies or access to military vehicles, any OPFOR assets left intact are extremely valuable.";
			tip = "Utility trucks are extremely valuable, giving you the resources to maintain your own equipment.";
			image = "\a3\ui_f\data\gui\cfg\hints\Rifles_ca.paa";
		};
		class Fortifications
		{
			displayName = "Fortifications";
			description = "You can build fortifications using spare parts from the %3service point%4.%1After being placed, you can use the logistics system included with ALiVE to reposition or transport them to another location.";
			image = "\a3\ui_f\data\gui\cfg\hints\steppingover_ca.paa";
		};
		class GuerrillaWarfare
		{
			displayName = "Guerrilla Warfare";
			description = "Weaken the enemy. Target their personnel, vehicles, equipment and strategic locations.";
			tip = "The enemy will respond to threats, constantly attacking the same location will cause it to be reinforced.";
			image = "\a3\ui_f\data\gui\cfg\hints\Annoucning_ca.paa";
		};
		class Persistence
		{
			displayName = "Persistence";
			description = "This mission is compatible with %3ALiVE persistence%4, the camps you've constructed and resources gathered will be saved along with your progress.%1Persistence will only function on a dedicated server, regardless of your settings.";
			tip = "If your %3War Room%4 server profile or server side settings are incorrect, the mission will most likely fail to start.%1Please test your persistence settings with a simple mission if you're not sure.";
			image = "\a3\ui_f\data\gui\cfg\hints\tactical_view_ca.paa";
		};
		class RadarStations
		{
			displayName = "Radar Stations";
			description = "OPFOR radar stations are equipped with the ability to track the locations of their own forces. Capturing a radar station will give you %3map-wide intel%4 on the movements of all OPFOR troops.";
			image = "\a3\ui_f\data\gui\cfg\hints\radar_ca.paa";
		};
		class RadioTowers
		{
			displayName = "Radio Towers";
			description = "The resistance has little in terms of communication equipment, securing radio towers from the enemy will allow longer range communication between resistance squad leaders.%1Nearby resistance squads will report their position and will be marked on the map.";
			tip = "Capturing several radio towers has a stacking effect, and will increase the radius of intel available to you.";
			image = "\a3\ui_f\data\gui\cfg\hints\callsupport_ca.paa";
		};
		class Recruitment
		{
			displayName = "Recruitment";
			description = "Civilians that live in the area are oppressed by the powerful OPFOR regime. To recruit members into the resistance, the populace needs convincing that victory is achievable.%1In general, carrying out successful resistance operations will spread the word, and new recruits will begin making contact with HQ.";
			tip = "Resistance activity in large urban areas (capital cities, larger towns) will have a much greater effect.";
			image = "\a3\ui_f\data\gui\cfg\hints\commanding_ca.paa";
		};
		class RecruitmentTent
		{
			displayName = "Recruitment Tent";
			description = "The %3recruitment tent%4 is where resistance recruits are processed. After making contact with the resistance, new forces will come here to grab a weapon and receive orders.%1You can put in a request for reinforcements here, units will be sent to your position when available.";
			image = "\a3\ui_f\data\gui\cfg\hints\commanding_ca.paa";
		};
		class ResistanceCamp
		{
			displayName = "Resistance Camp";
			description = "A camp allows the resistance to stay organized; without it, new recruits won't be able to make contact.%1The camp comes with an empty ammo crate to store spare equipment.";
			tip = "Until you've gathered a larger force, it's wise to be subtle. The enemy force is initially much larger than yours, if they discover your camp the resistance will be easily overpowered.";
			image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
			class Info_Camp
			{
				displayName = "Resistance Camp";
				description = "The resistance needs a camp to survive and stay organized, set up a camp with the mission's menu %3[Ctrl + V]%4.";
				tip = "The enemy can discover your camp, try to keep it out of sight and away from OPFOR locations.";
				image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
			};
		};
		class ResistanceHQ
		{
			displayName = "Resistance HQ";
			description = "The %3resistance HQ%4 is the primary camp building. It establishes a resistance camp in the area, allowing you to construct other buildings around it.%1The HQ also acts as a %3respawn point%4 for players.%1%1Once the resistance grows, you will be able to construct multiple camps, these camps need to be at least 1.5km apart.";
			image = "\a3\ui_f\data\gui\cfg\hints\unittype_ca.paa";
		};
		class ServicePoint
		{
			displayName = "Service Point";
			description = "The %3service point%4 is a resistance camp building used to maintain vehicles.%1You can bring any unwanted vehicles you have captured to this point to siphon fuel and strip them down for spare parts. You can then %3repair%4 and %3refuel%4 more important resistance assets.%1Aircraft and armoured vehicles can be stripped for more parts, but take more resources to maintain. Vehicles with weaponry can be stripped for military parts, which may be required to repair more valuable vehicles.%1Spare parts can also be used to construct %3fortifications%4.";
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
	};

	class ITD_Hints
	{
		class Info_FieldManual
		{
			displayName = "Field Manual";
			description = "A complete mission guide is available for new players.%1It's accessible by clicking on the %3[Field Manual]%4 option from the %3[Esc.]%4 menu.";
			image = "\a3\ui_f\data\gui\cfg\hints\miss_icon_ca.paa";
		};
		class Info_Building
		{
			displayName = "Building";
			description = "Use %3[C]%4 to place the building, or %3[Ctrl + C]%4 to cancel. You can also cancel by running away.";
			image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
		};
		class Info_Unlock
		{
			displayName = "Resistance Camp";
			description = "Recent resistance activity has attracted attention from the locals, who want to join the fight. A new %3build option%4 has been unlocked to process these new recruits.%1You can also construct a %3service point%4 to strip vehicles down for parts, and use those parts to repair other vehicles.";
			tip = "You can only build near an existing resistance HQ.";
			image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
		};
	}

	class ITD_CombatSupport
	{
		class Error_Distance
		{
			displayName = "Combat Support";
			description = "The vehicle needs to within 40m of the recruitment tent.";
		};
		class Error_NotEmpty
		{
			displayName = "Vehicle not empty";
			description = "The vehicle you want to assign as support needs to be empty.";
		};
		class Error_Dead
		{
			displayName = "Crew Casualties";
			description = "The support crew suffered casualities en route to their vehicle.";
		};
		class Error_Destroyed
		{
			displayName = "Vehicle Destroyed";
			description = "The assigned support vehicle was destroyed.";
		};
		class Error_NoCrew
		{
			displayName = "Crew Unavailable";
			description = "The resistance has no support crews available to man the vehicle.";
		};
		class Error_NonCombat
		{
			displayName = "Unarmed Vehicle";
			description = "You cannot create combat support using a non-combat vehicle.";
		};
	};

	class ITD_Persistence
	{
		class Info_Resumed
		{
			displayName = "Mission Resumed";
			description = "Your progress has been restored from the %3ALiVE War Room%4.%1If there are any mission specific errors or bugs with your save, please report them in the Interdiction thread.";
			image = "\a3\ui_f\data\gui\cfg\hints\tactical_view_ca.paa";
		};
		class Error_Load
		{
			displayName = "Error Loading";
			description = "There were problems with loading this mission from the %3War Room DB%4.%1If this is a new game, make sure you aren't sharing a mission .pbo name from one of your previous ALiVE ops.";
			image = "\a3\ui_f\data\gui\cfg\hints\tactical_view_ca.paa";
		};
		class Error_Version
		{
			displayName = "Error Loading";
			description = "The Interdiction save loaded from the %3War Room DB%4 was created with a newer version of Interdiction, please update the mission .pbo on the dedicated server.";
			image = "\a3\ui_f\data\gui\cfg\hints\tactical_view_ca.paa";
		};
		class Error_Setup
		{
			displayName = "Database Connection";
			description = "Your server failed to authenticate with the %3War Room DB%4.%1Please ensure your server is correctly setup.%1It's recommended to test your server's DB connection with a smaller mission.";
			image = "\a3\ui_f\data\gui\cfg\hints\tactical_view_ca.paa";
		};
	};

	class ITD_Recruitment
	{
		class Error_Queue
		{
			displayName = "Reinforcements";
			description = "You already have an active request for reinforcements.";
		};
	};

	class ITD_Camp
	{
		class Info_Built
		{
			displayName = "Resistance Camp";
			description = "A camp has been established at %3%11%4 by %3%12%4.%1%2You can respawn at this camp.%1%2If the enemy discovers your camp, they may decide to attack.";
			tip = "The camp has been marked on your map.";
			arguments[] = {
				"ITD_global_lastCampGrid",
				"ITD_global_campBuiltBy"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
		};
		class Info_BuiltM
		{
			displayName = "Resistance Camp";
			description = "Another resistance camp has been established at %3%11%4 by %3%12%4.";
			tip = "The new camp has been marked on your map.";
			arguments[] = {
				"ITD_global_lastCampGrid",
				"ITD_global_campBuiltBy"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\Gear_ca.paa";
		};
		class Error_Position
		{
			displayName = "Invalid Position";
			description = "Resistance camps cannot be built in water or on steep terrain.";
		};
		class Error_Distance
		{
			displayName = "Invalid Position";
			description = "This building needs to be placed within a resistance camp.";
		};
		class Error_DistanceHQ
		{
			displayName = "Invalid Position";
			description = "Resistance camps need to be at least 1.5km apart.";
		};
		class Error_Duplicate
		{
			displayName = "Invalid Position";
			description = "This building has already been constructed at this camp.";
		};
	};

	class ITD_Service
	{
		class Info_AssessDamage
		{
			displayName = "Vehicle Repair";
			description = "%11 requires %12 spare parts for a complete repair.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_partsUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_AssessDamageMil
		{
			displayName = "Vehicle Repair";
			description = "%11 requires %12 military parts and %13 spare parts for a complete repair.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_militaryUsed",
				"ITD_local_partsUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_AssessDamageNone
		{
			displayName = "Vehicle Repair";
			description = "%11 doesn't require any repairs.";
			arguments[] = {
				"ITD_local_serviceType"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_RepairComplete
		{
			displayName = "Vehicle Repaired";
			description = "%11 has been repaired using %12 spare parts.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_partsUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_RepairCompleteMil
		{
			displayName = "Vehicle Repaired";
			description = "%11 has been repaired using %12 spare parts and %13 military parts.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_partsUsed",
				"ITD_local_militaryUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_RepairPartial
		{
			displayName = "Vehicle Repaired";
			description = "%11 has been partially repaired using %12 spare parts. The service point has no more parts remaining.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_partsUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_RepairPartialMil
		{
			displayName = "Vehicle Repaired";
			description = "%11 has been partially repaired using %12 military parts, you need more military parts before continuing repairs.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_militaryUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_RepairPartialBoth
		{
			displayName = "Vehicle Repaired";
			description = "%11 has been partially repaired using %12 military parts and %13 parts, you need more parts to continue repairs.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_militaryUsed",
				"ITD_local_partsUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_RepairParts
		{
			displayName = "Vehicle Repair";
			description = "Repairs on %11 cannot be started without spare parts.";
			arguments[] = {
				"ITD_local_serviceType"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_RepairPartsMil
		{
			displayName = "Vehicle Repair";
			description = "Repairs on %11 cannot be started without military parts.";
			arguments[] = {
				"ITD_local_serviceType"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_RefuelFull
		{
			displayName = "Vehicle Refuelled";
			description = "%11 has been refuelled using %12 fuel.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_fuelUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_RefuelPartial
		{
			displayName = "Vehicle Refuelled";
			description = "%11 has been partially refuelled using %12 fuel. The service point is out of fuel.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_fuelUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_Siphon
		{
			displayName = "Fuel Siphoned";
			description = "%11 fuel has been siphoned from %12.";
			arguments[] = {
				"ITD_local_fuelUsed",
				"ITD_local_serviceType"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_SiphonNone
		{
			displayName = "Fuel Siphoned";
			description = "No fuel was siphoned from %11, the tank is already empty.";
			arguments[] = {
				"ITD_local_serviceType"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_Strip
		{
			displayName = "Vehicle Stripped";
			description = "%11 was stripped down for %12 parts.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_partsUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_StripSiphon
		{
			displayName = "Vehicle Stripped";
			description = "%11 was stripped down for %12 parts and %13 fuel.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_partsUsed",
				"ITD_local_fuelUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_StripMil
		{
			displayName = "Vehicle Stripped";
			description = "%11 was stripped down for %12 parts and %13 military parts.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_partsUsed",
				"ITD_local_militaryUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Info_StripMilSiphon
		{
			displayName = "Vehicle Stripped";
			description = "%11 was stripped down for %12 parts, %14 military parts and %13 fuel.";
			arguments[] = {
				"ITD_local_serviceType",
				"ITD_local_partsUsed",
				"ITD_local_fuelUsed",
				"ITD_local_militaryUsed"
			};
			image = "\a3\ui_f\data\gui\cfg\hints\vehiclerepair_ca.paa";
		};
		class Error_DistancePlayer
		{
			displayName = "Service Point";
			description = "You are not close enough to the service point.";
		};
		class Error_DistanceVehicle
		{
			displayName = "Service Point";
			description = "The vehicle is not close enough to the service point.";
		};
		class Error_DistanceClose
		{
			displayName = "Service Point";
			description = "You are not close enough to the vehicle.";
		};
		class Error_FortParts
		{
			displayName = "Fortification";
			description = "Not enough spare parts available to construct this fortification.";
		};
	};
};
