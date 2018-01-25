/***********************************
WW 2 WEAPONS MAGS N AMMO
***********************************/

/obj/item/ammo_casing/a145
	name = "shell casing"
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	matter = list(DEFAULT_WALL_MATERIAL = 1250)

/obj/item/ammo_magazine/ptrdbox
	name = "magazine box (PTRD ammo)"
	icon_state = "mosin_ammo"
//	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = "14.5mm"
	w_class = 3
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a145
	max_ammo = 20
	multiple_sprites = TRUE
	is_box = TRUE

/obj/item/ammo_casing/c4mm
	name = "a 4mm bullet casing"
	projectile_type = /obj/item/projectile/bullet/rifle/c4mm
	caliber = "c4mm"

/obj/item/ammo_casing/a792x33
	desc = "A 7.92x33mm bullet casing."
	caliber = "a792x33"
	projectile_type = /obj/item/projectile/bullet/rifle/a792x33

/obj/item/ammo_casing/a762x54
	desc = "A 7.62x54mm bullet casing."
	caliber = "a762x54"
	projectile_type = /obj/item/projectile/bullet/rifle/a762x54

/obj/item/ammo_casing/a792x57
	desc = "A 7.92x57mm bullet casing."
	caliber = "a792x57"
	projectile_type = /obj/item/projectile/bullet/rifle/a792x57

/obj/item/ammo_casing/a762x25
	desc = "A 7.62x25mm bullet casing."
	caliber = "a762x25"
	projectile_type = /obj/item/projectile/bullet/rifle/a762x25

/obj/item/ammo_casing/a9_parabellum
	desc = "A 9mm parabellum bullet casing."
	caliber = "a9mm_para"
	projectile_type = /obj/item/projectile/bullet/rifle/a9_parabellum

/obj/item/ammo_casing/a9_parabellum_luger
	desc = "A 9mm parabellum bullet casing."
	caliber = "a9mm_para_luger"
	projectile_type = /obj/item/projectile/bullet/rifle/a9_parabellum

/*
/obj/item/ammo_casing/svt
	desc = "A SVT bullet casing."
	caliber = "a792x33"
	projectile_type = /obj/item/projectile/bullet/rifle/a792x33
*/
/************************
		OTHER
************************/

/obj/item/ammo_casing/chameleon
	name = "chameleon bullets"
	desc = "A set of bullets for the Chameleon Gun."
	projectile_type = /obj/item/projectile/bullet/chameleon
	caliber = ".45"

/obj/item/ammo_casing/a762x39
	name = "a 7.62x39 bullet casing"
	projectile_type = /obj/item/projectile/bullet/rifle/a762x39
	caliber = "a762x39"

/obj/item/ammo_casing/a762x51
	name = "a 7.62x51 bullet casing"
	projectile_type = /obj/item/projectile/bullet/rifle/a762x51
	caliber = "a762x51"

/obj/item/ammo_casing/a556x45
	name = "a 5.56x45 bullet casing"
	projectile_type = /obj/item/projectile/bullet/rifle/a556x45
	caliber = "a556x45"

/obj/item/ammo_casing/a127x108
	name = "a 12.7x108 bullet casing"
	projectile_type = /obj/item/projectile/bullet/rifle/a127x108
	caliber = "a127x108"

/obj/item/ammo_casing/grenade
	name = "grenade"
	desc = "I hate descriptions."
	caliber = "grenade"

/obj/item/ammo_casing/grenade/he
	name = "he grenade"
	icon_state = "he_grenade"
	projectile_type = /obj/item/projectile/grenade/he
	caliber = "grenade"

/obj/item/ammo_casing/grenade/smoke
	name = "smoke grenade"
	icon_state = "smoke_grenade"
	projectile_type = /obj/item/projectile/grenade/smoke
	caliber = "grenade"

/obj/item/ammo_casing/a9x39
	desc = "a 9x39 bullet casing"
	projectile_type = /obj/item/projectile/bullet/rifle/a9x39
	caliber = "a9x39"

/**********************
		ROCKETS
**********************/

/obj/item/ammo_casing/rocket_he
	name = "a he rocket"
	desc = "High explosive rocket."
	projectile_type = /obj/item/projectile/bullet/rifle/missile/he
	caliber = "rocket"

/obj/item/ammo_casing/rocket/yuge
	projectile_type = /obj/item/projectile/bullet/rifle/missile/yuge

/obj/item/ammo_casing/rocket/tank
	projectile_type = /obj/item/projectile/bullet/rifle/missile/tank

/////////////////////FLAREGUNS//////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

/obj/item/ammo_casing/flare
	name = "flare shell"
	icon_state = ""
	projectile_type = /obj/item/projectile/flare
	caliber = "flare"