/obj/item/weapon/gun/projectile/semiautomatic

	// pistol accuracy, rifle skill & decent KD chance
	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 73,
			SHORT_RANGE_MOVING = 48,

			MEDIUM_RANGE_STILL = 63,
			MEDIUM_RANGE_MOVING = 42,

			LONG_RANGE_STILL = 53,
			LONG_RANGE_MOVING = 35,

			VERY_LONG_RANGE_STILL = 43,
			VERY_LONG_RANGE_MOVING = 28),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 78,
			SHORT_RANGE_MOVING = 51,

			MEDIUM_RANGE_STILL = 68,
			MEDIUM_RANGE_MOVING = 45,

			LONG_RANGE_STILL = 58,
			LONG_RANGE_MOVING = 38,

			VERY_LONG_RANGE_STILL = 48,
			VERY_LONG_RANGE_MOVING = 32),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 83,
			SHORT_RANGE_MOVING = 55,

			MEDIUM_RANGE_STILL = 73,
			MEDIUM_RANGE_MOVING = 48,

			LONG_RANGE_STILL = 63,
			LONG_RANGE_MOVING = 42,

			VERY_LONG_RANGE_STILL = 53,
			VERY_LONG_RANGE_MOVING = 35),
	)

	accuracy_increase_mod = 2.00
	accuracy_decrease_mod = 6.00
	KD_chance = KD_CHANCE_MEDIUM
	stat = "rifle"
	load_delay = 5
	aim_miss_chance_divider = 2.50

	headshot_kill_chance = 35
	KO_chance = 30
	handle_casings = EJECT_CASINGS
	var/jamcheck = 0
	var/last_fire = -1

/obj/item/weapon/gun/projectile/semiautomatic/attack_self(mob/user)
	var/mob/living/carbon/human/H = user //Yes its shitcode fuck you.
	if (jammed)
		user.visible_message("<span class = 'notice'>\The [user] starts to unjam the \the [src].</span>")
		playsound(loc, pick("sound/items/War_UI_Inventory_Organic_Gun_Parts_1.ogg","sound/items/War_UI_Inventory_Organic_Gun_Parts_2.ogg","sound/items/War_UI_Inventory_Organic_Gun_Parts_3.ogg","sound/items/War_UI_Inventory_Organic_Gun_Parts_4.ogg","sound/items/War_UI_Inventory_Organic_Gun_Parts_5.ogg","sound/items/War_UI_Inventory_Organic_Gun_Parts_6.ogg","sound/items/War_UI_Inventory_Organic_Gun_Parts_7.ogg"), 50, TRUE, -5)
		if (do_after(user,60/(H.getStatCoeff("rifle"))))
			user << "<span class = 'danger'>With a click, the gun becomes unjammed.</span>"
			playsound(loc, "sound/items/War_UI_Inventory_Equip_Change_Weapon_Pack_4.ogg", 50, TRUE, -5)
			jammed = FALSE
		return
	if (firemodes.len > 1)
		..()
	else
		unload_ammo(user)

/obj/item/weapon/gun/projectile/semiautomatic/handle_post_fire()
	..()

	if (istype(src, /obj/item/weapon/gun/projectile/semiautomatic/stg) || istype(src, /obj/item/weapon/gun/projectile/semiautomatic/fg42))
		return

	if (world.time - last_fire > 50)
		jamcheck = 0
	else
		++jamcheck

	if (prob(jamcheck*0.5))
		jammed = TRUE
		jamcheck = 0
		//Again its different code for calculating this, fucking why

	last_fire = world.time

/obj/item/weapon/gun/projectile/semiautomatic/svt
	name = "SVT-40"
	desc = "Soviet semi-automatic rifle chambered in 7.62x54mmR. Used by some guard units and defense units."
	icon_state = "svt"
	item_state = "svt-mag"
	fire_sound = 'sound/weapons/svt40_fire.ogg'
	w_class = 4
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 10
	caliber = "a762x54"
	ammo_type = /obj/item/ammo_casing/a762x54
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	magazine_type = /obj/item/ammo_magazine/mosin
	weight = 3.85
	firemodes = list(
		list(name="single shot",burst=1, move_delay=2, fire_delay=6)
		)

	gun_type = GUN_TYPE_RIFLE
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_BARREL
	force = 10
	throwforce = 20

