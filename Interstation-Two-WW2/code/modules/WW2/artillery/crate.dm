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