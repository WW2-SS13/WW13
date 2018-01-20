/turf
	var/dynamic_lighting = TRUE
	luminosity           = TRUE

	var/list/affecting_lights       // List of light sources affecting this turf.
	var/tmp/atom/movable/lighting_overlay/lighting_overlay // Our lighting overlay.
	var/tmp/list/datum/lighting_corner/corners[4]
	var/tmp/has_opaque_atom = FALSE // Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile.

/turf/New()
	. = ..()

	if(opacity)
		has_opaque_atom = TRUE

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	for(var/A in affecting_lights)
		if(!A)
			continue

		var/datum/light_source/L = A
		L.vis_update()

/turf/proc/lighting_clear_overlay()
	if(lighting_overlay)
		qdel(lighting_overlay)

	for(var/A in corners)
		if(!A)
			continue

		var/datum/lighting_corner/C = A
		C.update_active()

// Builds a lighting overlay for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if(!lighting_overlay)
		var/area/A = loc
		if(A.dynamic_lighting)
			PoolOrNew(/atom/movable/lighting_overlay, src)

			for(var/LC in corners)
				if(!LC)
					continue

				var/datum/lighting_corner/C = LC
				if(!C.active) // We would activate the corner, calculate the lighting for it.
					for(var/L in C.affecting)
						var/datum/light_source/S = L
						S.recalc_corner(C)

					C.active = TRUE

// DAYLIGHT RELATED MEMBER PROCS

// make this turf have a darkness level based on the time of day
/turf/proc/adjust_lighting_overlay_to_daylight()

	fix_corners_and_lighting_overlay()

	var/changed = FALSE

	for (var/datum/lighting_corner/corner in corners)
		corner.TOD_lum_r = time_of_day2luminosity[time_of_day]
		corner.TOD_lum_g = time_of_day2luminosity[time_of_day]
		corner.TOD_lum_b = time_of_day2luminosity[time_of_day]
		changed = TRUE

	if (changed)
		if (lighting_overlay)
			lighting_overlay.update_overlay()
/*
		spawn (1)
			for (var/obj/machinery/light/L in src)
				L.fix_TOD_lights()
*/
// HACKCODE

/turf/proc/fix_broken_daylights()
	var/area/A = get_area(src)
	if (!A.dynamic_lighting)
		adjust_lighting_overlay_to_daylight()
		reconsider_lights()

/turf/proc/fix_corners_and_lighting_overlay() // workaround for broken ice corners
	if (istype(src, /turf/floor/plating/beach/water/ice))
		for(var/i = TRUE to 4)
			if(corners[i]) // Already have a corner on this direction.
				continue

			corners[i] = new/datum/lighting_corner(src, LIGHTING_CORNER_DIAGONAL[i])
		for (var/atom/movable/lighting_overlay/LO in contents)
			lighting_overlay = LO
			break
/*
// make this turf have NO darkness. Used exclusively for trains (for now)
/turf/proc/adjust_lighting_overlay_to_train_light()

	var/changed = FALSE
	for (var/datum/lighting_corner/corner in corners)
		if (corner.TOD_lum_r)
			corner.lum_r = 1.0
			corner.lum_g = 1.0
			corner.lum_b = 1.0
			corner.TOD_lum_r = 1.0
			corner.TOD_lum_g = 1.0
			corner.TOD_lum_b = 1.0
			changed = TRUE

	if (changed)
		lighting_overlay.update_overlay()*/

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(var/minlum = FALSE, var/maxlum = TRUE)
	if(!lighting_overlay)
		return 0.5

	var/totallums = FALSE
	for(var/LL in corners)
		var/datum/lighting_corner/L = LL
		totallums += L.getLumR() + L.getLumB() + L.getLumG()

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = (totallums - minlum) / (maxlum - minlum)

	return CLAMP01(totallums)

// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
	has_opaque_atom = FALSE
	for(var/atom/A in contents + src) // Loop through every movable atom on our tile PLUS ourselves (we matter too...)
		if(A.opacity)
			has_opaque_atom = TRUE

// If an opaque movable atom moves around we need to potentially update visibility.
/turf/Entered(var/atom/movable/Obj, var/atom/OldLoc)
	. = ..()

	if(Obj && Obj.opacity)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()

/turf/Exited(var/atom/movable/Obj, var/atom/newloc)
	. = ..()

	if(Obj && Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

/turf/change_area(var/area/old_area, var/area/new_area)
	if(new_area.dynamic_lighting != old_area.dynamic_lighting)
		if(new_area.dynamic_lighting)
			lighting_build_overlay()

		else
			lighting_clear_overlay()

/turf/proc/get_corners(var/dir)
	if(has_opaque_atom)
		return null // Since this proc gets used in a for loop, null won't be looped though.

	return corners