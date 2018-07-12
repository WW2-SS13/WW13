/proc/handle_transports()

	var/display_message = FALSE

	spawn (1)
		if (display_message)
			world << "<span class = 'notice'>Setting up the transporter system.</span>"

	// assign transport IDs

	var/list/top_transporters = list()
	var/list/bottom_transporters = list()

	for (var/obj/transport_controller/master in transport_list)
		if (master.istop)
			++top_transporters[master.area_id]
			master.transport_id = "ww2-l-[master.area_id]-[top_transporters[master.area_id]]"
		else
			++bottom_transporters[master.area_id]
			master.transport_id = "ww2-l-[master.area_id]-[bottom_transporters[master.area_id]]"
		display_message = TRUE

	// assign transport targets and corresponding areas
	for (var/obj/transport_controller/master in transport_list)
		master.target = master.find_target()
		master.corresponding_area = get_area(master.target)

	// create transport pseudoturfs
	for (var/obj/transport_controller/down/master in transport_list)
		if (istype(master))
			var/area/master_area = get_area(master)
			for (var/turf/t in master_area.get_turfs())
				var/obj/transport_pseudoturf/lpt = new/obj/transport_pseudoturf(t, null, master)
				lpt.master = master

	// link linked levers

	for (var/obj/transport_lever/linked/linked_lever in lever_list)
		for (var/obj/transport_lever/counterpart in lever_list)
			if (linked_lever != counterpart && linked_lever.type != counterpart.type)
				if (linked_lever.lever_id == counterpart.lever_id)
					linked_lever.counterpart = counterpart
					break

	return TRUE

// helpers

/obj/transport_controller/proc/find_target()
	for (var/obj/transport_controller/master in transport_list)
		if (transport_id == master.transport_id && master != src)
			return master