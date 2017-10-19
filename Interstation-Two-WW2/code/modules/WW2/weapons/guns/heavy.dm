/obj/item/weapon/gun/projectile/heavysniper/ptrd
	name = "PTRD anti-tank rifle"
	desc = "A portable anti-armour rifle. Uses 14.5mm shells."
	icon_state = "ptrd"
	item_state = "l6closednomag" //placeholder
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "combat=8;materials=2;syndicate=8"
	caliber = "14.5mm"
	recoil = 3 //extra kickback
	fire_sound = 'sound/weapons/WW2/ptrd_fire.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING | SPEEDLOADER
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a145
	//+2 accuracy over the LWAP because only one shot
	accuracy = DEFAULT_BOLTACTION_ACCURACY + 2
	scoped_accuracy = DEFAULT_BOLTACTION_SCOPED_ACCURACY + 2

/obj/item/weapon/gun/projectile/heavysniper/ptrd/update_icon()
	if(bolt_open)
		icon_state = "ptrd"
	else
		icon_state = "ptrd"

/obj/item/weapon/gun/projectile/mk12
	name = "\improper MK12"
	desc = "Heavy scoped rifle."
	icon_state = "mk12_loaded"
	item_state = "mk12_loaded"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	w_class = 5
	caliber = "a556x45"
	magazine_type = /obj/item/ammo_magazine/a556x45

	accuracy = DEFAULT_BOLTACTION_ACCURACY + 1
	scoped_accuracy = DEFAULT_BOLTACTION_SCOPED_ACCURACY + 1

	can_wield = 1
	must_wield = 1
	can_scope = 1

	firemodes = list(
		list(name="single shot",	burst=1, move_delay=4, fire_delay=10, dispersion = list(0))
		)

/obj/item/weapon/gun/projectile/mk12/update_icon()
	if(ammo_magazine)
		icon_state = "mk12_loaded"
		if(wielded)
			item_state = "mk12_loaded_wielded"
		else
			item_state = "mk12_loaded"
	else
		icon_state = "mk12_empty"
		if(wielded)
			item_state = "mk12_empty_wielded"
		else
			item_state = "mk12_empty"
	update_held_icon()
	return

