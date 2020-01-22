/* this code has deviated so far from the original flamethrower code,
 * that there's almost no point in even keeping its parent type
 * around. This may as well become /obj/item/weapon/flammenwerfer - Kachnov */

/obj/item/weapon/flamethrower/flammenwerfer
	name = "flamthrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "fw_on"
	item_state = "fw_on"
	var/pressure_1 = 1000
	status = TRUE
	nothrow = TRUE
	var/fueltank = 1.00
	var/obj/item/weapon/storage/backpack/flammenwerfer/backpack = null
	var/rwidth = 7
	var/rheight = 5
	var/max_total_range = 12

/obj/item/weapon/flamethrower/flammenwerfer/New()
	..()
	sleep(5)
	if (backpack && backpack.flam_type == "usa")
		icon_state = "m2_flamethrower"
		item_state = "m2_flamerthrower"
/obj/item/weapon/flamethrower/flammenwerfer/nothrow_special_check()
	return nodrop_special_check()

/obj/item/weapon/flamethrower/flammenwerfer/update_icon()
	if (backpack.flam_type == "ger")
		if (lit)
			icon_state = "fw_on"
			item_state = "fw_on"
		else
			icon_state = "fw_off"
			item_state = "fw_off"
	else
		if (lit)
			icon_state = "m2_flamethrower_on"
			item_state = "m2_flamerthrower_on"
		else
			icon_state = "m2_flamethrower"
			item_state = "m2_flamerthrower"
	update_held_icon()

/obj/item/weapon/flamethrower/flammenwerfer/m2
	name = "M2 flamethrower"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "m2_flamethrower"
	item_state = "m2_flamerthrower"

/obj/item/weapon/flamethrower/flammenwerfer/nothrow_special_check()
	return nodrop_special_check()

/obj/item/weapon/flamethrower/flammenwerfer/m2/update_icon()
	if (lit)
		icon_state = "m2_flamethrower_on"
		item_state = "m2_flamerthrower_on"
	else
		icon_state = "m2_flamethrower"
		item_state = "m2_flamerthrower"
	update_held_icon()

/obj/item/weapon/flamethrower/flammenwerfer/Destroy()
	..()

/obj/item/weapon/flamethrower/flammenwerfer/afterattack(atom/target, mob/user, proximity)
	if (!proximity) return
	// Make sure our user is still holding us
	if (user && user.get_active_hand() == src)
		var/turf/target_turf = get_turf(target)
		if (target_turf)
			var/turflist = getturfsbetween(user, target_turf) | list(target_turf)
			flame_turfs(turflist, get_dir(get_turf(user), target_turf))

/obj/item/weapon/flamethrower/flammenwerfer/process()
	if (!lit)
		processing_objects.Remove(src)
		return null
	var/turf/location = loc
	if (istype(location, /mob/))
		var/mob/M = location
		if (M.l_hand == src || M.r_hand == src)
			location = M.loc
	// made this stop starting fires where we are standing. fuck.
	return

