var/process/time_of_day_change/time_of_day_change_process = null

/process/time_of_day_change
	var/ready = FALSE
	var/changeto = null
	var/admincaller = null
	var/announce = TRUE

/process/time_of_day_change/setup()
	name = "time of day change process"
	schedule_interval = 10
	start_delay = 0
	fires_at_gamestates = list(GAME_STATE_PLAYING)
	time_of_day_change_process = src

/process/time_of_day_change/fire()
	SCHECK_09

	if (!ready)
		return

	ready = FALSE

	var/O_time_of_day = time_of_day
	time_of_day = changeto

	// change lighting over x seconds & x*10 loops

	var/max_v = LIGHTING_CHANGE_TIME
	var/turfs_len = turfs.len // this makes things faster and it works because single-threadedness
	for (var/v in 1 to max_v)
		var/iterations_per_loop = ceil(turfs.len/max_v)
		for (var/vv in 1+(iterations_per_loop*(v-1)) to iterations_per_loop*v)
			if (turfs_len >= vv && turfs[vv])
				var/turf/t = turfs[vv]
				if (t.z <= max_lighting_z)
					var/area/a = get_area(t)

					var/areacheck = TRUE
					if (map)
						for (var/area_type in map.areas_without_lighting)
							if (istype(a, area_type))
								areacheck = FALSE
								break
							SCHECK_09

					if (a && a.dynamic_lighting && areacheck && (!map || !map.zlevels_without_lighting.Find(t.z)))
						t.adjust_lighting_overlay_to_daylight()
					else
					/*
						// You have to do this instead of deleting t.lighting_overlay.
						for (var/atom/movable/lighting_overlay/LO in t.contents)
							qdel(LO)*/

						// todo: way to determine if walls should be dark or not
						if (locate_type(/obj/train_track, t))
							t.color = rgb(255, 255, 255)
							var/TOD_2_rgb = min(255, round(time_of_day2luminosity[time_of_day] * 255))
							t.color = rgb(TOD_2_rgb, TOD_2_rgb, TOD_2_rgb)
							for (var/obj/train_track/TT in t.contents)
								TT.color = t.color
								SCHECK_09

				// regardless of whether or not we use dynamic lighting here
				// we still need to change the TOD to prevent Vampire dusting
				for (var/atom/movable/lighting_overlay/LO in t.contents)
					LO.TOD = time_of_day
					SCHECK_09
			SCHECK_09
		SCHECK_09

	if (admincaller)
		admincaller << "<span class = 'notice'>Updated lights for [time_of_day].</span>"
		var/M = "[key_name(admincaller)] changed the time of day from [O_time_of_day] to [time_of_day]."
		log_admin(M)
		message_admins(M)

	if (announce)
		for (var/M in player_list)
			M << "<font size=3><span class = 'notice'>It's <b>[lowertext(capitalize(time_of_day))]</b>.</span></font>"

	if (!setup_lighting)
		for (var/atom/movable/lighting_overlay/LO in world)
			if (LO.invisibility)
				LO.invisibility = 0

	setup_lighting = TRUE