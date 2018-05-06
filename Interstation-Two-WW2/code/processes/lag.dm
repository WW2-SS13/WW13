var/process/lag/lag_process = null

/process/lag

/process/lag/setup()
	name = "lag removal process"
	schedule_interval = 300 // every half minute
	start_delay = 10
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	lag_process = src

/process/lag/fire()
	SCHECK
	var/list/turf2casings = list()
	var/list/turf2cleanables = list()

	// get casings
	for (var/last_object in bullet_casings)
		var/obj/item/ammo_casing/A = last_object
		if (A.loc && isturf(A.loc)) // so we don't delete ammo casings in guns or mags or nullspace
			if (!turf2casings[A.loc])
				turf2casings[A.loc] = 0
			++turf2casings[A.loc]

	// get cleanables
	for (var/last_object in cleanables)
		var/obj/effect/decal/cleanable/C = last_object
		if (!turf2cleanables[C.loc])
			turf2cleanables[C.loc] = 0
		++turf2cleanables[C.loc]

	for (var/loc in turf2casings)
		if (turf2casings[loc] >= 2 && turf2casings[loc] <= 9)
			var/deleted = 0
			for (var/obj/item/ammo_casing/A in loc)
				bullet_casings -= A
				qdel(A)
				++deleted
				if (deleted >= turf2casings[loc]-1)
					break

	for (var/loc in turf2cleanables)
		if (turf2cleanables[loc] >= 2)
			var/deleted = 0
			for (var/obj/effect/decal/cleanable/C in loc)
				cleanables -= C
				qdel(C)
				++deleted
				if (deleted >= turf2cleanables[loc]-1)
					break