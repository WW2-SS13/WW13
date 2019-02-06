#define NO_WINNER "The search is still going on."

/obj/map_metadata/occupation
	ID = MAP_OCCUPATION
	title = "Occupation (125x125x2)"
	lobby_icon_state = "occupation"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall,
	/area/prishtina/no_mans_land/invisible_wall/inside) // above and underground
	respawn_delay = 1800
	squad_spawn_locations = FALSE
	min_autobalance_players = 50
	reinforcements = FALSE
	faction_organization = list(
		GERMAN,
		CIVILIAN)
	no_subfaction_chance = FALSE
	subfaction_is_main_faction = TRUE
	roundend_condition_sides = list(
		list(GERMAN) = /area/prishtina/farm1,
		list(SOVIET) = /area/prishtina/farm4 // in order to prevent them from winning by capture
		)
	available_subfactions = list(
		SCHUTZSTAFFEL)
	battle_name = "Occupation"
	agents = 1
	agents_in_game = 0
	custom_loadout = FALSE // so people do not spawn with guns!
	var/modded_num_of_SS = FALSE
	faction_distribution_coeffs = list(GERMAN = 0.3, CIVILIAN = 0.70)

/obj/map_metadata/occupation/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 72000 || admin_ended_all_grace_periods)

/obj/map_metadata/occupation/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 72000 || admin_ended_all_grace_periods)


/obj/map_metadata/occupation/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/german))
		if (!J.is_SS)
			. = FALSE
		else
			if (istype(J, /datum/job/german/soldier_ss))
				J.total_positions = max(round(clients.len*0.2), 20)
			if (istype(J, /datum/job/german/medic_ss))
				J.total_positions = 2
			if (istype(J, /datum/job/german/squad_leader_ss))
				J.total_positions = 2
				modded_num_of_SS = TRUE
	else if (istype(J, /datum/job/partisan/civilian))
		J.total_positions = max(round(clients.len, 15))
		if (istype(J, /datum/job/partisan/civilian/chef))
			J.total_positions = 4
		if (istype(J, /datum/job/partisan/civilian/det))
			J.total_positions = 2
		if (istype(J, /datum/job/partisan/civilian/preist))
			J.total_positions = 2
		if (istype(J, /datum/job/partisan/civilian/fire))
			J.total_positions = 3
		if (istype(J, /datum/job/partisan/civilian/cop))
			J.total_positions = 1
		if (istype(J, /datum/job/partisan/civilian/worker))
			J.total_positions = 10
		if (istype(J, /datum/job/partisan/civilian/rich))
			J.total_positions = 2
		if (istype(J, /datum/job/partisan/civilian/sci))
			J.total_positions = 3
		if (istype(J, /datum/job/partisan/civilian/mayor))
			J.total_positions = 1
		if (istype(J, /datum/job/partisan/civilian/librarian))
			J.total_positions = 2
		if (istype(J, /datum/job/partisan/civilian/jewl))
			J.total_positions = 1
		if (istype(J, /datum/job/partisan/civilian/journalist))
			J.total_positions = 1
		if (istype(J, /datum/job/partisan/civilian/writer))
			J.total_positions = 1
		if (istype(J, /datum/job/partisan/civilian/hunter))
			J.total_positions = 3
		if (istype(J, /datum/job/partisan/civilian/doctor))
			J.total_positions = 2
		if (istype(J, /datum/job/partisan/civilian/vio))
			J.total_positions = 1
		if (istype(J, /datum/job/partisan/civilian/americanspy))
			J.total_positions = 1
		if (istype(J, /datum/job/partisan/civilian/redcross))
			J.total_positions = 1
	return .

/obj/map_metadata/occupation/announce_mission_start(var/preparation_time)
	world << "<font size=4>Partisans are hiding in this town! The SS have been sent to hunt them down.<br>"

/obj/map_metadata/occupation/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())

/obj/map_metadata/occupation/short_win_time(faction)
	return 1200

/obj/map_metadata/occupation/long_win_time(faction)
	return 1200

var/no_loop_o = FALSE

/obj/map_metadata/occupation/update_win_condition()
	if (!win_condition_specialcheck())
		return FALSE
	if (world.time >= 72000)
		if (win_condition_spam_check)
			return FALSE
		ticker.finished = TRUE
		var/message = "The round has ended!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return FALSE
	if ((current_winner && current_loser && world.time > next_win) && no_loop_o == FALSE)
		ticker.finished = TRUE
		var/message = "Uhh you shouldn't be seeing this."
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		no_loop_o = TRUE
		return FALSE
	// German major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "A [roundend_condition_def2army(roundend_condition_sides[1][1])] soldier is almost escaping the area! They will win in 2 minutes."
				next_win = world.time +  short_win_time(GERMAN)
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// German minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "A [roundend_condition_def2army(roundend_condition_sides[1][1])] soldier is almost escaping the area! They will win in 2 minutes."
				next_win = world.time +  short_win_time(GERMAN)
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// Soviet major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "A [roundend_condition_def2army(roundend_condition_sides[2][1])] soldier is almost escaping the area! They will win in 2 minutes."
				next_win = world.time +  short_win_time(SOVIET)
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	// Soviet minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "A [roundend_condition_def2army(roundend_condition_sides[2][1])] soldier is almost escaping the area! They will win in 2 minutes."
				next_win = world.time + short_win_time(SOVIET)
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	else if (win_condition.check(list("REINFORCEMENTS"), list(), list(), 1.0, TRUE))
		if (last_win_condition != win_condition.hash)


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
			current_winner = null
			current_loser = null
		next_win = -1
		current_win_condition = NO_WINNER
		win_condition.hash = 0
	last_win_condition = win_condition.hash
	return TRUE

	#undef NO_WINNER