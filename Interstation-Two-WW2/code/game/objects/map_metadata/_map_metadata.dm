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
	var/subfaction_is_main_faction = FALSE
	var/list/faction_organization = list()
	var/list/faction_distribution_coeffs = list(INFINITY) // list(INFINITY) = no hard locks on factions
	var/list/available_subfactions = list()
	var/list/roundend_condition_sides = list(
		list(GERMAN),
		list(SOVIET))
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

	// NEW WIN CONDITIONS - Kachnov
	var/currently_winning = ""
	var/currently_winning_message = ""
	var/next_win_time = -1
	var/win_sort = 1
	var/win_condition = ""
	var/winning_side = ""

	var/admins_triggered_roundend = FALSE
	var/admins_triggered_noroundend = FALSE

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

/obj/map_metadata/proc/can_start()

	var/playercount = 0
	var/only_client_is_host = FALSE
	for(var/mob/new_player/player in player_list)
		if(player.client)
			if (!player.client.is_minimized())
				++playercount
			if (player.key == world.host)
				only_client_is_host = TRUE

	if(playercount >= required_players || only_client_is_host)
		return TRUE

	return FALSE

/obj/map_metadata/proc/next_win_time()
	if (time_both_sides_locked != -1 && !currently_winning)
		return max(round(((time_both_sides_locked+time_to_end_round_after_both_sides_locked) - world.realtime)/600),0)
	else if (currently_winning == get_army_people(1))
		return max(round((next_win_time-world.realtime)/600),0)
	else if (currently_winning == get_army_people(2))
		return max(round((next_win_time-world.realtime)/600),0)
	return -1

/obj/map_metadata/proc/current_stat_message()
	if (time_both_sides_locked != -1 && !currently_winning)
		return "Both sides are out of reinforcements; The round will automatically end in [next_win_time()] minute(s) if neither side is victorious."
	else if (currently_winning == get_army_people(1))
		return "The Wehrmacht will win in [next_win_time()] minute(s)."
	else if (currently_winning == get_army_people(2))
		return "The Red Army will win in [next_win_time()] minute(s)."
	else
		return "Neither side has captured the other side's base."

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

/obj/map_metadata/proc/get_soldiers(n)
	var/list/soldiers = WW2_soldiers_alive()
	if (!map)
		switch (n)
			if (-INFINITY to 1)
				return soldiers[GERMAN]
			if (2 to INFINITY)
				return soldiers[SOVIET]
	else
		var/num = 0
		for (var/v in 1 to map.roundend_condition_sides.len)
			if (v == n)
				var/list = map.roundend_condition_sides[v]
				for (var/item in list)
					num += soldiers[item]
		return num
	return 0

/obj/map_metadata/proc/get_army_name(n)
	if (!map)
		switch (n)
			if (-INFINITY to 1)
				return "Wehrmacht"
			if (2 to INFINITY)
				return "Red Army"
	else
		for (var/v in 1 to map.roundend_condition_sides.len)
			if (v == n)
				var/list = map.roundend_condition_sides[v]
				for (var/item in list)
					switch (item)
						if (GERMAN)
							return "Wehrmacht"
						if (SOVIET)
							return "Red Army"
						if (PILLARMEN)
							return "Pillar Men & Vampires"
		return TRUE
	return TRUE

/obj/map_metadata/proc/get_army_people(n)
	switch (get_army_name(n))
		if ("Wehrmacht")
			return "Germans"
		if ("Red Army")
			return "Soviets"
		if ("Pillar Men & Vampires")
			return "Pillar Men & Vampires"


