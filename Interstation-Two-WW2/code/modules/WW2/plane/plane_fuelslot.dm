/* a fuel slot. It's an object. You put fuel tanks in it. */

/obj/plane_part/plane_fuelslot
	anchored = 1
	icon = null
	icon_state = null
	layer = MOB_LAYER - 0.01
	var/screwed = 1
	var/open = 0
	var/fuel = 750
	var/max_fuel = 750
	var/locked = 1
	var/datum/plane/master = null

/obj/plane_part/plane_fuelslot/New(_master)
	..()
	master = _master
	if (!master)
		qdel(src)
		return

/obj/plane_part/plane_fuelslot/attack_hand(var/mob/user as mob)

	if (!ishuman(user))
		return 0

	if (open)
		plane_message("<span class = 'danger'>[user] closes [my_name()]'s fuel slot.</span>")
		open = 0
		return 1
	else
		return ..()

/obj/plane_part/plane_fuelslot/attackby(var/obj/item/weapon/W, var/mob/user as mob)

	if (!istype(W))
		return 0
	else if (istype(W, /obj/item/weapon/vehicle_fueltank))
		if (open)
			refuel(W, user)
			return 1
		else
			user << "<span class = 'danger'>Open the fuel slot first.</span>"
			return 0
	else if (istype(W, /obj/item/weapon/flammenwerfer_fueltank))
		if (open)
			user << "<span class = 'danger'>Wrong kind of fuel.</span>"
		return 0
	else if (istype(W, /obj/item/weapon/storage/belt/keychain))
		var/obj/item/weapon/storage/belt/keychain/kc = W
		//var/list/keylist = kc.keys

		for (var/obj/item/weapon/key/german/command_intermediate/key in kc.keys)
			if(istype(key))
				if (locked == 1)
					plane_message("<span class = 'notice'>[user] unlocks [my_name()].</span>")
					locked = 0
				else
					plane_message("<span class = 'notice'>[user] locks [my_name()].</span>")
					locked = 1
				return 0
		for (var/obj/item/weapon/key/russian/command_intermediate/key in kc.keys)
			if(istype(key))
				if (locked == 1)
					plane_message("<span class = 'notice'>[user] unlocks [my_name()].</span>")
					locked = 0
				else
					plane_message("<span class = 'notice'>[user] locks [my_name()].</span>")
					locked = 1
				return 0
		user << "<span class = 'danger'>None of your keys seem to fit!</span>"
		return 0
	else if (istype(W, /obj/item/weapon/key/german/command_intermediate) || istype(W, /obj/item/weapon/key/russian/command_intermediate))
		if (locked == 1)
			plane_message("<span class = 'notice'>[user] unlocks [my_name()].</span>")
			locked = 0
		else
			plane_message("<span class = 'notice'>[user] locks [my_name()].</span>")
			locked = 1
		return 0

	if (isplanevalidtool(W))
		if (istype(W, /obj/item/weapon/screwdriver))
			if (prob(50))
				playsound(get_turf(src), 'sound/items/Screwdriver.ogg', rand(75,100))
			else
				playsound(get_turf(src), 'sound/items/Screwdriver2.ogg', rand(75,100))
			screwed = !screwed
			plane_message("<span class = 'notice'>[user] [screwed ? "screws in" : "screws out"] the screw on [my_name()] fuel slot.</span>")
		else if (istype(W, /obj/item/weapon/crowbar))
			if (screwed)
				user << "<span class = 'danger'>Unscrew the fuel slot first.</span>"
			else if (open)
				user << "<span class = 'notice'>It's already open.</span>"
			else
				open = 1
				plane_message("<span class = 'notice'>[user] crowbars open [my_name()] fuel slot.</span>")
	else
		return 0
	return 1

/obj/plane_part/plane_fuelslot/proc/refuel(var/obj/item/weapon/vehicle_fueltank/ftank, var/mob/user as mob)
	plane_message("[user] refuels [my_name()] with [ftank].")
	qdel(ftank)
	fuel = max_fuel