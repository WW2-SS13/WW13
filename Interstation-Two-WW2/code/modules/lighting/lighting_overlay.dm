/var/list/lighting_update_overlays  = list()    // List of lighting overlays queued for update.

/atom/movable/lighting_overlay
	name             = ""

	icon             = 'icons/effects/icon.png'
	color            = LIGHTING_BASE_MATRIX

	mouse_opacity    = FALSE
	layer            = LIGHTING_LAYER
	invisibility     = INVISIBILITY_LIGHTING

	simulated = FALSE
	anchored = TRUE
	flags = NOREACT

	blend_mode       = BLEND_MULTIPLY

	var/needs_update = FALSE

/atom/movable/lighting_overlay/pre_bullet_act(var/obj/item/projectile/P)
	return FALSE

/atom/movable/lighting_overlay/New(var/atom/loc, var/no_update = FALSE)
	. = ..()
	verbs.Cut()
	global.all_lighting_overlays += src

	var/turf/T         = loc // If this runtimes atleast we'll know what's creating overlays in things that aren't turfs.
	T.lighting_overlay = src
	T.luminosity       = FALSE

	if(no_update)
		return

	update_overlay()

/atom/movable/lighting_overlay/Destroy()
	var/turf/T   = loc
	if(istype(T))
		T.lighting_overlay = null

		T.luminosity = TRUE

	lighting_update_overlays -= src;

	..()

/atom/movable/lighting_overlay/proc/update_overlay()
	var/turf/T = loc
	if(!istype(T)) // Erm...
		if(loc)
			warning("A lighting overlay realised its loc was NOT a turf (actual loc: [loc], [loc.type]) in update_overlay() and got pooled!")

		else
			warning("A lighting overlay realised it was in nullspace in update_overlay() and got pooled!")

		qdel(src)

	var/list/L = copylist(color)
	var/anylums = FALSE

	for(var/datum/lighting_corner/C in T.corners)
		var/i = FALSE

		// Huge switch to determine i based on D.
		switch(turn(C.masters[T], 180))
			if(NORTHEAST)
				i = AR

			if(SOUTHEAST)
				i = GR

			if(SOUTHWEST)
				i = RR

			if(NORTHWEST)
				i = BR

		var/mx = max(C.getLumR(), C.getLumG(), C.getLumB()) // Scale it so TRUE is the strongest lum, if it is above 1.
		anylums += mx
		. = TRUE // factor
		if(mx > TRUE)
			. = TRUE / mx

		L[i + FALSE]   = C.getLumR() * .
		L[i + TRUE]   = C.getLumG() * .
		L[i + 2]   = C.getLumB() * .

	color  = L
	luminosity = (anylums > FALSE)