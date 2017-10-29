//#define DAYTIME_DEBUG
/datum/controller/process/time_of_day
	var/change_time_of_day_interval = 18000
	var/minimum_change_time_of_day_delay = 1000
	var/next_can_change_time_of_day = -1

/datum/controller/process/time_of_day/setup()
	name = "daytime cycle"
	schedule_interval = 20
	start_delay = 20
	#ifdef DAYTIME_DEBUG
	change_time_of_day_interval = 2000
	#endif
	next_can_change_time_of_day = world.realtime + 100

/datum/controller/process/time_of_day/doWork()
	if (!roundstart_time)
		return

	var/prob_of_time_of_day_change = (((1/change_time_of_day_interval) * 10) * 2) * 100

	if (prob(prob_of_time_of_day_change))
		if (world.realtime >= next_can_change_time_of_day)
			randomly_update_lighting()
			next_can_change_time_of_day = world.realtime + minimum_change_time_of_day_delay