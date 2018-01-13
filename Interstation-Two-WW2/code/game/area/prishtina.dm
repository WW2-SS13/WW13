/area/prishtina
	requires_power = FALSE
	has_gravity = TRUE
	no_air = FALSE
	ambience = list()
	forced_ambience = null
	base_turf = /turf/floor/plating/grass/wild //The base turf type of the area, which can be used to override the z-level's base turf
	sound_env = STANDARD_STATION
	icon_state = "purple1"
	dynamic_lighting = TRUE

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

// Basic Area Definitions

/* note: BYOND reaches some kind of limit when it encounters areas with massive
 * contents lists (around 30,000 - 65,000 maybe), causing any movement in those areas
 * to slow down dramatically. The forest area reached this limit, but only
 * when there were snow objects, so its been split into 9 separate areas.
*/

/area/prishtina/no_mans_land
	dynamic_lighting = TRUE
	name = "No Man's Land"
	icon_state = "purple1"

/area/prishtina/no_mans_land/invisible_wall

/area/prishtina/forest
	dynamic_lighting = FALSE
	name = "The Forest"
	icon_state = "purple1"

/area/prishtina/forest/north/invisible_wall

/area/prishtina/forest/south/invisible_wall

/* sector TRUE = top left, sector 2 = top center, sector 3 = top right
   sector 4 = middle left, sector 5 = middle center, sector 6 = middle right
   sector 7 = bottom left, sector 8 = bottom center, sector 9 = bottom right */

/area/prishtina/forest/sector1
	name = "Northwestern Forest"
/area/prishtina/forest/sector1/ss1
/area/prishtina/forest/sector1/ss2
/area/prishtina/forest/sector1/ss3
/area/prishtina/forest/sector1/ss4

/area/prishtina/forest/sector2
	name = "Northern Forest"
/area/prishtina/forest/sector2/ss1
/area/prishtina/forest/sector2/ss2
/area/prishtina/forest/sector2/ss3
/area/prishtina/forest/sector2/ss4

/area/prishtina/forest/sector3
	name = "Northeastern Forest"
/area/prishtina/forest/sector3/ss1
/area/prishtina/forest/sector3/ss2
/area/prishtina/forest/sector3/ss3
/area/prishtina/forest/sector3/ss4

/area/prishtina/forest/sector4
	name = "Western Forest"
/area/prishtina/forest/sector4/ss1
/area/prishtina/forest/sector4/ss2
/area/prishtina/forest/sector4/ss3
/area/prishtina/forest/sector4/ss4

/area/prishtina/forest/sector5
	name = "Central Forest"
/area/prishtina/forest/sector5/ss1
/area/prishtina/forest/sector5/ss2
/area/prishtina/forest/sector5/ss3
/area/prishtina/forest/sector5/ss4

/area/prishtina/forest/sector6
	name = "Eastern Forest"
/area/prishtina/forest/sector6/ss1
/area/prishtina/forest/sector6/ss2
/area/prishtina/forest/sector6/ss3
/area/prishtina/forest/sector6/ss4

/area/prishtina/forest/sector7
	name = "Southwestern Forest"
/area/prishtina/forest/sector7/ss1
/area/prishtina/forest/sector7/ss2
/area/prishtina/forest/sector7/ss3
/area/prishtina/forest/sector7/ss4

/area/prishtina/forest/sector8
	name = "Southern Forest"
/area/prishtina/forest/sector8/ss1
/area/prishtina/forest/sector8/ss2
/area/prishtina/forest/sector8/ss3
/area/prishtina/forest/sector8/ss4

/area/prishtina/forest/sector9
	name = "Southeastern Forest"
/area/prishtina/forest/sector9/ss1
/area/prishtina/forest/sector9/ss2
/area/prishtina/forest/sector9/ss3
/area/prishtina/forest/sector9/ss4

/area/prishtina/farm1
	dynamic_lighting = FALSE
	name = "Farmland"
	icon_state = "red3"

/area/prishtina/farm2
	dynamic_lighting = FALSE
	name = "Farmland"
	icon_state = "red3"

