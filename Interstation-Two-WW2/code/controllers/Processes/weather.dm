var/datum/controller/process/weather/weather_process = null

/datum/controller/process/weather
	var/mod_weather_interval = 3500
	var/change_weather_interval = 3500

	var/minimum_mod_weather_delay = 1000
	var/minimum_change_weather_delay = 1000

	var/next_can_mod_weather = -1
	var/next_can_change_weather = -1

	var/enabled = TRUE

/datum/controller/process/weather/setup()
	name = "weather"
	schedule_interval = 20
	start_delay = 20
	next_can_mod_weather = world.realtime + 100
	next_can_change_weather = world.realtime + 12000
	weather_process = src

/datum/controller/process/weather/doWork()
	if (!roundstart_time)
		return

	process_weather()

	var/prob_of_weather_mod = (((1/mod_weather_interval) * 10) / 2) * 100
	var/prob_of_weather_change = (((1/change_weather_interval) * 10) / 2) * 100

	if (prob(prob_of_weather_mod))
		if (world.realtime >= next_can_mod_weather)
			modify_weather_somehow()
			next_can_mod_weather = world.realtime + minimum_mod_weather_delay
	else if (prob(prob_of_weather_change))
		if (world.realtime >= next_can_change_weather)
			if (ticker.mode.vars.Find("season"))
				change_weather_somehow()
				next_can_change_weather = world.realtime + minimum_change_weather_delay
	SCHECK