/obj/item/weapon/gun/projectile/semiautomatic/svt/update_icon()
	..()
	if (ammo_magazine)
		icon_state = "svt"
		item_state = "svt-mag"
	else
		icon_state = "svt"
		item_state = "svt-mag"
	return

/obj/item/weapon/gun/projectile/semiautomatic/g41
	name = "Gewehr 41"
	desc = "German semi-automatic rifle using 7.92x57mm Mauser ammunition in a 10 round magazine. Devastating rifle."
	icon_state = "g41"
	item_state = "g41"
	w_class = 4
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 10
	caliber = "a792x57"
//	origin_tech = "combat=4;materials=2"
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	ammo_type = /obj/item/ammo_casing/a792x57
	magazine_type = /obj/item/ammo_magazine/kar98k
	weight = 4.9
	firemodes = list(
		list(name="single shot",burst=1, move_delay=2, fire_delay=6)
		)
	force = 10
	throwforce = 20
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_BARREL
	effectiveness_mod = 1.05

/obj/item/weapon/gun/projectile/semiautomatic/g41/update_icon()
	..()
	if (ammo_magazine)
		icon_state = "g41"
		item_state = "g41"
	else
		icon_state = "g41"
		item_state = "g41"
	return


/obj/item/weapon/gun/projectile/semiautomatic/kbsp
	name = "KBSP wz.1938"
	desc = "Polish semi-automatic rifle using 7.92x57mm Mauser ammunition clips, in a 10 round magazine."
	icon_state = "kbsp"
	item_state = "kbsp"
	w_class = 4
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 10
	caliber = "a792x57"
//	origin_tech = "combat=4;materials=2"
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	ammo_type = /obj/item/ammo_casing/a792x57
	magazine_type = /obj/item/ammo_magazine/kar98k
	weight = 4.9
	firemodes = list(
		list(name="single shot",burst=1, move_delay=2, fire_delay=6)
		)
	force = 10
	throwforce = 20
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_BARREL
	effectiveness_mod = 1.05

/obj/item/weapon/gun/projectile/semiautomatic/kbsp/update_icon()
	..()
	if (ammo_magazine)
		icon_state = "kbsp"
		item_state = "kbsp"
	else
		icon_state = "kbsp"
		item_state = "kbsp"
	return

/obj/item/weapon/gun/projectile/semiautomatic/m1garand
	name = "M1 Garand"
	desc = "American semi-automatic rifle, standard-issue to Army units. Carries 8 30-06 rounds."
	icon_state = "M1Garand"
	item_state = "m1garand"
	w_class = 4
	load_method = MAGAZINE
	caliber = "c762x63"
//	origin_tech = "combat=4;materials=2"
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	magazine_type = /obj/item/ammo_magazine/c762x63
	ammo_type = /obj/item/ammo_casing/c762x63
	auto_eject = TRUE
	auto_eject_sound = 'sound/weapons/garand-ping.ogg'
	fire_sound = 'sound/weapons/m1garand_fire.ogg'
	weight = 4.3
	firemodes = list(
		list(name="single shot",burst=1, move_delay=2, fire_delay=6)
		)
	force = 10
	throwforce = 20
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_BARREL
	effectiveness_mod = 1.05

/obj/item/weapon/gun/projectile/semiautomatic/m1garand/update_icon()
	..()
	if (ammo_magazine)
		icon_state = "M1Garand"
		item_state = "m1garand"
	else
		icon_state = "M1Garand"
		item_state = "m1garand"
	return

/obj/item/weapon/gun/projectile/semiautomatic/fg42
	name = "FG42"
	desc = "German assault rifle with a 20 round magazine, it is chambered in 7.92x57mm. Luftwaffe's elite weapon."
	icon_state = "fg42"
	item_state = "fg42"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	w_class = 4
	caliber = "7.92x57mm"
	fire_sound = 'sound/weapons/fg42_fire.ogg'
	magazine_type = /obj/item/ammo_magazine/c792x57_fg42
	ammo_type = /obj/item/ammo_casing/c792x57_fg42
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_BARREL|ATTACH_SCOPE

	firemodes = list(
		list(name="semi automatic",	burst=1, burst_delay=0.8, recoil=0.4, move_delay=0, dispersion = list(0.2, 0.4, 0.4, 0.4, 0.6)),
		list(name="full auto",	burst=1, burst_delay=1, recoil=0.6, move_delay=0, dispersion = list(0.4, 0.6, 0.8, 1.0, 1.1)),
		)


