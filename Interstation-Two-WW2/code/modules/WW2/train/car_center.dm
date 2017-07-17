//type definitions

/obj/train_car_center // this is an object and not a datum because we use locations and it's probably a pain to recode that
	var/list/forwards_pseudoturfs = list() // for when we're going forwards - start from bottom down
	var/list/backwards_pseudoturfs = list() // for when we're going backwards - start from top up
	var/datum/train_controller/master = null
	var/turf/connector_turfs = list() // these are references to turfs and need to be regenerated every time we move.
	name = ""

/obj/train_car_center/proc/regenerate_connector_turfs()

	switch (master.orientation)

		if (VERTICAL)

			connector_turfs = list()

			var/middleX = 1000000
			var/minX = 1000000
			var/minY = 1000000

			for (var/obj/train_pseudoturf/tpt in forwards_pseudoturfs)
				minY = min(minY, tpt.y)
				minX = min(minX, tpt.x)

			middleX = minX + 3 // todo : make this a constant based on train width

			//get pseudoturf 1 - middle x, lowest y - 1
			var/turf/t1 = locate(middleX, minY-1, z)

			connector_turfs["turf"] = t1
			connector_turfs["dir"] = SOUTH // dir we're adding the connectors in is always SOUTH for vertical trains

		if (HORIZONTAL)

			connector_turfs = list()

			var/middleY = 1000000
			var/minY = 1000000
			var/minX = 1000000

			for (var/obj/train_pseudoturf/tpt in forwards_pseudoturfs)
				minY = min(minY, tpt.y)
				minX = min(minX, tpt.x)

			middleY = minY + 3 // todo : make this a constant based on train width

			//get pseudoturf 1 - middle x, lowest y - 1
			var/turf/t1 = locate(middleY, minY-1, z)

			connector_turfs["turf"] = t1
			connector_turfs["dir"] = SOUTH // dir we're adding the connectors in is always SOUTH for vertical trains

/obj/train_car_center/proc/print_loc(var/atom/a)
	return "[a.x],[a.y],[a.z]"

/obj/train_car_center/proc/connect_to(var/obj/train_car_center/other)
	if (other)
		regenerate_connector_turfs()
		var/turf/t1 = connector_turfs["turf"]
		if (t1)
			var/turf/t2 = locate(t1.x+1, t1.y, t1.z)
			var/turf/t3 = locate(t1.x-1, t1.y, t1.z)
			var/dir = connector_turfs["dir"]

			for (var/v in 1 to 3)

				if (t1)
					master.add_connector(t1)
					t1 = get_step(t1, dir)

				if (t2)
					master.add_railing(t2, WEST) // WEST so it's squeezing the connector
					t2 = get_step(t2, dir)

				if (t3)
					master.add_railing(t3, EAST) // EAST so ditto
					t3 = get_step(t3, dir)


/obj/train_car_center/german

/obj/train_car_center/german/officer

/obj/train_car_center/german/storage

/obj/train_car_center/german/soldier

/obj/train_car_center/german/conductor

/obj/train_car_center/german/supplytrain

/obj/train_car_center/russian

/obj/train_car_center/russian/officer

/obj/train_car_center/russian/storage

/obj/train_car_center/russian/soldier

/obj/train_car_center/russian/conductor

//_Move proc
/obj/train_car_center/proc/_Move(direction)
	var/list/pseudoturfs = forwards_pseudoturfs
	if (direction == "BACKWARDS")
		pseudoturfs = backwards_pseudoturfs //shoddy attempt to fix backwards moving.
	for (var/obj/train_pseudoturf/tpt in pseudoturfs)
		tpt.save_contents_as_refs()

	// the new behavior for destroying objects requires that we do it
	// prior to moving. We don't have to do so for gibbing, but I do it anyway
	// so gibs don't get all over train walls anymore - Kachnov

	for (var/obj/train_pseudoturf/tpt in pseudoturfs) // run people down
		tpt.gib_idiots()

	for (var/obj/train_pseudoturf/tpt in pseudoturfs) // crush stuff in our way
		tpt.destroy_objects()

	#ifdef USE_TRAIN_LIGHTS
	for (var/obj/train_pseudoturf/tpt in pseudoturfs)
		tpt.reset_track_lights()
	#endif

	for (var/obj/train_pseudoturf/tpt in pseudoturfs)
		tpt._Move(direction)

	#ifdef USE_TRAIN_LIGHTS
	for (var/obj/train_pseudoturf/tpt in pseudoturfs)
		tpt.unset_track_lights()
	#endif

	for (var/obj/train_pseudoturf/tpt in pseudoturfs)
		tpt.move_mobs(direction)

	for (var/obj/train_pseudoturf/tpt in pseudoturfs)
		tpt.remove_contents_refs()