/obj/map_metadata/proc/check_finished(var/round_ending = FALSE)
	if (admins_triggered_noroundend)
		return FALSE // no matter what, don't end
	else if (..() == TRUE)
		return TRUE
	else if (get_soldiers(1) > 0 && get_soldiers(2) <= 0 && game_started)
		winning_side = get_army_name(1)
		return TRUE
	else if (get_soldiers(2) > 0 && get_soldiers(1) <= 0 && game_started)
		winning_side = get_army_name(2)
		return TRUE
	else

		// condition one: both sides have reinforcements locked,
		// wait 10 minutes and see who is doing the best

		if (time_both_sides_locked != -1)
			if (world.realtime - time_both_sides_locked >= time_to_end_round_after_both_sides_locked && !currently_winning)
				return TRUE
		else if (reinforcements_master.is_permalocked(GERMAN))
			if (reinforcements_master.is_permalocked(SOVIET))
				time_both_sides_locked = world.realtime

				if (get_soldiers(2) && get_soldiers(2)/1.33 >= get_soldiers(1))
					time_to_end_round_after_both_sides_locked = 18000
				else if (get_soldiers(1) && get_soldiers(1)/1.33 >= get_soldiers(2))
					time_to_end_round_after_both_sides_locked = 18000
				else
					time_to_end_round_after_both_sides_locked = 6000

				world << "<font size = 3>Both sides are locked for reinforcements; the round will end in [time_to_end_round_after_both_sides_locked/600] minutes or less.</font>"
				return FALSE

		// conditions 2.1 to 2.5: one side has occupied the enemy base

		var/stats = get_stats()

		// todo: change these var names so their function is more obvious

		var/alive_germans = stats["alive_1"]
		var/alive_soviets = stats["alive_2"]

		var/germans_in_germany = stats["1_in_1"]
		var/germans_in_russia = stats["1_in_2"]

		var/soviets_in_germany = stats["2_in_1"]
		var/soviets_in_russia = stats["2_in_2"]

		// round end conditions

		var/old_currently_winning_message = currently_winning_message

		// condition 2.1: soviets outnumber germans and the amount of
		// soviets in the german base is > than the amount of germans there

		if (alive_soviets > alive_germans && soviets_in_germany > germans_in_germany)
			if (currently_winning != get_army_people(2) || win_sort != 2)
				currently_winning = get_army_people(2)
				currently_winning_message = "<font size = 3>The [get_army_name(2)] has occupied most [get_army_people(1)] territory! The [get_army_people(1)]s have [short_win_time()/600] minutes to reclaim their land!</font>"
				next_win_time = world.realtime + short_win_time()
				win_sort = 2

		// condition 2.2: Germans outnumber soviets and the amount of germans
		// in the soviet base is > than the amount of soviets there

		else if (alive_germans > alive_soviets && germans_in_russia > soviets_in_russia)
			if (currently_winning != get_army_people(1) || win_sort != 2)
				currently_winning = get_army_people(1)
				currently_winning_message = "<font size = 3>The [get_army_name(1)] have occupied most [get_army_people(2)] territory! The [get_army_name(2)] has [short_win_time()/600] minutes to reclaim their land!</font>"
				next_win_time = world.realtime + short_win_time()
				win_sort = 2

		// condition 2.3: Germans heavily outnumber soviets in the soviet
		// base, regardless of overall numerical superiority/inferiority.
		// they have to hold this position for 10+ minutes

		else if ((germans_in_russia/1.33) > soviets_in_russia)
			if (currently_winning != get_army_people(1) || win_sort != 1)
				currently_winning = get_army_people(1)
				currently_winning_message = "<font size = 3>The [get_army_name(1)] have occupied most [get_army_people(2)] territory! The [get_army_name(2)] has [long_win_time()/600] minutes to reclaim their land!</font>"
				next_win_time = world.realtime + long_win_time()
				win_sort = 1

		// condition 2.4: soviets heavily outnumber Germans in the German
		// base, regardless of overall numerical superiority/inferiority.
		// they have to hold this position for 10+ minutes

		else if ((soviets_in_germany/1.33) > germans_in_germany)
			if (currently_winning != get_army_people(2) || win_sort != 1)
				currently_winning = get_army_people(2)
				currently_winning_message = "<font size = 3>The [get_army_name(2)] has occupied most [get_army_people(1)] territory! The [get_army_name(1)] has [long_win_time()/600] minutes to reclaim their land!</font>"
				next_win_time = world.realtime + long_win_time()
				win_sort = 1

		else if (currently_winning)
			currently_winning_message = "<font size = 3>The [currently_winning] have lost control of the territory they occupied!</font>"
			currently_winning = ""
			next_win_time = -1

		if (currently_winning_message != old_currently_winning_message)
			world << currently_winning_message

		if ((world.realtime >= next_win_time && next_win_time != -1) || round_ending || admins_triggered_roundend)

			if (currently_winning == get_army_people(2) && win_sort == 2)
				if (!win_condition) win_condition = "The [get_army_name(2)] won by outnumbering the [get_army_people(1)]s and occupying most of their territory, cutting them off from supplies and reinforcements!"
				winning_side = get_army_name(2)
				return TRUE

			if (currently_winning == get_army_people(1) && win_sort == 2)
				if (!win_condition) win_condition = "The [get_army_name(1)] won by outnumbering the [get_army_name(2)] and occupying most of their territory. The [get_army_people(2)] base was surrounded and cut off from supplies and reinforcements!"
				winning_side = get_army_name(1)
				return TRUE

			if (currently_winning == get_army_people(2) && win_sort == 1)
				if (!win_condition) win_condition = "The [get_army_name(2)] won by occupying and holding [get_army_people(1)] territory, while heavily outnumber the [get_army_people(1)]s there."
				winning_side = get_army_name(2)
				return TRUE

			if (currently_winning == get_army_people(1) && win_sort == 1)
				if (!win_condition) win_condition = "The [get_army_name(1)] won by occupying and holding [get_army_people(2)] territory, while heavily outnumber the [get_army_people(2)]s there."
				winning_side = get_army_name(1)
				return TRUE

	if (admins_triggered_roundend)
		return TRUE

	return FALSE

