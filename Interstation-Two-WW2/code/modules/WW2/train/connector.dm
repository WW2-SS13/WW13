//based off of /obj/structure/lattice, but way simpler

/obj/train_connector
	name = "train"
	icon = 'icons/obj/structures.dmi'
	icon_state = "latticefull"
	density = 0
	anchored = 1.0
	w_class = 3
	layer = 2.3 //under pipes
	//	flags = CONDUCT
	var/occupied = 0
	var/last_loc = null
	var/datum/train_controller/master = null

/obj/train_connector/proc/_Move()
	for (var/atom/movable/a in get_turf(src))
		if (check_object_invalid_for_moving(src, a))
			continue
		a.y+=master.getMoveInc()
	y+=master.getMoveInc()

// copied from /obj/train_pseudoturf/move_mobs()

/obj/train_connector/proc/move_mobs(var/_direction)
	for (var/atom/movable/a in get_turf(src))
		if (ismob(a))
			var/mob/m = a
			if (!isnull(m.next_train_movement))
				var/atom/movable/p = m.pulling

				switch (m.next_train_movement)
					if (NORTH)
						m.Move(locate(m.x, m.y+1, m.z))
						if (p) p.Move(locate(p.x, p.y+1, p.z))
					if (SOUTH)
						m.Move(locate(m.x, m.y-1, m.z))
						if (p) p.Move(locate(p.x, p.y-1, p.z))
					if (EAST)
						m.Move(locate(m.x+1, m.y, m.z))
						if (p) p.Move(locate(p.x+1, p.y, p.z))
					if (WEST)
						m.Move(locate(m.x-1, m.y, m.z))
						if (p) p.Move(locate(p.x-1, p.y, p.z))

				m.dir = m.next_train_movement
				if (p) p.dir = m.next_train_movement
				m.start_pulling(p) // start_pulling checks for p on its own
				m.next_train_movement = null
				m.train_gib_immunity = 0

/obj/train_connector/ex_act(severity)
	if (prob(round(90 * (1/severity))))
		qdel(src)
	else
		return