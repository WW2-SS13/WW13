//these are probably broken

/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = TRUE
	var/on = FALSE
	var/obj/item/weapon/cell/high/cell = null
	var/use = 200 // 200W light
	var/unlocked = FALSE
	var/open = FALSE
	var/brightness_on = 8		//can't remember what the maxed out value is
	light_power = 2

/obj/machinery/floodlight/New()
	cell = new(src)
	cell.maxcharge = 1000
	cell.charge = 1000 // 41minutes @ 200W
	..()

/obj/machinery/floodlight/update_icon()
	overlays.Cut()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/process()
	if(!on)
		return

	if(!cell || (cell.charge < (use * CELLRATE)))
		turn_off(1)
		return

	// If the cell is almost empty rarely "flicker" the light. Aesthetic only.
	if((cell.percent() < 10) && prob(5))
		set_light(brightness_on/2, brightness_on/4)
		spawn(20)
			if(on)
				set_light(brightness_on, brightness_on/2)

	cell.use(use*CELLRATE)


// Returns FALSE on failure and TRUE on success
/obj/machinery/floodlight/proc/turn_on(var/loud = FALSE)
	if(!cell)
		return FALSE
	if(cell.charge < (use * CELLRATE))
		return FALSE

	on = TRUE
	set_light(brightness_on, brightness_on / 2)
	update_icon()
	if(loud)
		visible_message("\The [src] turns on.")
	return TRUE

/obj/machinery/floodlight/proc/turn_off(var/loud = FALSE)
	on = FALSE
	set_light(0, FALSE)
	update_icon()
	if(loud)
		visible_message("\The [src] shuts down.")

/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.loc = user.loc
		else
			cell.loc = loc

		cell.add_fingerprint(user)
		cell.update_icon()

		cell = null
		on = FALSE
		set_light(0)
		user << "You remove the power cell"
		update_icon()
		return

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			user << "You try to turn on \the [src] but it does not work."

	update_icon()


/obj/machinery/floodlight/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (!open)
			if(unlocked)
				unlocked = FALSE
				user << "You screw the battery panel in place."
			else
				unlocked = TRUE
				user << "You unscrew the battery panel."

	if (istype(W, /obj/item/weapon/crowbar))
		if(unlocked)
			if(open)
				open = FALSE
				overlays = null
				user << "You crowbar the battery panel in place."
			else
				if(unlocked)
					open = TRUE
					user << "You remove the battery panel."

	if (istype(W, /obj/item/weapon/cell))
		if(open)
			if(cell)
				user << "There is a power cell already installed."
			else
				user.drop_item()
				W.loc = src
				cell = W
				user << "You insert the power cell."
	update_icon()
