
/***********************************
WW 2 WEAPONS MAGS N AMMO
***********************************/

/obj/item/ammo_magazine/a792x33/stgmag
	name = "Stg44 magazine"
	icon_state = "stg_mag"
	max_ammo = 30
	caliber = "a792x33"
	ammo_type = /obj/item/ammo_casing/a792x33
	multiple_sprites = FALSE

/obj/item/ammo_magazine/mosin
	name = "Clip (7.62x54mm)"
	icon_state = "clip"
	caliber = "a762x54"
	matter = list(DEFAULT_WALL_MATERIAL = 360)
	ammo_type = /obj/item/ammo_casing/a762x54
	max_ammo = 5
	multiple_sprites = TRUE

/obj/item/ammo_magazine/mosinbox
	name = "magazine box (7.62x54mm)"
	icon_state = "mosin_ammo"
//	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = "a762x54"
	w_class = 3
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a762x54
	max_ammo = 50
	multiple_sprites = TRUE
	is_box = TRUE

/obj/item/ammo_magazine/kar98k
	name = "Clip (7.92x57mm)"
	icon_state = "kclip"
	caliber = "a792x57"
	matter = list(DEFAULT_WALL_MATERIAL = 360)
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 5
	multiple_sprites = TRUE

/obj/item/ammo_magazine/kar98kbox
	name = "magazine box (7.92x57mm)"
	icon_state = "mosin_ammo"
//	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = "a792x57"
	w_class = 3
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 50
	multiple_sprites = TRUE
	is_box = TRUE

/obj/item/ammo_magazine/mp40
	name = "magazine (9mm)"
	icon_state = "mp40mag"
//	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = "a9mm_para"
	w_class = 2
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a9_parabellum
	max_ammo = 32
	multiple_sprites = TRUE

/obj/item/ammo_magazine/maxim
	name = "Maxim ammo belt"
	icon_state = "maximbelt"
//	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = "a762x54"
	w_class = 4
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a762x54
	max_ammo = 100
	multiple_sprites = TRUE
	var/slot = "decor"
	var/obj/item/clothing/under/has_suit = null		//the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.
	var/image/mob_overlay = null
	var/overlay_state = null

