/obj/structure/window/half_wall
	name = "halfwall"
	icon_state = "half_wall"
	layer = MOB_LAYER + 0.01 //just above mobs
	anchored = TRUE
	climbable = TRUE
	maxhealth = 10

/obj/structure/window/half_wall/ex_act(severity)
	switch(severity)
		if (1.0)
			qdel(src)
			return
		if (2.0)
			qdel(src)
			return
		else
			if (prob(50))
				return ex_act(2.0)
	return

/obj/structure/window/half_wall/New(location, var/mob/creator)
	loc = location
	flags |= ON_BORDER

	if (creator && ismob(creator))
		dir = creator.dir
	else
		var/ndir = creator
		dir = ndir

	set_dir(dir)

	switch (dir)
		if (NORTH)
			layer = MOB_LAYER - 0.01
			pixel_y = FALSE
		if (SOUTH)
			layer = MOB_LAYER + 0.01
			pixel_y = FALSE
		if (EAST)
			layer = MOB_LAYER - 0.05
			pixel_x = FALSE
		if (WEST)
			layer = MOB_LAYER - 0.05
			pixel_x = FALSE

/obj/structure/window/half_wall/set_dir(direction)
	dir = direction

// dirt_wall window overrides

/obj/structure/window/half_wall/attackby(obj/O as obj, mob/user as mob)
	return FALSE

/obj/structure/window/half_wall/examine(mob/user)
	user << "That's a dirt wall."
	return TRUE

/obj/structure/window/half_wall/take_damage(var/damage = FALSE, var/sound_effect = TRUE)
	return FALSE

/obj/structure/window/half_wall/apply_silicate(var/amount)
	return FALSE

/obj/structure/window/half_wall/updateSilicate()
	return FALSE

/obj/structure/window/half_wall/shatter(var/display_message = TRUE)
	return FALSE

/obj/structure/window/half_wall/bullet_act(var/obj/item/projectile/Proj)
	return FALSE

/obj/structure/window/half_wall/ex_act(severity)
	switch(severity)
		if (1.0)
			qdel(src)
			return
		if (2.0)
			qdel(src)
			return
		if (3.0)
			if (prob(50))
				qdel(src)

/obj/structure/window/half_wall/is_full_window()
	return FALSE

/obj/structure/window/hitby(AM as mob|obj)
	return FALSE // don't move

/obj/structure/window/half_wall/attack_generic(var/mob/user, var/damage)
	return FALSE

/obj/structure/window/half_wall/rotate()
	return

/obj/structure/window/half_wall/revrotate()
	return

/obj/structure/window/half_wall/is_fulltile()
	return FALSE

/obj/structure/window/half_wall/update_verbs()
	verbs -= /obj/structure/window/proc/rotate
	verbs -= /obj/structure/window/proc/revrotate

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/half_wall/update_icon()
	return

/obj/structure/window/half_wall/fire_act(temperature)
	return


//unused
/obj/item/weapon/half_bricks
	name = "dirt pile"
	icon_state = "dirt_pile"
	icon = 'icons/obj/items.dmi'
	w_class = TRUE
	var/sand_amount = FALSE

// how much do we cover mobs behind full sandbags?
/obj/structure/window/half_wall/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	if (!cover)
		return FALSE
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return FALSE
	// can't hit legs or feet when they're behind a sandbag
	if (list("r_leg", "l_leg", "r_foot", "l_foot").Find(P.def_zone))
		return TRUE

	var/base_chance = 70
	var/extra_chance = 0

	if (ismob(P.original)) // what the firer clicked
		var/mob/m = P.original
		if (m.lying)
			extra_chance += 30
		if (ishuman(m))
			var/mob/living/carbon/human/H = m
			if (H.crouching && !H.lying)
				extra_chance += 20

	var/chance = base_chance + extra_chance

	chance = min(chance, 98)

	if (prob(chance))
		return TRUE
	else
		return FALSE

// procedure for both incomplete and complete sandbags
/obj/structure/window/half_wall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)

	if (istype(mover, /obj/effect/effect/smoke))
		return TRUE

	else if (!istype(mover, /obj/item))
		if (get_dir(loc, target) & dir)
			return FALSE
		else
			return TRUE
	else
		if (istype(mover, /obj/item/projectile))
			var/obj/item/projectile/proj = mover
			proj.throw_source = proj.starting
/*			if (proj.throw_source == get_turf(src) || get_step(proj.throw_source, proj.dir) == get_turf(src) || proj.firer && (get_step(proj.firer, proj.firer.dir) == get_turf(src) || proj.firer.loc == get_turf(src)))
				return TRUE*/

		if (!mover.throw_source)
			if (get_dir(loc, target) & dir)
				return FALSE
			else
				return TRUE
		else
			switch (get_dir(mover.throw_source, get_turf(src)))
				if (NORTH, NORTHEAST)
					if (dir == EAST || dir == WEST || dir == NORTH)
						return TRUE
				if (SOUTH, SOUTHEAST)
					if (dir == EAST || dir == WEST || dir == SOUTH)
						return TRUE
				if (EAST)
					if (dir != WEST)
						return TRUE
				if (WEST)
					if (dir != EAST)
						return TRUE

			if (check_cover(mover, mover.throw_source) && prob(bullet_deflection_chance(mover)))
				visible_message("<span class = 'warning'>[mover] hits the half wall!</span>")
				if (istype(mover, /obj/item/projectile))
					var/obj/item/projectile/B = mover
					B.damage = 0 // make sure we can't hurt people after hitting a sandbag
					B.invisibility = 101
					B.loc = null
					qdel(B) // because somehow we were still passing the sandbag
				return FALSE
			else
				return TRUE
