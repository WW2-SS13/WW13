

/var/list/all_lighting_overlays   = list()    // Global list of lighting overlays.
/var/lighting_corners_initialised = FALSE

/proc/create_all_lighting_overlays()
	for(var/zlevel = 1 to world.maxz)
		create_lighting_overlays_zlevel(zlevel)

/proc/create_lighting_overlays_zlevel(var/zlevel)
	ASSERT(zlevel)

	for(var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if(!T.dynamic_lighting)
			continue
		else
			var/area/A = T.loc
			if(!A.dynamic_lighting)
				continue

		PoolOrNew(/atom/movable/lighting_overlay, T, TRUE)

/proc/create_all_lighting_corners()
	for(var/zlevel = 1 to world.maxz)
		create_lighting_corners_zlevel(zlevel)

	global.lighting_corners_initialised = TRUE

	for (var/turf/t in world)

		if (!locate(/obj/train_track) in t.contents)
			if (istype(t, /turf/floor/plating/road) || istype(t, /turf/floor/plating/cobblestone) || istype(t, /turf/floor/dirt) || istype(t, /turf/floor/plating/grass) || istype(t, /turf/wall) || istype(t, /turf/floor/plating/beach) || istype(t, /turf/floor/plating/asteroid) || locate(/obj/structure/catwalk) in t.contents)
				var/area/a = t.loc
				if (a.dynamic_lighting && !istype(a, /area/prishtina/soviet/bunker) && !istype(a, /area/prishtina/soviet/bunker_entrance) && !istype(a, /area/prishtina/void))
					for (var/datum/lighting_corner/corner in t.corners)

						corner.TOD_lum_r = time_of_day2luminosity[time_of_day]
						corner.TOD_lum_g = time_of_day2luminosity[time_of_day]
						corner.TOD_lum_b = time_of_day2luminosity[time_of_day]

	// todo: make train tracks have darkness w/o making the train area
	// have dynamic lighting
	/*	e lse
			for (var/obj/train_track/tt in t.contents)
				var/r = ceil(time_of_day2luminosity[time_of_day] * 255)
				var/g = ceil(time_of_day2luminosity[time_of_day] * 255)
				var/b = ceil(time_of_day2luminosity[time_of_day] * 255)
				var/turf/tt_turf = get_turf(tt)
				tt_turf.color = rgb(r,g,b)*/

/proc/create_lighting_corners_zlevel(var/zlevel)
	for(var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if(!T.dynamic_lighting)
			continue
		else
			var/area/A = T.loc
			if(!A.dynamic_lighting)
				continue
		for(var/i = 1 to 4)
			if(T.corners[i]) // Already have a corner on this direction.
				continue

			T.corners[i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[i])


/world/New()

	#ifndef ALWAYS_DAY
	time_of_day = pick(times_of_day)
	#else
	time_of_day = "Midday"
	#endif

	. = ..()

	if (time_of_day == "Midday") // we have no darkness whatsoever
		for (var/area/prishtina/p in world) // make indoor areas have full light
			if (istype(p) && !istype(p, /area/prishtina/void) && !istype(p, /area/prishtina/soviet/bunker) && !istype(p, /area/prishtina/soviet/bunker_entrance))
				p.dynamic_lighting = 0
	else
		for (var/area/prishtina/p in world) // make all areas use lighting
			if (istype(p) && !istype(p, /area/prishtina/train) && !istype(p, /area/prishtina/german/train_zone) && !istype(p, /area/prishtina/german/armory/train))
				p.dynamic_lighting = 1
	/*	todo: fix train lights
	var/area/prishtina/german/train_zone/train_zone = locate() in world
	for (var/turf/t in train_zone.contents)
		for (var/obj/machinery/light/light in t.contents)
			light.brightness_range = 0
			light.brightness_power = 0
			light.update(0, 1, 1)*/



	create_all_lighting_corners()
	create_all_lighting_overlays()
