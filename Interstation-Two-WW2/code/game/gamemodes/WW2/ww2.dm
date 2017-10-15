/datum/game_mode/ww2
	name = "World War 2"
	config_tag = "ww2"
	required_players = 1
	round_description = ""
	extended_round_description = ""

	var/time_both_sides_locked = -1
	var/german_win_coeff = 1.1 // germans gets S.S.
	var/soviet_win_coeff = 1.0 // and soviets don't

	var/cond_2_1_check1 = 0
	var/cond_2_1_nextcheck = -1

	var/cond_2_2_check1 = 0
	var/cond_2_2_nextcheck = -1

	var/cond_2_3_check1 = 0
	var/cond_2_3_nextcheck = -1

	var/cond_2_4_check1 = 0
	var/cond_2_4_nextcheck = -1

	var/win_condition = ""
	var/winning_side = ""

	var/admins_triggered_roundend = 0
	var/admins_triggered_noroundend = 0

	var/personnel[2]
	var/supplies[2]

	var/season = "SPRING"

/datum/game_mode/ww2/New()
	..()
	season = pick(/*"SPRING", "SUMMER", "FALL", */"SPRING")

// because we don't use readying up, we override can_start()
/datum/game_mode/ww2/can_start(var/do_not_spawn)

	var/playerC = 0
	for(var/mob/new_player/player in player_list)
		if(player.client)
			playerC++

	if(playerC < required_players)
		return 0

	if(!(antag_templates && antag_templates.len))
		return 1

	var/enemy_count = 0
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
					return 0
				enemy_count += potential.len
				if(enemy_count >= required_enemies)
					return 1
	return 0

// win conditions for one side already exist, make sure we
// don't active another
/datum/game_mode/ww2/proc/trying_to_win()
	return (cond_2_1_check1 || cond_2_2_check1 || cond_2_3_check1 || cond_2_4_check1)

