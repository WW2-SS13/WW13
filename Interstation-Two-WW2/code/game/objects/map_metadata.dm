var/global/obj/map_metadata/map = null

/obj/map_metadata
	name = ""
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = 1
	simulated = 0
	invisibility = 101
	var/ID = null
	var/list/prishtina_blocking_area_types = list()
	var/last_crossing_block_status[2]
	var/admin_ended_all_grace_periods = 0

/obj/map_metadata/New()
	..()
	map = src
	icon = null
	icon_state = null

// called from the ticker process
/obj/map_metadata/proc/tick()
	if (last_crossing_block_status[GERMAN] == 0)
		if (germans_can_cross_blocks())
			world << "<font size = 4>The Germans may now cross the invisible wall!</font>"
	if (last_crossing_block_status[RUSSIAN] == 0)
		if (soviets_can_cross_blocks())
			world << "<font size = 4>The Soviets may now cross the invisible wall!</font>"

	last_crossing_block_status[GERMAN] = germans_can_cross_blocks()
	last_crossing_block_status[RUSSIAN] = soviets_can_cross_blocks()

/obj/map_metadata/proc/check_prishtina_block(var/mob/living/carbon/human/H, var/turf/T)
	if (!istype(H) || !istype(T))
		return 0
	var/area/A = get_area(T)
	if (prishtina_blocking_area_types.Find(A.type))
		if (!H.original_job)
			return 0
		else
			switch (H.original_job.base_type_flag())
				if (PARTISAN, CIVILIAN, RUSSIAN)
					return !soviets_can_cross_blocks()
				if (GERMAN)
					return !germans_can_cross_blocks()
	return 0

/obj/map_metadata/proc/soviets_can_cross_blocks()
	return 1

/obj/map_metadata/proc/germans_can_cross_blocks()
	return 1

/obj/map_metadata/proc/announce_mission_start(var/preparation_time = 0)
	return 1

/obj/map_metadata/forest
	ID = "Forest Map (200x529)"
	prishtina_blocking_area_types = list(
		/area/prishtina/forest/north/invisible_wall,
		/area/prishtina/forest/south/invisible_wall)

/obj/map_metadata/forest/germans_can_cross_blocks()
	return (mission_announced || admin_ended_all_grace_periods)

/obj/map_metadata/forest/soviets_can_cross_blocks()
	return ((mission_announced && train_arrived) || admin_ended_all_grace_periods)

/obj/map_metadata/forest/announce_mission_start(var/preparation_time = 0)
	world << "<font size=4>The German assault has started after <b>[preparation_time / 600] minutes</b> of preparation. The Soviet side may not attack until after <b>7 minutes</b>.</font><br>"

/obj/map_metadata/minicity
	ID = "City Map (70x70)"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall)

/obj/map_metadata/minicity/germans_can_cross_blocks()
	return (tickerProcess.time_elapsed >= 7200 || admin_ended_all_grace_periods)

/obj/map_metadata/minicity/soviets_can_cross_blocks()
	return (tickerProcess.time_elapsed >= 7200 || admin_ended_all_grace_periods)

/obj/map_metadata/minicity/announce_mission_start(var/preparation_time)
	world << "<font size=4>Both sides have <b>12 minutes</b> to prepare before combat will begin!</font>"