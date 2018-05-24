/obj/item/weapon/grenade/explosive
	slot_flags = SLOT_BELT|SLOT_MASK
	throw_speed = 2

/obj/item/weapon/grenade/explosive/stgnade
	name = "Stielgranate 41"
	icon_state = "stgnade"
	explosion_size = 4
	num_fragments = 37

/obj/item/weapon/grenade/explosive/rgd
	name = "RGD-33"
	icon_state = "rgd"
	explosion_size = 4
	num_fragments = 37

/obj/item/weapon/grenade/explosive/f1
	name = "RGD-5"
	icon_state = "rgd5"
	explosion_size = 3
	num_fragments = 75

/obj/item/weapon/grenade/explosive/l2a2
	name = "l2a2 grenade"
	icon_state = "l2a2"
	explosion_size = 3
	num_fragments = 75

/obj/item/weapon/grenade/smokebomb
	slot_flags = SLOT_BELT|SLOT_MASK

/obj/item/weapon/grenade/smokebomb/german
	desc = "German smoke grenade. Won't blow up."
	name = "Smoke grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "smoke_grenade"
	det_time = 20

/obj/item/weapon/grenade/smokebomb/soviet
	desc = "Soviet smoke grenade. Won't blow up."
	name = "Smoke grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "smoke_grenade"
	det_time = 20

/obj/item/weapon/storage/box/smoke_grenades
	name = "box of smoke grenades"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/smoke_grenades/New()
	..()
	for (var/i = 0; i < 7; i++)
		new /obj/item/ammo_casing/grenade/smoke(src)