/obj/item/ammo_magazine/maxim/proc/get_inv_overlay()
	if(!inv_overlay)
		if(!mob_overlay)
			get_mob_overlay()

		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if("[tmp_icon_state]_tie" in icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_tie"
		inv_overlay = image(icon = mob_overlay.icon, icon_state = tmp_icon_state, dir = SOUTH)
	return inv_overlay

/obj/item/ammo_magazine/maxim/proc/get_mob_overlay()
	if(!mob_overlay)
		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if("[tmp_icon_state]_mob" in icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_mob"
			mob_overlay = image("icon" = icon_override, "icon_state" = "[tmp_icon_state]")
		else
			mob_overlay = image("icon" = INV_ACCESSORIES_DEF_ICON, "icon_state" = "[tmp_icon_state]")
	return mob_overlay

//when user attached an accessory to S
/obj/item/ammo_magazine/maxim/proc/on_attached(obj/item/clothing/under/S, mob/user as mob)
	if(!istype(S))
		return
	has_suit = S
	loc = has_suit
	has_suit.overlays += get_inv_overlay()

	user << "<span class='notice'>You attach [src] to [has_suit].</span>"
	add_fingerprint(user)

/obj/item/ammo_magazine/maxim/proc/on_removed(mob/user as mob)
	if(!has_suit)
		return
	has_suit.overlays -= get_inv_overlay()
	has_suit = null
	usr.put_in_hands(src)
	add_fingerprint(user)

/obj/item/ammo_magazine/luger
	name = "Luger magazine"
	icon_state = "lugermag"
//	origin_tech = "combat=2"
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "a9mm_para"
	ammo_type = /obj/item/ammo_casing/a9_parabellum
	max_ammo = 8
	multiple_sprites = TRUE

/***********************************
OTHER
***********************************/

/obj/item/ammo_magazine/a12mm
	name = "magazine (12mm)"
	icon_state = "12mm"
//	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = "12mm"
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	ammo_type = "/obj/item/ammo_casing/a12mm"
	max_ammo = 20
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a12mm/empty
	initial_ammo = FALSE

/obj/item/ammo_magazine/a556
	name = "PPSh Drum Magazine"
	icon_state = "ppshmag"
////	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = "a762x25"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a762x25
	max_ammo = 71
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a556/empty
	initial_ammo = FALSE

/obj/item/ammo_magazine/a556/practice
	name = "magazine (5.56mm practice)"
	ammo_type = /obj/item/ammo_casing/a556p

/obj/item/ammo_magazine/a50
	name = "magazine (.50)"
	icon_state = "50ae"
////	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = ".50"
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 7
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a50/empty
	initial_ammo = FALSE

/obj/item/ammo_magazine/a75
	name = "ammo magazine (20mm)"
	icon_state = "75"
	mag_type = MAGAZINE
	caliber = "75"
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = TRUE
	max_ammo = 4

/obj/item/ammo_magazine/a75/empty
	initial_ammo = FALSE

/obj/item/ammo_magazine/a762
	name = "Mg34 drum magazine"
	icon_state = "mg34_drum"
////	origin_tech = "combat=2"
	mag_type = MAGAZINE
	w_class = 2
	caliber = "a792x57"
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 100
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a762x39/empty
	initial_ammo = FALSE

/obj/item/ammo_magazine/a762x39
	name = "magazine box (7.62mm x 39mm)"
	icon_state = "a762"
////	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = "a762x39"
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 50
	multiple_sprites = TRUE
	is_box = TRUE

/obj/item/ammo_magazine/a762x51/empty
	initial_ammo = FALSE

/obj/item/ammo_magazine/a762x51
	name = "magazine box (7.62mm x 51mm)"
	icon_state = "a762x51"
//	origin_tech = "combat=2"
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 4500)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 50
	multiple_sprites = TRUE
	is_box = TRUE

/obj/item/ammo_magazine/a762/empty
	initial_ammo = FALSE

/obj/item/ammo_magazine/c762
	name = "magazine (7.62mm)"
	icon_state = "c762"
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 20
	multiple_sprites = TRUE

/obj/item/ammo_magazine/chameleon
	name = "magazine (.45)"
	icon_state = "45"
	mag_type = MAGAZINE
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/chameleon
	max_ammo = 7
	multiple_sprites = TRUE
	matter = list()

/obj/item/ammo_magazine/chameleon/empty
	initial_ammo = FALSE

/obj/item/ammo_magazine/a556/m4
	icon_state = "ppshmag"
	max_ammo = 81
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a762/akm
	name = "Stg magazine"
	icon_state = "stg_mag"
	caliber = "a792x33"
	ammo_type = /obj/item/ammo_casing/a792x33
	max_ammo = 30
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a762/pkm
	name = "DP ammo disk"
	icon_state = "dpdisk"
	caliber = "a762x39"
	ammo_type = /obj/item/ammo_casing/a762x39
	max_ammo = 41
	multiple_sprites = TRUE
	w_class = 2

/obj/item/ammo_magazine/a762/m240
	name = "M240 ammo"
	caliber = "a762x51"
	ammo_type = /obj/item/ammo_casing/a762x51
	max_ammo = 100
	multiple_sprites = TRUE
	w_class = 3

/obj/item/ammo_magazine/a9x39
	name = "magazine (9x39)"
	icon_state = "9x39"
	mag_type = MAGAZINE
	caliber = "a9x39"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a9x39
	max_ammo = 20
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a556x45
	name = "magazine (5.56x45)"
	icon_state = "556x45"
	mag_type = MAGAZINE
	caliber = "a556x45"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a556x45
	max_ammo = 20
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a127x108
	name = "magazine (12.7x108)"
	icon_state = "127x108"
	mag_type = MAGAZINE
	caliber = "a127x108"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a127x108
	max_ammo = 100
	multiple_sprites = FALSE

/obj/item/ammo_magazine/svt
	name = "magazine (12.7x108)"
	icon_state = "127x108"
	mag_type = MAGAZINE
	caliber = "a762x54"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a762x54
	max_ammo = 10
	multiple_sprites = FALSE

/obj/item/ammo_magazine/g41
	name = "magazine (7.92x57)"
	icon_state = "127x108"
	mag_type = MAGAZINE
	caliber = "a792x57"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a792x57
	max_ammo = 10
	multiple_sprites = FALSE

/*
//unused garbage

/obj/item/ammo_magazine/a418
	name = "ammo box (.418)"
	icon_state = "418"
	ammo_type = "/obj/item/ammo_casing/a418"
	max_ammo = 7
	multiple_sprites = TRUE

/obj/item/ammo_magazine/a666
	name = "ammo box (.666)"
	icon_state = "666"
	ammo_type = "/obj/item/ammo_casing/a666"
	max_ammo = 4
	multiple_sprites = TRUE
*/

/obj/item/ammo_magazine/a9x39
	name = "magazine (9x39)"
	icon_state = "9x39"
	mag_type = MAGAZINE
	caliber = "a9x39"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a9x39
	max_ammo = 20
	multiple_sprites = TRUE

/////////////////////FLAREGUNS//////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

/obj/item/ammo_magazine/flare
	name = "flare that shouldn't exist"
	icon_state = ""
	caliber = "flare"
	ammo_type = /obj/item/ammo_casing/flare
	multiple_sprites = FALSE
	mag_type = MAGAZINE
	initial_ammo = TRUE
	max_ammo = TRUE

/obj/item/ammo_magazine/flare/red
	name = "red flare"
	icon_state = "flare_red"

/obj/item/ammo_magazine/flare/green
	name = "green flare"
	icon_state = "flare_green"

/obj/item/ammo_magazine/flare/yellow
	name = "yellow flare"
	icon_state = "flare_yellow"
