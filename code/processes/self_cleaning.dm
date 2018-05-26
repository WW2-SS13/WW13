/process/self_cleaning

/process/self_cleaning/setup()
	name = "self-cleaning decals"
	schedule_interval = 100
	start_delay = 20
	fires_at_gamestates = list(GAME_STATE_PLAYING)
	priority = PROCESS_PRIORITY_MEDIUM
	processes.self_cleaning = src

/process/self_cleaning/fire()

	var/deleted = 0

	for (current in current_list)
		if (!isDeleted(current))
			var/area/A = get_area(current)
			if (A && A.weather == WEATHER_RAIN)
				qdel(current)
				++deleted
				if (deleted >= 100)
					break
		else
			catchBadType(current)
			cleanables -= current

		current_list -= current
		PROCESS_TICK_CHECK

/process/self_cleaning/reset_current_list()
	if (current_list)
		current_list = null
	current_list = cleanables.Copy()