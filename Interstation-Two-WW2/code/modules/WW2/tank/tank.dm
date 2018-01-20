/mob/var/repairing_tank = FALSE

/obj/tank
	density = TRUE
	anchored = TRUE
	var/damage = FALSE
	var/max_damage = 450
	icon = 'icons/WW2/tank_large_vertical.dmi' // I don't know why but we start out southfacing
	var/horizontal_icon = 'icons/WW2/tank_large_horizontal.dmi'
	var/vertical_icon = 'icons/WW2/tank_large_vertical.dmi'
	icon_state = "ger"
	layer = MOB_LAYER + 0.01
	var/fuel_slot_screwed = TRUE
	var/fuel_slot_open = FALSE
	var/fuel = 750
	var/max_fuel = 750
	var/next_spam_allowed = -1
	var/locked = TRUE //tanks need to be unlocked
	var/heal_damage[2]
	var/named = FALSE

	pixel_x = -32

/obj/tank/New()
	..()
	update_bounding_rectangle()
	heal_damage["weldingtool"] = max_damage/10
	heal_damage["wrench"] = max_damage/20

/obj/tank/attack_hand(var/mob/user as mob)

	if (!ishuman(user))
		return FALSE

	if (fuel_slot_open)
		tank_message("<span class = 'danger'>[user] closes [my_name()]'s fuel slot.</span>")
		fuel_slot_open = FALSE
		return TRUE
	if (!named)
		var/str = sanitizeSafe(input(user,"Name tank?","Set Tank Name",""), MAX_NAME_LEN)
		if (str)
			set_name(str)
	else
		return ..()

/obj/tank/attackby(var/obj/item/weapon/W, var/mob/user as mob)

	if (!istype(W))
		return FALSE
	else if (istype(W, /obj/item/weapon/vehicle_fueltank))
		if (fuel_slot_open)
			refuel(W, user)
			return TRUE
		else
			user << "<span class = 'danger'>Open the fuel slot first.</span>"
			return FALSE
	else if (istype(W, /obj/item/weapon/flammenwerfer_fueltank))
		if (fuel_slot_open)
			user << "<span class = 'danger'>Wrong kind of fuel.</span>"
		return FALSE
	else if (istype(W, /obj/item/weapon/storage/belt/keychain))
		var/obj/item/weapon/storage/belt/keychain/kc = W
		//var/list/keylist = kc.keys

		if (istype(src, /obj/tank/german))
			for (var/obj/item/weapon/key/german/command_intermediate/key in kc.keys)
				if(istype(key))
					if (locked == TRUE)
						tank_message("<span class = 'notice'>[user] unlocks [my_name()].</span>")
						locked = FALSE
					else
						tank_message("<span class = 'notice'>[user] locks [my_name()].</span>")
						locked = TRUE
					return FALSE

		else if (istype(src, /obj/tank/soviet))
			for (var/obj/item/weapon/key/soviet/command_intermediate/key in kc.keys)
				if(istype(key))
					if (locked == TRUE)
						tank_message("<span class = 'notice'>[user] unlocks [my_name()].</span>")
						locked = FALSE
					else
						tank_message("<span class = 'notice'>[user] locks [my_name()].</span>")
						locked = TRUE
					return FALSE
		user << "<span class = 'danger'>None of your keys seem to fit!</span>"
		return FALSE
	else if (istype(W, /obj/item/weapon/key/german/command_intermediate) || istype(W, /obj/item/weapon/key/soviet/command_intermediate))
		if (locked == TRUE)
			tank_message("<span class = 'notice'>[user] unlocks [my_name()].</span>")
			locked = FALSE
		else
			tank_message("<span class = 'notice'>[user] locks [my_name()].</span>")
			locked = TRUE
		return FALSE
	else if (!istankvalidtool(W) || W.force < 5)
		if (user.a_intent != I_HURT)
			return FALSE

	if (istankvalidtool(W))
		if (istype(W, /obj/item/weapon/wrench) && !user.repairing_tank)
			tank_message("<span class = 'notice'>[user] starts to wrench in some loose parts on [my_name()].</span>")
			playsound(get_turf(src), 'sound/items/Ratchet.ogg', rand(75,100))
			user.repairing_tank = TRUE
			if (do_after(user, 50, src))
				tank_message("<span class = 'notice'>[user] wrenches in some loose parts on [my_name()]. It looks about [health_percentage()] healthy.</span>")
				damage = max(damage - heal_damage["wrench"], FALSE)
				user.repairing_tank = FALSE
			else
				user.repairing_tank = FALSE
		else if (istype(W, /obj/item/weapon/weldingtool) && !user.repairing_tank)
			var/obj/item/weapon/weldingtool/wt = W
			if (!wt.welding)
				return FALSE
			if (health_percentage_num() < 50)
				user << "<span class = 'warning'>The tank is too damaged to fix up with a welding tool. Use a wrench instead.</span>"
				return FALSE
			tank_message("<span class = 'notice'>[user] starts to repair damage on [my_name()] with their welding tool.</span>")
			playsound(get_turf(src), 'sound/items/Welder.ogg', rand(75,100))
			user.repairing_tank = TRUE
			if (do_after(user, 60, src))
				tank_message("<span class = 'notice'>[user] repairs some of the damage on [my_name()]. It looks about [health_percentage()] healthy.</span>")
				playsound(get_turf(src), 'sound/items/Welder2.ogg', rand(75,100))
				damage = max(damage - heal_damage["weldingtool"], FALSE)
				user.repairing_tank = FALSE
			else
				user.repairing_tank = FALSE
		else if (istype(W, /obj/item/weapon/screwdriver))
			if (prob(50))
				playsound(get_turf(src), 'sound/items/Screwdriver.ogg', rand(75,100))
			else
				playsound(get_turf(src), 'sound/items/Screwdriver2.ogg', rand(75,100))
			fuel_slot_screwed = !fuel_slot_screwed
			tank_message("<span class = 'notice'>[user] [fuel_slot_screwed ? "screws in" : "screws out"] the screw on [my_name()] fuel slot.</span>")
		else if (istype(W, /obj/item/weapon/crowbar))
			if (fuel_slot_screwed)
				user << "<span class = 'danger'>Unscrew the fuel slot first.</span>"
			else if (fuel_slot_open)
				user << "<span class = 'notice'>It's already open.</span>"
			else
				fuel_slot_open = TRUE
				tank_message("<span class = 'notice'>[user] crowbars open [my_name()] fuel slot.</span>")
	else
		tank_message("<span class = 'danger'>[user] hits [my_name()] with [W]!</span>")
		playsound(get_turf(src), W.hitsound, 100)
		damage += W.force/20 // huge nerf to melee vs tanks - Kachnov
		update_damage_status()
		if (prob(critical_damage_chance()))
			critical_damage()
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	return TRUE

