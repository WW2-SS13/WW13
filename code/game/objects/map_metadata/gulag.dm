#define NO_WINNER "No prisoners have escaped."

/obj/map_metadata/gulag
	ID = MAP_GULAG
	title = "GULAG #13 (125x125x2)"
	lobby_icon_state = "pow_camp"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall,
	/area/prishtina/no_mans_land/invisible_wall/inside) // above and underground
	respawn_delay = 1800
	squad_spawn_locations = FALSE
	//min_autobalance_players = 50 // aparently less that this will fuck autobalance
	reinforcements = FALSE
	faction_organization = list(
		CIVILIAN,
		SOVIET)
	no_subfaction_chance = FALSE
	subfaction_is_main_faction = TRUE
	roundend_condition_sides = list(
		list(CIVILIAN) = /area/prishtina/farm1,
		list(SOVIET) = /area/prishtina/farm4 // in order to prevent them from winning by capture
		)
	battle_name = "Prisioner's Camp"
	custom_loadout = FALSE // so people do not spawn with guns!
	var/modded_num_of_SSTV = FALSE
	var/modded_num_of_prisoners = FALSE
	faction_distribution_coeffs = list(CIVILIAN = 0.7, SOVIET = 0.3)
	songs = list(
		"The Great Escape:1" = 'sound/music/the_great_escape.ogg',
		"Bridge Over the River Kwai:1" = 'sound/music/bridge_over_river_kwai.ogg',
		)

/obj/map_metadata/gulag/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 600 || admin_ended_all_grace_periods)

/obj/map_metadata/gulag/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 1800 || admin_ended_all_grace_periods)


/obj/map_metadata/gulag/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/partisan/civilian))
		if (!J.is_prisoner)
			. = FALSE
		else
			if (istype(J, /datum/job/partisan/civilian/prisoner))
				J.total_positions = max(12, round(clients.len*3))
//	else if (istype(J, /datum/job/partisan/civilian))
//		J.total_positions = max(5, round(clients.len*0.75))
	else if (istype(J, /datum/job/soviet))
		if (!J.is_SS_TV)
			. = FALSE
		else
			if (istype(J, /datum/job/soviet/soldier_nkvd))
				J.total_positions = max(2, round(clients.len*0.25*3))
			if (istype(J, /datum/job/soviet/commander_nkvd))
				J.total_positions = 1
			if (istype(J, /datum/job/soviet/squad_leader_nkvd))
				J.total_positions = max(1, round(clients.len*0.05*3))
			if (istype(J, /datum/job/soviet/medic_nkvd))
				J.total_positions = max(1, round(clients.len*0.05*3))
				modded_num_of_SSTV = TRUE
	return .

/obj/map_metadata/gulag/announce_mission_start(var/preparation_time)
	world << "<font size=4>Soviets have <b>3 minutes</b> to prepare before the ceasefire ends! Germans can cross after <b>1 minute</b>. <br>The Germans will win if they hold out for 50 minutes without any escapes. The Soviets will win if a prisoner manages to escape.</font><br><br><br><b>PLEASE READ THE WIKI FOR RULES! http://mechahitler.co.nf/wiki/media/index.php?title=Camp_guide</b><br>"

/obj/map_metadata/gulag/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())

/obj/map_metadata/gulag/short_win_time(faction)
	return 1200

/obj/map_metadata/gulag/long_win_time(faction)
	return 1200

var/no_loop4 = FALSE

/obj/map_metadata/gulag/update_win_condition()
	if (!win_condition_specialcheck())
		return FALSE
	if (world.time >= 30000)
		if (win_condition_spam_check)
			return FALSE
		ticker.finished = TRUE
		var/message = "No prisoners have escaped! The NKVD guard unit has won the round!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return FALSE
	if ((current_winner && current_loser && world.time > next_win) && no_loop4 == FALSE)
		ticker.finished = TRUE
		var/message = "A prisoner has escaped! The prisoners have won the round!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		no_loop4 = TRUE
		return FALSE
	// German major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "A prisoner is almost escaping the area! They will win in 2 minutes."
				next_win = world.time +  short_win_time(CIVILIAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// German minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "A prisoner is almost escaping the area! They will win in 2 minutes."
				next_win = world.time +  short_win_time(CIVILIAN)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// Soviet major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "A prisoner is almost escaping the area! They will win in 2 minutes."
				next_win = world.time +  short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	// Soviet minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "A prisoner is almost escaping the area! They will win in 2 minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	else if (win_condition.check(list("REINFORCEMENTS"), list(), list(), 1.0, TRUE))
		if (last_win_condition != win_condition.hash)

			// let us know why we're changing to this win condition
			if (current_win_condition != NO_WINNER && current_winner && current_loser)
				world << "<font size = 3>The escaping prisoner has been recaptured!</font>"

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
			world << "<font size = 3>The escaping prisoner has been recaptured!</font>"
			current_winner = null
			current_loser = null
		next_win = -1
		current_win_condition = NO_WINNER
		win_condition.hash = 0
	last_win_condition = win_condition.hash
	return TRUE

	#undef NO_WINNER