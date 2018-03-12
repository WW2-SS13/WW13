/datum/game_mode/ww2
	name = "World War 2"
	config_tag = "WW2"
	#ifdef DEBUG
	required_players = 1
	#else
	required_players = 2
	#endif
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

	var/personnel[2]
	var/supplies[2]

	var/season = "SPRING"

/datum/game_mode/ww2/proc/current_stat_message()
	if (time_both_sides_locked != -1 && !currently_winning)
		return "The round will end in [round(((time_both_sides_locked+time_to_end_round_after_both_sides_locked) - world.realtime)/600)+1] minute(s); both sides are out of reinforcements."
	else if (currently_winning == "Soviets")
		return "The Soviets will win in [round((next_win_time-world.realtime)/600)+1] minute(s)."
	else if (currently_winning == "Germans")
		return "The Germans will win in [round((next_win_time-world.realtime)/600)+1] minute(s)."
	else
		return "Neither side has captured the other's base."

//#define WINTER_TESTING

/datum/game_mode/ww2/pre_setup()
	#ifdef WINTER_TESTING
	season = "WINTER"
	#else
	if (config && config.allowed_seasons && config.allowed_seasons.len)
		switch (config.allowed_seasons[1])
			if (1) // all seasons
				season = pick("SPRING", "SUMMER", "FALL", "WINTER")
			if (0) // no seasons = spring
				season = "SPRING"
			else
				season = pick(config.allowed_seasons)
	else
		season = pick("SPRING", "SUMMER", "FALL", "WINTER")
	#endif

// because we don't use readying up, we override can_start()
/datum/game_mode/ww2/can_start(var/do_not_spawn)

	var/playercount = 0
	for(var/mob/new_player/player in player_list)
		if(player.client)
			++playercount

	if(playercount < required_players)
		return FALSE

	return TRUE

/datum/game_mode/ww2/check_finished(var/round_ending = FALSE)
	if (admins_triggered_noroundend)
		return FALSE // no matter what, don't end
	else if (..() == TRUE)
		return TRUE
	else if (soldiers["de"] > 0 && soldiers["ru"] <= 0 && game_started)
		winning_side = "Wehrmacht"
		return TRUE
	else if (soldiers["ru"] > 0 && soldiers["de"] <= 0 && game_started)
		winning_side = "Red Army"
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

				if (soldiers["ru"] && soldiers["ru"]/1.33 >= soldiers["de"])
					time_to_end_round_after_both_sides_locked = 18000
				else if (soldiers["de"] && soldiers["de"]/1.33 >= soldiers["ru"])
					time_to_end_round_after_both_sides_locked = 18000
				else
					time_to_end_round_after_both_sides_locked = 6000

				world << "<font size = 3>Both sides are locked for reinforcements; the round will end in [time_to_end_round_after_both_sides_locked/600] minutes.</font>"
				return FALSE

		// conditions 2.1 to 2.5: one side has occupied the enemy base

		var/stats = get_soviet_german_stats()

		var/alive_soviets = stats["alive_soviets"]
		var/alive_germans = stats["alive_germans"]

		var/soviets_in_russia = stats["soviets_in_russia"]
		var/soviets_in_germany = stats["soviets_in_germany"]

		var/germans_in_germany = stats["germans_in_germany"]
		var/germans_in_russia = stats["germans_in_russia"]

		// round end conditions

		var/old_currently_winning_message = currently_winning_message

		// condition 2.1: soviets outnumber germans and the amount of
		// soviets in the german base is > than the amount of germans there

		if (alive_soviets > alive_germans && soviets_in_germany > germans_in_germany)
			if (currently_winning != "Soviets" || win_sort != 2)
				currently_winning = "Soviets"
				currently_winning_message = "<font size = 3>The Soviets have occupied most German territory! The Wehrmacht has 5 minutes to reclaim their land!</font>"
				next_win_time = world.realtime + 3000
				win_sort = 2

		// condition 2.2: Germans outnumber soviets and the amount of germans
		// in the soviet base is > than the amount of soviets there

		else if (alive_germans > alive_soviets && germans_in_russia > soviets_in_russia)
			if (currently_winning != "Germans" || win_sort != 2)
				currently_winning = "Germans"
				currently_winning_message = "<font size = 3>The Germans have occupied most Soviet territory! The Red Army has 5 minutes to reclaim their land!</font>"
				next_win_time = world.realtime + 3000
				win_sort = 2

		// condition 2.3: Germans heavily outnumber soviets in the soviet
		// base, regardless of overall numerical superiority/inferiority.
		// they have to hold this position for 10+ minutes

		else if ((germans_in_russia/1.33) > soviets_in_russia)
			if (currently_winning != "Germans" || win_sort != 1)
				currently_winning = "Germans"
				currently_winning_message = "<font size = 3>The Germans have occupied most Soviet territory! The Red Army has 10 minutes to reclaim their land!</font>"
				next_win_time = world.realtime + 6000
				win_sort = 1

		// condition 2.4: soviets heavily outnumber Germans in the German
		// base, regardless of overall numerical superiority/inferiority.
		// they have to hold this position for 10+ minutes

		else if ((soviets_in_germany/1.33) > germans_in_germany)
			if (currently_winning != "Soviets" || win_sort != 1)
				currently_winning = "Soviets"
				currently_winning_message = "<font size = 3>The Soviets have occupied most German territory! The Wehrmacht has 10 minutes to reclaim their land!</font>"
				next_win_time = world.realtime + 6000
				win_sort = 1

		else if (currently_winning)
			currently_winning_message = "<font size = 3>The [currently_winning] have lost control of the territory they occupied!</font>"
			currently_winning = ""
			next_win_time = -1

		if (currently_winning_message != old_currently_winning_message)
			world << currently_winning_message

		if ((world.realtime >= next_win_time && next_win_time != -1) || round_ending || admins_triggered_roundend)

			if (currently_winning == "Soviets" && win_sort == 2)
				if (!win_condition) win_condition = "The Red Army won by outnumbering the Germans and occupying most of their territory, cutting them off from supplies and reinforcements!"
				winning_side = "Red Army"
				return TRUE

			if (currently_winning == "Germans" && win_sort == 2)
				if (!win_condition) win_condition = "The Wehrmacht won by outnumbering the Soviets and occupying most of their territory. The bunker was surrounded and cut off from supplies and reinforcements!"
				winning_side = "Wehrmacht"
				return TRUE

			if (currently_winning == "Soviets" && win_sort == 1)
				if (!win_condition) win_condition = "The Red Army won by occupying and holding German territory, while heavily outnumber the Germans there."
				winning_side = "Red Army"
				return TRUE

			if (currently_winning == "Germans" && win_sort == 1)
				if (!win_condition) win_condition = "The Wehrmacht won by occupying and holding Soviet territory, while heavily outnumber the Soviets there."
				winning_side = "Wehrmacht"
				return TRUE


	if (admins_triggered_roundend)
		return TRUE

	return FALSE

