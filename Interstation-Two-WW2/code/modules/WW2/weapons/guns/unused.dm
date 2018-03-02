/*

/obj/item/weapon/gun/projectile/automatic/l6_saw
	accuracy = DEFAULT_MG_ACCURACY
	scoped_accuracy = DEFAULT_MG_SCOPED_ACCURACY

/obj/item/weapon/gun/projectile/automatic/l6_saw/m240
	name = "M240"
	caliber = "a762x51"
	max_shells = 100
	magazine_type = /obj/item/ammo_magazine/a762/m240
*/
/*
/obj/item/weapon/gun/projectile/automatic/val
	name = "\improper AS Val"
	desc = "A durable, efficient weapon."
	icon_state = "val_loaded"
	item_state = "val_loaded"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	w_class = 4
	caliber = "a9x39"
	fire_sound = 'sound/weapons/val.ogg'
	magazine_type = /obj/item/ammo_magazine/a9x39
	silenced = TRUE
	can_wield = TRUE
	accuracy = DEFAULT_MG_ACCURACY
	scoped_accuracy = DEFAULT_MG_SCOPED_ACCURACY+1
	//must_wield = TRUE

/obj/item/weapon/gun/projectile/automatic/val/update_icon()
	if(ammo_magazine)
		icon_state = "val_loaded"
		if(wielded)
			item_state = "val_loaded_wielded"
		else
			item_state = "val_loaded"
	else
		icon_state = "val_empty"
		if(wielded)
			item_state = "val_empty_wielded"
		else
			item_state = "val_empty"
	update_held_icon()
	return*/

/*
/obj/item/weapon/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon_state = "dshotgun"
	item_state = "dshotgun"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = 4
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
//	origin_tech = "combat=3;materials=1"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

	burst_delay = FALSE
	firemodes = list(
		list(name="fire one barrel at a time", burst=1),
		list(name="fire both barrels at once", burst=2),
		)

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flash shells."
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

//this is largely hacky and bad :(	-Pete
/obj/item/weapon/gun/projectile/shotgun/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/circular_saw))
		user << "<span class='notice'>You begin to shorten the barrel of \the [src].</span>"
		if(loaded.len)
			for(var/i in TRUE to max_shells)
				afterattack(user, user)	//will this work? //it will. we call it twice, for twice the FUN
				playsound(user, fire_sound, 50, TRUE)
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			item_state = "sawnshotgun"
			w_class = 3
			force = 5
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off shotgun"
			desc = "Omar's coming!"
			user << "<span class='warning'>You shorten the barrel of \the [src]!</span>"
	else
		..()

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	w_class = 3
	force = 5*/