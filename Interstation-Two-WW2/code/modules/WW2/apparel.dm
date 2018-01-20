/* Uniform Metadata: Soviet, German, Ukrainian, Italian */

#define SOVIET_UNIFORM_NAME "Soviet uniform"
#define SOVIET_UNIFORM_DESC "Standard issue Soviet uniform issued to soldiers of the Red Army. You can smell Vodka and see faint borsch stains."
#define SOVIET_UNIFORM_STATE "sovuni"

#define GERMAN_UNIFORM_NAME "German uniform"
#define GERMAN_UNIFORM_DESC "Standard issue German uniform issued to soldiers of the Wehrmacht. It looks sturdy and strictly folded."
#define GERMAN_UNIFORM_STATE "geruni"

#define UKRAINE_UNIFORM_NAME "Ukrainian uniform"
#define UKRAINE_UNIFORM_DESC "Standard issue Ukrainian uniform issued to foreign soldiers of the Red Army. You can smell Vodka and see faint borsch stains."
#define UKRAINE_UNIFORM_STATE "ukraineuni"

#define ITALIAN_UNIFORM_NAME "Italian uniform"
#define ITALIAN_UNIFORM_DESC "Standard issue Italian uniform issued to foreign soldiers of the Wehrmacht."
#define ITALIAN_UNIFORM_STATE "ukraineuni"

/* Helmet Metadata: Soviet, German, Ukrainian, Italian */

#define SOVIET_HELMET_NAME "Soviet helmet"
#define SOVIET_HELMET_DESC "Standard issue helmet of the Red Army. Provides some protection against both the elements and flying bullets."
#define SOVIET_HELMET_STATE "sovhelm"

#define GERMAN_HELMET_NAME "German helmet"
#define GERMAN_HELMET_DESC "Standard issue helmet of the Wehrmacht. Provides some protection against both the elements and flying bullets."
#define GERMAN_HELMET_STATE "gerhelm"

#define UKRAINE_HELMET_NAME "Soviet helmet"
#define UKRAINE_HELMET_DESC "Standard issue helmet of the Red Army. Provides some protection against both the elements and flying bullets."
#define UKRAINE_HELMET_STATE "sovhelm"

/obj/item/clothing/under
	var/swapped = FALSE

/obj/item/clothing/under/proc/add_alternative_setting()
	verbs += /obj/item/clothing/under/proc/Swap

/obj/item/clothing/under/proc/Swap()
	set category = "Object"
	var/mob/living/carbon/human/m = loc
	if (m && istype(m) && m.is_spy)

		if (name == GERMAN_UNIFORM_NAME)
			transform2soviet()
		else if (name == SOVIET_UNIFORM_NAME)
			transform2german()

		if (istype(src, /obj/item/clothing/under/geruni))
			switch (name)
				if (SOVIET_UNIFORM_NAME)
					m << "<span class = 'danger'>You change back into your original uniform. Long live mother Russia!</span>"
				if (GERMAN_UNIFORM_NAME)
					m << "<span class = 'danger'>You change back into your spy uniform.</span>"
		else if (istype(src, /obj/item/clothing/under/sovuni))
			if (GERMAN_UNIFORM_NAME)
				m << "<span class = 'danger'>You change back into your original uniform. Sieg heil!</span>"
			if (SOVIET_UNIFORM_NAME)
				m << "<span class = 'danger'>You change back into your spy uniform.</span>"

	return FALSE

/obj/item/clothing/under/proc/transform2soviet()

	name = SOVIET_UNIFORM_NAME
	desc = SOVIET_UNIFORM_DESC
	icon_state = SOVIET_UNIFORM_STATE
	item_state = SOVIET_UNIFORM_STATE
	worn_state = SOVIET_UNIFORM_STATE
	item_state_slots["slot_w_uniform"] = SOVIET_UNIFORM_STATE
	update_clothing_icon()

	var/mob/living/carbon/human/H = loc
	if (istype(H.s_store, /obj/item/device/radio/feldfu))
		var/radio = H.s_store
		H.drop_from_inventory(radio)
		qdel(radio)
		H.equip_to_slot_or_del(new /obj/item/device/radio/rbs(H), slot_s_store)
	if (istype(H.head, /obj/item/clothing/head/helmet/tactical/gerhelm))
		var/obj/item/clothing/head/helmet/tactical/gerhelm/head = H.head
		head.transform2soviet()

