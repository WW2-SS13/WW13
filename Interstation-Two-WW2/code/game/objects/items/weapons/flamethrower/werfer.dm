/* this code has deviated so far from the original flamethrower code,
 * that there's almost no point in even keeping its parent type
 * around. This may as well become /obj/item/weapon/flammenwerfer - Kachnov */

/obj/item/weapon/flamethrower/flammenwerfer
	name = "flammenwerfer"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "fw_off"
	item_state = "fw_off"
	var/pressure_1 = 100
	status = 1
	nothrow = 1
	var/fueltank = 1
	var/obj/item/weapon/storage/backpack/flammenwerfer/backpack = null

/obj/item/weapon/flamethrower/flammenwerfer/nothrow_special_check()
	return nodrop_special_check()

/obj/item/weapon/flamethrower/flammenwerfer/update_icon()
	if(lit)
		icon_state = "fw_on"
		item_state = "fw_on"
	else
		icon_state = "fw_off"
		item_state = "fw_off"
	update_held_icon()

/obj/item/weapon/flamethrower/flammenwerfer/Destroy()
	..()

/obj/item/weapon/flamethrower/flammenwerfer/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	// Make sure our user is still holding us
	if(user && user.get_active_hand() == src)
		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turflist = getturfsbetween(user, target_turf)
			flame_turfs(turflist, get_dir(get_turf(user), target_turf))

/obj/item/weapon/flamethrower/flammenwerfer/process()
	if(!lit)
		processing_objects.Remove(src)
		return null
	var/turf/location = loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = M.loc
	// made this stop starting fires where we are standing. fuck.
	return

// this has better range checking so we don't burn/overheat ourselves
/obj/item/weapon/flamethrower/flammenwerfer/flame_turfs(turflist, var/flamedir)

	var/turf/my_turf = get_turf(loc)

	if(!lit || operating)	return

	var/mob/living/carbon/human/my_mob = loc

	if (!my_mob || !istype(my_mob) || src != my_mob.get_active_hand())
		return

	if (!fueltank || fullness_percentage() <= 0.01)
		my_mob << "<span class = 'warning'>Out of fuel!</span>"
		return

	if (my_mob.back != backpack || !my_mob.back || !backpack)
		my_mob << "<span class = 'danger'>Put the backpack on first.</span>"
		return

	operating = 1
	playsound(my_turf, 'sound/weapons/flamethrower.ogg', 100, 1)

	var/blocking_turfs = list()

	for(var/turf/T in turflist)

		if (T == my_turf)
			continue

		switch (my_mob.dir)
			if (EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
				if (abs(my_turf.x - T.x) > 5 || abs(my_turf.y - T.y) > 3)
					continue
			if (NORTH, SOUTH)
				if (abs(my_turf.x - T.x) > 3 || abs(my_turf.y - T.y) > 5)
					continue

		if (T != get_step(my_turf, my_mob.dir) && prob(get_dist(my_turf, T)+7))
			continue

		if(T.density)
			blocking_turfs += T
			continue

		for (var/turf/TT in blocking_turfs)
			if (get_step(TT, my_mob.dir) == T)
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
		fueltank -= (1/4000) * get_throw_coeff()
		fueltank = max(fueltank, 0.00)

	previousturf = null
	operating = 0
	for(var/mob/M in viewers(1, loc))
		if((M.client && M.machine == src))
			attack_self(M)
	return

/obj/item/weapon/flamethrower/flammenwerfer/attack_self(mob/user as mob)
	if(user.stat || user.restrained() || user.lying)	return
	user.set_machine(src)
	if(!ptank)
		user << "<span class='notice'>Attach a plasma tank first!</span>"
		return
	var/dat = text("<TT><B>Das Flammenwerfer (<a href='?src=\ref[src];light=1'>[lit ? "<font color='red'>Lit</font>" : "Unlit"]</a>)</B><BR>\n Fullness: [fullness_percentage()]%<BR>\nAmount to throw: <A HREF='?src=\ref[src];amount=-100'>-</A> <A HREF='?src=\ref[src];amount=-10'>-</A> <A HREF='?src=\ref[src];amount=-1'>-</A> [throw_amount] <A HREF='?src=\ref[src];amount=1'>+</A> <A HREF='?src=\ref[src];amount=10'>+</A> <A HREF='?src=\ref[src];amount=100'>+</A><BR>\n - <A HREF='?src=\ref[src];close=1'>Close</A></TT>")
	user << browse(dat, "window=flamethrower;size=600x300")
	onclose(user, "flamethrower")
	return

/obj/item/weapon/flamethrower/flammenwerfer/proc/fullness_percentage()
	return round(fueltank * 100)

/obj/item/weapon/flamethrower/flammenwerfer/Topic(href,href_list[])
	if(href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=flamethrower")
		return
	if(usr.stat || usr.restrained() || usr.lying)	return
	usr.set_machine(src)
	if(href_list["light"])
		if(fueltank <= 0) return
		if(!status)	return
		lit = !lit
		if(lit)
			processing_objects.Add(src)
	if(href_list["amount"])
		throw_amount = throw_amount + text2num(href_list["amount"])
		throw_amount = max(50, min(5000, throw_amount))

	// refresh
	for(var/mob/M in viewers(1, loc))
		if((M.client && M.machine == src))
			attack_self(M)

	update_icon()
	return

/obj/item/weapon/flamethrower/flammenwerfer/proc/get_throw_coeff()
	. = 1.0
	. += ((throw_amount-100)/100)/3
	. = max(., 3.0) // don't get too hot
	. += ((throw_amount-100)/100)/50 // give us a bit of extra heat if we're super high

/obj/item/weapon/flamethrower/flammenwerfer/ignite_turf(turf/target, flamedir)
	var/throw_coeff = get_throw_coeff()
	var/dist_coeff = 1.0
	switch (get_dist(get_turf(src), target))
		if (0 to 5)
			dist_coeff = 1.00
		if (5 to 10)
			dist_coeff = 1.50 // the center is hottest I guess - Kachnov
		if (10 to INFINITY)
			dist_coeff = 1.00

	var/time_limit = pick(2,3)
	var/extra_temp = 0
	for (var/obj/fire/F in get_turf(src))
		extra_temp += ((F.temperature / 100) * rand(15,25))
		time_limit += 2
		qdel(F)

	var/obj/fire/F = target.create_fire(5, (rand(250,300) * throw_coeff * dist_coeff) + extra_temp, 0)
	F.time_limit = time_limit

	spawn (rand(120*throw_coeff, 150*throw_coeff))
		for (var/obj/fire/fire in target)
			qdel(fire) // shitty workaround #2