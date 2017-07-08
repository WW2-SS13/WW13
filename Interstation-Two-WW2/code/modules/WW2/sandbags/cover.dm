// how much do we cover mobs behind incomplete sandbags?
#define SANDBAG_BLOCK_ITEMS_CHANCE 70

/obj/structure/window/sandbag/incomplete/check_cover(obj/item/projectile/P, turf/from)

	var/effectiveness_coeff = (progress + 1)/maxProgress
	var/turf/cover = get_turf(src)
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1

	var/base_chance = SANDBAG_BLOCK_ITEMS_CHANCE - (P.penetrating * 3)
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

	if(prob(chance * effectiveness_coeff))
		return 1
	else
		return 0


// how much do we cover mobs behind full sandbags?
/obj/structure/window/sandbag/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1

	var/base_chance = SANDBAG_BLOCK_ITEMS_CHANCE - (P.penetrating * 3)
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

	if(prob(chance))
		return 1
	else
		return 0

// what is our chance of deflecting bullets regardless?
/proc/bullet_deflection_chance(obj/item/projectile/proj)
	var/base = 95
	if (!istype(proj))
		return base
		#ifdef BULLETDEBUG
		world << "non-proj [proj] deflection chance: 95%"
		#endif
	if (istype(proj, /obj/item/projectile/bullet/rifle/a762x54)) // mosin
		#ifdef BULLETDEBUG
		world << "mosin [proj] deflection chance: 55%"
		#endif
		return base - 40
	if (istype(proj, /obj/item/projectile/bullet/rifle/a792x57)) // kar
		#ifdef BULLETDEBUG
		world << "kar [proj] deflection chance: 55%"
		#endif
		return base - 40
	else
		#ifdef BULLETDEBUG
		world << "other [proj] deflection chance: 65%"
		#endif
		return base - 30

// procedure for both incomplete and complete sandbags
/obj/structure/window/sandbag/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)

	if (!istype(mover, /obj/item))
		if(get_dir(loc, target) & dir)
			return !density
		else
			return 1
	else
		if (istype(mover, /obj/item/projectile))
			var/obj/item/projectile/proj = mover
			proj.last_throw_source = (proj.firer ? get_turf(proj.firer) : null)
			if (proj.firer && (get_step(proj.firer, proj.firer.dir) == get_turf(src) || proj.firer.loc == get_turf(src)))
				return 1

		if (!mover.last_throw_source)
			return 0
		else
			switch (get_dir(mover.last_throw_source, get_turf(src)))
				if (NORTH, NORTHEAST)
					if (dir == EAST || dir == WEST || dir == NORTH)
						return 1
				if (SOUTH, SOUTHEAST)
					if (dir == EAST || dir == WEST || dir == SOUTH)
						return 1
				if (EAST)
					if (dir != WEST)
						return 1
				if (WEST)
					if (dir != EAST)
						return 1

			if (check_cover(mover, mover.last_throw_source) && prob(bullet_deflection_chance(mover)))
				visible_message("<span class = 'warning'>[mover] hits the sandbag!</span>")
				return 0
			else
				return 1