/obj/item/clothing/under/proc/transform2german()

	name = GERMAN_UNIFORM_NAME
	desc = GERMAN_UNIFORM_DESC
	icon_state = GERMAN_UNIFORM_STATE
	item_state = GERMAN_UNIFORM_STATE
	worn_state = GERMAN_UNIFORM_STATE
	item_state_slots["slot_w_uniform"] = GERMAN_UNIFORM_STATE
	update_clothing_icon()

	var/mob/living/carbon/human/H = loc
	if (istype(H.s_store, /obj/item/device/radio/rbs))
		var/radio = H.s_store
		H.drop_from_inventory(radio)
		qdel(radio)
		H.equip_to_slot_or_del(new /obj/item/device/radio/feldfu(H), slot_s_store)
	if (istype(H.head, /obj/item/clothing/head/helmet/tactical/sovhelm))
		var/obj/item/clothing/head/helmet/tactical/sovhelm/head = H.head
		head.transform2german()

/obj/item/clothing/under/sovuni
	name = SOVIET_UNIFORM_NAME
	desc = SOVIET_UNIFORM_DESC
	icon_state = SOVIET_UNIFORM_STATE
	item_state = SOVIET_UNIFORM_STATE
	worn_state = SOVIET_UNIFORM_STATE

/obj/item/clothing/under/sovuni/officer
	name = "soviet officer's uniform"
	desc = "A fancier, more pressed uniform of the Red Army, given to Soviet officers. It has a feel of pride and authority."
	icon_state = "sovuniofficer"
	item_state = "sovuniofficer"
	worn_state = "sovuniofficer"

/obj/item/clothing/under/sovuni/MP
	name = "soviet MP's uniform"
	desc = "A fancier, more pressed uniform of the Red Army, given to Soviet military police."
	icon_state = "sovuni_MP"
	item_state = "sovuni_MP"
	worn_state = "sovuni_MP"


/obj/item/clothing/under/geruni
	name = GERMAN_UNIFORM_NAME
	desc = GERMAN_UNIFORM_DESC
	icon_state = GERMAN_UNIFORM_STATE
	item_state = GERMAN_UNIFORM_STATE
	worn_state = GERMAN_UNIFORM_STATE
	var/rolled = FALSE

/obj/item/clothing/under/geruni/gerofficer
	name = "german officer's uniform"
	desc = "A fancier, more pressed uniform of the Nazi Army, given to German officers. It has a feel of pride and authority."
	icon_state = "falluni"
	item_state = "geruniofficer"
	worn_state = "geruniofficer"

/obj/item/clothing/under/geruni/MP
	name = "german MP's uniform"
	desc = "A fancier, more pressed uniform of the Nazi Army, given to German military police."
	icon_state = "geruni_MP"
	item_state = "geruni_MP"
	worn_state = "geruni_MP"

/obj/item/clothing/under/geruni/verb/roll_sleeves()
	set category = null
	set src in usr
	if (rolled)
		item_state = "geruni"
		worn_state = "geruni"
		item_state_slots["slot_w_uniform"] = "geruni"
		usr << "<span class = 'danger'>You roll down your uniform's sleeves.</span>"
		rolled = FALSE
	else if (!rolled)
		item_state = "gerunirolledup"
		worn_state = "gerunirolledup"
		item_state_slots["slot_w_uniform"] = "gerunirolledup"
		usr << "<span class = 'danger'>You roll up your uniform's sleeves.</span>"
		rolled = TRUE
	update_clothing_icon()

/obj/item/clothing/under/geruni/falluni
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
	allowed = list(/obj/item/device/radio/rbs,/obj/item/device/radio/feldfu,/obj/item/device/radio/partisan)


/obj/item/clothing/suit/sssmock
	name = "S.S. Smock"
	desc = "A camo S.S. overcoat that blends in well in the fall."
	icon_state = "sssmock"
	item_state = "sssmock"
	worn_state = "sssmock"
	allowed = list(/obj/item/device/radio/rbs,/obj/item/device/radio/feldfu,/obj/item/device/radio/partisan)


/obj/item/clothing/under/geruni/ssuni
	name = "SS uniform"
	desc = "Camo uniform for ShutzStaffel soldiers. Sturdy, comfy, and makes you less visible in autumn. They gave you this too early by the way."
	icon_state = "newssuni"
	item_state = "newssuni"
	worn_state = "newssuni"

/obj/item/clothing/under/geruni/ssformalofc
	name = "SS Officer's Formal Uniform"
	desc = "Jet black formal uniform. Swastika armband included."
	icon_state = "ss_formal_ofc"
	item_state = "ss_formal_ofc"
	worn_state = "ss_formal_ofc"

/obj/item/clothing/under/geruni/gertankeruni
	name = "Panzer Crewman Uniform"
	desc = "Dark gray jumpsuit with a brown belt. It has an insignia declaring the wearer as a tank crewman."
	icon_state = "gertankeruni"
	item_state = "gertankeruni"
	worn_state = "gertankeruni"

/obj/item/clothing/under/sovuni/sovtankeruni
	name = "Soviet Crewman Uniform"
	desc = "Dark blue jumpsuit with a brown belt and bandolier."
	icon_state = "sovtankeruni"
	item_state = "sovtankeruni"
	worn_state = "sovtankeruni"

