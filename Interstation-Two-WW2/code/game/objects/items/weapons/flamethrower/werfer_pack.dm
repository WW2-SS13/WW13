/obj/item/weapon/storage/backpack/flammenwerfer
	name = "flammenwerfer backpack"
	desc = "You wear this on your back and then blast people with fire."
	icon_state = "fw_back"
	item_state_slots = null
	var/obj/item/weapon/flamethrower/flammenwerfer/flamethrower = null // thrower is taken by movable atoms!
	var/obj/item/weapon/tank/plasma/ptank = null
	nothrow = TRUE

/obj/item/weapon/storage/backpack/flammenwerfer/nothrow_special_check()
	return nodrop_special_check()

/obj/item/weapon/storage/backpack/flammenwerfer/examine(var/mob/user)
	var/show = desc
	if (flamethrower && flamethrower.loc == src)
		show += " There is a flamethrower inside."
	user << "<span class = 'notice'>[show]</span>"

/obj/item/weapon/storage/backpack/flammenwerfer/New()
	..()

	flamethrower = new(src)
	flamethrower.backpack = src
	ptank = new/obj/item/weapon/tank/plasma/super()
	flamethrower.ptank = ptank
	flamethrower.pressure_1 = ptank.air_contents.return_pressure()

/obj/item/weapon/storage/backpack/flammenwerfer/open()
	return

// todo: this sucks - Kachnov
/obj/item/weapon/storage/backpack/flammenwerfer/equipped(var/mob/user, var/slot)

	if (slot == SLOT_BACK)
		if (!user.put_in_any_hand_if_possible(flamethrower) && !(user.l_hand == flamethrower) && !(user.r_hand == flamethrower))
			user << "<span class = 'danger'>You don't have space to hold the flammenwerfer in your hands.</span>"
			return

	..(user, slot)

/obj/item/weapon/storage/backpack/flammenwerfer/proc/reclaim_flamethrower()

	if (!flamethrower)
		return

	flamethrower.loc = src
	handle_item_insertion(flamethrower, TRUE)


/obj/item/weapon/storage/backpack/flammenwerfer/MouseDrop(obj/over_object as obj)
	if (!nodrop_special_check()) // if the flamethrower is in the backpack, we can move it
		return ..(over_object)


/obj/item/weapon/storage/backpack/flammenwerfer/attackby(obj/item/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/flamethrower/flammenwerfer))
		..(W, user)

	if (istype(W, /obj/item/weapon/flammenwerfer_fueltank))
		visible_message("<span class = 'notice'>[user] puts the flammenwerfer fuel tank in the flammenwerfer.</span>")
		qdel(W)
		flamethrower.ptank = new ptank.type
		flamethrower.pressure_1 = ptank.air_contents.return_pressure()
		flamethrower.fueltank += 1.00
		flamethrower.fueltank = min(flamethrower.fueltank, 1.00)

/obj/item/weapon/storage/backpack/flammenwerfer/attack_hand(mob/user as mob)
	if (loc == user)
		if (contents.Find(flamethrower))
			if (user.get_active_hand() == null)
				user.put_in_any_hand_if_possible(flamethrower)
				user << "<span class = 'notice'>You take the flamethrower from [src].</span>"
	else
		..(user)


/obj/item/weapon/storage/backpack/flammenwerfer/proc/explode()
	if (istype(loc, /mob))
		var/mob/m = loc
		m.visible_message("<span class = 'danger'>[m]'s flammenwerfer explodes!</span>", "<span class = 'danger'><font size = 3>Your flammenwerfer explodes!</font></span>")
		explosion(get_turf(m), FALSE, 2, 3, 4)

		for (var/mob/mm in range(1, get_turf(m)))
			var/turf/t = get_turf(mm)
			t.hotspot_expose((ptank.air_contents.temperature*2) + 380,500)

		//if (m.get_active_hand() == flamethrower || m.get_inactive_hand() == flamethrower)
		m.remove_from_mob(flamethrower)
		flamethrower.loc = null

		qdel(src)

		spawn (1)
			m.regenerate_icons()


