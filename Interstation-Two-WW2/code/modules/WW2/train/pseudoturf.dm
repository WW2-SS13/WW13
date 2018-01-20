

/obj/train_pseudoturf
	anchored = TRUE
	name = "train"
	layer = TURF_LAYER + 0.01
	var/obj/train_car_center/master = null
	var/datum/train_controller/controller = null
	var/deadly = FALSE
	var/list/saved_contents = list()
	var/based_on_type = null // debug variable
	var/copy_of_instance = null // debug variable

/obj/train_pseudoturf/New(_loc, var/turf/t, var/ignorecontents = FALSE)
	..()

	loc = _loc
	density = t.density
	opacity = t.opacity
	based_on_type = t.type
	copy_of_instance = t

	if (istype(t, /turf/wall))
		var/turf/wall/w = t
		icon = w.icon
		icon_state = w.ref_state
		overlays = w.overlays
		deadly = TRUE
	else
		icon = t.icon
		icon_state = t.icon_state
		for (var/atom/a in t.overlays)
			overlays += new a.type

	layer = t.layer + 0.05 //otherwise, train tracks go above train pseudoturfs
	pixel_x = t.pixel_x
	pixel_y = t.pixel_y
	dir = t.dir
	anchored = TRUE

	uses_initial_density = TRUE
	initial_density = density

	uses_initial_opacity = TRUE
	initial_opacity = opacity

	for (var/atom/movable/a in loc)
		if (istype(a, /obj/structure/wild))
			qdel(a)

	if (!ignorecontents)
		for (var/atom/movable/a in t)

			if (check_object_invalid_for_moving(src, a, TRUE))
				continue

			var/atom/movable/aa = new a.type(loc)

			if (istype(a, /obj/structure/multiz/ladder/ww2))
				var/obj/structure/multiz/ladder/ww2/old_ladder = a
				var/obj/structure/multiz/ladder/ww2/new_ladder = aa
				new_ladder.area_id = old_ladder.area_id
				new_ladder.ladder_id = old_ladder.ladder_id
				new_ladder.target = new_ladder.find_target()
				new_ladder.target.target = new_ladder
				qdel (old_ladder) // delete the source so we don't make multiple identical
					// ladders between different cars!

			if (istype(aa, /obj/train_lever))
				var/obj/train_lever/lever = aa
				lever.real = TRUE // distinguish us from the example lever

			if (istype(aa, /obj/structure/bed))
				var/obj/structure/bed/bed = aa
				bed.can_buckle = FALSE // fixes the train buckling meme

			if (istype(aa, /obj/machinery))
				aa.anchored = TRUE


			aa.icon = a.icon
			aa.icon_state = a.icon_state
			aa.layer = a.layer
			aa.pixel_x = a.pixel_x
			aa.pixel_y = a.pixel_y
			aa.dir = a.dir

			aa.uses_initial_density = TRUE
			aa.initial_density = aa.density

			aa.uses_initial_opacity = TRUE
			aa.initial_opacity = aa.opacity


	for (var/atom/movable/a in t)
		if (istype(a, /obj/structure))
			if (a.density && !istype(a, /obj/structure/railing/train_railing))
				if (!istype(a, /obj/structure/simple_door))
					deadly = TRUE

/obj/train_pseudoturf/proc/save_contents_as_refs()
	for (var/atom/movable/a in get_turf(src))
		if (!check_object_invalid_for_moving(src, a))
			saved_contents += a

/obj/train_pseudoturf/proc/remove_contents_refs()
	saved_contents.Cut()

/obj/train_pseudoturf/proc/reset_track_lights() // pre movement
	for (var/obj/train_track/tt in get_turf(src))
		tt.set_light(2, 3, "#a0a080") // reset the lights of tracks we left behind

/obj/train_pseudoturf/proc/unset_track_lights() // post movement
	for (var/obj/train_track/tt in get_turf(src))
		tt.set_light(0, FALSE) // unset the lights of tracks we're now on