/obj/item/clothing/head/helmet/tactical/gerhelm
	name = GERMAN_HELMET_NAME
	desc = GERMAN_HELMET_DESC
	icon_state = GERMAN_HELMET_STATE
	item_state = GERMAN_HELMET_STATE

/obj/item/clothing/head/helmet/tactical/gerhelm/proc/transform2soviet()
	name = SOVIET_HELMET_NAME
	desc = SOVIET_HELMET_DESC
	icon_state = SOVIET_HELMET_STATE
	item_state = SOVIET_HELMET_STATE
	worn_state = SOVIET_HELMET_STATE
	item_state_slots["slot_head"] = SOVIET_HELMET_STATE
	update_clothing_icon()

/obj/item/clothing/head/helmet/tactical/gerhelm/sshelm
	name = "SS camo helmet"
	desc =  "A metal helmet issued to SS soldiers, that is camouflaged for autumn operations. A bit early for it, ja?"
	icon_state = "sshelm"
	item_state = "sshelm"

/obj/item/clothing/head/helmet/tactical/gerhelm/MP
	name = "German MP helmet"
	desc =  "A metal helmet issued to German military police."
	icon_state = "gerhelm_MP"
	item_state = "gerhelm_MP"

/obj/item/clothing/head/helmet/tactical/gerhelm/medic
	name = "German medic helmet"
	desc =  "A metal helmet issued to German combat medics."
	icon_state = "gerhelm_CM"
	item_state = "gerhelm_CM"

/obj/item/clothing/head/helmet/tactical/sovhelm
	name = SOVIET_HELMET_NAME
	desc = SOVIET_HELMET_DESC
	icon_state = SOVIET_HELMET_STATE
	item_state = SOVIET_HELMET_STATE

/obj/item/clothing/head/helmet/tactical/sovhelm/proc/transform2german()
	name = GERMAN_HELMET_NAME
	desc = GERMAN_HELMET_DESC
	icon_state = GERMAN_HELMET_STATE
	item_state = GERMAN_HELMET_STATE
	worn_state = GERMAN_HELMET_STATE
	item_state_slots["slot_head"] = GERMAN_HELMET_STATE
	update_clothing_icon()

/obj/item/clothing/head/helmet/tactical/sovhelm/MP
	name = "Soviet MP helmet"
	desc =  "A metal helmet issued to Soviet military police."
	icon_state = "sovhelm_MP"
	item_state = "sovhelm_MP"

/obj/item/clothing/head/helmet/tactical/sovhelm/medic
	name = "Soviet medic helmet"
	desc =  "A metal helmet issued to Soviet combat medics."
	icon_state = "sovhelm_CM"
	item_state = "sovhelm_CM"

/obj/item/clothing/suit/armor/bulletproof/cn42
	name = "CN-42 bulletproof vest"
	desc = "A heavy vest used by Soviet shock troops."
	icon_state = "cn42"
	armor = list(melee = 30, bullet = 60, laser = 10, energy = 10, bomb = 15, bio = FALSE, rad = FALSE)
	allowed = list(/obj/item/device/radio/rbs,/obj/item/device/radio/feldfu,/obj/item/device/radio/partisan)

/obj/item/weapon/storage/belt/soviet
	name = "Soviet belt pouch"
	desc = "Can hold gear like pistol, ammo and other thingies."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 6
	max_w_class = 3
	max_storage_space = 28
	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/weapon/material,
		/obj/item/weapon/gauze_pack,
		/obj/item/weapon/grenade,
		/obj/item/weapon/attachment,
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/melee/classic_baton,
		/obj/item/device/flashlight,
		/obj/item/weapon/handcuffs
		)

/obj/item/weapon/storage/belt/soviet/anti_tank_crew
/obj/item/weapon/storage/belt/soviet/anti_tank_crew/New()
	..()

	for (var/v in TRUE to 10)
		new /obj/item/ammo_casing/a145(src)

/obj/item/weapon/storage/belt/soviet/MP/New()
	..()
	new /obj/item/weapon/melee/classic_baton/MP/soviet(src)
	new /obj/item/weapon/gun/projectile/pistol/_45(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)

/obj/item/weapon/storage/belt/german
	name = "German belt pouch"
	desc = "Can hold gear like pistol, ammo and other thingies."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 6
	max_w_class = 3
	max_storage_space = 28
	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/weapon/material,
		/obj/item/weapon/gauze_pack,
		/obj/item/weapon/grenade,
		/obj/item/weapon/attachment,
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/melee/classic_baton,
		/obj/item/device/flashlight,
		/obj/item/weapon/handcuffs
		)

/obj/item/weapon/storage/belt/german/anti_tank_crew
/obj/item/weapon/storage/belt/german/anti_tank_crew/New()
	..()

	for (var/v in TRUE to 10)
		new /obj/item/ammo_casing/a145(src)

