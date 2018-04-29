var/process/mapswap/mapswap_process = null

/process/mapswap
	// map = required players
	var/list/maps = list(
		MAP_CITY = 0,
		MAP_FOREST = 15,
		MAP_PILLAR = 25)
	var/ready = TRUE

/process/mapswap/setup()
	name = "mapswap"
	schedule_interval = 50 // every 5 seconds
	start_delay = 50
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	mapswap_process = src

/process/mapswap/fire()
	// no SCHECK here
	if (is_ready())
		ready = FALSE
		vote.initiate_vote("map", "MapSwap Process", TRUE, list(src, "swap"))

/process/mapswap/proc/is_ready()
	. = FALSE

	if (ready)
		// 60 minutes have passed
		if (ticks >= 720)
			. = TRUE
		// round will end in 5 minutes or less
		else if (ticker && ticker.mode && hascall(ticker.mode, "next_win_time") && ticker.mode:next_win_time() != -1 && ticker.mode:next_win_time() <= 3)
			. = TRUE

	return .

/process/mapswap/proc/swap(var/winner = "CITY")
	if (shell())
		shell("cd && sudo python3 mapswap.py [winner]")
		log_debug("Ran mapswap.py with arg '[winner]' on the shell.")
	else
		log_debug("Failed to execute python shell command in mapswap process!")