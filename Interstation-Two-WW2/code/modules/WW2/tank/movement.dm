/obj/tank/var/last_movement = -1
/obj/tank/var/movement_delay = 4.8 // about 1.4 - 1.5x slower than walking humans
/obj/tank/var/last_movement_sound = -1
/obj/tank/var/movement_sound_delay = 30
/obj/tank/var/last_gibbed = -1
/obj/tank/var/lastdir = -1

/obj/tank/Move()
	switch (dir)
		if (EAST, WEST)
			icon = horizontal_icon
		if (NORTH, SOUTH)
			icon = vertical_icon

	update_bounding_rectangle()
	..()

/obj/tank/proc/_Move(direct)
	if (world.time - last_movement > movement_delay || last_movement == -1)

		if (fuel <= 0)
			internal_tank_message("<span class = 'danger'><big>Out of fuel!</big></danger>")
			return

		last_movement = world.time
		var/turf/target = get_step(src, direct)

		if (istype(target, /turf/floor/plating/beach/water))
			play_movement_sound()
			return

		if (target && target.check_prishtina_block(src.front_seat()))
			return

		if (direct != lastdir && lastdir != -1)
			internal_tank_message("<span class = 'notice'><big>Attempting to turn...</big></span>")
			var/turndelay = 25
			last_movement = world.time + turndelay + 5
			sleep(turndelay)

		dir = direct
		lastdir = dir

		update_bounding_rectangle()
		switch (dir)
			if (EAST)
				icon = horizontal_icon
			if (WEST)
				icon = horizontal_icon
			if (NORTH)
				icon = vertical_icon
			if (SOUTH)
				icon = vertical_icon

		if (!handle_passing_target_turf(target))
			return 0

		play_movement_sound()

		for (var/obj/o in get_step(src, direct))
			if (!handle_passing_obj(o))
				return 0

		for (var/mob/m in get_step(src, direct))
			if (!handle_passing_mob(m))
				return 0

		loc = target
		fuel -= pick(0.33,0.5,0.75)

/obj/tank/proc/play_movement_sound()
	if (world.time - last_movement_sound > movement_sound_delay || last_movement_sound == -1)
		playsound(get_turf(src), 'sound/weapons/WW2/tank_move.ogg', 100)
		last_movement_sound = world.time

/obj/tank/proc/update_bounding_rectangle()
	switch (dir)
		if (EAST)
			bound_width = 160
			bound_height = 96
		if (WEST)
			bound_width = 160
			bound_height = 96
		if (NORTH)
			bound_width = 96
			bound_height = 160
		if (SOUTH)
			bound_width = 96
			bound_height = 160

/obj/tank/proc/handle_passing_target_turf(var/turf/t)

	var/list/turfs_in_the_way = list()

	// note that the actual object's x is ALWAYS(?) the bottom left corner of it
	// this new turfs in the way code is designed assuming the bounds of
	// the tank while facing EAST and WEST is 5x3, and the bounds while
	// facing NORTH and SOUTH is 3x5

	switch (dir)
		if (EAST)
			turfs_in_the_way += locate(t.x+4, t.y, t.z)
			turfs_in_the_way += locate(t.x+4, t.y+1, t.z)
		//	turfs_in_the_way += locate(t.x+5, t.y+2, t.z) // doesn't work with the current sprite
		if (WEST)
			turfs_in_the_way += locate(t.x, t.y, t.z)
			turfs_in_the_way += locate(t.x, t.y+1, t.z)
		//	turfs_in_the_way += locate(t.x-1, t.y+2, t.z) // doesn't work with the current sprite
		if (NORTH)
			turfs_in_the_way += locate(t.x, t.y+4, t.z)
			turfs_in_the_way += locate(t.x+1, t.y+4, t.z)
			turfs_in_the_way += locate(t.x+2, t.y+4, t.z)
		if (SOUTH)
			turfs_in_the_way += locate(t.x, t.y, t.z)
			turfs_in_the_way += locate(t.x+1, t.y, t.z)
			turfs_in_the_way += locate(t.x+2, t.y, t.z)

	for (var/turf/tt in turfs_in_the_way)
		if (!handle_passing_turf(tt))
			return 0
		for (var/atom/movable/am in tt)
			if (isobj(am))
				if (!handle_passing_obj(am))
					return 0
			else if (ismob(am))
				if (!handle_passing_mob(am))
					return 0
	return 1

