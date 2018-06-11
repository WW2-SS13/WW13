/obj/map_metadata/tower
	ID = MAP_TOWER
	title = "Tower (100x100x1)"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall)
	respawn_delay = 1200
	squad_spawn_locations = FALSE
	supply_points_per_tick = list(
		GERMAN = 1.00,
		SOVIET = 1.50)
	faction_organization = list(
		GERMAN,
		SOVIET)
	available_subfactions = list()
	faction_distribution_coeffs = list(GERMAN = 0.42, SOVIET = 0.58)
	battle_name = "City Battle"

/obj/map_metadata/tower/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 4800 || admin_ended_all_grace_periods)

/obj/map_metadata/tower/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 4800 || admin_ended_all_grace_periods)

/obj/map_metadata/tower/announce_mission_start(var/preparation_time)
	world << "<font size=4>All factions have <b>8 minutes</b> to prepare before combat will begin!</font>"

/obj/map_metadata/tower/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())