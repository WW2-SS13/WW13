/turf/simulated/floor/edgefloor //this is now a floor, not a wall, so that girders can be built on it
	name = ""
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass_dark"

	New()
		..()
		for (var/turf/t in range(1, src))
			if (!t.density && !istype(t, type))
				icon = t.icon
				icon_state = t.icon_state
				break

/obj/noghost
	icon = null
	icon_state = null
	name = ""
	opacity = 1
	layer = TURF_LAYER + 10