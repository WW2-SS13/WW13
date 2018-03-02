/obj/item/weapon/gun/projectile/svt
	name = "SVT-40"
	desc = "Soviet semi-automatic rifle chambered in 7.62x54mmR. Used by some guard units and defense units."
	icon_state = "svt"
	item_state = "svt"
	w_class = 4
	load_method = SPEEDLOADER | MAGAZINE
	max_shells = FALSE
	caliber = "a762x54"
//	origin_tech = "combat=4;materials=2"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a762x54
	accuracy = DEFAULT_SEMIAUTO_ACCURACY
	scoped_accuracy = DEFAULT_SEMIAUTO_SCOPED_ACCURACY
	magazine_type = /obj/item/ammo_magazine/svt
	firemodes = list(
		list(name="single shot",burst=1, move_delay=4, fire_delay=10)
		)

	gun_type = GUN_TYPE_RIFLE
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_SCOPE|ATTACH_BARREL
	force = 10
	throwforce = 20

/obj/item/weapon/gun/projectile/svt/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "svt"
		item_state = "svt-mag"
	else
		icon_state = "svt0"
		item_state = "svt-0"
	return

/obj/item/weapon/gun/projectile/g41
	name = "Gewehr 41"
	desc = "German semi-automatic rifle using 7.92x57mm Mauser ammunition in a 10 round magazine. Devastating rifle."
	icon_state = "" //to-do
	item_state = "" //to-do
	w_class = 4
	load_method = SPEEDLOADER | MAGAZINE
	max_shells = FALSE
	caliber = "a792x57"
//	origin_tech = "combat=4;materials=2"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a792x57
	accuracy = DEFAULT_SEMIAUTO_ACCURACY
	scoped_accuracy = DEFAULT_SEMIAUTO_SCOPED_ACCURACY
	magazine_type = /obj/item/ammo_magazine/g41
	firemodes = list(
		list(name="single shot",burst=1, move_delay=4, fire_delay=10, dispersion = list(1))
		)
	force = 10
	throwforce = 20

/obj/item/weapon/gun/projectile/g41/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "" //to-do
	else
		icon_state = "" //to-do
	return


//*********************
//PPS
//*********************

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
	w_class = 4
	caliber = "a9mm_para"
	magazine_type = /obj/item/ammo_magazine/mp40
	can_wield = TRUE
	//must_wield = TRUE

	accuracy = DEFAULT_SEMIAUTO_ACCURACY
	scoped_accuracy = DEFAULT_SEMIAUTO_SCOPED_ACCURACY

	firemodes = list(
		list(name="single shot",	burst=1, burst_delay=1.0, recoil=0.4, move_delay=1, dispersion = list(0.4, 0.6, 0.6, 0.6, 0.8)),
		list(name="short bursts",	burst=3, burst_delay=1.2, recoil=0.7, move_delay=2, dispersion = list(0.8, 1.2, 1.2, 1.2, 1.4)),
		list(name="long bursts",	burst=6, burst_delay=1.4, recoil=0.9, move_delay=4, dispersion = list(1.2, 1.4, 1.4, 1.4, 1.6)),
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

/obj/item/weapon/gun/projectile/automatic/stg
	name = "STG-44"
	desc = "German assault rifle with a 30 round magazine, chambered in 7.92x33mm Kurz. It is a devastating weapon."
	icon_state = "stg"
	item_state = "stg"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_BELT
	w_class = 4
	caliber = "a792x33"
	fire_sound = 'sound/weapons/stg.ogg'
	load_magazine_sound = 'sound/weapons/stg_reload.ogg'
	magazine_type = /obj/item/ammo_magazine/a792x33/stgmag

	accuracy = DEFAULT_SEMIAUTO_ACCURACY
	scoped_accuracy = DEFAULT_SEMIAUTO_SCOPED_ACCURACY

	can_wield = TRUE

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
	name = "MP-43/B"
	desc = "German assault rifle chambered in 7.92x33mm Kurz, 30 round magazine. Variant of the STG-44, issued to SS, usually."
	icon_state = "stg"
	item_state = "stg"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_BELT
	w_class = 4
	caliber = "a792x33"
	magazine_type = /obj/item/ammo_magazine/a762/akm

	accuracy = DEFAULT_SEMIAUTO_ACCURACY
	scoped_accuracy = DEFAULT_SEMIAUTO_SCOPED_ACCURACY

	can_wield = TRUE
	//must_wield = TRUE

	firemodes = list(
		list(name="single shot",	burst=1, burst_delay=1.8, move_delay=4, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="short bursts",	burst=3, burst_delay=1.8, move_delay=6, dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(name="long bursts",	burst=5, burst_delay=1.8, move_delay=8, dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

	sel_mode = 2

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

/obj/item/weapon/gun/projectile/automatic/ppsh
	name = "PPSh-41"
	desc = "Soviet submachinegun with a very large drum magazine. Capable of bringing many targets down in Stalin's name."
	icon_state = "ppsh"
	item_state = "ppsh"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_BELT
	w_class = 4
	fire_sound = 'sound/weapons/m16.ogg'
	accuracy = DEFAULT_SEMIAUTO_ACCURACY-1
	scoped_accuracy = DEFAULT_SEMIAUTO_SCOPED_ACCURACY-1
	caliber = "a762x25"
	magazine_type = /obj/item/ammo_magazine/a556/ppsh
	firemodes = list(
		list(name="single shot",	burst=1, burst_delay=0.8, recoil=0.4, move_delay=1, dispersion = list(0.5, 0.7, 0.7, 0.7, 0.9)),
		list(name="short bursts",	burst=4, burst_delay=1.0, recoil=0.6, move_delay=2, dispersion = list(1.0, 1.4, 1.4, 1.4, 1.6)),
		list(name="long bursts",	burst=8, burst_delay=1.2, recoil=0.8, move_delay=4, dispersion = list(1.4, 1.6, 1.6, 1.6, 1.8)),
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