/area/prishtina/farm3
	dynamic_lighting = FALSE
	name = "Farmland"
	icon_state = "red3"

/area/prishtina/farm4
	dynamic_lighting = FALSE
	name = "Farmland"
	icon_state = "red3"

// admin zone

/area/prishtina/admin
	icon_state = "purple1"
	name = "Admin Zone"
	location = AREA_INSIDE

// houses in No Man's Land

/area/prishtina/houses
	name = "\improper Houses"
	icon_state = "red1"
	location = AREA_INSIDE

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
	icon_state = "purple1"
	name = "the void"
	location = AREA_INSIDE

/area/prishtina/void/caves
	icon_state = "blue1"
	name = "the caves"
	location = AREA_INSIDE

/area/prishtina/void/german
	icon_state = "red1"
	name = "what the fuck is this"

/area/prishtina/void/german/ss_train
	icon_state = "red2"
	name = "Train"
	location = AREA_INSIDE

/area/prishtina/void/german/ss_train/entrance
	icon_state = "red3"
	name = "Train Entrance Room"

/area/prishtina/void/german/ss_train/command
	icon_state = "red4"
	name = "Train Command Room"

/area/prishtina/void/german/ss_train/command/office
	icon_state = "red5"
	name = "Train Command Office"

/area/prishtina/void/german/ss_train/prison
	icon_state = "blue1"
	name = "Train Prison"

/area/prishtina/void/german/ss_train/prison/cell1
	icon_state = "blue2"
	name = "Train Prison Cell #1"

/area/prishtina/void/german/ss_train/prison/cell2
	icon_state = "blue3"
	name = "Train Prison Cell #2"

/area/prishtina/void/german/ss_train/prison/cell3
	icon_state = "blue4"
	name = "Train Prison Cell #3"

/area/prishtina/void/german/ss_train/prison/cell4
	icon_state = "blue5"
	name = "Train Prison Cell #4"

/area/prishtina/void/german/ss_train/gas_chamber
	icon_state = "blue1"
	name = "Train Gas Chamber"

/area/prishtina/void/german/ss_train/gas_chamber/gas_room
	icon_state = "blue2"
	name = "Train Gas Room"

/area/prishtina/void/skybox
	icon_state = "purple1"
	name = "The Sky"

/area/prishtina/void/skybox/one
/area/prishtina/void/skybox/two
/area/prishtina/void/skybox/three
/area/prishtina/void/skybox/four
/area/prishtina/void/skybox/five
/area/prishtina/void/skybox/six
/area/prishtina/void/skybox/seven

/area/prishtina/void/sky
	icon_state = "purple1"
	name = "The Sky"
// end of wormhole areas

// german areas

/area/prishtina/german

/area/prishtina/german/main_area
	name = "German Base"
	icon_state = "red1"
	dynamic_lighting = FALSE

/area/prishtina/german/main_area/sector1
/area/prishtina/german/main_area/sector2
/area/prishtina/german/main_area/sector3

/area/prishtina/german/main_area/dogshed
	name = "German Dogshed"
	icon_state = "red2"
	dynamic_lighting = FALSE
	location = AREA_INSIDE

/area/prishtina/german/outside

/area/prishtina/german/outside/indoors
	location = AREA_INSIDE

/area/prishtina/german/gas_chamber
	name = "German Gas Chamber"
	icon_state = "red3"
	dynamic_lighting = FALSE

/area/prishtina/german/train_zone
	name = "Train Zone"
	icon_state = "blue1"
	#ifdef USE_TRAIN_LIGHTS
	dynamic_lighting = TRUE
	#else
	dynamic_lighting = FALSE
	#endif
	location = AREA_INSIDE
	is_train_area = TRUE

/area/prishtina/german/train_starting_zone
	icon_state = "blue2"
	name = "Train Boarding"
	dynamic_lighting = FALSE

/area/prishtina/german/train_landing_zone
	icon_state = "blue2"
	name = "Train Unboarding"
	dynamic_lighting = FALSE

/area/prishtina/german/resting_area_1
	name = "Resting Area #1"
	icon_state = "green1"
	location = AREA_INSIDE

