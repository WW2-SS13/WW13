var/global/datum/controller/process/ticker/tickerProcess
var/list/supply_points = list(GERMAN = 250, SOVIET = 250)

/datum/controller/process/ticker
	var/lastTickerTimeDuration
	var/lastTickerTime
	var/time_elapsed = 0

/datum/controller/process/ticker/setup()
	name = "ticker"
	schedule_interval = 20 // every 2 seconds

	lastTickerTime = world.timeofday

	if(!ticker)
		ticker = new

	tickerProcess = src

	spawn(0)
		if(ticker)
			ticker.pregame()
		start_serverswap_loop()
		start_serverdata_loop()

/datum/controller/process/ticker/doWork()
	var/currentTime = world.timeofday

	if(currentTime < lastTickerTime) // check for midnight rollover
		lastTickerTimeDuration = (currentTime - (lastTickerTime - TICKS_IN_DAY)) / TICKS_IN_SECOND
	else
		lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	ticker.process()

	/* todo: make this code into its own process - Kachnov
	 * all radios at the same type are linked, when one spends points,
	 * so do the others. This system could use datumization but its fine
	 * for now. */

	// small map and any other maps - soviet supply advantage
	if (!istype(map, /obj/map_metadata/forest))
		supply_points[GERMAN] += 0.50
		supply_points[SOVIET] += 0.75
	// forest map - german supply advantage: trains produce more points
	else if (german_supplytrain_master)
		supply_points[SOVIET] += 0.75
		german_supplytrain_master.supply_points += 1.00

	// for keeping track of time - Kachnov
	time_elapsed += schedule_interval

	// do map related stuff
	if (map)
		map.tick()

/datum/controller/process/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration
