var/global/datum/controller/process/ticker/tickerProcess

/datum/controller/process/ticker
	var/lastTickerTimeDuration
	var/lastTickerTime
	var/playtime_elapsed = 0

/datum/controller/process/ticker/setup()
	name = "ticker process"
	schedule_interval = 20 // every 2 seconds

	lastTickerTime = world.timeofday

	if(!ticker)
		ticker = new

	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)

	tickerProcess = src

	// what happens as soon as the server starts up
	spawn(0)
		if(ticker)
			ticker.pregame()
		start_serverswap_loop()
		start_serverdata_loop()

/datum/controller/process/ticker/doWork()
	SCHECK
	var/currentTime = world.timeofday

	if(currentTime < lastTickerTime) // check for midnight rollover
		lastTickerTimeDuration = (currentTime - (lastTickerTime - TICKS_IN_DAY)) / TICKS_IN_SECOND
	else
		lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	ticker.process()

	// for keeping track of time - Kachnov
	if (ticker.current_state == GAME_STATE_PLAYING)
		playtime_elapsed += schedule_interval

	// do map related stuff
	if (map)
		map.tick()

/datum/controller/process/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration
