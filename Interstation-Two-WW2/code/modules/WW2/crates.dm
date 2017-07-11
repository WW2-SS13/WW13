/obj/structure/closet/crate/flammenwerfer_fueltanks
	name = "Flammenwerfer fueltanks crate"
	icon = 'icons/WW2/artillery_crate.dmi'
	icon_state = "closed"
	icon_opened = "opened"
	icon_closed = "closed"

/obj/structure/closet/crate/maximbelt
	name = "Maxim ammo crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/bint
	name = "Bint crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/gauze
	name = "Gauze crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/mosinammo
	name = "Mosin ammo crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/ppshammo
	name = "PPSh ammo crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/lugerammo
	name = "Luger ammo crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/kar98kammo
	name = "Kar98k ammo crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/mp40kammo
	name = "Mp40 ammo crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/mg34ammo
	name = "Mg34 ammo crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/mp43ammo
	name = "Mp43 ammo crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/bettymines
	name = "Betty mines crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/dpammo
	name = "DP disk crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/gernade
	name = "Stielgranate crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/panzerfaust
	name = "Panzerfaust crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/gersnade
	name = "Smoke grenade crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/sovnade
	name = "RGD crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/sandbags
	name = "Sandbags crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/flares_ammo
	name = "Flaregun Ammo crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/flares
	name = "Flares crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

/obj/structure/closet/crate/bayonets
	name = "Bayonets crate"
	icon_state = "mil_crate_closed"
	icon_opened = "mil_crate_opened"
	icon_closed = "mil_crate_closed"

//making crates populate their contents via a for loop, so it's obvious how many things are in them. Original versions in
//ww2_weapons.dm

/obj/structure/closet/crate/flammenwerfer_fueltanks/New()
	..()
	for (var/v in 1 to 10)
		new/obj/item/weapon/flammenwerfer_fueltank(src)

/obj/structure/closet/crate/maximbelt/New()
	..()
	for (var/v in 1 to 4)
		new /obj/item/ammo_magazine/maxim(src)

/obj/structure/closet/crate/mosinammo/New()
	..()
	for (var/v in 1 to 24)
		new /obj/item/ammo_magazine/mosin(src)

/obj/structure/closet/crate/kar98kammo/New()
	..()
	for (var/v in 1 to 27)
		new /obj/item/ammo_magazine/kar98k(src)

/obj/structure/closet/crate/mp40kammo/New()
	..()
	for (var/v in 1 to 24)
		new /obj/item/ammo_magazine/mp40(src)

/obj/structure/closet/crate/mp43ammo/New()
	..()
	for (var/v in 1 to 21)
		new /obj/item/ammo_magazine/a762/akm(src)

/obj/structure/closet/crate/mg34ammo/New()
	..()
	for (var/v in 1 to 13)
		new /obj/item/ammo_magazine/a762(src)

/obj/structure/closet/crate/ppshammo/New()
	..()
	for (var/v in 1 to 17)
		new /obj/item/ammo_magazine/a556/m4(src)


/obj/structure/closet/crate/lugerammo/New()
	..()
	for (var/v in 1 to 15)
		new /obj/item/ammo_magazine/luger(src)


/obj/structure/closet/crate/bettymines/New()
	..()
	for (var/v in 1 to 20)
		new /obj/item/device/mine/betty(src)

/obj/structure/closet/crate/dpammo/New()
	..()
	for (var/v in 1 to 15)
		new /obj/item/ammo_magazine/a762/pkm(src)

/obj/structure/closet/crate/bint/New()
	..()
	for (var/v in 1 to 18)
		new /obj/item/weapon/gauze_pack/bint(src)


/obj/structure/closet/crate/gauze/New()
	..()
	for (var/v in 1 to 17)
		new /obj/item/weapon/gauze_pack/gauze(src)

/obj/structure/closet/crate/sovnade/New()
	..()
	for (var/v in 10 to 24)
		new /obj/item/weapon/grenade/explosive/rgd(src)

/obj/structure/closet/crate/gernade/New()
	..()
	for (var/v in 1 to 24)
		new /obj/item/weapon/grenade/explosive/stgnade(src)

/obj/structure/closet/crate/panzerfaust/New()
	..()
	for (var/v in 1 to 24)
		new /obj/item/weapon/gun/launcher/rocket/panzerfaust(src)


/obj/structure/closet/crate/gersnade/New()
	..()
	for (var/v in 1 to 10)
		new /obj/item/weapon/grenade/smokebomb/gernade(src)


/obj/structure/closet/crate/sandbags/New()
	..()
	// more than tripled this to 100 bags, experimental. Didn't seem like Germans had enough to make a decent FOB
	// now this is 66 because 100 seemed like way too many
	for (var/v in 1 to 66) // this was 24, I made it 30, meaning you can make 5 sandbag walls per crate, as each takes 6 right now
		new /obj/item/weapon/sandbag(src)

/obj/structure/closet/crate/flares_ammo/New()
	..()

	for (var/v in 1 to 10)
		new /obj/item/ammo_magazine/flare/red(src)
		new /obj/item/ammo_magazine/flare/green(src)
		new /obj/item/ammo_magazine/flare/yellow(src)

/obj/structure/closet/crate/flares/New()
	..()

	for (var/v in 1 to 50)
		new /obj/item/device/flashlight/flare(src)

/obj/structure/closet/crate/bayonets/New()
	..()

	for (var/v in 1 to 20)
		new /obj/item/weapon/gun_attachment/bayonet(src)

//arty

/obj/structure/closet/crate/artillery
	name = "German artillery shell crate"
	icon = 'icons/WW2/artillery_crate.dmi'
	icon_state = "closed"
	icon_opened = "opened"
	icon_closed = "closed"

	New()
		..()
		for (var/v in 1 to 20)
			new/obj/item/artillery_ammo(src)
		for (var/v in 1 to 3)
			new/obj/item/artillery_ammo/gaseous/green_cross/chlorine(src)
		for (var/v in 1 to 2)
			new/obj/item/artillery_ammo/gaseous/yellow_cross/mustard(src)
			new/obj/item/artillery_ammo/gaseous/yellow_cross/white_phosphorus(src)
		for (var/v in 1 to 4)
			new/obj/item/artillery_ammo/gaseous/blue_cross/xylyl_bromide(src)

/obj/structure/closet/crate/gasmasks
	name = "Gasmask crate"
	icon = 'icons/WW2/artillery_crate.dmi'
	icon_state = "closed"
	icon_opened = "opened"
	icon_closed = "closed"

	New()
		..()
		for (var/v in 1 to 10)
			new/obj/item/clothing/mask/gas/german(src)

/obj/structure/closet/crate/artillery/russian
	name = "Russian artillery shell crate"

	New()
		..()
		for (var/v in 1 to 20)
			new/obj/item/artillery_ammo(src)

		for (var/v in 1 to 2)
			new/obj/item/artillery_ammo/gaseous/green_cross/chlorine(src)

		for (var/v in 1 to 6)
			new/obj/item/artillery_ammo/gaseous/blue_cross/xylyl_bromide(src)

		new/obj/item/artillery_ammo/gaseous/yellow_cross/mustard(src)
		new/obj/item/artillery_ammo/gaseous/yellow_cross/white_phosphorus(src)