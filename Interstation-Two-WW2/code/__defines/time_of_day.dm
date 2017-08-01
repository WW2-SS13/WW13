var/time_of_day = "Morning"
var/list/times_of_day = list("Morning", "Afternoon", "Midday", "Evening", "Night", "Midnight", "Early Morning")
// from lightest to darkest: midday, afternoon, morning, early morning, evening, night, midnight
var/list/time_of_day2luminosity = list(
	"Midday" = 1.0,
	"Afternoon" = 0.8,
	"Morning" = 0.7,
	"Evening" = 0.5,
	"Early Morning" = 0.4,
	"Night" = 0.3,
	"Midnight" = 0.2)
