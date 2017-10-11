// uses /area/prishtina/field

/area/prishtina
	atmos = 0
	atmosalm = 0
	poweralm = 0
	requires_power = 0
	has_gravity = 1
	no_air = 0
	ambience = list()
	forced_ambience = null
	base_turf = /turf/floor/plating/grass/wild //The base turf type of the area, which can be used to override the z-level's base turf
	sound_env = STANDARD_STATION
	icon_state = "none"

/area/prishtina/New()
	..()
	if (istype(src, /area/prishtina/german) && !istype(src, /area/prishtina/german/ss_torture_room))
		name = "(German) [name]"
	else if (istype(src, /area/prishtina/soviet))
		name = "(Soviet) [name]"
	else if (istype(src, /area/prishtina/void/german/ss_train))
		name = "(Waffen-S.S.) [name]"
	else if (istype(src, /area/prishtina/german/ss_torture_room))
		name = "(Waffen-S.S.) [name]"
	else
		name = "(Civilian) [name]"

// base area

/area/prishtina/field
	name = "Field"

// admin zone

/area/prishtina/admin
	icon_state = "yellow"
	name = "Admin Zone"

// houses in No Man's Land

/area/prishtina/houses
	name = "\improper Houses"
	icon_state = "houses"

/area/prishtina/houses/nml_one
/area/prishtina/houses/nml_two
/area/prishtina/houses/nml_three
/area/prishtina/houses/nml_four
/area/prishtina/houses/nml_five
/area/prishtina/houses/nml_six
/area/prishtina/houses/nml_seven
/area/prishtina/houses/nml_eight
/area/prishtina/houses/nml_nine
/area/prishtina/houses/nml_ten
/area/prishtina/houses/nml_eleven
/area/prishtina/houses/nml_twelve
/area/prishtina/houses/nml_thirteen
/area/prishtina/houses/nml_fourteen

/area/prishtina/houses/sov_one
/area/prishtina/houses/sov_two
/area/prishtina/houses/sov_three
/area/prishtina/houses/sov_four
/area/prishtina/houses/sov_five
/area/prishtina/houses/sov_six
/area/prishtina/houses/sov_seven
/area/prishtina/houses/sov_eight
/area/prishtina/houses/sov_nine
/area/prishtina/houses/sov_ten
/area/prishtina/houses/sov_eleven
/area/prishtina/houses/sov_twelve
/area/prishtina/houses/sov_thirteen
/area/prishtina/houses/sov_fourteen

/area/prishtina/houses/ger_one
/area/prishtina/houses/ger_two
/area/prishtina/houses/ger_three
/area/prishtina/houses/ger_four
/area/prishtina/houses/ger_five
/area/prishtina/houses/ger_six
/area/prishtina/houses/ger_seven
/area/prishtina/houses/ger_eight
/area/prishtina/houses/ger_nine
/area/prishtina/houses/ger_ten
/area/prishtina/houses/ger_eleven
/area/prishtina/houses/ger_twelve
/area/prishtina/houses/ger_thirteen
/area/prishtina/houses/ger_fourteen


// "wormhole" areas: doesn't include trains since they don't get their area copied

// where all this stuff is

/area/prishtina/void
	icon_state = "dark"
	name = "the void"

/area/prishtina/void/german
	icon_state = "red2"
	name = "what the fuck is this"

/area/prishtina/void/german/ss_train
	icon_state = "red2"
	name = "Train"

/area/prishtina/void/german/ss_train/entrance
	icon_state = "red2"
	name = "Train Entrance Room"

/area/prishtina/void/german/ss_train/command
	icon_state = "blue2"
	name = "Train Command Room"

/area/prishtina/void/german/ss_train/command/office
	icon_state = "blue-red2"
	name = "Train Command Office"

/area/prishtina/void/german/ss_train/prison
	icon_state = "blue-red"
	name = "Train Prison"

/area/prishtina/void/german/ss_train/prison/cell1
	icon_state = "blue-red-d"
	name = "Train Prison Cell #1"

/area/prishtina/void/german/ss_train/prison/cell2
	icon_state = "purple"
	name = "Train Prison Cell #2"

/area/prishtina/void/german/ss_train/prison/cell3
	icon_state = "red2"
	name = "Train Prison Cell #3"

