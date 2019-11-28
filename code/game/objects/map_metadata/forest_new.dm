/obj/map_metadata/forest_new
	ID = MAP_FOREST
	title = "River (150x150x1)"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall)
	respawn_delay = 2400
	reinforcements = FALSE
	squad_spawn_locations = FALSE
	supply_points_per_tick = list(
		GERMAN = 1.00,
		SOVIET = 1.00)
	faction_organization = list(
		GERMAN,
		SOVIET)
	faction_distribution_coeffs = list(GERMAN = 0.42, SOVIET = 0.58)
	battle_name = "Battle of the River"

/obj/map_metadata/forest_new/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 9000 || admin_ended_all_grace_periods)

/obj/map_metadata/forest_new/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 9000 || admin_ended_all_grace_periods)

/obj/map_metadata/forest_new/announce_mission_start(var/preparation_time)
	world << "<font size=4>All factions have <b>15 minutes</b> to prepare before combat will begin!</font>"

/obj/map_metadata/forest_new/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())

/obj/map_metadata/forest_new/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/german))
		if (istype(J, /datum/job/german/soldier))
			J.total_positions = 12
		else if (istype(J, /datum/job/german/commander))
			J.total_positions = 1
		else if (istype(J, /datum/job/german/staff_officer))
			J.total_positions = 1
		else if (istype(J, /datum/job/german/QM))
			J.total_positions = 1
		else if (istype(J, /datum/job/german/squad_leader))
			J.total_positions = 3
		else if (istype(J, /datum/job/german/medic))
			J.total_positions = 3
		else if (istype(J, /datum/job/german/doctor))
			J.total_positions = 1
		else if (istype(J, /datum/job/german/sniper))
			J.total_positions = 2
		else if (istype(J, /datum/job/german/messenger))
			J.total_positions = 2
		else if (istype(J, /datum/job/german/heavy_weapon))
			J.total_positions = 6
		else if (istype(J, /datum/job/german/engineer))
			J.total_positions = 3
		else
			. = FALSE
	else if (istype(J, /datum/job/soviet))
		if (istype(J, /datum/job/soviet/soldier))
			J.total_positions = 15
		else if (istype(J, /datum/job/soviet/commander))
			J.total_positions = 1
		else if (istype(J, /datum/job/soviet/staff_officer))
			J.total_positions = 1
		else if (istype(J, /datum/job/soviet/QM))
			J.total_positions = 1
		else if (istype(J, /datum/job/soviet/squad_leader))
			J.total_positions = 3
		else if (istype(J, /datum/job/soviet/medic))
			J.total_positions = 3
		else if (istype(J, /datum/job/soviet/doctor))
			J.total_positions = 1
		else if (istype(J, /datum/job/soviet/sniper))
			J.total_positions = 2
		else if (istype(J, /datum/job/soviet/messenger))
			J.total_positions = 1
		else if (istype(J, /datum/job/soviet/heavy_weapon))
			J.total_positions = 6
		else if (istype(J, /datum/job/soviet/engineer))
			J.total_positions = 1
		else
			. = FALSE
	else
		. = FALSE
	return .
#define NO_WINNER "Neither side has captured the other's base."
