/obj/item/artillery_ammo
	icon = 'icons/WW2/artillery_ammo.dmi'
	name = "Artillery Shell"
	w_class = 5.0 // huge
	var/casing_state = "casing"

/obj/item/artillery_ammo/gaseous
	var/reagent_payload = null
	icon_state = "gc"
	casing_state = "gc-casing"

/obj/item/artillery_ammo/gaseous/green_cross
	icon_state = "gc"
	casing_state = "gc-casing"

/obj/item/artillery_ammo/gaseous/green_cross/chlorine
	reagent_payload = "chlorine_gas"
	name = "Chlorine Shell"

/obj/item/artillery_ammo/gaseous/yellow_cross
	icon_state = "yc"
	casing_state = "yc-casing"

/obj/item/artillery_ammo/gaseous/yellow_cross/mustard
	reagent_payload = "mustard_gas"
	name = "Mustard Gas Shell"

/obj/item/artillery_ammo/gaseous/yellow_cross/white_phosphorus
	reagent_payload = "white_phosphorus_gas"
	name = "White Phosphorus Shell"

/obj/item/artillery_ammo/gaseous/blue_cross
	icon_state = "bc"
	casing_state = "bc-casing"

/obj/item/artillery_ammo/gaseous/blue_cross/xylyl_bromide
	reagent_payload = "xylyl_bromide"
	name = "Xylyl Bromide Shell"


/obj/item/artillery_ammo/casing
	icon = 'icons/WW2/artillery_ammo.dmi'
	icon_state = "casing"
	name = "Artillery Shell Casing"

/obj/item/artillery_ammo/none
	name = "No Shell"
