#define NO_WINNER "No one has won."


/obj/map_metadata/survival
	ID = MAP_SURVIVAL
	title = "Thicket"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall,
	/area/prishtina/no_mans_land/invisible_wall/inside) // above and underground
	respawn_delay = 100
	squad_spawn_locations = FALSE
	min_autobalance_players = 100 // aparently less that this will fuck autobalance
	reinforcements = FALSE
	faction_organization = list(
		ITALIAN,
		GERMAN,
		SOVIET)
	available_subfactions = list(ITALIAN = 100)
	no_subfaction_chance = FALSE
	subfaction_is_main_faction = TRUE
	roundend_condition_sides = list(
	       list(ITALIAN) = /area/prishtina/italian_base,
	       list(GERMAN) = /area/prishtina/italian_base,
	       list(SOVIET) = /area/prishtina/soviet)
	available_subfactions = list(ITALIAN)
	battle_name = "Soviet Thicket"
	faction_distribution_coeffs = list(GERMAN = 0.5, SOVIET = 0.5)


/obj/map_metadata/survival/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 1800 || admin_ended_all_grace_periods)

/obj/map_metadata/survival/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 1800 || admin_ended_all_grace_periods)


/obj/map_metadata/survival/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/italian))
		if (istype(J, /datum/job/italian/soldier))
			J.total_positions = max(5, round(clients.len*3))
		if (istype(J, /datum/job/italian/squad_leader))
			J.total_positions = max(1, round(clients.len*0.5))
		if (istype(J, /datum/job/italian/medic))
			J.total_positions = max(1, round(clients.len*0.5))
//	else if (istype(J, /datum/job/partisan/civilian))
//		J.total_positions = max(5, round(clients.len*0.75))
	else if (istype(J, /datum/job/soviet))
		if (istype(J, /datum/job/soviet/soldier))
			J.total_positions = max(5, round(clients.len*3))
		else if (istype(J, /datum/job/soviet/medic))
			J.total_positions = max(1, round(clients.len*0.5))
		else if (istype(J, /datum/job/soviet/squad_leader))
			J.total_positions = max(1, round(clients.len*0.5))
		else
			. = FALSE
	else if (istype(J, /datum/job/german))
		. = FALSE
	return .

/obj/map_metadata/survival/announce_mission_start(var/preparation_time)
	world << "<font size=4>The battle begins!</font>"

/obj/map_metadata/survival/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())

	#undef NO_WINNER
