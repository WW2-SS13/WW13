/obj/item/weapon/gun/projectile/heavysniper/ptrd
	name = "PTRD anti-tank rifle"
	desc = "A portable anti-armour rifle. Uses 14.5mm shells."
	icon_state = "ptrd"
	item_state = "l6closednomag" //placeholder
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	caliber = "14.5mm"
	recoil = 3 //extra kickback
	fire_sound = 'sound/weapons/WW2/ptrd_fire.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING | SPEEDLOADER
	max_shells = TRUE
	ammo_type = /obj/item/ammo_casing/a145
	// lower accuracy due to being so powerful; meant to fight tanks now
	accuracy = DEFAULT_PTRD_ACCURACY
	scoped_accuracy = DEFAULT_PTRD_SCOPED_ACCURACY

	gun_type = GUN_TYPE_HEAVY

/obj/item/weapon/gun/projectile/heavysniper/ptrd/german
	name = "14.5mm PaB 783"

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

	accuracy = DEFAULT_BOLTACTION_ACCURACY + TRUE
	scoped_accuracy = DEFAULT_BOLTACTION_SCOPED_ACCURACY + TRUE

	can_wield = TRUE
	must_wield = TRUE
	can_scope = TRUE

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

