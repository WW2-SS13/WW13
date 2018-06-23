#define NO_WINNER "The Reichstag is in German hands."

/obj/map_metadata/reichstag
	ID = MAP_REICHSTAG
	title = "Reichstag (100x100x5)"
	lobby_icon_state = "reichstag"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall,
	/area/prishtina/no_mans_land/invisible_wall/inside)
	respawn_delay = 2400
	min_autobalance_players = 100
	var/modded_num_reichstag = FALSE
	var/modded_num_reichstag_s = FALSE
	squad_spawn_locations = FALSE
	faction_organization = list(
		GERMAN,
		SOVIET)
	no_subfaction_chance = FALSE
	subfaction_is_main_faction = FALSE
	roundend_condition_sides = list(
		list(GERMAN) = /area/prishtina/german/briefing,
		list(SOVIET) = /area/prishtina/farm4 // area inexistent in this map, in order to prevent the germans from winning by capture
		)
	available_subfactions = list()
	battle_name = "Reichstag"
	times_of_day = list("Early Morning")
	songs = list(
		"Russian Theme:1" = 'sound/music/wow_russian_theme.ogg',
		"Brave Soldat:1" = 'sound/music/wow_brave_soldat.ogg')
	faction_distribution_coeffs = list(GERMAN = 0.30, SOVIET = 0.7)

/obj/map_metadata/reichstag/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 4800 || admin_ended_all_grace_periods)

/obj/map_metadata/reichstag/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 4800 || admin_ended_all_grace_periods)

/obj/map_metadata/reichstag/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/german))
		if (!J.is_reichstag)
			. = FALSE
		else
			if (istype(J, /datum/job/german/volkssturm) && !modded_num_reichstag)
				J.min_positions = 30
				J.max_positions = 30
				J.total_positions = 30
			if (istype(J, /datum/job/german/kriegsmarine) && !modded_num_reichstag)
				J.min_positions = 26
				J.max_positions = 26
				J.total_positions = 26
			if (istype(J, /datum/job/german/soldier_ss_charlemagne) && !modded_num_reichstag)
				J.min_positions = 12
				J.max_positions = 12
				J.total_positions = 12
			if (istype(J, /datum/job/german/soldier_ss_nordland) && !modded_num_reichstag)
				J.min_positions = 12
				J.max_positions = 12
				J.total_positions = 12
			if (istype(J, /datum/job/german/paratrooper_reichstag) && !modded_num_reichstag)
				J.min_positions = 12
				J.max_positions = 12
				J.total_positions = 12
			if (istype(J, /datum/job/german/squad_leader) && !modded_num_reichstag)
				J.min_positions = 8
				J.max_positions = 8
				J.total_positions = 38
			if (istype(J, /datum/job/german/commander) && !modded_num_reichstag)
				J.min_positions = 1
				J.max_positions = 1
				J.total_positions = 1
				modded_num_reichstag = TRUE

	else if (istype(J, /datum/job/soviet))
		if (istype(J, /datum/job/soviet/soldier) && !modded_num_reichstag_s)
			J.min_positions = 100
			J.max_positions = 100
			J.total_positions = 100
		if (istype(J, /datum/job/soviet/guard) && !modded_num_reichstag_s)
			J.min_positions = 10
			J.max_positions = 10
			J.total_positions = 10
		if (istype(J, /datum/job/soviet/sturmovik) && !modded_num_reichstag_s)
			J.min_positions = 30
			J.max_positions = 30
			J.total_positions = 30
		if (istype(J, /datum/job/soviet/heavy_weapon) && !modded_num_reichstag_s)
			J.min_positions = 10
			J.max_positions = 10
			J.total_positions = 10
		if (istype(J, /datum/job/soviet/sniper) && !modded_num_reichstag_s)
			J.min_positions = 6
			J.max_positions = 6
			J.total_positions = 6
		if (istype(J, /datum/job/soviet/medic) && !modded_num_reichstag_s)
			J.min_positions = 14
			J.max_positions = 14
			J.total_positions = 14
		if (istype(J, /datum/job/soviet/doctor) && !modded_num_reichstag_s)
			J.min_positions = 10
			J.max_positions = 10
			J.total_positions = 10
		if (istype(J, /datum/job/soviet/squad_leader) && !modded_num_reichstag_s)
			J.min_positions = 20
			J.max_positions = 20
			J.total_positions = 20
		if (istype(J, /datum/job/soviet/commander) && !modded_num_reichstag_s)
			J.min_positions = 1
			J.max_positions = 1
			J.total_positions = 1
		modded_num_reichstag_s = TRUE


	return .

/obj/map_metadata/reichstag/announce_mission_start(var/preparation_time)
	world << "<font size=4>All factions have <b>8 minutes</b> to prepare before the ceasefire ends!<br>The Germans will win if they hold out for 50 minutes. The Soviets will win if they manage to reach the top of the Reichstag.</font>"

/obj/map_metadata/reichstag/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())

/obj/map_metadata/reichstag/short_win_time(faction)
	return 1200

/obj/map_metadata/reichstag/long_win_time(faction)
	return 3000

var/no_loop_r = FALSE

/obj/map_metadata/reichstag/update_win_condition()
	if (!win_condition_specialcheck())
		return FALSE
	if (world.time >= 30000)
		if (win_condition_spam_check)
			return FALSE
		ticker.finished = TRUE
		var/message = "The <b>Wehrmacht</b> has sucessfuly defended the Reichstag! The Soviets retreat!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return FALSE
	if ((current_winner && current_loser && world.time > next_win) && no_loop_r == FALSE)
		ticker.finished = TRUE
		var/message = "The <b>Soviets</b> have captured the Reichstag! The battle for Berlin is over!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		no_loop_r = TRUE
		return FALSE
	// German major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Soviets have reached the top of the Reichstag! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// German minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Soviets have reached the top of the Reichstag! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// Soviet major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Soviets have reached the top of the Reichstag! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	// Soviet minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Soviets have reached the top of the Reichstag! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	else if (win_condition.check(list("REINFORCEMENTS"), list(), list(), 1.0, TRUE))
		if (last_win_condition != win_condition.hash)

			// let us know why we're changing to this win condition
			if (current_win_condition != NO_WINNER && current_winner && current_loser)
				world << "<font size = 3>The <b>Wehrmacht</b> has recaptured the Reichstag!</font>"

			current_win_condition = "Both sides are out of reinforcements; the round will end in {time} minute{s}."

			if (last_reinforcements_next_win != -1)
				next_win = last_reinforcements_next_win
			else
				next_win = world.time + long_win_time(null)
				last_reinforcements_next_win = next_win

			announce_current_win_condition()
			current_winner = null
			current_loser = null
	else
		if (current_win_condition != NO_WINNER && current_winner && current_loser)
			world << "<font size = 3>The <b>Wehrmacht</b> has recaptured the Reichstag!</font>"
			current_winner = null
			current_loser = null
		next_win = -1
		current_win_condition = NO_WINNER
		win_condition.hash = 0
	last_win_condition = win_condition.hash
	return TRUE