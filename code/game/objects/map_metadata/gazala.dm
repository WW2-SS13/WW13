#define NO_WINNER "The Allies control the road."
/obj/map_metadata/gazala
	ID = MAP_GAZALA
	title = "Road to Gazala (250x100x1)"
	lobby_icon_state = "afrika"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall,
	/area/prishtina/no_mans_land/invisible_wall/inside)
	respawn_delay = 600
	min_autobalance_players = 100
	squad_spawn_locations = FALSE
	reinforcements = TRUE
	faction_organization = list(
		GERMAN,
		USA,)
	no_subfaction_chance = FALSE
	subfaction_is_main_faction = FALSE
	roundend_condition_sides = list(
		list(GERMAN) = /area/prishtina/forest, // area inexistent in this map, in order to prevent the americans from winning by capture
		list(USA) = /area/prishtina/soviet
		)
	available_subfactions = list()
	front = "Western"
	battle_name = "battle of the road to Gazala"
	songs = list(
		"Panzerlied:1" = 'sound/music/panzerlied.ogg')
	faction_distribution_coeffs = list(GERMAN = 0.5, USA = 0.5)
	var/modded_num_of_prisoners3 = FALSE

/obj/map_metadata/gazala/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 9000 || admin_ended_all_grace_periods)

/obj/map_metadata/gazala/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 9000 || admin_ended_all_grace_periods)

/obj/map_metadata/gazala/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/usa))
		if (J.is_prisoner)
			. = FALSE
		else
			if (istype(J, /datum/job/usa/soldier_prisoner))
				J.total_positions = max(0, round(clients.len*0.*0))
			if (istype(J, /datum/job/usa/uk_soldier_prisoner))
				J.total_positions = max(0, round(clients.len*0.*0))
			if (istype(J, /datum/job/usa/squad_leader_prisoner) && !modded_num_of_prisoners3)
				J.total_positions = max(0, round(clients.len*0.*0))
				modded_num_of_prisoners3 = TRUE
		if (istype(J, /datum/job/usa/marines_squad_leader))
			. = FALSE
		if (istype(J, /datum/job/usa/marines_soldier))
			. = FALSE

/obj/map_metadata/gazala/announce_mission_start(var/preparation_time)
	world << "<font size=4>All factions have <b>15 minutes</b> to prepare before the ceasefire ends!<br>The Germans will win if they capture the American HQ. The Americans will win if they manage to defend for <b>45 minutes</b>.</font>"

/obj/map_metadata/gazala/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())

/obj/map_metadata/gazala/short_win_time(faction)
	return 1200

/obj/map_metadata/gazala/long_win_time(faction)
	return 3000

var/no_loop_g = FALSE

/obj/map_metadata/gazala/update_win_condition()
	if (!win_condition_specialcheck())
		return FALSE
	if (world.time >= 27000)
		if (win_condition_spam_check)
			return FALSE
		ticker.finished = TRUE
		var/message = "The <b>American Army</b> has sucessfuly defended the road to Gazala! The Afrika Korps halted the attack!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return FALSE
	if ((current_winner && current_loser && world.time > next_win) && no_loop_g == FALSE)
		ticker.finished = TRUE
		var/message = "The <b>Afrika Korps</b> have captured the road! The Panzer keep advancing!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		no_loop_g = TRUE
		return FALSE
	// German major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Afrika Korps have captured the road to Gazala! They will win  in {time} minutes."
				next_win = world.time + short_win_time(GERMAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// German minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Afrika Korps have captured the road to Gazala! They will win  in {time} minutes."
				next_win = world.time + short_win_time(GERMAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// Soviet major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Afrika Korps have captured the road to Gazala! They will win  in {time} minutes."
				next_win = world.time + short_win_time(GERMAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	// Soviet minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Afrika Korps have captured the road to Gazala! They will win  in {time} minutes."
				next_win = world.time + short_win_time(GERMAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	else if (win_condition.check(list("REINFORCEMENTS"), list(), list(), 1.0, TRUE))
		if (last_win_condition != win_condition.hash)

			// let us know why we're changing to this win condition
			if (current_win_condition != NO_WINNER && current_winner && current_loser)
				world << "<font size = 3>The <b>US Army</b> has recaptured the road!</font>"

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
			world << "<font size = 3>The <b>US Army</b> has recaptured the road!</font>"
			current_winner = null
			current_loser = null
		next_win = -1
		current_win_condition = NO_WINNER
		win_condition.hash = 0
	last_win_condition = win_condition.hash
	return TRUE


	#undef NO_WINNER