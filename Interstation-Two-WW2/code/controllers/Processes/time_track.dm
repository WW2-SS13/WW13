// ported from /tg/station - Kachnov

var/datum/controller/process/time_track/time_track = null

/datum/controller/process/time_track
	var/dilation = 0
	var/last_tick_realtime = 0
	var/last_tick_byond_time = 0
	var/last_tick_tickcount = 0
	var/first_run = TRUE

/datum/controller/process/time_track/setup()
	name = "Time Tracking"
	schedule_interval = 50

	if (!time_track)
		time_track = src

/datum/controller/process/time_track/doWork()
	..()

	var/current_realtime = world.timeofday

	if (current_realtime < last_tick_realtime) // midnight rollerover
		current_realtime = 864000 + schedule_interval

	var/current_byondtime = world.time
	var/current_tickcount = world.time/world.tick_lag

	if (!first_run)
		var/tick_drift = max(0, (((current_realtime - last_tick_realtime) - (current_byondtime - last_tick_byond_time)) / world.tick_lag))
		dilation = tick_drift / (current_tickcount - last_tick_tickcount) * 100
	else
		first_run = FALSE

	if (current_realtime == (864000 + schedule_interval))
		current_realtime = world.timeofday

	last_tick_realtime = current_realtime
	last_tick_byond_time = current_byondtime
	last_tick_tickcount = current_tickcount