/obj/tank/proc/handle_passing_turf(var/turf/t)
	if (!t.density)
		return 1
	if (!istype(t, /turf/wall))
		return 1
	if (istype(t,  /turf/wall/rockwall))
		return 0
	if (istype(t, /turf/wall))
		var/turf/wall/wall = t
		if (!wall.tank_destroyable)
			return 0
		var/wall_integrity = wall.material ? wall.material.integrity : 150
		if (prob(min(wall_integrity/2, 97)))
			tank_message("<span class = 'danger'>The tank smashes against [wall]!</span>")
			playsound(get_turf(src), 'sound/effects/clang.ogg', 100)
			return 0
		else // defenses [b]roke
			tank_message("<span class = 'danger'>The tank smashes its way through [wall]!</span>")
			qdel(wall)
			return 1
	return 1

/obj/tank/proc/handle_passing_obj(var/obj/o)

	if (o == src)
		return 1

	if (istype(o))

		if (istype(o, /obj/item/device/mine))
			var/obj/item/device/mine/mine = o
			mine.trigger(src)
			damage += x_percent_of_max_damage(rand(5,7))
			update_damage_status()
			return 0 // halt us too

		if (istype(o, /obj/item/weapon/grenade))
			return 1 // pass over it

		if (istype(o, /obj/train_lever))
			return 1 // pass over it

		if (istype(o, /obj/train_pseudoturf))
			if (o.density)
				var/wall_integrity = 500 // trains are hard as fuck
				if (prob(min(wall_integrity/2, 98)))
					tank_message("<span class = 'danger'>The tank smashes against [o]!</span>")
					playsound(get_turf(src), 'sound/effects/clang.ogg', 100)
					return 0
				else
					tank_message("<span class = 'danger'>The tank smashes its way through [o]!</span>")
					qdel(o)
					return 1
			else // you can no longer drive tanks into trains.
				return 0

		else if (istype(o, /obj/tank))
			tank_message("<span class = 'danger'>The tank rams into [o]!</span>")
			var/obj/tank/other = o
			if (prob(50))
				other.damage += other.x_percent_of_max_damage(2)
			else
				visible_message("<span class = 'danger'>The hit bounces off [other]!</span>")

			if (prob(33))
				damage += x_percent_of_max_damage(1) // we take some, but not much damage
			else
				visible_message("<span class = 'danger'>The hit bounces off [src]!</span>")

			layer = initial(layer) + 0.01
			other.layer = initial(layer)
			playsound(get_turf(src), 'sound/effects/clang.ogg', 100)

			update_damage_status()
			other.update_damage_status()

			if (prob(critical_damage_chance()))
				critical_damage()
			if (prob(other.critical_damage_chance()))
				other.critical_damage()

			return 0
		else
			if (!o.density && !istype(o, /obj/item))
				return 1
			if ((istype(o, /obj/item) && o.w_class == 1) || (istype(o, /obj/item) && o.anchored) || istype(o, /obj/item/ammo_casing) || istype(o, /obj/item/ammo_magazine) || istype(o, /obj/item/organ))
				return 1
			else
				tank_message("<span class = 'warning'>The tank crushes [o].</span>")
				qdel(o)
				return 1
			if (istype(o, /obj/structure))
				if (prob(40) || !o.density)
					tank_message("<span class = 'danger'>The tank crushes [o]!</span>")
					qdel(o)
					return 1
				else
					tank_message("<span class = 'danger'>The tank rams into [o]!</span>")
					playsound(get_turf(src), 'sound/effects/clang.ogg', rand(60,70))
					return 0

	return 1

/obj/tank/proc/handle_passing_mob(var/mob/living/m)

	if (istype(m) && (world.time - last_gibbed > 5 || last_gibbed == -1))
		last_gibbed = world.time
		tank_message("<span class = 'danger'>The tank crushes [m]!</span>")
		m.crush()
		last_movement = world.time + 25
	else if (istype(m))
		spawn (5)
			m.crush()
			last_movement = world.time + 25

	return 1