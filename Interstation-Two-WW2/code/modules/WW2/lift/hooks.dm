/proc/handle_lifts()

	world << "<span class = 'notice'>Setting up the lift system.</span>"

	// assign lift IDs

	var/list/top_lifts = list()
	var/list/bottom_lifts = list()

	for (var/obj/lift_controller/master in world) // todo: remove
		if (master.istop)
			++top_lifts[master.area_id]
			master.lift_id = "ww2-l-[master.area_id]-[top_lifts[master.area_id]]"
		else
			++bottom_lifts[master.area_id]
			master.lift_id = "ww2-l-[master.area_id]-[bottom_lifts[master.area_id]]"

	// assign lift targets and corresponding areas
	for (var/obj/lift_controller/master in world)
		master.target = master.find_target()
		master.corresponding_area = get_area(master.target)

	// create lift pseudoturfs
	for (var/obj/lift_controller/down/master in world)
		if (istype(master))
			var/area/master_area = get_area(master)
			for (var/turf/t in master_area.get_turfs())
				var/obj/lift_pseudoturf/lpt = new/obj/lift_pseudoturf(t, null, master)
				lpt.master = master

	// link linked levers

	for (var/obj/lift_lever/linked/linked_lever in world)
		for (var/obj/lift_lever/counterpart in world)
			if (linked_lever != counterpart && linked_lever.type != counterpart.type)
				if (linked_lever.lever_id == counterpart.lever_id)
					linked_lever.counterpart = counterpart
					break

// helpers

/obj/lift_controller/proc/find_target()
	for (var/obj/lift_controller/master in world) // todo: get rid of
		if (lift_id == master.lift_id && master != src)
			return master