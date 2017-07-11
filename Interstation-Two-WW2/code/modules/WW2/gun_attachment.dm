/obj/item/weapon/gun_attachment
	var/attack_sound = 'sound/weapons/slice.ogg'
	var/improper_name = ""

/obj/item/weapon/gun_attachment/bayonet
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "bayonet"
	item_state = "knife"
	flags = CONDUCT
	sharp = 1
	edge = 1
	force = WEAPON_FORCE_DANGEROUS/1.5
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	name = "bayonet"
	improper_name = "bayonet"