var/datum/game_schedule/global_game_schedule = null

/datum/game_schedule
	// when the game is open to non-staff, UTC (4 hours ahead of EST)
	var/starttime = 16
	// when the game is closed to non-staff, UTC (4 hours ahead of EST)
	var/endtime = 21
	// days the game is CLOSED
	var/list/days_closed = list("Sunday", "Monday", "Tuesday")
	// a reference realtime, date (in DD-MM-YY format) and day:
	// this is not 100% accurate, but because starttime, endtime, are
	// independent of this, it doesn't matter
	var/refdate = "5619460480:22-10-17:Sunday"
	// the day
	var/day = "Sunday"
	// stored value of world.realtime at the time of creation
	var/realtime = -1

/datum/game_schedule/New(_starttime, _endtime)
	starttime = _starttime
	endtime = _endtime
	if (getCurrentTime() >= starttime && getCurrentTime() <= endtime)
		world_is_open = 1
	else
		world_is_open = 0

	// determine the day by counting from refdate's day
	var/split = splittext(refdate, ":")
	var/ref_realtime = text2num(split[1])
//	var/ref_date = split[2] // currently unused
	var/ref_day = split[3]
	var/days_elapsed = world.realtime - ref_realtime
	for (var/v in 1 to days_elapsed)
		ref_day = nextDay(ref_day)

	day = ref_day
	realtime = world.realtime

/datum/game_schedule/proc/getCurrentTime()
	// first, get the number of seconds that have elapsed since 00:00:00 today
	. = world.timeofday/10
	// now convert that to minutes
	. /= 60
	// now convert that to hours
	. /= 60
	// now we've returned the current time

/datum/game_schedule/proc/getScheduleAsString()
	return "from [starttime] to [endtime] UTC"

/proc/nextDay(day)
	switch (day)
		if ("Monday")
			return "Tuesday"
		if ("Tuesday")
			return "Wednesday"
		if ("Wednesday")
			return "Thursday"
		if ("Thursday")
			return "Friday"
		if ("Friday")
			return "Saturday"
		if ("Saturday")
			return "Sunday"
		if ("Sunday")
			return "Monday"