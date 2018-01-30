var/global/obj/map_metadata/map = null

/obj/map_metadata
	name = ""
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = TRUE
	simulated = FALSE
	invisibility = 101
	var/ID = null // MUST be text, or aspects will break
	var/title = null
	var/list/prishtina_blocking_area_types = list()
	var/last_crossing_block_status[3]
	var/admin_ended_all_grace_periods = FALSE
	var/uses_supply_train = FALSE
	var/uses_main_train = FALSE
	var/list/faction_organization = list(
		GERMAN,
		SOVIET,
		PARTISAN,
		CIVILIAN,
		ITALIAN,
		UKRAINIAN)
	var/event_faction = null
	var/min_autobalance_players = 0
	var/respawn_delay = 3000
	var/list/valid_weather_types = list(WEATHER_RAIN, WEATHER_SNOW)
	var/reinforcements = TRUE

/obj/map_metadata/New()
	..()
	map = src
	icon = null
	icon_state = null

// called from the ticker process
/obj/map_metadata/proc/tick()
	if (last_crossing_block_status[GERMAN] == FALSE)
		if (germans_can_cross_blocks())
			world << cross_message(GERMAN)
	if (last_crossing_block_status[SOVIET] == FALSE)
		if (soviets_can_cross_blocks())
			world << cross_message(SOVIET)
	if (last_crossing_block_status[event_faction] == FALSE)
		if (specialfaction_can_cross_blocks())
			world << cross_message(event_faction)

	last_crossing_block_status[GERMAN] = germans_can_cross_blocks()
	last_crossing_block_status[SOVIET] = soviets_can_cross_blocks()
	if (event_faction)
		last_crossing_block_status[event_faction] = specialfaction_can_cross_blocks()

/obj/map_metadata/proc/check_prishtina_block(var/mob/living/carbon/human/H, var/turf/T)
	if (!istype(H) || !istype(T))
		return FALSE
	var/area/A = get_area(T)
	if (prishtina_blocking_area_types.Find(A.type))
		if (!H.original_job)
			return FALSE
		else
			switch (H.original_job.base_type_flag())
				if (PARTISAN, CIVILIAN, SOVIET)
					return !soviets_can_cross_blocks()
				if (GERMAN)
					return !germans_can_cross_blocks()
				if (PILLARMEN)
					return !specialfaction_can_cross_blocks()
	return FALSE

/obj/map_metadata/proc/soviets_can_cross_blocks()
	return TRUE

/obj/map_metadata/proc/germans_can_cross_blocks()
	return TRUE

/obj/map_metadata/proc/specialfaction_can_cross_blocks()
	return FALSE

/obj/map_metadata/proc/announce_mission_start(var/preparation_time = FALSE)
	return TRUE

/obj/map_metadata/proc/game_really_started()
	return (soviets_can_cross_blocks() && germans_can_cross_blocks())

/obj/map_metadata/proc/job_enabled_specialcheck(var/datum/job/J)
	return TRUE

/obj/map_metadata/proc/cross_message(faction)
	return "<font size = 4>The [faction_const2name(faction)] may now cross the invisible wall!</font>"

// FOREST MAP
/obj/map_metadata/forest
	ID = "FOREST"
	title = "Forest Map (200x529x1)"
	prishtina_blocking_area_types = list(
		/area/prishtina/forest/north/invisible_wall,
		/area/prishtina/forest/south/invisible_wall)
	uses_supply_train = TRUE
	uses_main_train = TRUE
	faction_organization = list(
		GERMAN,
		SOVIET,
		PARTISAN,
		CIVILIAN,
		ITALIAN,
		UKRAINIAN)

/obj/map_metadata/forest/germans_can_cross_blocks()
	return (mission_announced || admin_ended_all_grace_periods)

/obj/map_metadata/forest/soviets_can_cross_blocks()
	return ((mission_announced && train_arrived) || admin_ended_all_grace_periods)

/obj/map_metadata/forest/announce_mission_start(var/preparation_time = FALSE)
	world << "<font size=4>The German assault has started after <b>[preparation_time / 600] minutes</b> of preparation. The Soviet side may not attack until after <b>7 minutes</b>.</font><br>"

// SMALL CITY MAP
/obj/map_metadata/minicity
	ID = "SMALLCITY"
	title = "City Map (70x70x2)"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall)
	faction_organization = list(
		GERMAN,
		SOVIET,
		PARTISAN,
		CIVILIAN,
		ITALIAN,
		UKRAINIAN)
	respawn_delay = 1200

/obj/map_metadata/minicity/germans_can_cross_blocks()
	return (tickerProcess.time_elapsed >= 7200 || admin_ended_all_grace_periods)

/obj/map_metadata/minicity/soviets_can_cross_blocks()
	return (tickerProcess.time_elapsed >= 7200 || admin_ended_all_grace_periods)

/obj/map_metadata/minicity/announce_mission_start(var/preparation_time)
	world << "<font size=4>Both sides have <b>12 minutes</b> to prepare before combat will begin!</font>"

// PILLARMAP
/obj/map_metadata/pillarmap
	ID = "PILLARMAP"
	title = "Pillar Map (70x70x2)"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall/inside)
	faction_organization = list(
		PILLARMEN,
		GERMAN)
	event_faction = PILLARMEN
	min_autobalance_players = 100
	respawn_delay = 0
	valid_weather_types = list()
	reinforcements = FALSE
	var/modded_num_of_SS = FALSE

/obj/map_metadata/pillarmap/germans_can_cross_blocks()
	return (tickerProcess.time_elapsed >= 6000 || admin_ended_all_grace_periods)

/obj/map_metadata/pillarmap/soviets_can_cross_blocks()
	return FALSE

/obj/map_metadata/pillarmap/specialfaction_can_cross_blocks()
	return (tickerProcess.time_elapsed >= 9000)

/obj/map_metadata/pillarmap/announce_mission_start(var/preparation_time)
	world << "<font size=4>The <b>Waffen SS</b> may attack after 10 minutes. The <b>Pillar Men</b> and <b>Vampires</b> may not attack until after 15 minutes.</font>"

/obj/map_metadata/pillarmap/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/german))
		if (!J.is_SS)
			. = FALSE
		else
			if (istype(J, /datum/job/german/soldier_ss) && !modded_num_of_SS)
				J.total_positions *= 16
				modded_num_of_SS = TRUE
	return .

/obj/map_metadata/pillarmap/cross_message(faction)
	if (faction == GERMAN)
		return "<font size = 4>The Waffen-SS may now attack! Get on the elevator and invade the sewers!</font>"
	return "<font size = 4>The [faction_const2name(faction)] may now cross the invisible wall!</font>"
