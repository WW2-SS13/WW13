/obj/item/weapon/gun/projectile/boltaction
	recoil = 2

/obj/item/weapon/gun/projectile/boltaction/mosin
	name = "Mosin-Nagant rifle"
	desc = "A bolt-action rifle of true LIBERATORS."
	icon_state = "mosin"
	item_state = "mosin" //placeholder
	w_class = 4
	force = 12
	max_shells = 5
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2;syndicate=8"
	caliber = "a762x54"
	fire_sound = 'sound/weapons/mosin_shot.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING | SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a762x54
	magazine_type = /obj/item/ammo_magazine/mosin
	//+2 accuracy over the LWAP because only one shot
	accuracy = 1
	scoped_accuracy = 2

/obj/item/weapon/gun/projectile/boltaction/mosin/update_icon()
	if(bolt_open)
		icon_state = "mosin_open" //open
	else
		icon_state = "mosin" //closed



/obj/item/weapon/gun/projectile/boltaction/mosin_scope
	name = "Mosin-Nagant scoped rifle"
	desc = "A bolt-action rifle of true LIBERATORS."
	icon_state = "mosin_scope"
	item_state = "mosin_scope" //placeholder
	w_class = 4
	force = 12
	max_shells = 5
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2;syndicate=8"
	caliber = "a762x54"
	fire_sound = 'sound/weapons/mosin_shot.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING | SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a762x54
	magazine_type = /obj/item/ammo_magazine/mosin
	//+2 accuracy over the LWAP because only one shot
	accuracy = 1
	scoped_accuracy = 2



/obj/item/weapon/gun/projectile/boltaction/mosin_scope/update_icon()
	if(bolt_open)
		icon_state = "mosin_scope_open" //open
	else
		icon_state = "mosin_scope" //closed

/obj/item/weapon/gun/projectile/boltaction/mosin_scope/verb/m_sniper_scope()
	set category = "Weapons"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

/obj/item/weapon/gun/projectile/boltaction/kar98k
	name = "Kar98k rifle"
	desc = "A bolt-action rifle of true ARYAN."
	icon_state = "kar98k"
	item_state = "kar98k" //placeholder
	w_class = 4
	force = 10
	max_shells = 5
	slot_flags = SLOT_BACK
	origin_tech = "combat=5;materials=2;syndicate=8"
	caliber = "a792x57"
	fire_sound = 'sound/weapons/kar_shot.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING | SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a792x57
	magazine_type = /obj/item/ammo_magazine/kar98k
	//+2 accuracy over the LWAP because only one shot
	accuracy = 2
	scoped_accuracy = 4

/obj/item/weapon/gun/projectile/boltaction/kar98k/update_icon()

	if(bolt_open)
		icon_state = "kar98k_open" //open
	else
		icon_state = "kar98k" //closed



/obj/item/weapon/gun/projectile/boltaction/kar98k_scope
	name = "Kar98k scoped rifle"
	desc = "A bolt-action rifle of true ARYAN."
	icon_state = "kar98k_scope"
	item_state = "kar98k_scope" //placeholder
	w_class = 4
	force = 10
	max_shells = 5
	slot_flags = SLOT_BACK
	origin_tech = "combat=5;materials=2;syndicate=8"
	caliber = "a792x57"
	fire_sound = 'sound/weapons/kar_shot.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING | SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a792x57
	magazine_type = /obj/item/ammo_magazine/kar98k
	//+2 accuracy over the LWAP because only one shot
	accuracy = 2
	scoped_accuracy = 5

/obj/item/weapon/gun/projectile/boltaction/kar98k_scope/update_icon()
	if(bolt_open)
		icon_state = "kar98k_scope_open" //open
	else
		icon_state = "kar98k_scope" //closed



/obj/item/weapon/gun/projectile/boltaction/kar98k_scope/verb/k_sniper_scope()
	set category = "Weapons"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.2)