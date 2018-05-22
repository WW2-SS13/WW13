/process/weather
	var/mod_weather_interval = 3500
	var/change_weather_interval = 3500

	var/minimum_mod_weather_delay = 1000
	var/minimum_change_weather_delay = 1000

	var/next_can_mod_weather = -1
	var/next_can_change_weather = -1

	var/enabled = TRUE

/process/weather/setup()
	name = "weather"
	schedule_interval = 100
	start_delay = 20
	next_can_mod_weather = world.realtime + 100
	next_can_change_weather = world.realtime + 12000
	fires_at_gamestates = list(GAME_STATE_PLAYING)
	processes.weather = src

/process/weather/fire()
	SCHECK

	var/deleted = 0

	FORNEXT(cleanables)
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

	var/prob_of_weather_mod = ((((1/mod_weather_interval) * 10) / 2) * 100) * schedule_interval/20
	var/prob_of_weather_change = ((((1/change_weather_interval) * 10) / 2) * 100) * schedule_interval/20

	if (prob(prob_of_weather_mod))
		if (world.realtime >= next_can_mod_weather)
			modify_weather_somehow()
			next_can_mod_weather = world.realtime + minimum_mod_weather_delay
	else if (prob(prob_of_weather_change))
		if (world.realtime >= next_can_change_weather)
			change_weather_somehow()
			next_can_change_weather = world.realtime + minimum_change_weather_delay