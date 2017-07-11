/obj/item/weapon/flamethrower/flammenwerfer
	name = "flammenwerfer"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "fw_off"
	item_state = "fw_off"
	var/pressure_1 = 100
	status = 1
	nodrop = 1
	var/fueltank = 1

/obj/item/weapon/flamethrower/flammenwerfer/update_icon()
	overlays.Cut()
	if(lit)
		icon_state = "fw_on"
		item_state = "fw_on"
	else
		item_state = "fw_off"
		item_state = "fw_off"
/*
/obj/item/weapon/flamethrower/flammenwerfer/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/flammenwerfer_fueltank))
		if (!fueltank)
			fueltank = 1
			qdel(W)
			visible_message("<span class = 'notice'>[user] puts a fuel tank into their flammenwerfer.</span>")
			ptank = new ptank.type

/obj/item/weapon/flamethrower/flammenwerfer/MouseDrop(obj/over_object as obj)

	if (istype(over_object, /obj/screen/inventory))
		if (fueltank)
			if (user.put_in_any_hand_if_possible(new/obj/item/weapon/flammenwerfer_fueltank))
				visible_message("<span class = 'notice'>[user] takes a fuel tank out of the flammenwerfer.</span>")
				fueltank = 0
				qdel(ptank)*/


/obj/item/weapon/flamethrower/flammenwerfer/Destroy()
	..()


/obj/item/weapon/flamethrower/flammenwerfer/throw_at(atom/target, range, speed, thrower)
	return

/obj/item/weapon/flamethrower/flammenwerfer/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	// Make sure our user is still holding us
	if(user && user.get_active_hand() == src)
		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turflist = getstraightline(user, target_turf, 1, 1)
			flame_turf(turflist)

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


/obj/item/weapon/flamethrower/flammenwerfer/update_icon()
	overlays.Cut()
	if(lit)
		item_state = "flamethrower_1"
	else
		item_state = "flamethrower_0"
	return

// this has better range checking so we don't burn/overheat ourselves
/obj/item/weapon/flamethrower/flammenwerfer/flame_turf(turflist)
	var/turf/my_turf = get_turf(loc)

	if(!lit || operating)	return
	operating = 1
	playsound(my_turf, 'sound/weapons/flamethrower.ogg', 100, 1)

	for(var/turf/T in turflist)

		if (T == my_turf)
			continue

		if(T.density || istype(T, /turf/space))
			break

		ignite_turf(T)


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
	return throw_amount * calculate_power_decimal()

/obj/item/weapon/flamethrower/flammenwerfer/proc/calculate_power_decimal()
	var/p1 = pressure_1
	var/p2 = ptank.air_contents.return_pressure()

	return (p2/p1)

/obj/item/weapon/flamethrower/flammenwerfer/ignite_turf(turf/target)
	//TODO: DEFERRED Consider checking to make sure tank pressure is high enough before doing this...
	//Transfer 2.5% of current tank air contents to turf
	var/datum/gas_mixture/air_transfer = ptank.air_contents.remove_ratio(0.02*(calculate_throw_amount()/100))

	var/abs_dist = 3
	var/mob/m = loc
	if (m)
		abs_dist = abs(m.x - target.x) + abs(m.y - target.y)

	if (abs_dist >= 3) // experiment to try and keep flammenwerfersoldats from igniting themselves
		new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(target,air_transfer.gas["plasma"],get_dir(loc,target),1)

	air_transfer.gas["plasma"] = 0
	target.assume_air(air_transfer)
	target.create_fire(5, rand(400,600))