/obj/map_metadata/proc/declare_completion()

	// automatically show the battle report after 5 seconds
	if (battlereport)
		battlereport.BR_ticks = battlereport.max_BR_ticks - 5

	name = "World War 2"

	var/text = "<big><span class = 'danger'>The battle has ended.</span></big><br><br>"

	for (var/client/C in clients)
		winset(C, null, "mainwindow.flash=1")

	if (map)
		// German
		if (map.available_subfactions.Find(SCHUTZSTAFFEL))
			text += "[n_of_side(GERMAN)] Wehrmacht and SS soldiers survived.<br>"
		else if (map.available_subfactions.Find(ITALIAN))
			text += "[n_of_side(GERMAN) + n_of_side(ITALIAN)] Wehrmacht and Italian soldiers survived.<br>"
		else
			text += "[n_of_side(GERMAN)] Wehrmacht soldiers survived.<br>"

		// Soviet
		if (map.available_subfactions.Find(SOVIET))
			text += "[n_of_side(SOVIET)] Soviet soldiers survived.<br><br>"

		// Undead
		if (map.available_subfactions.Find(PILLARMEN))
			text += "[n_of_side(PILLARMEN)] undead survived.<br><br>"

		// Civilians
		if (map.available_subfactions.Find(CIVILIAN))
			text += "[n_of_side(CIVILIAN)] survived.<br><br>"

		// Partisans
		if (map.available_subfactions.Find(PARTISAN))
			text += "[n_of_side(PARTISAN)] survived.<br><br>"

	if (winning_side)
		text += "<big><span class = 'danger'>The [winning_side] is victorious!</span></big><br><br>"
	else
		text += "<big><span class = 'danger'>Neither side wins.</span></big><br><br>"

	if (win_condition)
		text += "<big>[win_condition]</big>"
	else
		if (winning_side)
			text += "<big><i>The [winning_side] won by a war of attrition.</i></big>"

	world << text

	for (var/client/client in clients)
		client << "<br>"

	ticker.finished = TRUE