/area/prishtina/void/german/ss_train/prison/cell4
	icon_state = "blue2"
	name = "Train Prison Cell #4"

/area/prishtina/void/german/ss_train/gas_chamber
	icon_state = "blue-red2"
	name = "Train Gas Chamber"

/area/prishtina/void/german/ss_train/gas_chamber/gas_room
	icon_state = "purple"
	name = "Train Gas Room"
// end of wormhole areas

// no man's land

/area/prishtina/no_mans_land
	dynamic_lighting = 0
	name = "No Man's Land"

// german areas

/area/prishtina/german

/area/prishtina/german/main_area
	name = "German Base"
	icon_state = "red2"
	dynamic_lighting = 0

/area/prishtina/german/outside

/area/prishtina/german/gas_chamber
	name = "German Gas Chamber"
	icon_state = "blue-red"
	dynamic_lighting = 0

/area/prishtina/german/train_zone
	name = "Train Zone"
	icon_state = "blue2"
	#ifdef USE_TRAIN_LIGHTS
	dynamic_lighting = 1
	#else
	dynamic_lighting = 0
	#endif

/area/prishtina/german/train_zone/fieldtest
	name = "Field Zone"
	dynamic_lighting = 1

/area/prishtina/german/train_starting_zone
	icon_state = "blue-red2"
	name = "Train Boarding"
	dynamic_lighting = 0

/area/prishtina/german/train_landing_zone
	icon_state = "blue-red"
	name = "Train Unboarding"
	dynamic_lighting = 0

/area/prishtina/german/resting_area_1
	name = "Resting Area #1"
	icon_state = "blue-red-d"

/area/prishtina/german/resting_area_2
	name = "Resting Area #2"
	icon_state = "purple"

/area/prishtina/german/resting_area_3
	name = "Resting Area #3"
	icon_state = "red2"

/area/prishtina/german/resting_area_4
	name = "Resting Area #4"
	icon_state = "blue2"

/area/prishtina/german/cargo
	name = "Cargo"
	icon_state = "blue-red2"

/area/prishtina/german/armory
	name = "Armory"
	icon_state = "blue-red"

/area/prishtina/german/armory/train
	name = "Armory"
	icon_state = "purple"
	dynamic_lighting = 0

/area/prishtina/german/cafeteria
	name = "Cafeteria"
	icon_state = "blue-red-d"

/area/prishtina/german/kitchen
	name = "Kitchen"
	icon_state = "purple"

// because the german showers and drying rooms are disconnected, giving them the same color
 // - Kachnov

/area/prishtina/german/shower1
	name = "Showers #1"
	icon_state = "red2"
	dynamic_lighting = 0

/area/prishtina/german/shower2
	name = "Showers #2"
	icon_state = "red2"
	dynamic_lighting = 0

/area/prishtina/german/shower3
	name = "Showers #3"
	icon_state = "red2"
	dynamic_lighting = 0

/area/prishtina/german/drying1
	name = "Drying Room #1"
	icon_state = "blue2"
	dynamic_lighting = 0

/area/prishtina/german/drying2
	name = "Drying Room #2"
	icon_state = "blue2"
	dynamic_lighting = 0

/area/prishtina/german/drying3
	name = "Drying Room #3"
	icon_state = "blue2"
	dynamic_lighting = 0

/area/prishtina/german/ss_torture_room
	name = "Interrogation Room" // "Interrogation"
	icon_state = "blue-red2"

/area/prishtina/german/ss_torture_room/tools
	name = "Interrogation Room Tools"
	icon_state = "blue-red"

/area/prishtina/german/ss_torture_room/cell1
	name = "Interrogation Room Cell #1"
	icon_state = "blue-red-d"

/area/prishtina/german/ss_torture_room/cell2
	name = "Interrogation Room Cell #2"
	icon_state = "purple"

/area/prishtina/german/command
	name = "Command"
	icon_state = "purple"

/area/prishtina/german/command/office
	name = "Feldwebel's Office"
	icon_state = "blue-red-d"

/area/prishtina/german/briefing
	name = "Briefing"
	icon_state = "red2"
	dynamic_lighting = 0

/area/prishtina/german/base_defenses
	name = "Base Defenses"
	icon_state = "blue2"
	dynamic_lighting = 0

