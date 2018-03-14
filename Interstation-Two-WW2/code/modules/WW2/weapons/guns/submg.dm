/obj/item/weapon/gun/projectile/automatic
	force = 10
	throwforce = 20

/obj/item/weapon/gun/projectile/automatic/mp40
	name = "MP-40"
	desc = "German submachinegun chambered in 9x19 Parabellum, with a 32 magazine magazine layout. Standard issue amongst most troops."
	icon_state = "mp40"
	item_state = "mp40"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_BELT
	w_class = 3
	caliber = "a9mm_para"
	magazine_type = /obj/item/ammo_magazine/mp40
	can_wield = TRUE
	//must_wield = TRUE

	accuracy = DEFAULT_SUBMACHINEGUN_ACCURACY
	scoped_accuracy = DEFAULT_SUBMACHINEGUN_SCOPED_ACCURACY

	firemodes = list(
		list(name="single shot",	burst=1, burst_delay=1.0, recoil=0.4, move_delay=0, dispersion = list(0.4, 0.6, 0.6, 0.6, 0.8), accuracy = list(DEFAULT_SUBMACHINEGUN_ACCURACY + 1)),
		list(name="short bursts",	burst=3, burst_delay=1.2, recoil=0.7, move_delay=1, dispersion = list(0.8, 1.2, 1.2, 1.2, 1.4)),
		list(name="long bursts",	burst=6, burst_delay=1.4, recoil=0.9, move_delay=1.5, dispersion = list(1.2, 1.4, 1.4, 1.4, 1.6)),
		)

	sel_mode = 2

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

/obj/item/weapon/gun/projectile/automatic/ppsh
	name = "PPSh-41"
	desc = "Soviet submachinegun with a very large drum magazine. Capable of bringing many targets down in Stalin's name."
	icon_state = "ppsh"
	item_state = "ppsh"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_BELT
	w_class = 3
	fire_sound = 'sound/weapons/m16.ogg'
	accuracy = DEFAULT_SUBMACHINEGUN_ACCURACY-1
	scoped_accuracy = DEFAULT_SUBMACHINEGUN_ACCURACY-1
	caliber = "a762x25"
	magazine_type = /obj/item/ammo_magazine/a556/ppsh
	firemodes = list(
		list(name="single shot",	burst=1, burst_delay=0.8, recoil=0.4, move_delay=0, dispersion = list(0.5, 0.7, 0.7, 0.7, 0.9)),
		list(name="short bursts",	burst=4, burst_delay=1.0, recoil=0.6, move_delay=0.5, dispersion = list(1.0, 1.4, 1.4, 1.4, 1.6)),
		list(name="long bursts",	burst=8, burst_delay=1.2, recoil=0.8, move_delay=1, dispersion = list(1.4, 1.6, 1.6, 1.6, 1.8)),
		)

	can_wield = TRUE

	sel_mode = 2

/obj/item/weapon/gun/projectile/automatic/ppsh/update_icon()
	if(ammo_magazine)
		icon_state = "ppsh"
		if(wielded)
			item_state = "ppsh"
		else
			item_state = "ppsh"
	else
		icon_state = "ppsh_empty"
		if(wielded)
			item_state = "ppsh_empty"
		else
			item_state = "ppsh_empty"
	update_held_icon()
	return

/obj/item/weapon/gun/projectile/automatic/pps
	name = "PPS-43"
	desc = "Russian submachine gun chambered in 7.62x25mm Tokarev."
	icon_state = "pps"
	item_state = "pps"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_BELT
	w_class = 3
	//fire_sound = ''
	accuracy = DEFAULT_SUBMACHINEGUN_ACCURACY
	scoped_accuracy = DEFAULT_SUBMACHINEGUN_SCOPED_ACCURACY-1
	caliber = "7.62x25mm"
	magazine_type = /obj/item/ammo_magazine/c762x25mm_pps
	firemodes = list(
		list(name="short bursts",	burst=3, burst_delay=1.0, recoil=0.6, move_delay=0.8, dispersion = list(0.9, 1.3, 1.3, 1.3, 1.5)),
		list(name="long bursts",	burst=6, burst_delay=1.2, recoil=0.8, move_delay=1.2, dispersion = list(1.4, 1.6, 1.6, 1.6, 1.8)),
		)

	can_wield = TRUE

	sel_mode = 2

/obj/item/weapon/gun/projectile/automatic/pps/update_icon()
	if(ammo_magazine)
		icon_state = "pps"
	else
		icon_state = "pps0"
	return

/obj/item/weapon/gun/projectile/automatic/stenmk3
	name = "Sten MKIII"
	desc = "British submachine gun chambered in 9x19mm."
	icon_state = "sten"
	item_state = "sten"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_BELT
	w_class = 3
	//fire_sound = '' // TO DO
	accuracy = DEFAULT_SUBMACHINEGUN_ACCURACY-2
	scoped_accuracy = DEFAULT_SUBMACHINEGUN_SCOPED_ACCURACY-3
	caliber = "9x19mm"
	magazine_type = /obj/item/ammo_magazine/c9x19mm_stenmk3
	firemodes = list(
		list(name="short burst",	burst=3, burst_delay=1.2, recoil=0.4, move_delay=0.2, dispersion = list(1.0, 1.4, 1.4, 1.4, 1.6)),
		list(name="long burst", 	burst=6, burst_delay=1.6, recoil=0.8, move_delay=0.4, dispersion = list(1.5, 1.7, 1.7, 1.7, 1.9)),
		)

	can_wield = TRUE

	sel_mode = 2

/obj/item/weapon/gun/projectile/automatic/stenmk3/update_icon()
	if(ammo_magazine)
		icon_state = "sten"
	else
		icon_state = "sten0"
	return