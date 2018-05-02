#define MAP_MODE(x) if (map_mode == x)
#define WARFARE 1
#define NO_WINNER "Neither side has captured the other side's base."
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
	var/subfaction_is_main_faction = FALSE
	var/list/faction_organization = list()
	var/list/faction_distribution_coeffs = list(INFINITY) // list(INFINITY) = no hard locks on factions
	var/list/available_subfactions = list()
	var/list/roundend_condition_sides = list(
		list(GERMAN) = /area/prishtina/german,
		list(SOVIET) = /area/prishtina/soviet)
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

	// stuff ported from removed game mode system
	var/required_players = 2
	var/time_both_sides_locked = -1
	var/time_to_end_round_after_both_sides_locked = 6000
	var/admins_triggered_roundend = FALSE
	var/admins_triggered_noroundend = FALSE

	// win conditions 3.0 - Kachnov
	var/datum/win_condition/win_condition = null
	var/current_win_condition = NO_WINNER
	var/last_win_condition = null // this is a hash
	var/current_winner = null
	var/current_loser = null
	var/next_win = -1

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

	win_condition = new

// called from the map process
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

	update_win_condition()

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

// old game mode stuff
/obj/map_metadata/proc/can_start()

	var/playercount = 0
	var/only_client_is_host = FALSE
	for(var/mob/new_player/player in new_player_mob_list)
		if(player.client)
			if (!player.client.is_minimized())
				++playercount
			if (player.key == world.host)
				only_client_is_host = TRUE

	if(playercount >= required_players || only_client_is_host)
		return TRUE

	return FALSE

/obj/map_metadata/proc/update_win_condition()
	if (world.time >= next_win && next_win != -1)
		ticker.finished = TRUE
		var/message = "The battle was a stalemate!"
		if (current_winner && current_loser)
			message = "The [current_winner] was victorious over the [current_loser]!"
		world << "The round is over! [message]"
		return FALSE
	// German major
	if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The [roundend_condition_def2army(roundend_condition_sides[1][1])] has captured the [roundend_condition_def2name(roundend_condition_sides[2][1])] base! They will win in {time} minute{s}."
				next_win = world.time + short_win_time()
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// German minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The [roundend_condition_def2army(roundend_condition_sides[1][1])] has captured the [roundend_condition_def2name(roundend_condition_sides[2][1])] base! They will win in {time} minute{s}."
				next_win = world.time + long_win_time()
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// Soviet major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The [roundend_condition_def2army(roundend_condition_sides[2][1])] has captured the [roundend_condition_def2name(roundend_condition_sides[1][1])] base! They will win in {time} minute{s}."
				next_win = world.time + short_win_time()
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	// Soviet minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The [roundend_condition_def2army(roundend_condition_sides[2][1])] has captured the [roundend_condition_def2name(roundend_condition_sides[1][1])] base! They will win in {time} minute{s}."
				next_win = world.time + long_win_time()
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	else if (win_condition.check(list("REINFORCEMENTS"), list(), list(), 1.0, TRUE))
		if (last_win_condition != win_condition.hash)
			current_win_condition = "Both sides are out of reinforcements; the round will end in {time} minutes."
			next_win = world.time + long_win_time()
			announce_current_win_condition()
			current_winner = null
			current_loser = null
	else
		if (current_win_condition != NO_WINNER && current_winner && current_loser)
			world << "<font size = 3>The [current_winner] has lost control of the [army2name(current_loser)] base!</font>"
			current_winner = null
			current_loser = null
		current_win_condition = NO_WINNER
		win_condition.hash = 0
	last_win_condition = win_condition.hash
	return TRUE

/obj/map_metadata/proc/next_win_time()
	return round((next_win - world.time)/600)

/obj/map_metadata/proc/current_stat_message()
	var/next_win_time = max(0, next_win_time())
	. = current_win_condition
	. = replacetext(., "{time}", next_win_time)
	if (next_win_time == 1)
		. = replacetext(., "{s}", "")
	else
		. = replacetext(., "{s}", "s")
	return .

/obj/map_metadata/proc/announce_current_win_condition()
	world << "<font size = 3>[current_stat_message()]</font>"

/obj/map_metadata/proc/short_win_time()
	if (clients.len >= 20)
		return 6000 // ten minutes
	else
		return 3000 // five minutes

/obj/map_metadata/proc/long_win_time()
	if (clients.len >= 20)
		return 9000 // 15 minutes
	else
		return 6000 // ten minutes

/obj/map_metadata/proc/roundend_condition_def2name(define)
	switch (define)
		if (GERMAN)
			return "German"
		if (SOVIET)
			return "Soviet"
		if (PILLARMEN)
			return "Undead"

/obj/map_metadata/proc/roundend_condition_def2army(define)
	switch (define)
		if (GERMAN)
			return "Wehrmacht"
		if (SOVIET)
			return "Red Army"
		if (PILLARMEN)
			return "Undead"

/obj/map_metadata/proc/army2name(army)
	switch (army)
		if ("Wehrmacht")
			return "German"
		if ("Red Army")
			return "Soviet"
		if ("Undead")
			return "Undead"

#undef NO_WINNER