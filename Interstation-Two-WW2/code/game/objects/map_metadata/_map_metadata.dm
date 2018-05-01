#define MAP_MODE(x) if (map_mode == x)
#define WARFARE 1
var/map_mode = WARFARE

var/global/obj/map_metadata/map = null

/obj/map_metadata
	name = ""
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = TRUE
	simulated = FALSE
	invisibility = 101
	var/ID = null // MUST be text, or aspects will break
	var/title = null
	var/lobby_icon_state = "1"
	var/list/prishtina_blocking_area_types = list()
	var/last_crossing_block_status[3]
	var/admin_ended_all_grace_periods = FALSE
	var/uses_supply_train = FALSE
	var/uses_main_train = FALSE
	var/event_faction = null
	var/min_autobalance_players = 0
	var/respawn_delay = 3000
	var/list/valid_weather_types = list(WEATHER_RAIN, WEATHER_SNOW)
	var/reinforcements = TRUE
	var/squad_spawn_locations = TRUE
	var/list/supply_points_per_tick = list(
		GERMAN = 1.00,
		SOVIET = 1.00)
	var/character_arrival_announcement_time = 10
	var/katyushas = TRUE
	var/no_subfaction_chance = TRUE
	var/list/faction_organization = list()
	var/list/faction_distribution_coeffs = list(INFINITY) // list(INFINITY) = no hard locks on factions
	var/list/available_subfactions = list()
	var/list/ambience = list()
	var/list/songs = list(
		"Bots - Was Wollen Wir Trinken (Harcourt Edit):1" = 'sound/music/BotsWaswollenwirtrinkenWehrmachtHarcourt.ogg',
		"ERIKA:1" = 'sound/music/ERIKA.ogg',
		"Fallschirmjager Lied:1" = 'sound/music/Fallschirmjager_lied_German_paratrooper_song.ogg',
		"Farewell of Slavianka:1" = 'sound/music/FarewellofSlavianka.ogg',
		"Katyusha:1" = 'sound/music/katyusha.ogg',
		"Smuglianka:1" = 'sound/music/smuglianka.ogg',
		"SS Marschiert in Feindesland:1" = 'sound/music/SSmarschiertinFeindesland.ogg',
		"Latvian SS Anthem:1" = 'sound/music/latvianss.ogg',
		"r2.ogg:1" = 'sound/music/r2.ogg')

/obj/map_metadata/New()
	..()
	map = src
	icon = null
	icon_state = null

	if (no_subfaction_chance)
		if (available_subfactions.len)
			switch (available_subfactions.len)
				if (1) // this may be necessary due to sprob() memes - Kachnov
					if (prob(50))
						available_subfactions = list(available_subfactions[1])
					else
						available_subfactions = list()
				if (2 to INFINITY)
					if (sprob(100 - round((100/(available_subfactions.len+1)))))
						available_subfactions = list(available_subfactions[srand(1, available_subfactions.len)])
					else
						available_subfactions = list()

// called from the ticker process
/obj/map_metadata/proc/tick()
	if (last_crossing_block_status[GERMAN] == FALSE)
		if (germans_can_cross_blocks())
			world << cross_message(GERMAN)
			// let new players see the reinforcements links
			for (var/mob/new_player/np in world)
				if (np.client)
					np.new_player_panel_proc()

	else if (last_crossing_block_status[GERMAN] == TRUE)
		if (!germans_can_cross_blocks())
			world << reverse_cross_message(GERMAN)
			// let new players see the reinforcements links
			for (var/mob/new_player/np in world)
				if (np.client)
					np.new_player_panel_proc()

	if (last_crossing_block_status[SOVIET] == FALSE)
		if (soviets_can_cross_blocks())
			world << cross_message(SOVIET)
			// let new players see the reinforcements links
			for (var/mob/new_player/np in world)
				if (np.client)
					np.new_player_panel_proc()

	else if (last_crossing_block_status[SOVIET] == TRUE)
		if (!soviets_can_cross_blocks())
			world << reverse_cross_message(SOVIET)
			// let new players see the reinforcements links
			for (var/mob/new_player/np in world)
				if (np.client)
					np.new_player_panel_proc()

	if (last_crossing_block_status[event_faction] == FALSE)
		if (specialfaction_can_cross_blocks())
			world << cross_message(event_faction)
	else if (last_crossing_block_status[event_faction] == TRUE)
		if (!specialfaction_can_cross_blocks())
			world << reverse_cross_message(event_faction)

	last_crossing_block_status[GERMAN] = germans_can_cross_blocks()
	last_crossing_block_status[SOVIET] = soviets_can_cross_blocks()

	if (event_faction)
		last_crossing_block_status[event_faction] = specialfaction_can_cross_blocks()

/obj/map_metadata/proc/check_prishtina_block(var/mob/living/carbon/human/H, var/turf/T)
	if (!istype(H) || !istype(T))
		return FALSE
	var/area/A = get_area(T)
	if (prishtina_blocking_area_types.Find(A.type))
		if (!H.original_job)
			return FALSE
		else
			switch (H.original_job.base_type_flag())
				if (PARTISAN, CIVILIAN, SOVIET)
					return !soviets_can_cross_blocks()
				if (GERMAN, ITALIAN)
					return !germans_can_cross_blocks()
				if (PILLARMEN)
					return !specialfaction_can_cross_blocks()
	return FALSE

/obj/map_metadata/proc/soviets_can_cross_blocks()
	return TRUE

/obj/map_metadata/proc/germans_can_cross_blocks()
	return TRUE

/obj/map_metadata/proc/specialfaction_can_cross_blocks()
	return TRUE

/obj/map_metadata/proc/announce_mission_start(var/preparation_time = FALSE)
	return TRUE

/obj/map_metadata/proc/game_really_started()
	return (soviets_can_cross_blocks() && germans_can_cross_blocks())

/obj/map_metadata/proc/job_enabled_specialcheck(var/datum/job/J)
	return TRUE

/obj/map_metadata/proc/cross_message(faction)
	return "<font size = 4>The [faction_const2name(faction)] may now cross the invisible wall!</font>"

/obj/map_metadata/proc/reverse_cross_message(faction)
	return "<span class = 'userdanger'>The [faction_const2name(faction)] may no longer cross the invisible wall!</span>"

/obj/map_metadata/proc/reinforcements_ready()
	return game_started