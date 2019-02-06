#define NO_WINNER "The Reichstag is in German hands."
/obj/map_metadata/train
	ID = MAP_TRAIN
	title = "Train Yard (100x100x5)"
	lobby_icon_state = "train"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall,
	/area/prishtina/no_mans_land/invisible_wall/inside)
	respawn_delay = 500
	min_autobalance_players = 100
	squad_spawn_locations = FALSE
	reinforcements = FALSE
	faction_organization = list(
		GERMAN,
		POLISH_INSURGENTS)
	no_subfaction_chance = FALSE
	subfaction_is_main_faction = FALSE
	roundend_condition_sides = list(
		list(GERMAN) = /area/prishtina/german/bunker,
		list(POLISH_INSURGENTS) = /area/prishtina/farm4 // area inexistent in this map, in order to prevent the germans from winning by capture
		)
	available_subfactions = list()
	battle_name = "Train Yard"
	times_of_day = list("Early Morning")

	songs = list(
		"Russian Theme:1" = 'sound/music/wow_russian_theme.ogg',)
	faction_distribution_coeffs = list(GERMAN = 0.5, SOVIET = 0.5)

/obj/map_metadata/train/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 600 || admin_ended_all_grace_periods)

/obj/map_metadata/train/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 600 || admin_ended_all_grace_periods)

/obj/map_metadata/train/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/german))
		if (!J.is_reichstag)
			. = FALSE
		else
			if (istype(J, /datum/job/german/soldier_ss_reichstag))
				J.min_positions = 25
				J.max_positions = 25
				J.total_positions = 25

	else if (istype(J, /datum/job/polish))
		if (!J.is_partisan)
			. = FALSE
		else
			if (istype(J, /datum/job/polish/soldier))
				J.min_positions = 25
				J.max_positions = 25
				J.total_positions = 25
			else
				J.min_positions = 0
				J.max_positions = 0
				J.total_positions = 0

	return .

/obj/map_metadata/train/announce_mission_start(var/preparation_time)
	world << "<font size=4>All factions have <b>1 minutes</b> to prepare before the ceasefire ends!<br>The SS will win if they hold out for <b>15 mins</b>. The Partisans will win if they manage to reach the SS compartment of the train.</font>"

/obj/map_metadata/train/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())

/obj/map_metadata/train/short_win_time(faction)
	return 1200

/obj/map_metadata/train/long_win_time(faction)
	return 3000

var/no_loop_t = FALSE

/obj/map_metadata/train/update_win_condition()
	if (!win_condition_specialcheck())
		return FALSE
	if (world.time >= 9000)
		if (win_condition_spam_check)
			return FALSE
		ticker.finished = TRUE
		var/message = "The <b>SS</b> has sucessfuly defended the train! The Partisans halted the attack!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return FALSE
	if ((current_winner && current_loser && world.time > next_win) && no_loop_t == FALSE)
		ticker.finished = TRUE
		var/message = "The <b>Partisans</b> have captured the train! The battle is over!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		no_loop_t = TRUE
		return FALSE
	// German major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Partisans have captured the train! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// German minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Partisans have captured the train! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// Soviet major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Partisans have captured the train! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	// Soviet minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Partisans have captured the train! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	else if (win_condition.check(list("REINFORCEMENTS"), list(), list(), 1.0, TRUE))
		if (last_win_condition != win_condition.hash)

			// let us know why we're changing to this win condition
			if (current_win_condition != NO_WINNER && current_winner && current_loser)
				world << "<font size = 3>The <b>SS</b> has recaptured the train!</font>"

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
			world << "<font size = 3>The <b>SS</b> has recaptured the train!</font>"
			current_winner = null
			current_loser = null
		next_win = -1
		current_win_condition = NO_WINNER
		win_condition.hash = 0
	last_win_condition = win_condition.hash
	return TRUE


	#undef NO_WINNER