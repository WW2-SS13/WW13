//With air
/turf/floor/plating/asteroid //floor piece
	name = "sand"
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	interior = 0
	stepsound = "dirt"

/turf/shuttle/helicopter
	name = "Helicopter cassis"
	icon = 'icons/WW2/helicopter.dmi'
	opacity = 0
	density = 1

	New()
		..()
//		if (!istype(src, /turf/shuttle/helicopter/sdkfz))
	//		var/turf/shuttle/helicopter/sdkfz/truck = new/turf/shuttle/helicopter/sdkfz(src, "0[icon_state]")
		update()

	proc/update()
		for (var/turf/t in range(1, src))
			if (!istype(t, /turf/shuttle/helicopter))
				if (!(t.y < y))
					density = 1
					return
		density = 0

/turf/shuttle/helicopter/sdkfz // "trucks"
	name = "Truck cassis"
	icon = 'icons/WW2/sdkfz.dmi'
	opacity = 0
	density = 1

	New(var/state)
		icon_state = state
		..()
		update()
