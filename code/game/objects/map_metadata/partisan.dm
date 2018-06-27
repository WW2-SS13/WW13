/obj/map_metadata/partisan
	ID = MAP_PARTISAN
	title = "Partisan (100x100x1)"
	lobby_icon_state = "partisan"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall)
	respawn_delay = 1800 //3 minutes
	squad_spawn_locations = FALSE
	reinforcements = FALSE
	faction_organization = list(
		GERMAN,
		PARTISAN,)
	available_subfactions = list(
		SCHUTZSTAFFEL = 100,
	)
	roundend_condition_sides = list(
		list(GERMAN) = /area/prishtina/german/ss_armory,
		list(PARTISAN) = /area/prishtina/houses)
	ambience = list()
	times_of_day = list("Night")
	faction_distribution_coeffs = list(GERMAN = 0.35, PARTISAN = 0.65)
	battle_name = "Partisan Hunting in Ukraine"
//	songs = list(
//	 "Horst Wessel Lied:1" = 'sound/music/horst_wessel_lied.ogg')
	meme = FALSE

/obj/map_metadata/partisan/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/partisan/soldier))
		J.total_positions = max(10, round(clients.len*1.4))
	if (istype(J, /datum/job/partisan/commander))
		J.total_positions = max(1, round(clients.len*0.1))
	if (istype(J, /datum/job/german))
		if (!J.is_SS)
			. = FALSE
		else
			if (istype(J, /datum/job/german/soldier_ss))
				J.total_positions = max(7, round(clients.len*0.9))
			if (istype(J, /datum/job/german/squad_leader_ss))
				J.total_positions = max(1, round(clients.len*0.1))
	return .


/obj/map_metadata/partisan/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 6000 || admin_ended_all_grace_periods)

/obj/map_metadata/partisan/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 6000 || admin_ended_all_grace_periods)

/obj/map_metadata/partisan/announce_mission_start(var/preparation_time)
	world << "<font size=4>All factions have <b>10 minutes</b> to prepare for battle before combat will begin!</font>"

/obj/map_metadata/partisan/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())