/obj/item/weapon/gun/projectile/boltaction
	recoil = 2
	gun_type = GUN_TYPE_RIFLE
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_SCOPE|ATTACH_BARREL
	var/next_reload = -1

	// 5x as accurate as MGs for now
	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 90,
			SHORT_RANGE_MOVING = 45,

			MEDIUM_RANGE_STILL = 80,
			MEDIUM_RANGE_MOVING = 40,

			LONG_RANGE_STILL = 70,
			LONG_RANGE_MOVING = 35,

			VERY_LONG_RANGE_STILL = 60,
			VERY_LONG_RANGE_MOVING = 30),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 95,
			SHORT_RANGE_MOVING = 48,

			MEDIUM_RANGE_STILL = 85,
			MEDIUM_RANGE_MOVING = 43,

			LONG_RANGE_STILL = 75,
			LONG_RANGE_MOVING = 38,

			VERY_LONG_RANGE_STILL = 65,
			VERY_LONG_RANGE_MOVING = 33),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 100,
			SHORT_RANGE_MOVING = 50,

			MEDIUM_RANGE_STILL = 90,
			MEDIUM_RANGE_MOVING = 45,

			LONG_RANGE_STILL = 80,
			LONG_RANGE_MOVING = 40,

			VERY_LONG_RANGE_STILL = 70,
			VERY_LONG_RANGE_MOVING = 35),
	)

	accuracy_increase_mod = 1.10
	accuracy_decrease_mod = 1.20
	KD_chance = 50
	stat = "rifle"

	var/jammed_until = -1

/obj/item/weapon/gun/projectile/boltaction/handle_post_fire()
	..()
	if (prob(7))
		jammed_until = world.time + rand(50,100)


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

/obj/item/weapon/gun/projectile/boltaction/carcano
	name = "Carcano M1891"
	desc = "Italian made bolt action rifle Carcano Modello 1891. It smells of tomato pasta and gunpowder."
	icon_state = "carcano"
	item_state = "carcano"
	caliber = "6.5x52mm"
	fire_sound = 'sound/weapons/kar_shot.ogg'
	ammo_type = /obj/item/ammo_casing/c65x52mm
	magazine_type = /obj/item/ammo_magazine/c65x52mm
	max_shells = 6
	accuracy = DEFAULT_BOLTACTION_ACCURACY + 1
	scoped_accuracy = DEFAULT_BOLTACTION_SCOPED_ACCURACY
	bolt_safety = FALSE

/obj/item/weapon/gun/projectile/boltaction/carcano/update_icon(var/add_scope = FALSE)
	if(add_scope)
		if(bolt_open)
			icon_state = "carcano_scope_open"
			item_state = "carcano"
			return
		else
			icon_state = "carcano_scope"
			item_state = "carcano"
			return
	if(bolt_open)
		if(!findtext(icon_state, "_open"))
			icon_state = addtext(icon_state, "_open") //open
	else if(icon_state == "carcano_scope_open") //closed
		icon_state = "carcano_scope"
	else if(icon_state == "carcano_scope")
		return
	else
		icon_state = "carcano"

