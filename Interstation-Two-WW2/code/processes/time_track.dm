// ported from /tg/station - Kachnov
/process/time_track
	var/dilation = 0
	var/last_tick_realtime = 0
	var/last_tick_byond_time = 0
	var/last_tick_tickcount = 0
	var/first_run = TRUE
	var/list/averages = list()

/process/time_track/setup()
	name = "Time Tracking"
	schedule_interval = 10 // this was 50, but this isn't expensive to track so every second is fine - Kachnov
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	averages.len = 10
	processes.time_track = src

/process/time_track/fire()
	SCHECK

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

	averages += dilation
	if (averages.len >= 20)
		var/list/old = averages.Copy()
		averages.Cut()
		averages.len = 10
		for (var/v in 11 to 20)
			averages[v-10] = old[v]

/process/time_track/proc/average_dilation()
	if (!averages.len)
		return 0
	. = 0
	for (var/n in averages)
		. += n
	. /= averages.len