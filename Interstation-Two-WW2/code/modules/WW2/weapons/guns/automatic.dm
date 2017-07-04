
//*********************
//PPS
//*********************
/obj/item/weapon/gun/projectile/automatic/mp40
	name = "Mp40"
	desc = "Mp40 german submachinegun."
	icon_state = "mp40"
	item_state = "mp40"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	w_class = 4
	caliber = "a9mm_para"
	magazine_type = /obj/item/ammo_magazine/mp40
	accuracy = -6

	can_wield = 1
	//must_wield = 1

	firemodes = list(
		list(name="single shot",	burst=1, burst_delay=1.5, move_delay=2, accuracy = list(0,0,-1,-1,-2,-2,-2,-3), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="short bursts",	burst=3, burst_delay=1.5, move_delay=4, accuracy = list(0,-1,-1,-2,-2,-2,-3,-4), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="long bursts",	burst=5, burst_delay=1.5, move_delay=6, accuracy = list(0,-1,-1,-2,-2,-2,-4,-5), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/mp40/update_icon()
	if(ammo_magazine)
		icon_state = "mp40"
		if(wielded)
			item_state = "mp40-w"
		else
			item_state = "mp40"
	else
		icon_state = "mp400"
		if(wielded)
			item_state = "mp40-w"
		else
			item_state = "mp400"
	update_held_icon()
	return

/obj/item/weapon/gun/projectile/automatic/stg
	name = "Stg44"
	desc = "Assault rifle made by german genius."
	icon_state = "stg"
	item_state = "stg"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	w_class = 5
	caliber = "a792x33"
	fire_sound = 'sound/weapons/stg.ogg'
	load_magazine_sound = 'sound/weapons/stg_reload.ogg'
	magazine_type = /obj/item/ammo_magazine/a792x33/stgmag

	can_wield = 1
	//must_wield = 1

/obj/item/weapon/gun/projectile/automatic/stg/update_icon()
	if(ammo_magazine)
		icon_state = "stg"
		if(wielded)
			item_state = "stg-w"
		else
			item_state = "stg"
	else
		icon_state = "stg0"
		if(wielded)
			item_state = "stg-w"
		else
			item_state = "stg0"
	update_held_icon()
	return


/obj/item/weapon/gun/projectile/automatic/akm
	name = "Mp43B"
	desc = "Assault rifle made by german genius."
	icon_state = "stg"
	item_state = "stg"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	w_class = 5
	caliber = "a792x33"
	magazine_type = /obj/item/ammo_magazine/a762/akm
	accuracy = -5

	can_wield = 1
	//must_wield = 1

	firemodes = list(
		list(name="single shot",	burst=1, burst_delay=1.8, move_delay=4, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="short bursts",	burst=3, burst_delay=1.8, move_delay=6, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="long bursts",	burst=5, burst_delay=1.8, move_delay=8, dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/akm/update_icon()
	if(ammo_magazine)
		icon_state = "stg"
		if(wielded)
			item_state = "stg-w"
		else
			item_state = "stg"
	else
		icon_state = "stg0"
		if(wielded)
			item_state = "stg-w"
		else
			item_state = "stg0"
	update_held_icon()
	return

/obj/item/weapon/gun/projectile/automatic/m4
	name = "PPSh submachinegun"
	desc = "Soviet submachinegun. Easy to make and easy to stuff someone with led using it."
	icon_state = "ppsh"
	item_state = "ppsh"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_BELT
	w_class = 4
	fire_sound = 'sound/weapons/m16.ogg'
	accuracy = -8
	caliber = "a762x25"
	magazine_type = /obj/item/ammo_magazine/a556/m4
	firemodes = list(
		list(name="single shot",	burst=1, burst_delay=1.1, move_delay=3, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="short bursts",	burst=5, burst_delay=1.1, move_delay=5, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="long bursts",	burst=8, burst_delay=1.1, move_delay=7, dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

	can_wield = 1
	//must_wield = 1

/obj/item/weapon/gun/projectile/automatic/m4/update_icon()
	if(ammo_magazine)
		icon_state = "ppsh"
		if(wielded)
			item_state = "ppsh"
		else
			item_state = "ppsh"
	else
		icon_state = "ppsh_empty"
		if(wielded)
			item_state = "ppsh"
		else
			item_state = "ppsh_empty"
	update_held_icon()
	return

/obj/item/weapon/gun/projectile/automatic/pkm
	name = "DP"
	desc = "DP soviet machinegun. Durable and accurate, but not so fast firing."
	icon_state = "dp"
	item_state = "dp"
	load_method = MAGAZINE
	w_class = 5
	accuracy = -5
	caliber = "a762x39"
	magazine_type = /obj/item/ammo_magazine/a762/pkm

	can_wield = 1
	must_wield = 1

	firemodes = list(
		list(name="single shot",	burst=1, burst_delay=2, move_delay=3, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="short bursts",	burst=5, burst_delay=2, move_delay=6, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="long bursts",	burst=8, burst_delay=2, move_delay=8, dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/pkm/update_icon()
	if(ammo_magazine)
		icon_state = "dp"
		if(wielded)
			item_state = "dp-w"
		else
			item_state = "dp"
	else
		icon_state = "dp0"
		if(wielded)
			item_state = "dp-w"
		else
			item_state = "dp0"
	update_held_icon()
	return

/obj/item/weapon/gun/projectile/automatic/l6_saw/m240
	name = "M240"
	caliber = "a762x51"
	max_shells = 100
	magazine_type = /obj/item/ammo_magazine/a762/m240


/obj/item/weapon/gun/projectile/automatic/val
	name = "\improper AS Val"
	desc = "A durable, efficient weapon."
	icon_state = "val_loaded"
	item_state = "val_loaded"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	w_class = 5
	caliber = "a9x39"
	fire_sound = 'sound/weapons/val.ogg'
	magazine_type = /obj/item/ammo_magazine/a9x39
	silenced = 1

	can_wield = 1
	//must_wield = 1

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
	return