/obj/tank/MouseDrop_T(var/atom/dropping, var/mob/user as mob)

	if (dropping != user)
		return FALSE

	if (!ishuman(user))
		return FALSE

	if (locked == FALSE)
		if (next_seat() && !accepting_occupant)
			tank_message("<span class = 'warning'>[user] starts to go in the [next_seat_name()] of [my_name()].</span>")
			accepting_occupant = TRUE
			if (do_after(user, 30, src))
				tank_message("<span class = 'warning'>[user] gets in the [next_seat_name()] of [my_name()].")
				assign_seat(user)
				accepting_occupant = FALSE
				user << "<span class = 'notice'><big>To fire, use SPACE and be in the back seat.</big></span>"
				return TRUE
			else
				tank_message("<span class = 'warning'>[user] stops going in [my_name()].</span>")
				accepting_occupant = FALSE
				return FALSE
	else
		user << "<span class = 'danger'>[capitalize(my_name())] is locked! Use a tank key or keychain with a tank key on it to unlock it.</span>"

/obj/tank/proc/receive_command_from(var/mob/user, x)
	if (!isliving(user) || user.stat == UNCONSCIOUS || user.stat == DEAD)
		return
	if (user == front_seat())
		return receive_frontseat_command(x)
	else if (user == back_seat())
		return receive_backseat_command(x)

/obj/tank/proc/receive_frontseat_command(x)
	var/moved = FALSE

	switch (x)
		if (NORTH)
			_Move(NORTH)
			moved = TRUE
		if (SOUTH)
			_Move(SOUTH)
			moved = TRUE
		if (EAST)
			_Move(EAST)
			moved = TRUE
		if (WEST)
			_Move(WEST)
			moved = TRUE

	if (moved && world.time > next_spam_allowed)
		if (fuel/max_fuel < 0.2)
			internal_tank_message("<span class = 'danger'><big>WARNING: tank fuel is less than 20%!</big></span>")
			next_spam_allowed = world.time + 100
		else if (fuel/max_fuel < 0.5)
			internal_tank_message("<span class = 'danger'><big>WARNING: tank fuel is less than 50%.</big></span>")
			next_spam_allowed = world.time + 300

/obj/tank/proc/receive_backseat_command(x)
	if (x == "FIRE")
		if (!did_critical_damage)
			Fire()