/datum/game_mode/ww2/declare_completion()

	check_finished(TRUE)

	name = "World War 2"

	var/list/soldiers = WW2_soldiers_alive()

	var/text = "<big><span class = 'danger'>The battle has ended.</span></big><br><br>"

	for (var/client/C in clients)
		winset(C, null, "mainwindow.flash=1")

	text += "[soldiers["de"]] Wehrmacht and SS soldiers survived.<br>"
	text += "[soldiers["ru"]] Soviet soldiers survived.<br><br>"

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
/datum/game_mode/ww2/announce() //to be called when round starts

	world << "<b><big>The round has started!</big></b>"
	for (var/client/C in clients)
		winset(C, null, "mainwindow.flash=1")
	// announce after some other stuff, like system setups, are announced
	spawn (3)

	//	new/datum/game_aspect/ww2(src)

	//	spawn (1)
/*			if (aspect)
				aspect.activate()
				aspect.post_activation()*/

			// train might not be set up yet
		//	spawn (100)
			//	job_master.german_job_slots *= personnel[GERMAN]
			//	job_master.soviet_job_slots *= personnel[SOVIET]

				// nerf or buff german supplies by editing the supply train controller
		//		german_supplytrain_master.supply_points_per_second_min *= supplies[GERMAN]
		//		german_supplytrain_master.supply_points_per_second_max *= supplies[GERMAN]

			// nerf or buff soviet supplies by editing crates in Soviet territory.
		/*	spawn (10) // make sure rations are set up?
				for (var/obj/structure/closet/crate/soviet in world)
					if (istype(get_area(soviet), /area/prishtina/soviet))
						soviet.resize(supplies[SOVIET])*/

			// this may have already happened, do it again w/o announce
		setup_autobalance(0)

		// let new players see the join link
		for (var/mob/new_player/np in world)
			if (np.client)
				np.new_player_panel_proc()

		// no tanks on lowpop
		if (!istype(aspect, /datum/game_aspect/ww2/no_tanks))
			if (clients.len <= TANK_LOWPOP_THRESHOLD)
				if (locate(/obj/tank) in world)
					for (var/obj/tank/T in world)
						if (!T.admin)
							qdel(T)
					world << "<i>Due to lowpop, there are no tanks.</i>"

		if (!istype(aspect, /datum/game_aspect/ww2/no_artillery))
			if (clients.len <= ARTILLERY_LOWPOP_THRESHOLD)
				if (locate(/obj/machinery/artillery) in world)
					for (var/obj/machinery/artillery/A in world)
						qdel(A)
					world << "<i>Due to lowpop, there is no artillery.</i>"