// this has better range checking so we don't burn/overheat ourselves
/obj/item/weapon/flamethrower/flammenwerfer/flame_turfs(turflist, var/flamedir)

	var/turf/my_turf = get_turf(loc)

	if (!lit || operating)	return

	var/mob/living/carbon/human/H = loc

	if (!H || !istype(H) || src != H.get_active_hand())
		return

	if (!fueltank || fullness_percentage() <= 0.01)
		H << "<span class = 'warning'>Out of fuel!</span>"
		return

	if (!H.back || !backpack || H.back != backpack)
		H << "<span class = 'danger'>Put the backpack on first.</span>"
		return

	operating = TRUE
	playsound(my_turf, 'sound/weapons/flamethrower.ogg', 100, TRUE)

	var/list/blocking_turfs = list()

	for (var/turf/T in turflist)

		if (T == my_turf)
			continue

		switch (H.dir)
			if (EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
				if (abs(my_turf.x - T.x) > rwidth || abs(my_turf.y - T.y) > rheight)
					continue
			if (NORTH, SOUTH)
				if (abs(my_turf.x - T.x) > rheight || abs(my_turf.y - T.y) > rwidth)
					continue

		// higher temperature = less missed turfs
		if (T != get_step(my_turf, H.dir) && prob((get_dist(my_turf, T)+10)/get_temperature_coeff()))
			continue

		if (T.density)
			blocking_turfs += T
		else
			for (var/obj/structure/S in T.contents)
				if (S.density && !S.low && !S.throwpass)
					blocking_turfs += T
					break

		if (blocking_turfs.Find(T))
			continue

		for (var/turf/TT in blocking_turfs)
			if (get_step(TT, H.dir) == T)
				continue

		if (my_turf)
			if (T.x <= my_turf.x)
				if (flamedir == EAST || flamedir == NORTHEAST || flamedir == SOUTHEAST)
					continue
			else if (T.x >= my_turf.x)
				if (flamedir == WEST || flamedir == NORTHWEST || flamedir == SOUTHWEST)
					continue
			else if (T.y >= my_turf.y)
				if (flamedir == NORTH || flamedir == NORTHEAST || flamedir == NORTHWEST)
					continue
			else if (T.y <= my_turf.y)
				if (flamedir == SOUTH || flamedir == SOUTHEAST || flamedir == SOUTHWEST)
					continue

		if (fueltank <= 0.00)
			break

		spawn (get_dist(my_turf, T))
			ignite_turf(T, flamedir)
		// we run out of fuel after flamming 4000 turfs (on min fuel)
		fueltank -= (1/4000) * get_temperature_coeff()
		fueltank = max(fueltank, 0.00)

	previousturf = null
	operating = FALSE
	for (var/mob/M in viewers(1, loc))
		if ((M.client && M.using_object == src))
			attack_self(M)
	return

/obj/item/weapon/flamethrower/flammenwerfer/attack_self(mob/user as mob)
	if (user.stat || user.restrained() || user.lying)	return
	return

/obj/item/weapon/flamethrower/flammenwerfer/proc/fullness_percentage()
	return round(fueltank * 100)

/obj/item/weapon/flamethrower/flammenwerfer/proc/get_temperature_coeff()
	return 1.0 + (throw_amount+400)/100

// what is the multiplier put on our fire's heat based on throw_amount
// you will notice that the most efficient throw_amount is the default one,
// and at throw amounts > 700 its downright inefficient as the fire barely gets hotter
/obj/item/weapon/flamethrower/flammenwerfer/proc/get_heat_coeff()
	. = 1.0
	. += ((throw_amount+400)/100)/3
	. = min(., 3.0) // don't get too hot
	. += ((throw_amount+400)/100)/20 // give us a bit of extra heat if we're super high
	// for example, 200 throw amount = 1.38x
	// 500 = 2.53x
	// 700 = 3.3x
	// 1500 = 3.7x

/obj/item/weapon/flamethrower/flammenwerfer/ignite_turf(turf/target, flamedir)
	var/throw_coeff = get_heat_coeff()
	var/dist_coeff = 1.0

	switch (get_dist(get_turf(src), target))
		if (0 to 5)
			dist_coeff = 1.00
		if (5 to 10)
			dist_coeff = 1.50 // the center is hottest I guess - Kachnov
		if (10 to INFINITY)
			dist_coeff = 1.00

	var/time_limit = pick(20,30,40)

	var/extra_temp = 0

	for (var/obj/fire/F in get_turf(src))
		extra_temp += ((F.temperature / 100) * rand(20,25))
		time_limit += pick(10,20)
		qdel(F)

	var/temperature = (rand(500,600) * throw_coeff * dist_coeff) + extra_temp
//	log_debug("1: [temperature];[throw_coeff];[dist_coeff];[extra_temp]")
	target.create_fire(5, temperature, FALSE, time_limit)