//Graft proc

/obj/train_car_center/proc/Graft(what)
	return

/obj/train_car_center/german/Graft(what)

	switch (what)
		if ("officer")
			var/area/a = locate(/area/prishtina/train/german/cabin/officer)
			var/min_x = min_area_x(a)
			var/max_y = max_area_y(a) // start at the minimum x and maximum y, ie top left corner
			for (var/turf/t in a.contents)
				var/x_offset = t.x - min_x
				var/y_offset = max_y - t.y
				var/z = t.z
				var/obj/train_pseudoturf/tpt = new/obj/train_pseudoturf(locate(src.x + x_offset,src.y - y_offset,z), t)
				tpt.master = src
				tpt.controller = src.master
				forwards_pseudoturfs += tpt
		if ("storage")
			var/area/a = locate(/area/prishtina/train/german/cabin/storage)
			var/min_x = min_area_x(a)
			var/max_y = max_area_y(a) // start at the minimum x and maximum y, ie top left corner
			for (var/turf/t in a.contents)
				var/x_offset = t.x - min_x
				var/y_offset = max_y - t.y
				var/z = t.z
				var/obj/train_pseudoturf/tpt = new/obj/train_pseudoturf(locate(src.x + x_offset,src.y - y_offset,z), t)
				tpt.master = src
				tpt.controller = src.master
				forwards_pseudoturfs += tpt
		if ("horizontal-storage")
			var/area/a = locate(/area/prishtina/train/german/cabin/storage/horizontal)
			var/min_x = min_area_x(a)
			var/max_y = max_area_y(a) // start at the minimum x and maximum y, ie top left corner
			for (var/turf/t in a.contents)
				var/x_offset = t.x - min_x
				var/y_offset = max_y - t.y
				var/z = t.z
				var/obj/train_pseudoturf/tpt = new/obj/train_pseudoturf(locate(src.x + x_offset,src.y - y_offset,z), t)
				tpt.master = src
				tpt.controller = src.master
				forwards_pseudoturfs += tpt
		if ("soldier")
			var/area/a = locate(/area/prishtina/train/german/cabin/soldier)
			var/min_x = min_area_x(a)
			var/max_y = max_area_y(a) // start at the minimum x and maximum y, ie top left corner
			for (var/turf/t in a.contents)
				var/x_offset = t.x - min_x
				var/y_offset = max_y - t.y
				var/z = t.z
				var/obj/train_pseudoturf/tpt = new/obj/train_pseudoturf(locate(src.x + x_offset,src.y - y_offset,z), t)
				tpt.master = src
				tpt.controller = src.master
				forwards_pseudoturfs += tpt
		if ("conductor")
			var/area/a = locate(/area/prishtina/train/german/cabin/conductor)
			var/min_x = min_area_x(a)
			var/max_y = max_area_y(a) // start at the minimum x and maximum y, ie bottom left corner
			for (var/turf/t in a.contents)
				var/x_offset = t.x - min_x
				var/y_offset = max_y - t.y
				var/z = t.z
				var/obj/train_pseudoturf/tpt = new/obj/train_pseudoturf(locate(src.x + x_offset,src.y - y_offset,z), t)
				tpt.master = src
				tpt.controller = src.master
				forwards_pseudoturfs += tpt

	backwards_pseudoturfs = forwards_pseudoturfs


/obj/train_car_center/russian/Graft(what)
	return

// and no graft procs for specific cars/cabins

//New() procs

/obj/train_car_center/New(_loc, _master)
	..()

	loc = _loc
	master = _master

/obj/train_car_center/german/New(_loc, _master)
	..(_loc, _master)

/obj/train_car_center/german/supplytrain/New(_loc, _master)
	..(_loc, _master)
	Graft("horizontal-storage")

/obj/train_car_center/german/officer/New(_loc, _master)
	..(_loc, _master)
	Graft("officer")

/obj/train_car_center/german/storage/New(_loc, _master)
	..(_loc, _master)
	Graft("storage")

/obj/train_car_center/german/soldier/New(_loc, _master)
	..(_loc, _master)
	Graft("soldier")

/obj/train_car_center/german/conductor/New(_loc, _master)
	..(_loc, _master)
	Graft("conductor")

/obj/train_car_center/russian/New(_loc, _master)
	..(_loc, _master)

/obj/train_car_center/russian/officer/New(_loc, _master)
	return

/obj/train_car_center/russian/storage/New(_loc, _master)
	return

/obj/train_car_center/russian/soldier/New(_loc, _master)
	return

/obj/train_car_center/russian/conductor/New(_loc, _master)
	return