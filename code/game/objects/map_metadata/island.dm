/obj/map_metadata/island
	ID = MAP_ISLAND
	title = "Island (100x100x1)"
	lobby_icon_state = "pacific"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall)
	respawn_delay = 2400
	squad_spawn_locations = FALSE
	supply_points_per_tick = list(
		USA = 1.00,
		JAPAN = 1.50)
//	supply_points_per_tick = list(
//		GERMAN = 1.00,
//		SOVIET = 1.50)
	faction_organization = list(
//		GERMAN,
//		SOVIET,
		USA,
		JAPAN,
		PARTISAN,
		CIVILIAN,
		ITALIAN)
	available_subfactions = list(
		)
	faction_distribution_coeffs = list(USA = 0.42, JAPAN = 0.58)
	songs = list(
		"Song of the Kamikaze:1" = 'sound/music/kamikaze.ogg',
		"Blood On the Risers(Gory Gory):1" = 'sound/music/gory.ogg',
		"Battotai:1" = 'sound/music/battotai.ogg',
		"American March:1" = 'sound/music/american_march.ogg',
		)
	meme = FALSE
	battle_name = "Battle of Peleliu"

/obj/map_metadata/island/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 4800 || admin_ended_all_grace_periods)

/obj/map_metadata/island/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 4800 || admin_ended_all_grace_periods)

/obj/map_metadata/island/announce_mission_start(var/preparation_time)
	world << "<font size=4>All factions have <b>8 minutes</b> to prepare before combat will begin!</font>"

/obj/map_metadata/island/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())