//#define ALWAYS_DAY



var/time_of_day = "Morning"
var/list/times_of_day = list("Early Morning", "Morning", "Afternoon", "Midday", "Evening", "Night", "Midnight")
// from lightest to darkest: midday, afternoon, morning, early morning, evening, night, midnight
var/list/time_of_day2luminosity = list(
	"Early Morning" = 0.3,
	"Morning" = 0.5,
	"Afternoon" = 0.6,
	"Midday" = 1.0,
	"Evening" = 0.4,
	"Night" = 0.2,
	"Midnight" = 0.1)

/proc/isDarkOutside()
	if (time_of_day in list("Early Morning", "Evening", "Night", "Midnight"))
		return 1
	return 0

/proc/pick_TOD()
	// attempt to fix broken BYOND probability

	// do not shuffle the actual list, we need it to stay in order
	var/list/c_times_of_day = shuffle(times_of_day)
	#ifdef ALWAYS_DAY
	return "Midday"
	#else
	// chance of midday: ~52%. Chance of afternoon: ~27%. Chance of any other: ~21%
	if (prob(50))
		if (prob(75))
			return "Midday"
		else
			return "Afternoon"
	else
		return pick(c_times_of_day)
	#endif

/proc/progress_time_of_day(var/caller = null)

	var/TOD_position_in_list = 1
	for (var/v in 1 to times_of_day.len)
		if (times_of_day[v] == time_of_day)
			TOD_position_in_list = v

	++TOD_position_in_list
	if (TOD_position_in_list > times_of_day.len)
		TOD_position_in_list = 1

	for (var/v in 1 to times_of_day.len)
		if (v == TOD_position_in_list)
			update_lighting(times_of_day[v], admincaller = caller)