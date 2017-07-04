
/obj/item/weapon/storage/box/he_grenades
	name = "box of he grenades"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/he_grenades/New()
	..()
	for(var/i = 0; i < 7; i++)
		new /obj/item/ammo_casing/grenade/he(src)

/obj/item/weapon/storage/box/smoke_grenades
	name = "box of smoke grenades"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/smoke_grenades/New()
	..()
	for(var/i = 0; i < 7; i++)
		new /obj/item/ammo_casing/grenade/smoke(src)

/obj/item/weapon/grenade/explosive/f1
	name = "RGD-5"
	icon_state = "rgd5"
	throw_speed = 1

/obj/item/weapon/grenade/explosive/l2a2
	name = "l2a2 grenade"
	icon_state = "l2a2"
	throw_speed = 1