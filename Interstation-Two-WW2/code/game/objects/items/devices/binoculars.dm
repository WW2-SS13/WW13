//Snowfleked under guns with the zooming changes (Don't worry you can't shoot anyone with this)

/obj/item/weapon/gun/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
	icon = 'icons/obj/device.dmi'
	icon_state = "binoculars"

	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
	w_class = 2.0
	throwforce = WEAPON_FORCE_WEAK
	throw_range = 15
	throw_speed = 3
	zoomable = TRUE
	zoomed = FALSE
	zoom_amt = 15
	zoomdevicename = null
	//matter = list("metal" = 50,"glass" = 50)
	item_icons = list(0)
	slot_flags = SLOT_BELT|SLOT_POCKET
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	w_class = 3
	throwforce = 1
	throw_speed = 4
	throw_range = 5
	force = 1
	origin_tech = null
	attack_verb = list("struck", "hit", "bashed")
	fire_delay = 60	//delay after shooting before the gun can be used again
	burst_delay = 0	//delay between shots, if firing in bursts
	fire_sound = 'sound/weapons/Gunshot.ogg'
	fire_sound_text = "gunshot"
	recoil = 0		//screen shake
	silenced = 0
	muzzle_flash = 0
	accuracy = 0   //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	scoped_accuracy = null
	next_fire_time = 0
	sel_mode = 0 //index of the currently selected mode
	keep_aim = 0
	multi_aim = 0
	told_cant_shoot = 0
	lock_time = 0

	wielded = 0
	must_wield = 0
	can_wield = 0
	can_scope = 0

	burst = 0
	move_delay = 0

/obj/item/weapon/gun/binoculars/New()
	..()
	if(ishuman(loc))
		azoom.Grant(loc)

/datum/action/toggle_scope
	//button_icon = 'icons/obj/device.dmi'
	//button_icon_state = "binoculars"

/obj/item/weapon/gun/binoculars/attackby()
/obj/item/weapon/gun/binoculars/handle_shield()
/obj/item/weapon/gun/binoculars/afterattack()
/obj/item/weapon/gun/binoculars/attack()
/obj/item/weapon/gun/binoculars/attack_self()
