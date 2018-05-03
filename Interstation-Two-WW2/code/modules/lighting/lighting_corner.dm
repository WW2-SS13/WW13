// Because we can control each corner of every lighting overlay.
// And corners get shared between multiple turfs (unless you're on the corners of the map, then TRUE corner doesn't).
// For the record: these should never ever ever be deleted, even if the turf doesn't have dynamic lighting.

// This list is what the code that assigns corners listens to, the order in this list is the order in which corners are added to the /turf/corners list.
/var/list/LIGHTING_CORNER_DIAGONAL = list(NORTHEAST, SOUTHEAST, SOUTHWEST, NORTHWEST)

/datum/lighting_corner
	var/list/turf/masters                 = list()
	var/list/datum/light_source/affecting = list() // Light sources affecting us.
	var/active                            = FALSE  // TRUE if one of our masters has dynamic lighting.

	var/x     = FALSE
	var/y     = FALSE

	// luminosity values based on lights
	var/lum_r = 0.0
	var/lum_g = 0.0
	var/lum_b = 0.0

	// luminosity values based on the time of day
	var/TOD_lum_r = 0.0
	var/TOD_lum_g = 0.0
	var/TOD_lum_b = 0.0

	// misc
	var/window_coeff = 0.0
	var/next_calculate_window_coeff = -1

/datum/lighting_corner/proc/calculate_window_coeff()
	. = 0

	var/turf/T = masters[1]
	var/area/T_area = get_area(T)

	if (T_area.location == AREA_OUTSIDE)
		window_coeff = 1.0
		return window_coeff

	// objects that let in light
	for (var/turf/TT in view(10, T))
		if (!TT.density)
			var/area/TT_area = get_area(TT)
			if (TT_area.location == AREA_OUTSIDE)
				. += (1/abs_dist(T, TT))

	// dividing '.' by 7 returns a more reasonable number - Kachnov
	window_coeff = min(1.0, (.)/7)
	return window_coeff

// new system for handling time of day and luminosity
/datum/lighting_corner/proc/getLumR()
	/* calculate_window_coeff() is very expensive so only do it once in a while
	 * the reason its done here is because getLumR() is always called first - Kachnov */
	if (world.time >= next_calculate_window_coeff)
		calculate_window_coeff()
		next_calculate_window_coeff = world.time + 300
	return min(1.0, lum_r + (TOD_lum_r * window_coeff))

/datum/lighting_corner/proc/getLumG()
	return min(1.0, lum_g + (TOD_lum_g * window_coeff))

/datum/lighting_corner/proc/getLumB()
	return min(1.0, lum_b + (TOD_lum_b * window_coeff))

/datum/lighting_corner/New(var/turf/new_turf, var/diagonal)
	. = ..()

	var/area/A = get_area(new_turf)
	// bunker is darker
	if (A && istype(A, /area/prishtina/soviet/bunker))
		lum_r = 0.3
		lum_g = 0.3
		lum_b = 0.3

	masters[new_turf] = turn(diagonal, 180)

	var/vertical   = diagonal & ~(diagonal - 1) // The horizontal directions (4 and 8) are bigger than the vertical ones (1 and 2), so we can reliably say the lsb is the horizontal direction.
	var/horizontal = diagonal & ~vertical       // Now that we know the horizontal one we can get the vertical one.

	x = new_turf.x + (horizontal == EAST  ? 0.5 : -0.5)
	y = new_turf.y + (vertical   == NORTH ? 0.5 : -0.5)

	// My initial plan was to make this loop through a list of all the dirs (horizontal, vertical, diagonal).
	// Issue being that the only way I could think of doing it was very messy, slow and honestly overengineered.
	// So we'll have this hardcode instead.
	var/turf/T
	var/i

	// Diagonal one is easy.
	T = get_step(new_turf, diagonal)
	if(T) // In case we're on the map's border.
		masters[T]   = diagonal
		i            = LIGHTING_CORNER_DIAGONAL.Find(turn(diagonal, 180))
		T.corners[i] = src

	// Now the horizontal one.
	T = get_step(new_turf, horizontal)
	if(T) // Ditto.
		masters[T]   = ((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH) // Get the dir based on coordinates.
		i            = LIGHTING_CORNER_DIAGONAL.Find(turn(masters[T], 180))
		T.corners[i] = src

	// And finally the vertical one.
	T = get_step(new_turf, vertical)
	if(T)
		masters[T]   = ((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH) // Get the dir based on coordinates.
		i            = LIGHTING_CORNER_DIAGONAL.Find(turn(masters[T], 180))
		T.corners[i] = src

	spawn() // Lighting overlays get initialized AFTER corners, so this spawn() will make sure the activity (which checks for overlays) is updated after the overlays are generated.
		update_active()

/datum/lighting_corner/proc/update_active()
	active = FALSE
	for(var/TT in masters)
		var/turf/T = TT
		if(T.lighting_overlay)
			active = TRUE

// God that was a mess, now to do the rest of the corner code! Hooray!
/datum/lighting_corner/proc/update_lumcount(var/delta_r, var/delta_g, var/delta_b)

	lum_r += delta_r
	lum_g += delta_g
	lum_b += delta_b

	for(var/TT in masters)
		var/turf/T = TT
		if(T.lighting_overlay)
			#ifdef LIGHTING_INSTANT_UPDATES
			T.lighting_overlay.update_overlay()
			#else
			if(!T.lighting_overlay.needs_update)
				T.lighting_overlay.needs_update = TRUE
				lighting_update_overlays += T.lighting_overlay
			#endif


