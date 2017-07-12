

/obj/train_pseudoturf
	anchored = 1
	name = "train"
	layer = TURF_LAYER + 0.01
	var/obj/train_car_center/master = null
	var/datum/train_controller/controller = null
	var/deadly = 0
	var/list/saved_contents = list()

/obj/train_pseudoturf/New(_loc, var/turf/t, var/ignorecontents = 0)
	..()

	loc = _loc
	density = t.density
	opacity = t.opacity

	if (istype(t, /turf/simulated/wall))
		var/turf/simulated/wall/w = t
		icon = w.icon
		icon_state = w.ref_state
		overlays = w.overlays
		deadly = 1
	else
		icon = t.icon
		icon_state = t.icon_state
		for (var/atom/a in t.overlays)
			overlays += new a.type

	layer = t.layer + 0.05 //otherwise, train tracks go above train pseudoturfs
	pixel_x = t.pixel_x
	pixel_y = t.pixel_y
	dir = t.dir
	anchored = 1

	for (var/atom/movable/a in loc)
		if (istype(a, /obj/structure/flora) || istype(a, /obj/structure/wild))
			qdel(a)

	if (!ignorecontents)
		for (var/atom/movable/a in t)

			if (check_object_invalid_for_moving(src, a, 1))
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
				lever.real = 1 // distinguish us from the example lever

			if (istype(aa, /obj/structure/bed))
				var/obj/structure/bed/bed = aa
				bed.can_buckle = 0 // fixes the train buckling meme

			aa.icon = a.icon
			aa.icon_state = a.icon_state
			aa.layer = a.layer
			aa.pixel_x = a.pixel_x
			aa.pixel_y = a.pixel_y
			aa.dir = a.dir


	for (var/atom/movable/a in t)
		if (istype(a, /obj/structure))
			if (a.density && !istype(a, /obj/structure/railing/train_railing))
				if (!istype(a, /obj/structure/simple_door))
					deadly = 1
	#ifdef USE_TRAIN_LIGHTS
	for (var/obj/train_track/tt in get_turf(src))
		tt.set_light(0,0)
	#endif

/obj/train_pseudoturf/proc/save_contents_as_refs()
	for (var/atom/movable/a in get_turf(src))
		if (!check_object_invalid_for_moving(src, a))
			saved_contents += a

/obj/train_pseudoturf/proc/remove_contents_refs()
	saved_contents.Cut()

/mob/var/next_train_movement = null
/mob/var/last_train_movement_attempt = -1
/mob/var/original_pulling = null

/obj/train_pseudoturf/proc/reset_track_lights() // pre movement
	for (var/obj/train_track/tt in get_turf(src))
		tt.set_light(2, 3, "#a0a080") // reset the lights of tracks we left behind

/obj/train_pseudoturf/proc/unset_track_lights() // post movement
	for (var/obj/train_track/tt in get_turf(src))
		tt.set_light(0, 0) // unset the lights of tracks we're now on

/obj/train_pseudoturf/proc/_Move(var/_direction)

	for (var/atom/movable/a in saved_contents)
		if (ismob(a))
			var/mob/m = a
			m.original_pulling = m.pulling
		#ifdef USE_TRAIN_LIGHTS
		if (istype(a, /obj/machinery/light))
			var/obj/machinery/light/l = a
			l.seton(0, 0, 1, 1)
		#endif
		if (ismob(a))
			var/mob/m = a
			m.train_move(locate(m.x, m.y+controller.getMoveInc(), m.z))
		else
			a.y += controller.getMoveInc()
		#ifdef USE_TRAIN_LIGHTS
		if (istype(a, /obj/machinery/light))
			var/obj/machinery/light/l = a
			l.seton(1, 0, 1, 1)
		#endif

	for (var/mob/m in saved_contents)
		if (istype(m))
			m.start_pulling(m.original_pulling)
			m.original_pulling = null

	y+=controller.getMoveInc()

/obj/train_pseudoturf/proc/move_mobs(var/_direction)
	for (var/atom/movable/a in saved_contents)
		if (ismob(a))
			var/mob/m = a
			if (!isnull(m.next_train_movement))
				var/atom/movable/p = m.pulling
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

/obj/train_pseudoturf/proc/src_dir()
	switch (controller.direction)
		if ("FORWARDS")
			return SOUTH
		if ("BACKWARDS")
			return NORTH

/obj/train_pseudoturf/proc/destroy_objects()
	for (var/atom/movable/a in get_step(src, src_dir()))
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
			m.gib()
			m.loc = pick(locate(m.x+10, m.y, m.z), locate(m.x-10, m.y, m.z))// attempt to fix 4x gibbing error

/obj/train_connector/ex_act(severity)
	if (prob(round(70 * (1/severity))))
		qdel(src)
	else
		return