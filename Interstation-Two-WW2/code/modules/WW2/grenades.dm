
/obj/item/weapon/storage/box/he_grenades
	name = "box of he grenades"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/he_grenades/New()
	..()
	for(var/i = FALSE; i < 7; i++)
		new /obj/item/ammo_casing/grenade/he(src)

/obj/item/weapon/storage/box/smoke_grenades
	name = "box of smoke grenades"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/smoke_grenades/New()
	..()
	for(var/i = FALSE; i < 7; i++)
		new /obj/item/ammo_casing/grenade/smoke(src)
