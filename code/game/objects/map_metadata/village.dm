/obj/map_metadata/village
	ID = MAP_VILLAGE
	title = "Village (160x160x1)"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall)
	respawn_delay = 2400
	squad_spawn_locations = FALSE
	min_autobalance_players = 50
	supply_points_per_tick = list(
		GERMAN = 1.00,
		USA = 1.00)
	faction_organization = list(
		GERMAN,
		USA,
		CIVILIAN)
	available_subfactions = list(
		SCHUTZSTAFFEL = 50,
		)
	faction_distribution_coeffs = list(GERMAN = 0.5, USA = 0.5)
	battle_name = "Village Battle"
	front = "Western"

/obj/map_metadata/village/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/usa))
		if (J.is_prisoner)
			. = FALSE
	if (istype(J, /datum/job/partisan/civilian))
		J.total_positions = max(round(clients.len), 15)
		if (J.is_occupation)
			. = FALSE
		else
			if (istype(J, /datum/job/partisan/civilian/redcross))
				J.total_positions = 5
	return .
/obj/map_metadata/village/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 4800 || admin_ended_all_grace_periods)

/obj/map_metadata/village/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 4800 || admin_ended_all_grace_periods)

/obj/map_metadata/village/announce_mission_start(var/preparation_time)
	world << "<font size=4>All factions have <b>8 minutes</b> to prepare before combat will begin!</font>"

/obj/map_metadata/village/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())
