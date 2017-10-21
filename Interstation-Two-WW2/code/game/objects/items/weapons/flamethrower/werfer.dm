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
	overlays.Cut()
	if(lit)
		icon_state = "fw_on"
		item_state = "fw_on"
	else
		icon_state = "fw_off"
		item_state = "fw_off"

/obj/item/weapon/flamethrower/flammenwerfer/Destroy()
	..()

/obj/item/weapon/flamethrower/flammenwerfer/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	// Make sure our user is still holding us
	if(user && user.get_active_hand() == src)
		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turflist = getturfsbetween(user, target_turf)
			flame_turf(turflist, get_dir(get_turf(user), target_turf))

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
/obj/item/weapon/flamethrower/flammenwerfer/flame_turf(turflist, var/flamedir)

	var/turf/my_turf = get_turf(loc)

	if(!lit || operating)	return

	var/mob/living/carbon/human/my_mob = loc
	if (!my_mob || !istype(my_mob))
		return

	if (my_mob.back != backpack || !my_mob.back || !backpack)
		my_mob << "<span class = 'danger'>Put the backpack on first.</span>"
		return

	operating = 1
	playsound(my_turf, 'sound/weapons/flamethrower.ogg', 100, 1)

	for(var/turf/T in turflist)

		if (T == my_turf)
			continue

		if(T.density || istype(T, /turf/space))
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

		ignite_turf(T, flamedir)

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
	var/dat = text("<TT><B>Das Flammenwerfer (<A HREF='?src=\ref[src];light=1'>[lit ? "<font color='red'>Lit</font>" : "Unlit"]</a>)</B><BR>\n Tank Pressure: [ptank.air_contents.return_pressure()]<BR>\nAmount to throw: <A HREF='?src=\ref[src];amount=-100'>-</A> <A HREF='?src=\ref[src];amount=-10'>-</A> <A HREF='?src=\ref[src];amount=-1'>-</A> [throw_amount] <A HREF='?src=\ref[src];amount=1'>+</A> <A HREF='?src=\ref[src];amount=10'>+</A> <A HREF='?src=\ref[src];amount=100'>+</A><BR>\n - <A HREF='?src=\ref[src];close=1'>Close</A></TT>")
	user << browse(dat, "window=flamethrower;size=600x300")
	onclose(user, "flamethrower")
	return


/obj/item/weapon/flamethrower/flammenwerfer/Topic(href,href_list[])
	if(href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=flamethrower")
		return
	if(usr.stat || usr.restrained() || usr.lying)	return
	usr.set_machine(src)
	if(href_list["light"])
		if(!ptank)	return
		if(ptank.air_contents.gas["plasma"] < 1)	return
		if(!status)	return
		lit = !lit
		if(lit)
			processing_objects.Add(src)
	if(href_list["amount"])
		throw_amount = throw_amount + text2num(href_list["amount"])
		throw_amount = max(50, min(5000, throw_amount))
	for(var/mob/M in viewers(1, loc))
		if((M.client && M.machine == src))
			attack_self(M)
	update_icon()
	return

/obj/item/weapon/flamethrower/flammenwerfer/proc/calculate_throw_amount()
	return throw_amount * calculate_power_coeff()

/obj/item/weapon/flamethrower/flammenwerfer/proc/calculate_power_coeff()
	var/p1 = pressure_1
	var/p2 = ptank.air_contents.return_pressure()
	return (p2/p1)

/obj/item/weapon/flamethrower/flammenwerfer/ignite_turf(turf/target, flamedir)
	target.create_fire(5, rand(300,400), 0)
	spawn (150)
		for (var/obj/fire/fire in target)
			qdel(fire) // shitty workaround #2