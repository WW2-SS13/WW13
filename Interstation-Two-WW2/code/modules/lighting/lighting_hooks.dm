// after lights are setup
/hook/roundstart/proc/make_lights_visible()
	spawn (LIGHTING_CHANGE_TIME*1.1)
		for (var/atom/movable/lighting_overlay/LO in world)
			LO.invisibility = 0
	// turning lights on and off fixes a bug that causes some lighting overlays to be invisible
	spawn (LIGHTING_CHANGE_TIME*1.5)
		for (var/obj/structure/light/L in world)
			L.on = !L.on
			L.update(0, nosound = TRUE)
			L.on = (L.status == LIGHT_OK)
			L.update(0, nosound = TRUE)