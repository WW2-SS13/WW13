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
	daynight_setting = "DAY"

	. = ..()

	if (prob(50))
		daynight_setting = "DAY"
		for (var/area/prishtina/p in world) // make indoor areas have full light
			if (istype(p) && !istype(p, /area/prishtina/void) && !istype(p, /area/prishtina/soviet/bunker) && !istype(p, /area/prishtina/soviet/bunker_entrance))
				p.dynamic_lighting = 0
	else
		daynight_setting = "NIGHT"
		for (var/area/prishtina/p in world) // make all areas use lighting
			if (istype(p) && !istype(p, /area/prishtina/train)) // not trains
				p.dynamic_lighting = 1

	create_all_lighting_corners()
	create_all_lighting_overlays()

	if (daynight_setting == "NIGHT")
		for (var/obj/machinery/light/l in world)
			l.brightness_power = 1
			l.brightness_range = round(l.brightness_range*1.33) // 7 to 9
			l.update_icon()


