/obj/map_metadata/forest
	ID = MAP_FOREST
	title = "Forest (200x529x1)"
	prishtina_blocking_area_types = list(
		/area/prishtina/forest/north/invisible_wall,
		/area/prishtina/forest/south/invisible_wall)
	uses_supply_train = TRUE
	uses_main_train = TRUE
	supply_points_per_tick = list(
		SOVIET = 1.00,
		GERMAN = 1.50)
	ambience = list('sound/ambience/war.ogg')

/obj/map_metadata/forest/New()
	MAP_MODE(MODE_WAR)
		faction_organization = list(
			GERMAN,
			SOVIET,
			PARTISAN,
			CIVILIAN,
			ITALIAN)
		available_subfactions = list(
			SCHUTZSTAFFEL,
			ITALIAN)
		faction_distribution_coeffs = list(GERMAN = 0.42, SOVIET = 0.58)
	..()

/obj/map_metadata/forest/germans_can_cross_blocks()
	return (mission_announced || admin_ended_all_grace_periods)

/obj/map_metadata/forest/soviets_can_cross_blocks()
	return ((mission_announced && train_arrived) || admin_ended_all_grace_periods)

/obj/map_metadata/forest/announce_mission_start(var/preparation_time = FALSE)
	world << "<font size=4>The German assault has started after <b>[preparation_time / 600] minutes</b> of preparation. The Soviet side may not attack until after <b>7 minutes</b>.</font><br>"