/area/prishtina/german/engineering
	name = "Engineering"
	icon_state = "blue-red"

/area/prishtina/german/janitor
	name = "Janitor's Closet"
	icon_state = "blue-red2"

/area/prishtina/german/medical
	name = "Medical Area"
	icon_state = "blue-red2"

// soviet areas

/area/prishtina/soviet
	name = "soviet"

/area/prishtina/soviet/bunker_entrance
	name = "Bunker Entrance"
	icon_state = "red2"

/area/prishtina/soviet/immediate_outside_defenses
	name = "Bunker Defenses"
	icon_state = "blue2"
	dynamic_lighting = 0

/area/prishtina/soviet/forward_defenses
	name = "Bunker Defenses"
	icon_state = "blue-red2"
	dynamic_lighting = 0
// bunker areas

/area/prishtina/soviet/bunker
	name = "Soviet Bunker"

/area/prishtina/soviet/bunker/tunnel
	icon_state = "purple"
	name = "Soviet Bunker Tunnel"

/area/prishtina/soviet/bunker/entrance
	icon_state = "red2"
	name = "entrance"

/area/prishtina/soviet/bunker/main_hallway
	icon_state = "blue2"
	name = "Bunker Main Hallway"

/area/prishtina/soviet/bunker/briefing
	icon_state = "blue-red2"
	name = "Briefing"

/area/prishtina/soviet/bunker/cargo
	icon_state = "blue-red"
	name = "Cargo"

/area/prishtina/soviet/bunker/engineering
	icon_state = "blue-red-d"
	name = "Engineering"

/area/prishtina/soviet/bunker/medical
	icon_state = "green"
	name = "Medical Area"

/area/prishtina/soviet/bunker/janitor
	icon_state = "purple"
	name = "Janitor's Closet"

/area/prishtina/soviet/bunker/command
	icon_state = "red2"
	name = "Command"

/area/prishtina/soviet/bunker/command/office
	icon_state = "blue2"
	name = "Commandir's Office"

/area/prishtina/soviet/bunker/armory
	icon_state = "blue-red2"
	name = "Armory"

/area/prishtina/soviet/bunker/showers
	icon_state = "blue-red"
	name = "Showers"

/area/prishtina/soviet/bunker/cafeteria
	icon_state = "blue-red-d"
	name = "Cafeteria"

/area/prishtina/soviet/bunker/kitchen
	icon_state = "green"
	name = "Kitchen"

/area/prishtina/soviet/bunker/resting_area
	icon_state = "purple"
	name = "Resting Area"

/area/prishtina/soviet/bunker/brig
	icon_state = "red2"
	name = "Brig"

/area/prishtina/soviet/bunker/brig/cell1
	icon_state = "blue2"
	name = "Brig Cell #1"

/area/prishtina/soviet/bunker/brig/cell2
	icon_state = "blue-red2"
	name = "Brig Cell #2"

/area/prishtina/soviet/lift/
	icon_state = "purple"
	name = "Soviet Lift"

/area/prishtina/soviet/lift/upper

/area/prishtina/soviet/lift/lower

/area/prishtina/soviet/backup_armory
	icon_state = "purple"
	name = "Soviet Backup Armory"


// areas for example train cars

/area/prishtina/train // nothing here yet, but I feel like I will need it later - Kachnov

/area/prishtina/train/german

/area/prishtina/train/german/cabin

/area/prishtina/train/german/cabin/officer // fanciest cabin. Also, nobody has to walk through your room since it's in the back.

/area/prishtina/train/german/cabin/storage // crates

// don't inherit this from storage, it causes problems
/area/prishtina/train/german/cabin/storage_horizontal // crates

/area/prishtina/train/german/cabin/soldier // personnel

/area/prishtina/train/german/cabin/conductor // where the conductor drives the train

/area/prishtina/train/russian

/area/prishtina/train/russian/cabin

/area/prishtina/train/russian/cabin/officer // fanciest cabin. Also, nobody has to walk through your room since it's in the back.

/area/prishtina/train/russian/cabin/storage // crates

/area/prishtina/train/russian/cabin/soldier // personnel

/area/prishtina/train/russian/cabin/conductor // where the conductor drives the train

