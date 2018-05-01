#define TANK_LOWPOP_THRESHOLD 12
#define ARTILLERY_LOWPOP_THRESHOLD 15

/datum/game_mode/WW2
	name = "World War 2"
	config_tag = "WW2"
	required_players = 2
	round_description = ""
	extended_round_description = ""

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

/datum/game_mode/WW2/proc/next_win_time()
	if (time_both_sides_locked != -1 && !currently_winning)
		return max(round(((time_both_sides_locked+time_to_end_round_after_both_sides_locked) - world.realtime)/600),0)
	else if (currently_winning == get_army_people(1))
		return max(round((next_win_time-world.realtime)/600),0)
	else if (currently_winning == get_army_people(2))
		return max(round((next_win_time-world.realtime)/600),0)
	return -1

/datum/game_mode/WW2/proc/current_stat_message()
	if (time_both_sides_locked != -1 && !currently_winning)
		return "Both sides are out of reinforcements; The round will automatically end in [next_win_time()] minute(s) if neither side is victorious."
	else if (currently_winning == get_army_people(1))
		return "The Wehrmacht will win in [next_win_time()] minute(s)."
	else if (currently_winning == get_army_people(2))
		return "The Red Army will win in [next_win_time()] minute(s)."
	else
		return "Neither side has captured the other side's base."

/datum/game_mode/WW2/proc/short_win_time()
	if (clients.len >= 20)
		return 6000 // ten minutes
	else
		return 3000 // five minutes

/datum/game_mode/WW2/proc/long_win_time()
	if (clients.len >= 20)
		return 9000 // 15 minutes
	else
		return 6000 // ten minutes

/datum/game_mode/WW2/proc/get_soldiers(n)
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

/datum/game_mode/WW2/proc/get_army_name(n)
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

/datum/game_mode/WW2/proc/get_army_people(n)
	switch (get_army_name(n))
		if ("Wehrmacht")
			return "Germans"
		if ("Red Army")
			return "Soviets"
		if ("Pillar Men & Vampires")
			return "Pillar Men & Vampires"

//#define WINTER_TESTING

/datum/game_mode/WW2/pre_setup()
	#ifdef WINTER_TESTING
	season = "WINTER"
	#else
	if (config && config.allowed_seasons && config.allowed_seasons.len)
		switch (config.allowed_seasons[1])
			if (1) // all seasons
				season = spick("SPRING", "SUMMER", "FALL", "WINTER")
			if (0) // no seasons = spring
				season = "SPRING"
			else
				season = spick(config.allowed_seasons)
	else
		season = spick("SPRING", "SUMMER", "FALL", "WINTER")
	#endif

// because we don't use readying up, we override can_start()
/datum/game_mode/WW2/can_start(var/do_not_spawn)

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

/datum/game_mode/WW2/check_finished(var/round_ending = FALSE)
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

		var/stats = map ? map.get_stats() : get_stats()

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

/datum/game_mode/WW2/declare_completion()

	// automatically show the battle report after 5 seconds
	if (battlereport)
		battlereport.BR_ticks = battlereport.max_BR_ticks - 5

	check_finished(TRUE)

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

// todo: aspect recode
/datum/game_mode/WW2/announce() //to be called when round starts

	world << "<b><big>The round has started!</big></b>"
	for (var/client/C in clients)
		winset(C, null, "mainwindow.flash=1")
	supply_codes[GERMAN] = srand(1000,9999)
	supply_codes[SOVIET] = srand(1000,9999)
	// announce after some other stuff, like system setups, are announced
	spawn (3)

		// this may have already happened, do it again w/o announce
		setup_autobalance(0)

		// let new players see the join link
		for (var/mob/new_player/np in world)
			if (np.client)
				np.new_player_panel_proc()

		// no tanks on lowpop
		if (clients.len <= TANK_LOWPOP_THRESHOLD)
			if (locate(/obj/tank) in world)
				for (var/obj/tank/T in world)
					if (!T.admin)
						qdel(T)
				world << "<i>Due to lowpop, there are no tanks.</i>"

		if (clients.len <= ARTILLERY_LOWPOP_THRESHOLD)
			for (var/obj/structure/artillery/A in world)
				qdel(A)
			for (var/obj/structure/closet/crate/artillery/C in world)
				qdel(C)
			for (var/obj/structure/closet/crate/artillery_gas/C in world)
				qdel(C)
			if (map)
				german_supply_crate_types -= "7,5 cm FK 18 Artillery Piece"
				german_supply_crate_types -= "Artillery Ballistic Shells Crate"
				german_supply_crate_types -= "Artillery Gas Shells Crate"
				map.katyushas = FALSE
			for (var/obj/structure/mortar/M in world)
				qdel(M)
			for (var/obj/item/weapon/shovel/spade/mortar/S in world)
				qdel(S)
			for (var/obj/structure/closet/crate/mortar_shells/C in world)
				qdel(C)
			if (map)
				german_supply_crate_types -= "Mortar Shells"
				soviet_supply_crate_types -= "Mortar Shells"
				soviet_supply_crate_types -= "37mm Spade Mortar"
			world << "<i>Due to lowpop, there is no artillery or mortars.</i>"

		if (clients.len <= 12)
			for (var/obj/structure/simple_door/key_door/soviet/QM/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/soviet/medic/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/soviet/engineer/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/german/QM/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/german/medic/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/german/engineer/D in world)
				D.Open()
			world << "<b>Due to lowpop, some doors have started open.</b>"