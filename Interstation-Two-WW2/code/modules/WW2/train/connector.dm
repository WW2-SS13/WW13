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
	var/list/saved_contents = list()

// #define TCDEBUG

/obj/train_connector/proc/save_contents_as_refs()
	for (var/atom/movable/a in get_turf(src))
		if (!check_object_invalid_for_moving(src, a))
			saved_contents += a

/obj/train_connector/proc/remove_contents_refs()
	saved_contents.Cut()

// copied from /obj/train_pseudoturf/_Move()
/obj/train_connector/proc/_Move()

	for (var/atom/movable/a in saved_contents)
		if (ismob(a))
			var/mob/m = a
			m.original_pulling = m.pulling
			if (!m.buckled)
				switch (master.orientation)
					if (VERTICAL)
						m.train_move(locate(m.x, m.y+master.getMoveInc(), m.z))
					if (HORIZONTAL)
						m.train_move(locate(m.x+master.getMoveInc(), m.y, m.z))
		else
			switch (master.orientation)
				if (VERTICAL)
					a.train_move(locate(a.x, a.y+master.getMoveInc(), a.z))
				if (HORIZONTAL)
					a.train_move(locate(a.x+master.getMoveInc(), a.y, a.z))

			if (istype(a, /obj/structure/bed))
				var/obj/structure/bed/bed = a
				var/mob/m = bed.buckled_mob
				if (m)
					switch (master.orientation)
						if (VERTICAL)
							m.train_move(locate(m.x, m.y+master.getMoveInc(), m.z))
						if (HORIZONTAL)
							m.train_move(locate(m.x+master.getMoveInc(), m.y, m.z))

	for (var/mob/m in saved_contents)
		if (istype(m))
			m.start_pulling(m.original_pulling)
			m.original_pulling = null

	switch (master.orientation)
		if (VERTICAL)
			y+=master.getMoveInc()
		if (HORIZONTAL)
			x+=master.getMoveInc()

// copied from /obj/train_pseudoturf/move_mobs()

/obj/train_connector/proc/move_mobs(var/_direction)
	for (var/atom/movable/a in get_turf(src))
		if (ismob(a))
			var/mob/m = a
			if (!isnull(m.next_train_movement))
				var/atom/movable/p = m.pulling

				// orientation is irrelevant here
				switch (m.next_train_movement)
					if (NORTH)
						m.train_move(locate(m.x, m.y+1, m.z))
						if (p) p.train_move(locate(p.x, p.y+1, p.z))
					if (SOUTH)
						m.train_move(locate(m.x, m.y-1, m.z))
						if (p) p.train_move(locate(p.x, p.y-1, p.z))
					if (EAST)
						m.train_move(locate(m.x+1, m.y, m.z))
						if (p) p.train_move(locate(p.x+1, p.y, p.z))
					if (WEST)
						m.train_move(locate(m.x-1, m.y, m.z))
						if (p) p.train_move(locate(p.x-1, p.y, p.z))

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