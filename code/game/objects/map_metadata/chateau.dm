#define NO_WINNER "No one has won."

/obj/map_metadata/chateau
	ID = MAP_CHATEAU
	title = "Chateau"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall,
	/area/prishtina/no_mans_land/invisible_wall/inside) // above and underground
	respawn_delay = TRUE
	squad_spawn_locations = FALSE
	min_autobalance_players = 100 // aparently less that this will fuck autobalance
	reinforcements = FALSE
	faction_organization = list(
		GERMAN,
		CIVILIAN,
		USA)
	available_subfactions = list(SCHUTZSTAFFEL = 100)
	no_subfaction_chance = FALSE
	subfaction_is_main_faction = TRUE
	roundend_condition_sides = list(
	       list(GERMAN) = /area/prishtina/german/main_area/inside)
	battle_name = "The battle of Chateau"
	faction_distribution_coeffs = list(GERMAN = 0.5, SOVIET = 0.5)


/obj/map_metadata/factory/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 1800 || admin_ended_all_grace_periods)

/obj/map_metadata/factory/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 1800 || admin_ended_all_grace_periods)


/obj/map_metadata/factory/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/usa))
		if (istype(J, /datum/job/usa/soldier))
			J.total_positions = max(6, round(clients.len*4))
		if (istype(J, /datum/job/usa/squad_leader))
			J.total_positions = max(1, round(clients.len*1))
		if (istype(J, /datum/job/usa/medic))
			J.total_positions = max(1, round(clients.len*0.5))
		if (istype(J, /datum/job/usa/MP))
			J.total_positions = max(1, round(clients.len*0.5))
//	else if (istype(J, /datum/job/partisan/civilian))
//		J.total_positions = max(5, round(clients.len*0.75))
	else if (istype(J, /datum/job/german))
		if (istype(J, /datum/job/german/soldier_ss))
			J.total_positions = max(6, round(clients.len*3))
		else if (istype(J, /datum/job/german/medic_ss))
			J.total_positions = max(1, round(clients.len*0.5))
		else if (istype(J, /datum/job/soviet/squad_leader))
			J.total_positions = max(1, round(clients.len*0.5))
		else J.total_positions = 0
	return .

/obj/map_metadata/factory/announce_mission_start(var/preparation_time)
	world << "<font size=4>The Soviets must defende the reactor from the italians </font>"

/obj/map_metadata/factory/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())

	#undef NO_WINNER
