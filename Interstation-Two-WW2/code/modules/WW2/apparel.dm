/obj/item/clothing/under/sovuni
	name = "Soviet uniform"
	desc = "Standart soviet uniform for soildiers. You can smell german virgin's blood on it."
	icon_state = "sovuni"
	item_state = "sovuni"
	worn_state = "sovuni"

/obj/item/clothing/under/geruni
	name = "German uniform"
	desc = "Standart german uniform for soildiers. You can smell seiner madchenes parfume!"
	icon_state = "geruni"
	item_state = "geruni"
	worn_state = "geruni"
	var/rolled = 0

/obj/item/clothing/under/geruni/verb/roll_sleeves()
	set category = null
	set src in usr
	if (rolled)
		item_state = "geruni"
		worn_state = "geruni"
		item_state_slots["slot_w_uniform"] = "geruni"
		usr << "<span class = 'danger'>You roll down your uniform's sleeves.</span>"
		rolled = 0
	else if (!rolled)
		item_state = "gerunirolledup"
		worn_state = "gerunirolledup"
		item_state_slots["slot_w_uniform"] = "gerunirolledup"
		usr << "<span class = 'danger'>You roll up your uniform's sleeves.</span>"
		rolled = 1
	update_clothing_icon()

/obj/item/clothing/under/falluni
	name = "Fallschirmjager uniform"
	desc = "Standart german uniform for fallschirmjagers. This is quite comfy and sturdy uniform."
	icon_state = "falluni"
	item_state = "falluni"
	worn_state = "falluni"

/obj/item/clothing/suit/fallsparka
	name = "Fallschirmjager Parka"
	desc = "A warm and comfy parka for fallschirmjagers."
	icon_state = "fallsparka"
	item_state = "fallsparka"
	worn_state = "fallsparka"

/obj/item/clothing/suit/sssmock
	name = "S.S. Smock"
	desc = "A camo S.S. overcoat."
	icon_state = "sssmock"
	item_state = "sssmock"
	worn_state = "sssmock"


/obj/item/clothing/under/ssuni
	name = "SS uniform"
	desc = "Camo uniform for ShutzStaffel soldiers. Sturdy, comfy, and makes you less visible in autumn. They gave you this too early by the way."
	icon_state = "newssuni"
	item_state = "newssuni"
	worn_state = "newssuni"

/obj/item/clothing/head/helmet/tactical/gerhelm
	name = "German helmet"
	icon_state = "gerhelm"
	item_state = "gerhelm"

/obj/item/clothing/head/helmet/tactical/sshelm
	name = "SS camo helmet"
	icon_state = "sshelm"
	item_state = "sshelm"

/obj/item/clothing/head/helmet/tactical/sovhelm
	name = "Soviet helmet"
	icon_state = "sovhelm"
	item_state = "sovhelm"


//WIP, need icons - Kachnov
/obj/item/clothing/suit/armor/flammenwerfer
	name = "fireproof flammenwerfer vest"
	icon_state = "cn42"
	armor = list(melee = 30, bullet = 60, laser = 10, energy = 10, bomb = 15, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/bulletproof/cn42
	name = "CN-42 bulletproof vest"
	desc = "A heavy vest used by soviet shock troops"
	icon_state = "cn42"
	armor = list(melee = 30, bullet = 60, laser = 10, energy = 10, bomb = 15, bio = 0, rad = 0)

/obj/item/weapon/storage/belt/german
	name = "German belt pouch"
	desc = "Can hold gear like pistol, ammo and other thingies."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 6
	max_w_class = 3
	max_storage_space = 28
	can_hold = list(
		/obj/item/ammo_magazine/a792x33/stgmag,
		/obj/item/ammo_magazine/kar98k,
		/obj/item/ammo_magazine/mp40,
		/obj/item/weapon/material/knife,
		/obj/item/weapon/gauze_pack/gauze,
		/obj/item/weapon/grenade/explosive/stgnade,
		/obj/item/weapon/gun/projectile/pistol/luger,
		/obj/item/ammo_magazine/luger
		)

/obj/item/weapon/storage/belt/german/fallofficer
	name = "German belt"
	desc = "Can hold gear like pistol, ammo and other thingies."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 6
	max_w_class = 3
	max_storage_space = 20

/obj/item/weapon/storage/belt/german/fallofficer/New()
	..()
	new /obj/item/ammo_magazine/mp40(src)
	new /obj/item/ammo_magazine/mp40(src)
	new /obj/item/ammo_magazine/mp40(src)
	new /obj/item/weapon/gauze_pack/gauze(src)
	new /obj/item/weapon/grenade/explosive/stgnade(src)
	new /obj/item/weapon/grenade/explosive/stgnade(src)

/obj/item/weapon/storage/belt/german/fallsoldier
	name = "German belt"
	desc = "Can hold gear like pistol, ammo and other thingies."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 6
	max_w_class = 3
	max_storage_space = 20

/obj/item/weapon/storage/belt/german/fallsoldier/New()
	..()
	new /obj/item/ammo_magazine/kar98k(src)
	new /obj/item/ammo_magazine/kar98k(src)
	new /obj/item/ammo_magazine/kar98k(src)
	new /obj/item/ammo_magazine/kar98k(src)
	new /obj/item/weapon/gauze_pack/gauze(src)
	new /obj/item/weapon/grenade/explosive/stgnade(src)