/area/prishtina/german/resting_area_2
	name = "Resting Area #2"
	icon_state = "green2"
	location = AREA_INSIDE


/area/prishtina/german/resting_area_3
	name = "Resting Area #3"
	icon_state = "green3"
	location = AREA_INSIDE


/area/prishtina/german/resting_area_4
	name = "Resting Area #4"
	icon_state = "green4"
	location = AREA_INSIDE

/area/prishtina/german/gearing
	name = "Cargo"
	icon_state = "blue1"
	location = AREA_INSIDE

/area/prishtina/german/armory
	name = "Armory"
	icon_state = "blue2"
	location = AREA_INSIDE

/area/prishtina/german/armory/train
	name = "Armory"
	icon_state = "blue3"
	dynamic_lighting = FALSE
	is_train_area = TRUE

/area/prishtina/german/cafeteria
	name = "Cafeteria"
	icon_state = "blue4"
	location = AREA_INSIDE

/area/prishtina/german/kitchen
	name = "Kitchen"
	icon_state = "blue5"
	location = AREA_INSIDE

/area/prishtina/german/shower1
	name = "Showers #1"
	icon_state = "red2"
	dynamic_lighting = FALSE
	location = AREA_INSIDE

/area/prishtina/german/shower2
	name = "Showers #2"
	icon_state = "red2"
	dynamic_lighting = FALSE
	location = AREA_INSIDE

/area/prishtina/german/shower3
	name = "Showers #3"
	icon_state = "red2"
	dynamic_lighting = FALSE
	location = AREA_INSIDE

/area/prishtina/german/drying1
	name = "Drying Room #1"
	icon_state = "blue2"
	dynamic_lighting = FALSE
	location = AREA_INSIDE

/area/prishtina/german/drying2
	name = "Drying Room #2"
	icon_state = "blue2"
	dynamic_lighting = FALSE
	location = AREA_INSIDE

/area/prishtina/german/drying3
	name = "Drying Room #3"
	icon_state = "blue2"
	dynamic_lighting = FALSE
	location = AREA_INSIDE

/area/prishtina/german/ss_torture_room
	name = "Interrogation Room" // "Interrogation"
	icon_state = "blue1"
	location = AREA_INSIDE

/area/prishtina/german/ss_torture_room/tools
	name = "Interrogation Room Tools"
	icon_state = "blue2"
	location = AREA_INSIDE

/area/prishtina/german/ss_torture_room/cell1
	name = "Interrogation Room Cell #1"
	icon_state = "blue3"
	location = AREA_INSIDE

/area/prishtina/german/ss_torture_room/cell2
	name = "Interrogation Room Cell #2"
	icon_state = "blue4"
	location = AREA_INSIDE

/area/prishtina/german/command
	name = "Command"
	icon_state = "green1"
	location = AREA_INSIDE

/area/prishtina/german/command/office
	name = "Feldwebel's Office"
	icon_state = "green2"
	location = AREA_INSIDE

/area/prishtina/german/briefing
	name = "Briefing"
	icon_state = "green1"
	dynamic_lighting = FALSE

/area/prishtina/german/base_defenses
	name = "Base Defenses"
	icon_state = "green2"
	dynamic_lighting = FALSE

// prevents snowing on some walls
/area/prishtina/german/base_defenses/wall
	location = AREA_INSIDE

/area/prishtina/german/engineering
	name = "Engineering"
	icon_state = "blue1"
	location = AREA_INSIDE

/area/prishtina/german/janitor
	name = "Janitor's Closet"
	icon_state = "blue2"
	location = AREA_INSIDE

/area/prishtina/german/medical
	name = "Medical Area"
	icon_state = "blue3"
	location = AREA_INSIDE

// soviet areas

/area/prishtina/soviet
	name = "soviet"

// for the small map

/area/prishtina/soviet/small_map/main_area
	name = "Soviet Main Area"
	icon_state = "blue1"

/area/prishtina/soviet/small_map/inside
	name = "Soviet Inside Area"
	icon_state = "red2"
	location = AREA_INSIDE

/area/prishtina/soviet/small_map/inside/armory
	name = "Soviet Armory"
	icon_state = "red3"

