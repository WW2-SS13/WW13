/datum/game_mode/ww2
	name = "World War 2"
	config_tag = "WW2"
	#ifdef DEBUG
	required_players = TRUE
	#else
	required_players = 2
	#endif
	round_description = ""
	extended_round_description = ""

	var/time_both_sides_locked = -1
	var/german_win_coeff = 1.1 // germans gets S.S.
	var/soviet_win_coeff = 1.0 // and soviets don't

	var/cond_2_1_check1 = FALSE
	var/cond_2_1_nextcheck = -1

	var/cond_2_2_check1 = FALSE
	var/cond_2_2_nextcheck = -1

	var/cond_2_3_check1 = FALSE
	var/cond_2_3_nextcheck = -1

	var/cond_2_4_check1 = FALSE
	var/cond_2_4_nextcheck = -1

	var/win_condition = ""
	var/winning_side = ""

	var/admins_triggered_roundend = FALSE
	var/admins_triggered_noroundend = FALSE

	var/personnel[2]
	var/supplies[2]

	var/season = "SPRING"

//#define WINTER_TESTING

/datum/game_mode/ww2/pre_setup()
	#ifdef WINTER_TESTING
	season = "WINTER"
	#else
	season = pick("SPRING", "SUMMER", "FALL", "WINTER")
	#endif

// because we don't use readying up, we override can_start()
/datum/game_mode/ww2/can_start(var/do_not_spawn)

	var/playerC = FALSE
	for(var/mob/new_player/player in player_list)
		if(player.client)
			playerC++

	if(playerC < required_players)
		return FALSE

	if(!(antag_templates && antag_templates.len))
		return TRUE

	var/enemy_count = FALSE
	if(antag_tags && antag_tags.len)
		for(var/antag_tag in antag_tags)
			var/datum/antagonist/antag = all_antag_types[antag_tag]
			if(!antag)
				continue
			var/list/potential = list()
			if(antag.flags & ANTAG_OVERRIDE_JOB)
				potential = antag.pending_antagonists
			else
				potential = antag.candidates
			if(islist(potential))
				if(require_all_templates && potential.len < antag.initial_spawn_req)
					return FALSE
				enemy_count += potential.len
				if(enemy_count >= required_enemies)
					return TRUE
	return FALSE

// win conditions for one side already exist, make sure we
// don't active another
/datum/game_mode/ww2/proc/trying_to_win()
	return (cond_2_1_check1 || cond_2_2_check1 || cond_2_3_check1 || cond_2_4_check1)

