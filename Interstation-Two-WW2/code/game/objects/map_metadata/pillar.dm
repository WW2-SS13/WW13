/obj/map_metadata/pillar
	ID = MAP_PILLAR
	title = "Pillar (70x70x2)"
	lobby_icon_state = "stroheim"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall/inside)
	event_faction = PILLARMEN
	min_autobalance_players = 100
	respawn_delay = 0
	valid_weather_types = list()
	reinforcements = FALSE
	no_subfaction_chance = FALSE
	subfaction_is_main_faction = TRUE
	roundend_condition_sides = list(
		list(GERMAN) = /area/prishtina/german/bunker, // faster than /area/prishtina/german, less subtypess - Kachnov
		list(PILLARMEN) = /area/prishtina/sewers)
	ambience = list()
	times_of_day = list("Midday")
	zlevels_without_lighting = list(2)
	areas_without_lighting = list(/area/prishtina/german/lift/down)
	songs = list(
		"Pa Pa Tu Tu Wa Wa:1" = 'sound/music/papatutu.ogg',
		"Awaken:1" = 'sound/music/awaken.ogg',
		"Blackout Crew - Dialled:1" = 'sound/music/dialled.ogg',
		"Propaganda:1" = 'sound/music/propaganda.ogg',
		"Cornered:1" = 'sound/music/cornered.ogg')
	var/modded_num_of_SS = FALSE

/obj/map_metadata/pillar/New()
	MAP_MODE(MODE_WAR)
		faction_organization = list(
			GERMAN,
			PILLARMEN)
		available_subfactions = list(
			SCHUTZSTAFFEL)
	..()

/obj/map_metadata/pillar/germans_can_cross_blocks()
	return (tickerProcess.playtime_elapsed >= 6000 || admin_ended_all_grace_periods)

/obj/map_metadata/pillar/soviets_can_cross_blocks()
	return FALSE

/obj/map_metadata/pillar/specialfaction_can_cross_blocks()
	return (tickerProcess.playtime_elapsed >= 9000)

/obj/map_metadata/pillar/announce_mission_start(var/preparation_time)
	world << "<font size=4>The <b>Waffen SS</b> may attack after 10 minutes. The <b>Pillar Men</b> and <b>Vampires</b> may not attack until after 15 minutes.</font>"

/obj/map_metadata/pillar/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/german))
		if (!J.is_SS)
			. = FALSE
		else
			if (istype(J, /datum/job/german/soldier_ss) && !modded_num_of_SS)
				J.total_positions *= 16
				modded_num_of_SS = TRUE
	else if (istype(J, /datum/job/pillarman/pillarman))
		J.total_positions = max(1, round(clients.len/15))
	else if (istype(J, /datum/job/pillarman/vampire))
		J.total_positions = max(4, round(clients.len/7))

	return .

/obj/map_metadata/pillar/cross_message(faction)
	if (faction == GERMAN)
		return "<font size = 4>The Waffen-SS may now attack! Get on the elevator and invade the sewers!</font>"
	return "<font size = 4>The [faction_const2name(faction)] may now cross the invisible wall!</font>"