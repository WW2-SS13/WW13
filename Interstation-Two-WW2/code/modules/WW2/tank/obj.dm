/mob/var/repairing_tank = 0

/obj/tank
	density = 1
	anchored = 1
	var/damage = 0
	var/max_damage = 450
	icon = 'icons/WW2/tank_large_vertical.dmi' // I don't know why but we start out southfacing
	var/horizontal_icon = 'icons/WW2/tank_large_horizontal.dmi'
	var/vertical_icon = 'icons/WW2/tank_large_vertical.dmi'
	icon_state = "ger"
	layer = MOB_LAYER - 0.01
	var/fuel_slot_screwed = 1
	var/fuel_slot_open = 0
	var/fuel = 750
	var/max_fuel = 750
	var/next_spam_allowed = -1
	var/locked = 1 //tanks need to be unlocked
	var/heal_damage[2]
	var/named = 0

/obj/tank/New()
	..()
	update_bounding_rectangle()
	heal_damage["weldingtool"] = max_damage/10
	heal_damage["wrench"] = max_damage/20

/obj/tank/attack_hand(var/mob/user as mob)

	if (!ishuman(user))
		return 0

	if (fuel_slot_open)
		tank_message("<span class = 'danger'>[user] closes [my_name()]'s fuel slot.</span>")
		fuel_slot_open = 0
		return 1
	if (!named)
		var/str = sanitizeSafe(input(user,"Name tank?","Set Tank Name",""), MAX_NAME_LEN)
		if (str)
			set_name(str)
	else
		return ..()

/obj/tank/attackby(var/obj/item/weapon/W, var/mob/user as mob)

	if (!istype(W))
		return 0
	else if (istype(W, /obj/item/weapon/tank_fueltank))
		if (fuel_slot_open)
			refuel(W, user)
			return 1
		else
			user << "<span class = 'danger'>Open the fuel slot first.</span>"
			return 0
	else if (istype(W, /obj/item/weapon/flammenwerfer_fueltank))
		if (fuel_slot_open)
			user << "<span class = 'danger'>Wrong kind of fuel.</span>"
		return 0
	else if (istype(W, /obj/item/weapon/storage/belt/keychain))
		var/obj/item/weapon/storage/belt/keychain/kc = W
		//var/list/keylist = kc.keys

		for (var/obj/item/weapon/key/german/command_intermediate/key in kc.keys)
			if(istype(key))
				if (locked == 1)
					tank_message("<span class = 'notice'>[user] unlocks [my_name()].</span>")
					locked = 0
				else
					tank_message("<span class = 'notice'>[user] locks [my_name()].</span>")
					locked = 1
				return 0
		for (var/obj/item/weapon/key/russian/command_intermediate/key in kc.keys)
			if(istype(key))
				if (locked == 1)
					tank_message("<span class = 'notice'>[user] unlocks [my_name()].</span>")
					locked = 0
				else
					tank_message("<span class = 'notice'>[user] locks [my_name()].</span>")
					locked = 1
				return 0
		user << "<span class = 'danger'>None of your keys seem to fit!</span>"
		return 0
	else if (istype(W, /obj/item/weapon/key/german/command_intermediate) || istype(W, /obj/item/weapon/key/russian/command_intermediate))
		if (locked == 1)
			tank_message("<span class = 'notice'>[user] unlocks [my_name()].</span>")
			locked = 0
		else
			tank_message("<span class = 'notice'>[user] locks [my_name()].</span>")
			locked = 1
		return 0
	else if (!istankvalidtool(W) || W.force < 5)
		if (user.a_intent != I_HURT)
			return 0

	if (istankvalidtool(W))
		if (istype(W, /obj/item/weapon/wrench) && !user.repairing_tank)
			tank_message("<span class = 'notice'>[user] starts to wrench in some loose parts on [my_name()].</span>")
			playsound(get_turf(src), 'sound/items/Ratchet.ogg', rand(75,100))
			user.repairing_tank = 1
			if (do_after(user, 50, src))
				tank_message("<span class = 'notice'>[user] wrenches in some loose parts on [my_name()]. It looks about [health_percentage()] healthy.</span>")
				damage = max(damage - heal_damage["wrench"], 0)
				user.repairing_tank = 0
			else
				user.repairing_tank = 0
		else if (istype(W, /obj/item/weapon/weldingtool) && !user.repairing_tank)
			var/obj/item/weapon/weldingtool/wt = W
			if (!wt.welding)
				return 0
			if (health_percentage_num() < 50)
				user << "<span class = 'warning'>The tank is too damaged to fix up with a welding tool. Use a wrench instead.</span>"
				return 0
			tank_message("<span class = 'notice'>[user] starts to repair damage on [my_name()] with their welding tool.</span>")
			playsound(get_turf(src), 'sound/items/Welder.ogg', rand(75,100))
			user.repairing_tank = 1
			if (do_after(user, 60, src))
				tank_message("<span class = 'notice'>[user] repairs some of the damage on [my_name()]. It looks about [health_percentage()] healthy.</span>")
				playsound(get_turf(src), 'sound/items/Welder2.ogg', rand(75,100))
				damage = max(damage - heal_damage["weldingtool"], 0)
				user.repairing_tank = 0
			else
				user.repairing_tank = 0
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
				fuel_slot_open = 1
				tank_message("<span class = 'notice'>[user] crowbars open [my_name()] fuel slot.</span>")
	else
		tank_message("<span class = 'danger'>[user] hits [my_name()] with [W]!</span>")
		playsound(get_turf(src), W.hitsound, 100)
		damage += W.force/20 // huge nerf to melee vs tanks - Kachnov
		update_damage_status()
		if (prob(critical_damage_chance()))
			critical_damage()
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	return 1

/obj/tank/MouseDrop_T(var/atom/dropping, var/mob/user as mob)

	if (dropping != user)
		return 0

	if (!ishuman(user))
		return 0

	var/mob/living/carbon/human/H = user

	if (locked == 0)
		if (H.is_jew)
			user << "<span class = 'danger'>You don't know how to use [my_name()].</span>"
			return 0

		if (next_seat() && !accepting_occupant)
			tank_message("<span class = 'warning'>[user] starts to go in the [next_seat_name()] of [my_name()].</span>")
			accepting_occupant = 1
			if (do_after(user, 30, src))
				tank_message("<span class = 'warning'>[user] gets in the [next_seat_name()] of [my_name()].")
				assign_seat(user)
				accepting_occupant = 0
				user << "<span class = 'notice'><big>To fire, use SPACE and be in the back seat.</big></span>"
				return 1
			else
				tank_message("<span class = 'warning'>[user] stops going in [my_name()].</span>")
				accepting_occupant = 0
				return 0
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
	var/moved = 0

	switch (x)
		if (NORTH)
			_Move(NORTH)
			moved = 1
		if (SOUTH)
			_Move(SOUTH)
			moved = 1
		if (EAST)
			_Move(EAST)
			moved = 1
		if (WEST)
			_Move(WEST)
			moved = 1

	if (moved && world.time > next_spam_allowed)
		if (fuel/max_fuel < 0.2)
			internal_tank_message("<span class = 'danger'><big>WARNING: tank fuel is less than 20%!</big></span>")
			next_spam_allowed = world.time + 100
		else if (fuel/max_fuel < 0.5)
			internal_tank_message("<span class = 'danger'><big>WARNING: tank fuel is less than 50%.</big></span>")
			next_spam_allowed = world.time + 300

/obj/tank/proc/receive_backseat_command(x)
	if (x == "FIRE")
		Fire()

