/obj/item/weapon/gun/projectile/boltaction
	recoil = 2

/obj/item/weapon/gun/projectile/boltaction/mosin
	name = "Mosin-Nagant rifle"
	desc = "A bolt-action rifle of true LIBERATORS."
	force = 12
	origin_tech = "combat=4;materials=2;syndicate=8"
	fire_sound = 'sound/weapons/mosin_shot.ogg'
	caliber = "a762x54"
	//+2 accuracy over the LWAP because only one shot
	accuracy = 2
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_SCOPE|ATTACH_BARREL

//This should only be temporary until more attachment icons are made, then we switch to adding/removing icon masks
/obj/item/weapon/gun/projectile/boltaction/mosin/update_icon(var/add_scope = 0)
	if(add_scope)
		if(bolt_open)
			icon_state = "mosin_scope_open"
			item_state = "mosin_scope_open"
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
	name = "Kar98k rifle"
	desc = "A bolt-action rifle of true ARYAN."
	icon_state = "kar98k"
	item_state = "kar98k" //placeholder
	caliber = "a792x57"
	fire_sound = 'sound/weapons/kar_shot.ogg'
	ammo_type = /obj/item/ammo_casing/a792x57
	magazine_type = /obj/item/ammo_magazine/kar98k
	//+2 accuracy over the LWAP because only one shot
	accuracy = 2
	scoped_accuracy = 4
	bolt_safety = 1
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_SCOPE|ATTACH_BARREL

//This should only be temporary until more attachment icons are made, then we switch to adding/removing icon masks
/obj/item/weapon/gun/projectile/boltaction/kar98k/update_icon(var/add_scope = 0)
	if(add_scope)
		if(bolt_open)
			icon_state = "kar98k_scope_open"
			item_state = "kar98k_scope_open"
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
