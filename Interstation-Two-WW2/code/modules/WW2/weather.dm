/var/global/weather = WEATHER_NONE
/var/global/weather_intensity = 1.0

/proc/change_weather(_weather = WEATHER_NONE, var/bypass_same_weather_check = FALSE)

	if (_weather == null)
		return

	if (weather == _weather && !bypass_same_weather_check)
		return

	var/old_weather = weather

	weather = _weather

	var/area_icon = 'icons/effects/weather.dmi'
	var/area_icon_state = ""
	var/area_alpha = 255

	switch (weather)
		if (WEATHER_SNOW)
			switch (weather_intensity)
				if (1.0)
					area_icon_state = "snow1"
					area_alpha = 75
				if (2.0)
					area_icon_state = "snow2"
					area_alpha = 100
				if (3.0)
					area_icon_state = "snow3"
					area_alpha = 125
		if (WEATHER_RAIN)
			switch (weather_intensity)
				if (1.0)
					area_icon_state = "rain1"
					area_alpha = 75
				if (2.0)
					area_icon_state = "rain2"
					area_alpha = 100
				if (3.0)
					area_icon_state = "rain3"
					area_alpha = 125

	for (var/area/prishtina/A in all_areas)
		if (istype(A) && A.location == AREA_OUTSIDE && A.z == TRUE)
			A.icon = area_icon
			A.icon_state = area_icon_state
			A.alpha = area_alpha
			A.weather = weather
			A.weather_intensity = weather_intensity

	if (old_weather != weather)
		announce_weather_change(old_weather, weather)

// happens every time the weather process ticks, right now 2 seconds
#define NO_NEW_SNOWFALL
#define SNOW_GATHERING_RATE 1.0
/proc/process_weather()
	if (weather == WEATHER_SNOW)
		#ifdef NO_NEW_SNOWFALL
		return
		#endif
		var/turfs_made_snowy = FALSE
		// randomize the areas we snow in
		var/list_of_areas = shuffle(all_areas)
		for (var/area/A in list_of_areas)
			if (A.snowfall_valid_turfs.len)
				// randomize the turfs we snow in
				var/min_index = TRUE
				var/max_index = A.snowfall_valid_turfs.len
				var/random_indices = list()

				for (var/v in TRUE to 15)
					random_indices |= rand(min_index, max_index)
				for (var/v in random_indices)
					var/turf/floor/F = A.snowfall_valid_turfs[v]
					if (!F)
						A.snowfall_valid_turfs -= F
						continue
					if (istype(F) && !F.has_snow())
						var/snowfall_prob = 20
						for (var/obj/snow/S in orange(1, F))
							snowfall_prob += 10
						if (prob(snowfall_prob))
							var/obj/snow/S = new/obj/snow(F)
							if (A.location == AREA_INSIDE)
								S.visible_message("<span class = 'danger'>Snow falls in from the ceiling.</span>")
							++turfs_made_snowy
							if (turfs_made_snowy >= rand(20*SNOW_GATHERING_RATE,30*SNOW_GATHERING_RATE))
								break
	else if (weather == WEATHER_RAIN)

		// delete cleanable decals that are outside
		var/deleted = 0
		for (var/obj/effect/decal/cleanable/C in world)
			var/area/A = get_area(C)
			if (A.weather == WEATHER_RAIN)
				qdel(C)
				++deleted
				if (deleted >= 100)
					break
/* // for performance reasons, mudiness is no longer handled here - Kachnov
		// randomize the areas we make muddy
		var/list_of_areas = shuffle(all_areas)
		for (var/area/A in list_of_areas)
			if (A.snowfall_valid_turfs.len) // even though this is rain, same reqs
				// randomize the turfs we make muddy
				var/min_index = TRUE
				var/max_index = A.snowfall_valid_turfs.len
				var/random_indices = list()

				for (var/v in TRUE to 40) // 2 to 3x more than snow affects
					random_indices |= rand(min_index, max_index)
				for (var/v in random_indices)
					var/turf/floor/F = A.snowfall_valid_turfs[v]
					if (!F)
						A.snowfall_valid_turfs -= F
						continue
					if (istype(F) && F.uses_winter_overlay)
						if (prob(33))
							F.muddy = TRUE
							spawn (rand(15000,25000))
								if (weather != WEATHER_RAIN)
									F.muddy = FALSE*/

/proc/modify_weather_somehow()
	if (weather == WEATHER_NONE)
		return

	var/old_intensity = weather_intensity

	if (prob(66) && weather_intensity < 3.0)
		++weather_intensity
	else if (weather_intensity > 1.0)
		--weather_intensity
	change_weather(weather, TRUE)

	if (old_intensity != weather_intensity)
		announce_weather_mod(old_intensity, weather_intensity)

/proc/change_weather_somehow()

	var/list/possibilities = list(WEATHER_NONE)
	var/list/non_possibilities = list(weather)

	if (ticker.mode.vars.Find("season"))
		switch (ticker.mode:season)
			if ("WINTER")
				possibilities += WEATHER_SNOW
			if ("SPRING", "SUMMER")
				possibilities += WEATHER_RAIN

	possibilities -= non_possibilities

	change_weather(pick(possibilities))

/proc/get_weather(var/_weather)
	switch (_weather ? _weather : weather)
		if (WEATHER_NONE)
			return "none"
		if (WEATHER_SNOW)
			return "snow"
		if (WEATHER_RAIN)
			return "rain"

// global weather variable changed
/proc/announce_weather_change(var/old, var/_new)
	switch (_new)
		if (WEATHER_NONE)
			switch (old)
				if (WEATHER_NONE)
					. = ""
				if (WEATHER_SNOW, WEATHER_RAIN)
					. = "It's no longer <b>[get_weather(old)]ing</b>."
		if (WEATHER_SNOW, WEATHER_RAIN)
			switch (old)
				if (WEATHER_NONE)
					. = "It's now <b>[get_weather(_new)]ing</b>."
				if (WEATHER_SNOW,  WEATHER_RAIN)
					. = ""
	if (.)
		world << "<font size=3><span class = 'notice'>[.]</span></font>"

// global weather_intensity variable changed
/proc/announce_weather_mod(var/old, var/_new)
	. = ""
	switch (_new)
		if (1.0)
			. = "slowly"
		if (2.0)
			. = "quickly"
		if (3.0)
			. = "rapidly"

	var/weathertype = ""
	switch (weather)
		if (WEATHER_SNOW)
			weathertype = "snow"
		if (WEATHER_RAIN)
			weathertype = "rain"

	if (weather == WEATHER_NONE)
		. = ""

	if (.)
		world << "<font size=3><span class = 'notice'>[capitalize(weathertype)] is now coming down [.].</span></font>"