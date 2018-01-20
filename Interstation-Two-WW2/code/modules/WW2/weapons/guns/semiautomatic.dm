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
	attachment_slots = ATTACH_IRONSIGHTS|ATTACH_BARREL

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

/obj/item/weapon/gun/projectile/g41/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "" //to-do
	else
		icon_state = "" //to-do
	return