/obj/train_pseudoturf/proc/_Move(var/_direction)

	for (var/atom/movable/a in saved_contents)
		if (ismob(a))
			var/mob/m = a
			m.original_pulling = m.pulling
			if (!m.buckled)
				switch (controller.orientation)
					if (VERTICAL)
						m.train_move(locate(m.x, m.y+controller.getMoveInc(), m.z))
					if (HORIZONTAL)
						m.train_move(locate(m.x+controller.getMoveInc(), m.y, m.z))
		else
			switch (controller.orientation)
				if (VERTICAL)
					a.train_move(locate(a.x, a.y+controller.getMoveInc(), a.z))
				if (HORIZONTAL)
					a.train_move(locate(a.x+controller.getMoveInc(), a.y, a.z))

			if (istype(a, /obj/structure/bed))
				var/obj/structure/bed/bed = a
				var/mob/m = bed.buckled_mob
				if (m)
					switch (controller.orientation)
						if (VERTICAL)
							m.train_move(locate(m.x, m.y+controller.getMoveInc(), m.z))
						if (HORIZONTAL)
							m.train_move(locate(m.x+controller.getMoveInc(), m.y, m.z))


	for (var/mob/m in saved_contents)
		if (istype(m))
			if (m.original_pulling)
				m.start_pulling(m.original_pulling)
				m.original_pulling = null

	switch (controller.orientation)
		if (VERTICAL)
			y+=controller.getMoveInc()
		if (HORIZONTAL)
			x+=controller.getMoveInc()

/obj/train_pseudoturf/proc/move_mobs(var/_direction)
	for (var/atom/movable/a in saved_contents)
		if (ismob(a))
			var/mob/m = a
			if (!isnull(m.next_train_movement))

				var/atom/movable/p = m.pulling

				if (m.next_train_movement)
					m.dir = m.next_train_movement
					if (p) p.dir = m.next_train_movement

				switch (m.next_train_movement)
					if (NORTH)
						var/moved = m.train_move(locate(m.x, m.y+1, m.z))
						if (p && moved) p.train_move(m.behind())
					if (SOUTH)
						var/moved = m.train_move(locate(m.x, m.y-1, m.z))
						if (p && moved) p.train_move(m.behind())
					if (EAST)
						var/moved = m.train_move(locate(m.x+1, m.y, m.z))
						if (p && moved) p.train_move(m.behind())
					if (WEST)
						var/moved = m.train_move(locate(m.x-1, m.y, m.z))
						if (p && moved) p.train_move(m.behind())

				if (p && get_dist(m, p) <= TRUE)
					m.start_pulling(p) // start_pulling checks for p on its own

				m.next_train_movement = null
				m.train_gib_immunity = FALSE
				m.last_moved_on_train = world.time

/obj/train_pseudoturf/proc/src_dir()
	switch (controller.direction)
		if ("FORWARDS")
			return SOUTH
		if ("BACKWARDS")
			return NORTH

/obj/train_pseudoturf/proc/destroy_objects()
	for (var/atom/movable/a in get_step(src, src_dir()))
		if (a.pulledby && a.pulledby.is_on_train())
			continue
		if (istype(a, /obj/tank)) // should fix the most horrible bug in the history of bugs, maybe ever - Kachnov
			continue
		if (check_object_invalid_for_moving(src, a) && check_object_valid_for_destruction(a))
			if (a.density)
				visible_message("<span class = 'danger'>The train crushes [a]!</span>")
				if (istype(a, /obj/machinery))
					gibs(get_turf(a), gibber_type = /obj/effect/gibspawner/robot)
				qdel(a)
			else if (!a.density)
				visible_message("<span class = 'warning'>The train crushes [a].</span>")
				qdel(a)

/obj/train_pseudoturf/proc/gib_idiots()
	for (var/mob/living/m in get_step(src, src_dir()))

		if (m.is_on_train() && m.get_train() == controller)
			continue

		if (m.train_gib_immunity)
			continue

		if (deadly && istype(m))
			visible_message("<span class = 'danger'>The train crushes [m]!</span>")
			m.crush()

/obj/train_connector/ex_act(severity)
	if (prob(round(70 * (1/severity))))
		qdel(src)
	else
		return