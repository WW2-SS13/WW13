/obj/item/weapon/gun/projectile/boltaction
	recoil = 2
	gun_type = GUN_TYPE_RIFLE

/obj/item/weapon/gun/projectile/boltaction/mosin
	name = "Mosin-Nagant"
	desc = "Soviet bolt-action rifle chambered in 7.62x54mmR cartridges. It looks worn and has Katyusha on the butt."
	force = 12
//	origin_tech = "combat=4;materials=2;syndicate=8"
	fire_sound = 'sound/weapons/mosin_shot.ogg'
	caliber = "a762x54"
	//+2 accuracy over the LWAP because only one shot
	accuracy = DEFAULT_BOLTACTION_ACCURACY
	scoped_accuracy = DEFAULT_BOLTACTION_SCOPED_ACCURACY
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_SCOPE|ATTACH_BARREL

//This should only be temporary until more attachment icons are made, then we switch to adding/removing icon masks
/obj/item/weapon/gun/projectile/boltaction/mosin/update_icon(var/add_scope = FALSE)
	if(add_scope)
		if(bolt_open)
			icon_state = "mosin_scope_open"
			item_state = "mosin_scope"
			return
		else
			icon_state = "mosin_scope"
			item_state = "mosin_scope"
			return
	if(bolt_open)
		if(!findtext(icon_state, "_open"))
			icon_state = addtext(icon_state, "_open") //open
	else if(icon_state == "mosin_scope_open") //closed
		icon_state = "mosin_scope"
	else if(icon_state == "mosin_scope")
		return
	else
		icon_state = "mosin"

/obj/item/weapon/gun/projectile/boltaction/kar98k
	name = "Kar-98K"
	desc = "German bolt-action rifle chambered in 7.92x57mm Mauser ammunition. It looks clean and well-fabricated."
	icon_state = "kar98k"
	item_state = "kar98k"
	caliber = "a792x57"
	fire_sound = 'sound/weapons/kar_shot.ogg'
	ammo_type = /obj/item/ammo_casing/a792x57
	magazine_type = /obj/item/ammo_magazine/kar98k
	//+2 accuracy over the LWAP because only one shot
	accuracy = DEFAULT_BOLTACTION_ACCURACY
	scoped_accuracy = DEFAULT_BOLTACTION_SCOPED_ACCURACY
	bolt_safety = TRUE
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_SCOPE|ATTACH_BARREL

//This should only be temporary until more attachment icons are made, then we switch to adding/removing icon masks
/obj/item/weapon/gun/projectile/boltaction/kar98k/update_icon(var/add_scope = FALSE)
	if(add_scope)
		if(bolt_open)
			icon_state = "kar98k_scope_open"
			item_state = "kar98k_scope"
			return
		else
			icon_state = "kar98k_scope"
			item_state = "kar98k_scope"
			return
	if(bolt_open)
		if(!findtext(icon_state, "_open"))
			icon_state = addtext(icon_state, "_open") //open
	else if(icon_state == "kar98k_scope_open") //closed
		icon_state = "kar98k_scope"
	else if(icon_state == "kar98k_scope")
		return
	else
		icon_state = "kar98k"