/obj/item/weapon/storage/belt/german/fallofficer
	name = "German belt"
	desc = "Can hold gear like pistol, ammo and other thingies."
	icon_state = "gerbelt"
	item_state = "gerbelt"
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
	max_storage_space = 20

/obj/item/weapon/storage/belt/german/fallsoldier/New()
	..()
	new /obj/item/ammo_magazine/kar98k(src)
	new /obj/item/ammo_magazine/kar98k(src)
	new /obj/item/ammo_magazine/kar98k(src)
	new /obj/item/weapon/attachment/bayonet(src)
	new /obj/item/weapon/gauze_pack/gauze(src)
	new /obj/item/weapon/grenade/explosive/stgnade(src)

/obj/item/weapon/storage/belt/german/MP/New()
	..()
	new /obj/item/weapon/melee/classic_baton/MP/german(src)
	new /obj/item/weapon/gun/projectile/pistol/luger(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)

/obj/item/clothing/under/doctor
	name = "doctor's uniform"
	desc = "A sterile, nicely pressed suit for doctors."
	icon_state = "ba_suit"
	item_state = "ba_suit"

// soviets and partisans

/obj/item/clothing/shoes/swat/wrappedboots
	name = "\improper wrapped boots"
	icon_state = "wrappedboots"
	force = WEAPON_FORCE_WEAK
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = FALSE)
	item_flags = NOSLIP
	siemens_coefficient = 0.6


// partisans / civs

/obj/item/clothing/under/civ1
	name = "Civilian Clothing"
	desc = "A nice set of threads for civilians. Smells of sweat and resentment."
	icon_state = "civuni1"
	item_state = "civuni1"
	worn_state = "civuni1"

/obj/item/clothing/under/civ2
	name = "Civilian Clothing"
	desc = "A nice set of threads for civilians. Smells of sweat and resentment."
	icon_state = "civuni2"
	item_state = "civuni2"
	worn_state = "civuni2"

/obj/item/clothing/under/civ3
	name = "Civilian Clothing"
	desc = "A nice set of threads for civilians. Smells of sweat and resentment."
	icon_state = "civuni3"
	item_state = "civuni3"
	worn_state = "civuni3"


/obj/item/weapon/storage/backpack/german
	name = "german backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "germanpack"
	item_state_slots = null

//portable rations

/obj/item/weapon/storage/backpack/german/rations

/obj/item/weapon/storage/backpack/german/rations/New()
	..()
	for (var/v in TRUE to 3)
		contents += new_ration(GERMAN, "solid")

/obj/item/weapon/storage/backpack/german/paratrooper

/obj/item/weapon/storage/backpack/german/paratrooper/New()
	..()
	for (var/v in TRUE to 3)
		contents += new_ration(GERMAN, "solid")
	contents += new/obj/item/device/flashlight/lantern()

// todo: needs a new icon

/obj/item/weapon/storage/backpack/soviet
	name = "soviet backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "russianpack"
	item_state_slots = null

// coats

/obj/item/clothing/suit/coat
	name = "generic coat"
	desc = "generic desc"
	allowed = list(/obj/item/device/radio/rbs,/obj/item/device/radio/feldfu,/obj/item/device/radio/partisan)

/obj/item/clothing/suit/coat/civilian
	name = "Civilian's Coat"
	desc = "An ordinary winter coat."
	icon_state = "winter_coat"
	item_state = "winter_coat"
	worn_state = "winter_coat"

/obj/item/clothing/suit/coat/german
	name = "German Soldier's Coat"
	desc = "An ordinary winter coat for a Wehrmacht soldier."
	icon_state = "nazi_coat"
	item_state = "nazi_coat"
	worn_state = "nazi_coat"

/obj/item/clothing/suit/coat/german/SS
	name = "SS Soldier's Coat"
	desc = "An ordinary winter coat for an SS soldier."
	icon_state = "ss_coat"
	item_state = "ss_coat"
	worn_state = "ss_coat"

/obj/item/clothing/suit/coat/german/officer
	name = "German Officer's Coat"
	desc = "An ordinary winter coat for a Wehrmacht officer."
	icon_state = "nazimp_coat"
	item_state = "nazimp_coat"
	worn_state = "nazimp_coat"

/obj/item/clothing/suit/coat/soviet
	name = "Soviet Soldier's Coat"
	desc = "An ordinary winter coat for a Soviet soldier."
	icon_state = "soviet_coat"
	item_state = "soviet_coat"
	worn_state = "soviet_coat"

/obj/item/clothing/suit/coat/soviet/officer
	name = "Soviet Officer's Coat"
	desc = "An ordinary winter coat for a Soviet officer."
	icon_state = "sovofficer_coat"
	item_state = "sovofficer_coat"
	worn_state = "sovofficer_coat"
