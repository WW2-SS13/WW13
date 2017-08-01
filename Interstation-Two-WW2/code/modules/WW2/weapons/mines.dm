
//*****************************
//MINES
//*****************************
/obj/item/device/mine
	name = "proximity mine"
	desc = "An anti-personnel mine. Useful for setting traps or for area denial. "
	icon = 'icons/obj/grenade.dmi'
	icon_state = "mine"
	force = 5.0
	w_class = 2.0
	layer = OBJ_LAYER + 0.01 //because they go in crates
	throwforce = 5.0
	throw_range = 6
	throw_speed = 3
	unacidable = 1
	anchored = 0

	var/triggered = 0
	var/triggertype = "explosive" //Calls that proc
	/*
		"explosive"
		//"incendiary" //New bay//
	*/


//Arming
/obj/item/device/mine/attack_self(mob/living/user as mob)
	if(locate(/obj/item/device/mine) in get_turf(src))
		src << "There's already a mine at this position!"
		return

	if(!anchored)
		user.visible_message("\blue \The [user] starts to deploy the \the [src]")
		if(!do_after(user,40))
			user.visible_message("\blue \The [user] decides not to deploy the \the [src].")
			return
		user.visible_message("\blue \The [user] finishes deploying the \the [src].")
		anchored = 1
		layer = TURF_LAYER + 0.01
		icon_state = "mine_armed"
		user.drop_item()
		return

//Disarming
/obj/item/device/mine/attackby(obj/item/W as obj, mob/user as mob)
	if(anchored)
		if(istype(W, /obj/item/weapon/wirecutters))
			user.visible_message("\blue \The [user] starts to disarm the \the [src] with the [W]")
			if(!do_after(user,60))
				user.visible_message("\blue \The [user] decides not to disarm the \the [src].")
				return
			if(prob(95))
				user.visible_message("\blue \The [user] finishes disarming the \the [src]!")
				anchored = 0
				icon_state = "betty"
				layer = initial(layer)
				return
			else
				Bumped(user)
		else if(istype(W, /obj/item/weapon/material/knife))
			user.visible_message("\blue \The [user] starts to disarm the \the [src] with the [W].")
			if(!do_after(user,80))
				user.visible_message("\blue \The [user] decides not to disarm the \the [src].")
				return
			if(prob(50))
				user.visible_message("\blue \The [user] finishes disarming the \the [src]!")
				anchored = 0
				icon_state = "betty"
				layer = initial(layer)
				return
			else
				Bumped(user)
		else
			Bumped(user)

/obj/item/device/mine/attack_hand(mob/user as mob)
	if(anchored)
		user.visible_message("\blue \The [user] starts to dig around the \the [src] with their bare hands!")
		if(!do_after(user,100))
			user.visible_message("\blue \The [user] decides not to dig up the \the [src].")
			return
		if(prob(15))
			user.visible_message("\blue \The [user] finishes digging up the \the [src], disarming it!")
			anchored = 0
			icon_state = "betty"
			layer = initial(layer)
			return
		else
			Bumped(user)
	else
		..()

//Triggering
/obj/item/device/mine/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/item/device/mine/Bumped(mob/M as mob|obj)
	if(!anchored) return //If armed
	if(triggered) return

	if(istype(M, /mob/living/carbon/human) && M.stat != DEAD)
		for(var/mob/O in viewers(world.view, src.loc))
			O << "<font color='red'>[M] triggered the [src]!</font>"
		triggered = 1
		visible_message("\red <b>Click!</b>")
		explosion(src.loc,-1,1,3)
		spawn(0)
			if(src)
				del(src)

//TYPES//
//Explosive
/obj/item/device/mine/proc/explosive(obj)
	explosion(src.loc,-1,-1,3)
	spawn(0)
		del(src)


/obj/item/device/mine/betty
	name = "S-mine 'Bouncing Betty'"
	desc = "German anti-personnel mine. Useful for setting traps or for area denial."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "betty"
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 6
	throw_speed = 3
	unacidable = 1
	anchored = 0