/area/prishtina/soviet/small_map/inside/resting_area
	name = "Soviet Resting Area"
	icon_state = "red4"

/area/prishtina/soviet/small_map/inside/gearing
	name = "Soviet Gearing Up Area"
	icon_state = "red5"

/area/prishtina/soviet/small_map/inside/relaxation
	name = "Soviet Relaxation Area"
	icon_state = "red5"

/area/prishtina/soviet/small_map/inside/kitchen
	name = "Soviet Kitchen"
	icon_state = "blue1"

/area/prishtina/soviet/small_map/inside/commander_bedroom
	name = "Soviet Commander Bedroom"
	icon_state = "blue1"

/area/prishtina/soviet/small_map/inside/medical
	name = "Soviet Medical Room"
	icon_state = "blue2"

// for the large map

/area/prishtina/soviet/bunker_entrance
	name = "Bunker Entrance"
	icon_state = "red2"
	location = AREA_INSIDE

/area/prishtina/soviet/immediate_outside_defenses
	name = "Bunker Defenses"
	icon_state = "red3"
	dynamic_lighting = FALSE

/area/prishtina/soviet/dogshed
	name = "Soviet Dog Shed"
	icon_state = "blue1"
	dynamic_lighting = TRUE
	location = AREA_INSIDE

/area/prishtina/soviet/immediate_outside_defenses/houses
	icon_state = "blue2"
	dynamic_lighting = TRUE
	location = AREA_INSIDE

/area/prishtina/soviet/forward_defenses
	name = "Bunker Defenses"
	icon_state = "blue3"
	dynamic_lighting = FALSE
// bunker areas

/area/prishtina/soviet/bunker
	name = "Soviet Bunker"
	location = AREA_INSIDE

/area/prishtina/soviet/bunker/tunnel
	icon_state = "red2"
	name = "Soviet Bunker Tunnel"

/area/prishtina/soviet/bunker/entrance
	icon_state = "green1"
	name = "entrance"

/area/prishtina/soviet/bunker/main_hallway
	icon_state = "green2"
	name = "Bunker Main Hallway"

/area/prishtina/soviet/bunker/briefing
	icon_state = "green3"
	name = "Briefing"

/area/prishtina/soviet/bunker/cargo
	icon_state = "green4"
	name = "Cargo"

/area/prishtina/soviet/bunker/engineering
	icon_state = "green5"
	name = "Engineering"

/area/prishtina/soviet/bunker/medical
	icon_state = "blue1"
	name = "Medical Area"

/area/prishtina/soviet/bunker/janitor
	icon_state = "blue2"
	name = "Janitor's Closet"

/area/prishtina/soviet/bunker/command
	icon_state = "blue3"
	name = "Command"

/area/prishtina/soviet/bunker/command/office
	icon_state = "blue4"
	name = "Commandir's Office"

/area/prishtina/soviet/bunker/armory
	icon_state = "blue5"
	name = "Armory"

/area/prishtina/soviet/bunker/showers
	icon_state = "red1"
	name = "Showers"

/area/prishtina/soviet/bunker/cafeteria
	icon_state = "red2"
	name = "Cafeteria"

/area/prishtina/soviet/bunker/kitchen
	icon_state = "red3"
	name = "Kitchen"

/area/prishtina/soviet/bunker/resting_area
	icon_state = "red4"
	name = "Resting Area"

/area/prishtina/soviet/bunker/brig
	icon_state = "red5"
	name = "Brig"

/area/prishtina/soviet/bunker/brig/cell1
	icon_state = "red1"
	name = "Brig Cell #1"

/area/prishtina/soviet/bunker/brig/cell2
	icon_state = "red2"
	name = "Brig Cell #2"

/area/prishtina/soviet/lift/
	icon_state = "blue1"
	name = "Soviet Lift"
	location = AREA_INSIDE

/area/prishtina/soviet/lift/upper

/area/prishtina/soviet/lift/lower

/area/prishtina/soviet/backup_armory
	icon_state = "blue2"
	name = "Soviet Backup Armory"
	location = AREA_INSIDE


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

