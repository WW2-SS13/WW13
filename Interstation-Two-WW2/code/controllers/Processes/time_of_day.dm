var/datum/controller/process/time_of_day/time_of_day_process = null
var/TOD_may_automatically_change = FALSE

/datum/controller/process/time_of_day
	var/TOD_ticks = 0

/datum/controller/process/time_of_day/setup()
	name = "time of day cycle"
	schedule_interval = 100
	start_delay = 20
	time_of_day_process = src

/datum/controller/process/time_of_day/doWork()
	if (!roundstart_time)
		return
	try
		TOD_ticks += schedule_interval/10
		if (TOD_ticks >= time_of_day2ticks[time_of_day])
			TOD_ticks = 0
			TOD_may_automatically_change = TRUE // not sure how else to do this without breaking the process

	catch(var/exception/e)
		catchException(e)
	SCHECK