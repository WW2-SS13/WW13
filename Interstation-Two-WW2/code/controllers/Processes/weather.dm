//#define WEATHERDEBUG

/datum/controller/process/weather
	var/mod_weather_interval = 5000
	var/change_weather_interval = 18000

	var/minimum_mod_weather_delay = 1000
	var/minimum_change_weather_delay = 1000

	var/next_can_mod_weather = -1
	var/next_can_change_weather = -1

/datum/controller/process/weather/setup()
	name = "weather"
	schedule_interval = 20
	start_delay = 20
	#ifdef WEATHERDEBUG
	mod_weather_interval = 1000
	change_weather_interval = 2000
	#endif
	next_can_mod_weather = world.realtime + 100
	next_can_change_weather = world.realtime + 100

/datum/controller/process/weather/doWork()
	if (!roundstart_time)
		return

	process_weather()

	var/prob_of_weather_mod = (((1/mod_weather_interval) * 10) * 2) * 100
	var/prob_of_weather_change = (((1/change_weather_interval) * 10) * 2) * 100

//	world << "prob. of weather mod: [prob_of_weather_mod]"
//	world << "prob. of weather change: [prob_of_weather_change]"

	if (prob(prob_of_weather_mod))
		if (world.realtime >= next_can_mod_weather)
//			world << "modding weather"
			modify_weather_somehow()
			next_can_mod_weather = world.realtime + minimum_mod_weather_delay
	else if (prob(prob_of_weather_change))
		if (world.realtime >= next_can_change_weather)
//			world << "changing weather"
			if (ticker.mode.vars.Find("season"))
				change_weather_somehow()
				next_can_change_weather = world.realtime + minimum_change_weather_delay