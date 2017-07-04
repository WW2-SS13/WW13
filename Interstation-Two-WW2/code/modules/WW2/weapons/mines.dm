
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
		user.visible_message("\blue \The [user] is deploying \the [src]")
		if(!do_after(user,40))
			user.visible_message("\blue \The [user] decides not to deploy \the [src].")
			return
		user.visible_message("\blue \The [user] deployed \the [src].")
		anchored = 1
		icon_state = "mine_armed"
		user.drop_item()
		return

//Disarming
/obj/item/device/mine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/material/knife))
		if(anchored)
			user.visible_message("\blue \The [user] starts to disarm \the [src].")
			if(!do_after(user,80))
				user.visible_message("\blue \The [user] decides not to disarm \the [src].")
				return
			user.visible_message("\blue \The [user] finishes disarming \the [src]!")
			anchored = 0
			icon_state = "mine"
			return

//Triggering
/obj/item/device/mine/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/item/device/mine/Bumped(mob/M as mob|obj)
	if(!anchored) return //If armed
	if(triggered) return

	if(istype(M, /mob/living/carbon/human) && M.stat != DEAD)
		for(var/mob/O in viewers(world.view, src.loc))
			O << "<font color='red'>[M] triggered the \icon[src] [src]!</font>"
		triggered = 1
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