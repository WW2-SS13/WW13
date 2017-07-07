/obj/item/weapon/gun/projectile/svt
	name = "SVT automatic rifle"
	desc = "Automatic Simonov rifle."
	icon_state = "svt"
	item_state = "svt"
	w_class = 4
	load_method = SPEEDLOADER | MAGAZINE
	max_shells = 0
	caliber = "a762x54"
	origin_tech = "combat=4;materials=2"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a762x54
	accuracy = -1
	magazine_type = /obj/item/ammo_magazine/svt
	firemodes = list(
		list(name="single shot",	burst=1, move_delay=4, fire_delay=10, accuracy = list(0), dispersion = list(1))
		)

/obj/item/weapon/gun/projectile/svt/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "svt"
	else
		icon_state = "svt0"
	return

/obj/item/weapon/gun/projectile/g41
	name = "Gewehr 41"
	desc = "Semi-Automatic Jew Hunter."
	icon_state = "" //to-do
	item_state = "" //to-do
	w_class = 4
	load_method = SPEEDLOADER | MAGAZINE
	max_shells = 0
	caliber = "a792x57"
	origin_tech = "combat=4;materials=2"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a792x57
	accuracy = -1
	magazine_type = /obj/item/ammo_magazine/g41
	firemodes = list(
		list(name="single shot",	burst=1, move_delay=4, fire_delay=10, accuracy = list(0), dispersion = list(1))
		)

/obj/item/weapon/gun/projectile/g41/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "" //to-do
	else
		icon_state = "" //to-do
	return