/datum/game_mode/ww2/check_finished()
	if (admins_triggered_noroundend)
		return FALSE // no matter what, don't end
	else if (..() == TRUE || admins_triggered_roundend)
		return TRUE
	else if (WW2_soldiers_en_ru_ratio() == 1000 && game_started)
		winning_side = "German Army"
		return TRUE
	else if (WW2_soldiers_en_ru_ratio() == TRUE/1000 && game_started)
		winning_side = "Soviet Army"
		return TRUE
	else

		// condition one: both sides have reinforcements locked,
		// wait 10 minutes and see who is doing the best

		if (time_both_sides_locked != -1)
			if (world.timeofday - time_both_sides_locked >= 6000)
				return TRUE
		else if (reinforcements_master.is_permalocked(GERMAN))
			if (reinforcements_master.is_permalocked(SOVIET))
				time_both_sides_locked = world.timeofday
				world << "<font size = 3>Both sides are locked for reinforcements; the round will end in 10 minutes.</font>"
				return FALSE

		// conditions 2.1 to 2.5: one side has occupied the enemy base

		var/stats = get_soviet_german_stats()

		var/alive_soviets = stats["alive_soviets"]
		var/alive_germans = stats["alive_germans"]

		var/soviets_in_russia = stats["soviets_in_russia"]
		var/soviets_in_germany = stats["soviets_in_germany"]

		var/germans_in_germany = stats["germans_in_germany"]
		var/germans_in_russia = stats["germans_in_russia"]

		// the conditions below have multiple checks
		// check1 occurs every time this proc is called (once a tick?)
		// check2 occurs once every five-ten minutes

		// condition 2.1: soviets outnumber germans and the amount of
		// soviets in the german base is > than the amount of germans there

		if (alive_soviets > alive_germans)
			if (soviets_in_germany > germans_in_germany && !cond_2_1_check1 && !trying_to_win())
				cond_2_1_check1 = TRUE
				cond_2_1_nextcheck = world.timeofday + 3000
				world << "<font size = 3>The Soviets have occupied most German territory! The German Army has 5 minutes to reclaim their land!</font>"
				return FALSE
		else
			if (cond_2_1_check1 == TRUE) // soviets lost control!
				if(cond_2_1_nextcheck < world.timeofday + 2400)
					world << "<font size = 3>The Soviets have lost control of the German territory they occupied!</font>"
				else
					return

			cond_2_1_check1 = FALSE

		// condition 2.2: Germans outnumber soviets and the amount of germans
		// in the soviet base is > than the amount of soviets there

		if (alive_germans > alive_soviets)
			if (germans_in_russia > soviets_in_russia && !cond_2_2_check1 && !trying_to_win())
				cond_2_2_check1 = TRUE
				cond_2_2_nextcheck = world.timeofday + 3000
				world << "<font size = 3>The Germans have occupied most Soviet territory! The Soviet Army has 5 minutes to reclaim their land!</font>"
				return FALSE
		else
			if (cond_2_2_check1 == TRUE) // germans lost control!
				if(cond_2_2_nextcheck < world.timeofday + 2400)
					world << "<font size = 3>The Germans have lost control of the Soviet territory they occupied!</font>"
				else
					return

			cond_2_2_check1 = FALSE

		// condition 2.3: Germans heavily outnumber soviets in the soviet
		// base, regardless of general numerical superiority/inferiority.
		// they have to hold this position for 10+ minutes

		if ((germans_in_russia/1.33) > soviets_in_russia && !trying_to_win())
			if(!cond_2_3_check1)
				cond_2_3_check1 = TRUE
				cond_2_3_nextcheck = world.timeofday + 6000
				world << "<font size = 3>The Germans have occupied most Soviet territory! The Soviet Army has 10 minutes to reclaim their land!</font>"
				return FALSE
		else
			if (cond_2_3_check1 == TRUE) // soviets lost control!
				if(cond_2_3_nextcheck < world.timeofday + 5400)
					world << "<font size = 3>The Germans have lost control of the Soviet territory they occupied!</font>"
				else
					return

			cond_2_3_check1 = FALSE

		// condition 2.4: soviets heavily outnumber Germans in the German
		// base, regardless of general numerical superiority/inferiority.
		// they have to hold this position for 10+ minutes

		if ((soviets_in_germany/1.33) > germans_in_germany && !trying_to_win())
			if(!cond_2_4_check1)
				cond_2_4_check1 = TRUE
				cond_2_4_nextcheck = world.timeofday + 6000
				world << "<font size = 3>The Soviets have occupied most German territory! The German Army has 10 minutes to reclaim their land!</font>"
				return FALSE
		else
			if (cond_2_4_check1 == TRUE) // soviets lost control!
				if(cond_2_4_nextcheck < world.timeofday + 5400)
					world << "<font size = 3>The Soviets have lost control of the German territory they occupied!</font>"
				else
					return

			cond_2_4_check1 = FALSE

		if (cond_2_1_check1 && world.timeofday >= cond_2_1_nextcheck && cond_2_1_nextcheck != -1) // condition 2.1 completed
			if (!win_condition) win_condition = "The Soviet Army won by outnumbering the Germans and occupying most of their territory, cutting them off from supplies!"
			winning_side = "Soviet Army"
			return TRUE

		if (cond_2_2_check1 && world.timeofday >= cond_2_2_nextcheck && cond_2_2_nextcheck != -1) // condition 2.2 completed
			if (!win_condition) win_condition = "The German Army won by outnumbering the Soviets and occupying most of their territory. The bunker was surrounded and cut off from reinforcements!"
			winning_side = "German Army"
			return TRUE

		if (cond_2_3_check1 && world.timeofday >= cond_2_3_nextcheck && cond_2_3_nextcheck != -1) // condition 2.3 completed
			if (!win_condition) win_condition = "The German Army won by occupying and holding Soviet territory, while heavily outnumber the Soviets there."
			winning_side = "German Army"
			return TRUE

		if (cond_2_4_check1 && world.timeofday >= cond_2_4_nextcheck && cond_2_4_nextcheck != -1) // condition 2.4 completed
			if (!win_condition) win_condition = "The Soviet Army won by occupying and holding German territory, while heavily outnumber the Germans there."
			winning_side = "Soviet Army"
			return TRUE

	return FALSE

/datum/game_mode/ww2/declare_completion()

	name = "World War 2"

	var/list/soldiers = WW2_soldiers_alive()
	var/WW2_soldiers_en_ru_coeff = WW2_soldiers_en_ru_ratio()

	var/winners = winning_side

	if (!winners)
		if (WW2_soldiers_en_ru_coeff >= german_win_coeff)
			winners = "German Army"
		else if (WW2_soldiers_en_ru_coeff <= soviet_win_coeff)
			winners = "Soviet Army"

	var/text = "<big><span class = 'notice'>The War has ended.</span></big><br><br>"

	text += "[soldiers["de"]] Wehrmacht and SS soldiers survived.<br>"
	text += "[soldiers["ru"]] Soviet soldiers survived.<br><br>"

	if (winning_side)
		text += "<big><span class = 'danger'>The [winning_side] wins!</span></big><br><br>"
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
	//	print_spies(client, FALSE)
	//	print_jews(client, FALSE)

/datum/game_mode/ww2/announce() //to be called when round starts

	// announce after some other stuff, like system setups, are announced
	spawn (3)

		new/datum/game_aspect/ww2(src)

		spawn (0)
			if (aspect)
				aspect.activate()
				aspect.post_activation()

			// train might not be set up yet
			spawn (100)
				job_master.german_job_slots *= personnel[GERMAN]
				job_master.soviet_job_slots *= personnel[SOVIET]

				// nerf or buff german supplies by editing the supply train controller
				german_supplytrain_master.supply_points_per_second_min *= supplies[GERMAN]
				german_supplytrain_master.supply_points_per_second_max *= supplies[GERMAN]

			// nerf or buff soviet supplies by editing crates in Soviet territory.
			spawn (10) // make sure rations are set up?
				for (var/obj/structure/closet/crate/soviet in world)
					if (istype(get_area(soviet), /area/prishtina/soviet))
						soviet.resize(supplies[SOVIET])

			// this may have already happened, do it again w/o announce
			setup_autobalance(0)

		world << "<b>The current game mode is World War II!</b>"

		// let new players see the join link
		for (var/mob/new_player/np in world)
			if (np.client)
				np.new_player_panel_proc()

		// no tanks on lowpop
		if (!istype(aspect, /datum/game_aspect/ww2/no_tanks))
			if (clients.len <= TANK_LOWPOP_THRESHOLD)
				for (var/obj/tank/T in world)
					qdel(T)
				world << "<i>Due to lowpop, there are no tanks.</i>"

