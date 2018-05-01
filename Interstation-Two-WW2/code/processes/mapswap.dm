var/process/mapswap/mapswap_process = null

/process/mapswap
	// map = required players
	var/list/maps = list(
		MAP_CITY = 0,
		MAP_FOREST = 0,
		MAP_PILLAR = 0)
	var/ready = TRUE
	var/admin_triggered = FALSE

/process/mapswap/setup()
	name = "mapswap"
	schedule_interval = 50 // every 5 seconds
	start_delay = 50
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	mapswap_process = src

/process/mapswap/fire()
	// no SCHECK here
	if (is_ready())
		ready = FALSE
		vote.initiate_vote("map", "MapSwap Process", TRUE, list(src, "swap"))
		ticker.delay_end = TRUE
		spawn (600)
			ticker.delay_end = FALSE

/process/mapswap/proc/is_ready()
	. = FALSE

	if (ready)
		if (admin_triggered)
			. = TRUE
		// 60 minutes have passed
		else if (ticks >= 720 || (map && istype(map, /obj/map_metadata/pillar) && ticks >= 240))
			. = TRUE
		// round will end in 5 minutes or less
		else if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/WW2))
			var/datum/game_mode/WW2/mode = ticker.mode
			if (mode.next_win_time() <= 3 && mode.next_win_time() != -1)
				. = TRUE
			else if (mode.admins_triggered_roundend)
				. = TRUE
	return .

/process/mapswap/proc/swap(var/winner = "City")
	winner = uppertext(winner)
	if (!list(MAP_CITY, MAP_FOREST, MAP_PILLAR).Find(winner))
		winner = maps[1]
	if (shell())
		shell("cd && sudo python3 mapswap.py [winner]")
		log_debug("Ran mapswap.py with arg '[winner]' on the shell.")
	else
		log_debug("Failed to execute python shell command in mapswap process!")