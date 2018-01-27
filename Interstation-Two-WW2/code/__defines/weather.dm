/* none of these constants should be == 0, because change_weather(weather)
 breaks if weather == null */

#define WEATHER_NONE 1
#define WEATHER_RAIN 2
#define WEATHER_SNOW 3

/proc/weather_const2text(var/constant)
	switch (constant)
		if (WEATHER_NONE)
			return "NONE"
		if (WEATHER_RAIN)
			return "RAIN"
		if (WEATHER_SNOW)
			return "SNOW"
	return ""