/datum/game_mode/ww2/check_finished()
	if (admins_triggered_noroundend)
		return 0 // no matter what, don't end
	else if (..() == 1 || admins_triggered_roundend)
		return 1
	else if (WW2_soldiers_en_ru_ratio() == 1000 && game_started)
		winning_side = "German Army"
		return 1
	else if (WW2_soldiers_en_ru_ratio() == 1/1000 && game_started)
		winning_side = "Soviet Army"
		return 1
	else

		// condition one: both sides have reinforcements locked,
		// wait 10 minutes and see who is doing the best

		if (time_both_sides_locked != -1)
			if ((time_both_sides_locked - world.time) >= 6000)
				return 1
		else if (reinforcements_master.is_permalocked(GERMAN))
			if (reinforcements_master.is_permalocked(RUSSIAN))
				time_both_sides_locked = world.time
				world << "<font size = 3>Both sides are locked for reinforcements; the game will end in 10 minutes.</font>"
				return 0

		// conditions 2.1 to 2.5: one side has occupied the enemy base

		var/stats = get_russian_german_stats()

		var/alive_russians = stats["alive_russians"]
		var/alive_germans = stats["alive_germans"]

		var/russians_in_russia = stats["russians_in_russia"]
		var/russians_in_germany = stats["russians_in_germany"]

		var/germans_in_germany = stats["germans_in_germany"]
		var/germans_in_russia = stats["germans_in_russia"]

		// the conditions below have multiple checks
		// check1 occurs every time this proc is called (once a tick?)
		// check2 occurs once every five-ten minutes

		// condition 2.1: Russians outnumber germans and the amount of
		// russians in the german base is > than the amount of germans there

		if (alive_russians > alive_germans)
			if (russians_in_germany > germans_in_germany && !cond_2_1_check1 && !trying_to_win())
				cond_2_1_check1 = 1
				cond_2_1_nextcheck = world.time + 3000
				world << "<font size = 3>The Soviets have occupied most German territory! The German Army has 5 minutes to reclaim their land!</font>"
				return 0
		else
			if (cond_2_1_check1 == 1) // soviets lost control!
				if(cond_2_1_nextcheck < world.time + 2400)
					world << "<font size = 3>The Soviets have lost control of the German territory they occupied!</font>"
				else
					return

			cond_2_1_check1 = 0

		// condition 2.2: Germans outnumber russians and the amount of germans
		// in the russian base is > than the amount of russians there

		if (alive_germans > alive_russians)
			if (germans_in_russia > russians_in_russia && !cond_2_2_check1 && !trying_to_win())
				cond_2_2_check1 = 1
				cond_2_2_nextcheck = world.time + 3000
				world << "<font size = 3>The Germans have occupied most Soviet territory! The Soviet Army has 5 minutes to reclaim their land!</font>"
				return 0
		else
			if (cond_2_2_check1 == 1) // germans lost control!
				if(cond_2_2_nextcheck < world.time + 2400)
					world << "<font size = 3>The Germans have lost control of the Soviet territory they occupied!</font>"
				else
					return

			cond_2_2_check1 = 0

		// condition 2.3: Germans heavily outnumber russians in the russian
		// base, regardless of general numerical superiority/inferiority.
		// they have to hold this position for 10+ minutes

		if ((germans_in_russia/1.33) > russians_in_russia && !trying_to_win())
			if(!cond_2_3_check1)
				cond_2_3_check1 = 1
				cond_2_3_nextcheck = world.time + 6000
				world << "<font size = 3>The Germans have occupied most Soviet territory! The Soviet Army has 10 minutes to reclaim their land!</font>"
				return 0
		else
			if (cond_2_3_check1 == 1) // soviets lost control!
				if(cond_2_3_nextcheck < world.time + 5400)
					world << "<font size = 3>The Germans have lost control of the Soviet territory they occupied!</font>"
				else
					return

			cond_2_3_check1 = 0

		// condition 2.4: Russians heavily outnumber Germans in the German
		// base, regardless of general numerical superiority/inferiority.
		// they have to hold this position for 10+ minutes

		if ((russians_in_germany/1.33) > germans_in_germany && !trying_to_win())
			if(!cond_2_4_check1)
				cond_2_4_check1 = 1
				cond_2_4_nextcheck = world.time + 6000
				world << "<font size = 3>The Soviets have occupied most German territory! The German Army has 10 minutes to reclaim their land!</font>"
				return 0
		else
			if (cond_2_4_check1 == 1) // soviets lost control!
				if(cond_2_4_nextcheck < world.time + 5400)
					world << "<font size = 3>The Soviets have lost control of the German territory they occupied!</font>"
				else
					return

			cond_2_4_check1 = 0

		if (cond_2_1_check1 && world.time >= cond_2_1_nextcheck && cond_2_1_nextcheck != -1) // condition 2.1 completed
			if (!win_condition) win_condition = "The Soviet Army won by outnumbering the Germans and occupying most of their territory, cutting them off from supplies!"
			winning_side = "Soviet Army"
			return 1

		if (cond_2_2_check1 && world.time >= cond_2_2_nextcheck && cond_2_2_nextcheck != -1) // condition 2.2 completed
			if (!win_condition) win_condition = "The German Army won by outnumbering the Soviets and occupying most of their territory. The bunker was surrounded and cut off from reinforcements!"
			winning_side = "German Army"
			return 1

		if (cond_2_3_check1 && world.time >= cond_2_3_nextcheck && cond_2_3_nextcheck != -1) // condition 2.3 completed
			if (!win_condition) win_condition = "The German Army won by occupying and holding Soviet territory, while heavily outnumber the Soviets there."
			winning_side = "German Army"
			return 1

		if (cond_2_4_check1 && world.time >= cond_2_4_nextcheck && cond_2_4_nextcheck != -1) // condition 2.4 completed
			if (!win_condition) win_condition = "The Soviet Army won by occupying and holding German territory, while heavily outnumber the Germans there."
			winning_side = "Soviet Army"
			return 1

	return 0

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
		print_spies(client, 0)
		print_jews(client, 0)

/datum/game_mode/ww2/announce() //to be called when round starts

	// announce after some other stuff, like system setups, are announced
	spawn (3)

		new/datum/game_aspect/ww2(src)

		spawn (0)
			if (aspect)
				aspect.activate()
				aspect.post_activation()

			spawn (1)
				job_master.german_job_slots *= personnel[GERMAN]
				job_master.russian_job_slots *= personnel[RUSSIAN]

				// nerf or buff german supplies by editing the supply train controller
				german_supplytrain_master.supply_points_per_second_min *= supplies[GERMAN]
				german_supplytrain_master.supply_points_per_second_max *= supplies[GERMAN]

				// nerf or buff soviet supplies by editing crates in Soviet territory.
				spawn (10) // make sure rations are set up?
					for (var/obj/structure/closet/crate/soviet in world)
						if (istype(get_area(soviet), /area/prishtina/soviet))
							soviet.resize(supplies[RUSSIAN])

				// this may have already happened, do it again w/o announce
				setup_autobalance(0)

		world << "<b>The current game mode is World War II!</b>"