/obj/item/weapon/gun/projectile/semiautomatic/fg42/update_icon()
	..()
	if (ammo_magazine)
		icon_state = "fg42"
		item_state = "fg42"
	else
		icon_state = "fg42"
		item_state = "fg42"
	return

/obj/item/weapon/gun/projectile/semiautomatic/bar
	name = "M1918 BAR"
	desc = "An american Light Machine Gun. Uses 30-06 rounds."
	icon_state = "bar"
	item_state = "dp0"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	w_class = 4
	caliber = "c762x63_smg"
	magazine_type = /obj/item/ammo_magazine/c762x63_smg
	ammo_type = /obj/item/ammo_casing/c762x63_smg
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_BARREL
	effectiveness_mod = 1.00
	firemodes = list(
		list(name="semi automatic",	burst=1, burst_delay=0.8, move_delay=2, dispersion = list(0.2, 0.4, 0.4, 0.4, 0.6)),
		list(name="full auto",	burst=1, burst_delay=1, recoil=1.5, move_delay=2, dispersion = list(0.4, 0.6, 0.8, 1.0, 1.1)),
		)


/obj/item/weapon/gun/projectile/semiautomatic/bar/update_icon()
	..()
	if (ammo_magazine)
		icon_state = "bar"
		item_state = "bar"
	else
		icon_state = "bar0"
		item_state = "bar0"
	return

/obj/item/weapon/gun/projectile/semiautomatic/type99
	name = "Type 99 LMG"
	desc = "A japanese Light Machine Gun. Uses 7.7x58mm arisaka rounds."
	icon_state = "type99"
	item_state = "type99"
	fire_sound = 'sound/weapons/type99_fire.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	w_class = 4
	caliber = "c77x58_smg"
	magazine_type = /obj/item/ammo_magazine/c77x58_smg
	ammo_type = /obj/item/ammo_casing/c77x58_smg
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_BARREL
	effectiveness_mod = 0.95

	firemodes = list(
		list(name="semi automatic",	burst=1, burst_delay=0.8, move_delay=2, dispersion = list(0.4, 0.6, 0.8, 1.2, 1.4)),
		list(name="full auto",	burst=1, burst_delay=1, recoil=2.5, move_delay=2, dispersion = list(0.8, 1.2, 1.4, 1.6, 1.8)),
		)


/obj/item/weapon/gun/projectile/semiautomatic/type99/update_icon()
	..()
	if (ammo_magazine)
		icon_state = "type99"
		item_state = "type99"
	else
		icon_state = "type99_empty"
		item_state = "type99_empty"
	return

/obj/item/weapon/gun/projectile/semiautomatic/stg
	name = "MP-43/B"
	desc = "German assault rifle chambered in 7.92x33mm Kurz, 30 round magazine. Variant of the STG-44, issued to SS, usually."
	icon_state = "stg"
	item_state = "stg"
	fire_sound = 'sound/weapons/stg44_fire.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK|SLOT_BELT
	w_class = 4
	caliber = "a792x33"
	fire_sound = 'sound/weapons/stg.ogg'
	load_magazine_sound = 'sound/weapons/stg_reload.ogg'
	magazine_type = /obj/item/ammo_magazine/a762/akm
	weight = 4.6

	firemodes = list(
		list(name="semi automatic",	burst=1, burst_delay=0.8, recoil=0.6, move_delay=0, dispersion = list(0.2, 0.4, 0.4, 0.4, 0.6)),
		list(name="full auto",	burst=1, burst_delay=1, recoil=0.8, move_delay=0, dispersion = list(0.4, 0.6, 0.8, 1.0, 1.1)),
			)

	sel_mode = 2

/obj/item/weapon/gun/projectile/semiautomatic/stg/update_icon()
	if (ammo_magazine)
		icon_state = "stg"
		item_state = "stg"
	else
		icon_state = "stg0"
		item_state = "stg0"
	update_held_icon()
	return
