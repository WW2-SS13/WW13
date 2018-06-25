/* Uniform Metadata: Soviet, German, Italian */

#define SOVIET_UNIFORM_NAME "Soviet uniform"
#define SOVIET_UNIFORM_DESC "A standard issue Soviet uniform issued to Red Army soldiers."
#define SOVIET_UNIFORM_STATE "sovuni"

#define GERMAN_UNIFORM_NAME "German uniform"
#define GERMAN_UNIFORM_DESC "A standard issue German uniform issued to Wehrmacht soldiers. It looks sturdy and strictly folded."
#define GERMAN_UNIFORM_STATE "geruni"

#define ITALIAN_UNIFORM_NAME "Italian uniform"
#define ITALIAN_UNIFORM_DESC "A standard issue Italian uniform issued to Italian soldiers fighting alongside the Wehrmacht."
#define ITALIAN_UNIFORM_STATE "itauni"

/* Helmet Metadata: Soviet, German, Italian */

#define SOVIET_HELMET_NAME "Soviet helmet"
#define SOVIET_HELMET_DESC "A standard issue helmet of the Red Army. Provides some protection against both the elements and flying shrapnel."
#define SOVIET_HELMET_STATE "sovhelm"

#define GERMAN_HELMET_NAME "German helmet"
#define GERMAN_HELMET_DESC "A standard issue helmet of the Wehrmacht. Provides some protection against both the elements and flying shrapnel."
#define GERMAN_HELMET_STATE "gerhelm"

#define ITALIAN_HELMET_NAME "Italian helmet"
#define ITALIAN_HELMET_DESC "A standard issue helmet of the Italian Army. Provides some protection against both the elements and flying shrapnel."
#define ITALIAN_HELMET_STATE "itahelm"

/obj/item/clothing/under
	var/swapped = FALSE

/obj/item/clothing/under/proc/add_alternative_setting()
	verbs += /obj/item/clothing/under/proc/Swap

/obj/item/clothing/under/proc/Swap()
	set category = null
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
	if (istype(H.s_store, /obj/item/radio/feldfu))
		var/radio = H.s_store
		H.drop_from_inventory(radio)
		qdel(radio)
		H.equip_to_slot_or_del(new /obj/item/radio/rbs(H), slot_s_store)
	if (istype(H.head, /obj/item/clothing/head/helmet/gerhelm))
		var/obj/item/clothing/head/helmet/gerhelm/head = H.head
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
	if (istype(H.s_store, /obj/item/radio/rbs))
		var/radio = H.s_store
		H.drop_from_inventory(radio)
		qdel(radio)
		H.equip_to_slot_or_del(new /obj/item/radio/feldfu(H), slot_s_store)
	if (istype(H.head, /obj/item/clothing/head/helmet/sovhelm))
		var/obj/item/clothing/head/helmet/sovhelm/head = H.head
		head.transform2german()

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

/obj/item/clothing/under/geruni/kriegsmarine
	name = "Kriegsmarine sailor uniform"
	desc = "A dark blue uniform of the Kriegsmarine."
	icon_state = "kriegsmarine"
	item_state = "kriegsmarine"
	worn_state = "kriegsmarine"

/obj/item/clothing/under/geruni/MP
	name = "german MP's uniform"
	desc = "A fancier, more pressed uniform of the Nazi Army, given to German military police."
	icon_state = "geruni_MP"
	item_state = "geruni_MP"
	worn_state = "geruni_MP"


/obj/item/clothing/under/geruni/verb/roll_sleeves()
	set category = null
	set src in usr
	if (type != /obj/item/clothing/under/geruni)
		return // no sprites - Kachnov
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

/obj/item/clothing/under/geruni/general
	name = "Heer General uniform"
	desc = "A comfortable and sturdy high-ranking officer's uniform."
	icon_state = "gerunigeneral"
	item_state = "gerunigeneral"
	worn_state = "gerunigeneral"

/obj/item/clothing/under/geruni/ghillie
	name = "german ghilli suit"
	desc = "A sneaky sneaky ghillie suit."
	icon_state = "ger_ghillie"
	item_state = "ger_ghillie"
	worn_state = "ger_ghillie"


/obj/item/clothing/under/geruni/falluni
	name = "Fallschirmjager uniform"
	desc = "A standard issue german uniform for Fallschirmjagers. This one is quite comfy and sturdy."
	icon_state = "falluni"
	item_state = "falluni"
	worn_state = "falluni"

/obj/item/clothing/under/geruni/ssuni
	name = "SS uniform"
	desc = "A black uniform issued to SchutzStaffel soldiers. Sturdy and comfortable."
	icon_state = "newssuni"
	item_state = "newssuni"
	worn_state = "newssuni"

/obj/item/clothing/under/geruni/sscamo
	name = "SS camo uniform"
	desc = "A camo uniform issued to SchutzStaffel soldiers. Sturdy, comfy, and makes you less visible in autumn."
	icon_state = "ssunicamo"
	item_state = "ssunicamo"
	worn_state = "ssunicamo"

/obj/item/clothing/under/geruni/ssformalofc
	name = "SS Officer's Formal Uniform"
	desc = "A jet black formal uniform issued to SchutzStaffel officers. There's a NSDAP armband attached."
	icon_state = "ss_formal_ofc"
	item_state = "ss_formal_ofc"
	worn_state = "ss_formal_ofc"

/obj/item/clothing/under/geruni/sauni
	name = "SA Uniform"
	desc = "A uniform of the SturmAbteilung, used by NSAP party officials."
	icon_state = "SAuni"
	item_state = "SAuni"
	worn_state = "SAuni"

/obj/item/clothing/under/geruni/hj_uni
	name = "Hitlerjugend Uniform"
	desc = "A uniform of the Hitlerjugend, the Hitler's Youth."
	icon_state = "hj_uni"
	item_state = "hj_uni"
	worn_state = "hj_uni"

/obj/item/clothing/under/geruni/gertankeruni
	name = "Panzer Crewman Uniform"
	desc = "A dark gray jumpsuit with a brown belt. It has an insignia indicating that the wearer is a tank crewman."
	icon_state = "gertankeruni"
	item_state = "gertankeruni"
	worn_state = "gertankeruni"

/obj/item/clothing/under/sovuni
	name = SOVIET_UNIFORM_NAME
	desc = SOVIET_UNIFORM_DESC
	icon_state = SOVIET_UNIFORM_STATE
	item_state = SOVIET_UNIFORM_STATE
	worn_state = SOVIET_UNIFORM_STATE

/obj/item/clothing/under/sovuni/camo
	name = "Soviet Camo Uniform"
	desc = "A camo uniform for Soviet soldiers. Sturdy, comfy, and makes you less visible in autumn."
	icon_state = "sovunicamo"
	item_state = "sovunicamo"
	worn_state = "sovunicamo"

/obj/item/clothing/under/sovuni/officer
	name = "Soviet Officer's uniform"
	desc = "A fancier, more pressed uniform of the Red Army, given to Soviet officers. It has a feel of pride and authority."
	icon_state = "sovuniofficer"
	item_state = "sovuniofficer"
	worn_state = "sovuniofficer"

/obj/item/clothing/under/sovuni/MP
	name = "Soviet MP's uniform"
	desc = "A fancier, more pressed uniform of the Red Army, given to Soviet military police."
	icon_state = "sovuni_MP"
	item_state = "sovuni_MP"
	worn_state = "sovuni_MP"

/obj/item/clothing/under/sovuni/sovtankeruni
	name = "Soviet Crewman Uniform"
	desc = "A dark blue jumpsuit with a brown belt and bandolier."
	icon_state = "sovtankeruni"
	item_state = "sovtankeruni"
	worn_state = "sovtankeruni"

/obj/item/clothing/under/itauni
	name = ITALIAN_UNIFORM_NAME
	desc = ITALIAN_UNIFORM_DESC
	icon_state = ITALIAN_UNIFORM_STATE
	item_state = ITALIAN_UNIFORM_STATE
	worn_state = ITALIAN_UNIFORM_STATE
	var/rolled = FALSE

/obj/item/clothing/under/itauni/officer
	name = "Italian Officer's Uniform"
	desc = "A fancier, more pressed uniform of the Italian Army, given to Soviet military police."
	icon_state = "itauni_officer"
	item_state = "itauni_officer"
	worn_state = "itauni_officer"

/obj/item/clothing/suit/fallsparka
	name = "Fallschirmjager Parka"
	desc = "A warm and comfy parka for Fallschirmjagers."
	icon_state = "fallsparka"
	item_state = "fallsparka"
	worn_state = "fallsparka"
	allowed = list(/obj/item/radio/rbs,/obj/item/radio/feldfu,/obj/item/radio/partisan)

/obj/item/clothing/suit/sssmock
	name = "S.S. Smock"
	desc = "A camo SchutzStaffel overcoat that blends in well in the fall."
	icon_state = "sssmock"
	item_state = "sssmock"
	worn_state = "sssmock"
	allowed = list(/obj/item/radio/rbs,/obj/item/radio/feldfu,/obj/item/radio/partisan)

/obj/item/clothing/head/helmet/gerhelm
	name = GERMAN_HELMET_NAME
	desc = GERMAN_HELMET_DESC
	icon_state = GERMAN_HELMET_STATE
	item_state = GERMAN_HELMET_STATE

/obj/item/clothing/head/helmet/gerhelm/proc/transform2soviet()
	name = SOVIET_HELMET_NAME
	desc = SOVIET_HELMET_DESC
	icon_state = SOVIET_HELMET_STATE
	item_state = SOVIET_HELMET_STATE
	worn_state = SOVIET_HELMET_STATE
	item_state_slots["slot_head"] = SOVIET_HELMET_STATE
	update_clothing_icon()

/obj/item/clothing/head/helmet/gerhelm/sshelm
	name = "SS camo helmet"
	desc =  "A metal helmet issued to SS soldiers, camouflaged for autumn operations."
	icon_state = "sshelm"
	item_state = "sshelm"

/obj/item/clothing/head/helmet/gerhelm/MP
	name = "German MP helmet"
	desc =  "A fancy metal helmet issued to German military police."
	icon_state = "gerhelm_MP"
	item_state = "gerhelm_MP"

/obj/item/clothing/head/helmet/gerhelm/ghillie
	name = "Ghilie Suit Hood"
	desc =  "A standard ghillie suit helm."
	icon_state = "ger_ghillie"
	item_state = "ger_ghillie"

/obj/item/clothing/head/helmet/gerhelm/medic
	name = "German medic's helmet"
	desc =  "A standard metal helmet issued to German combat medics."
	icon_state = "gerhelm_CM"
	item_state = "gerhelm_CM"

/obj/item/clothing/head/helmet/sovhelm
	name = SOVIET_HELMET_NAME
	desc = SOVIET_HELMET_DESC
	icon_state = SOVIET_HELMET_STATE
	item_state = SOVIET_HELMET_STATE

/obj/item/clothing/head/helmet/sovhelm/proc/transform2german()
	name = GERMAN_HELMET_NAME
	desc = GERMAN_HELMET_DESC
	icon_state = GERMAN_HELMET_STATE
	item_state = GERMAN_HELMET_STATE
	worn_state = GERMAN_HELMET_STATE
	item_state_slots["slot_head"] = GERMAN_HELMET_STATE
	update_clothing_icon()

/obj/item/clothing/head/helmet/sovhelm/MP
	name = "Soviet MP helmet"
	desc =  "A fancy metal helmet issued to Soviet military police."
	icon_state = "sovhelm_MP"
	item_state = "sovhelm_MP"

/obj/item/clothing/head/helmet/sovhelm/medic
	name = "Soviet medic's helmet"
	desc =  "A standard metal helmet issued to Soviet combat medics."
	icon_state = "sovhelm_CM"
	item_state = "sovhelm_CM"

/obj/item/clothing/head/helmet/itahelm
	name = ITALIAN_HELMET_NAME
	desc = ITALIAN_HELMET_DESC
	icon_state = ITALIAN_HELMET_STATE
	item_state = ITALIAN_HELMET_STATE

/obj/item/clothing/head/helmet/itahelm/medic
	name = "Italian medic's helmet"
	desc =  "A standard metal helmet issued to Italian combat medics."
	icon_state = "itahelm_CM"
	item_state = "itahelm_CM"

/obj/item/clothing/suit/armor/cn42
	name = "CN-42 bulletproof vest"
	desc = "A heavy vest used by Soviet Sturmovik. Used for deflecting shrapnel and some bullets."
	icon_state = "cn42"
	armor = list(melee = 50)
	allowed = list(/obj/item/radio/rbs,/obj/item/radio/feldfu,/obj/item/radio/partisan)

/obj/item/weapon/storage/belt/soviet
	name = "Soviet belt pouch"
	desc = "A belt that can hold gear like pistols, ammo and other things."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 12
	max_w_class = 3
	max_storage_space = 24
	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/weapon/material,
		/obj/item/weapon/gauze_pack,
		/obj/item/weapon/grenade,
		/obj/item/weapon/attachment,
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/weapon/melee/classic_baton,
		/obj/item/flashlight,
		/obj/item/weapon/handcuffs,
		/obj/item/ammo_casing/a145,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/canteen
		)

/obj/item/weapon/storage/belt/soviet_basic
	name = "Small soviet belt pouch"
	desc = "A basic soviet belt pouch capable of storing a small arms handgun, handgun magazines, gauze and your trustyworthy shovel."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 6
	max_w_class = 3
	max_storage_space = 12
	can_hold = list(
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/ammo_magazine/c763x25mm_mauser,
		/obj/item/ammo_magazine/c762mm_tokarev,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/luger,
		/obj/item/weapon/gauze_pack,
		/obj/item/weapon/shovel/spade/russia,
			/obj/item/weapon/shovel/spade/german,
		/obj/item/weapon/reagent_containers/food
		)

/obj/item/weapon/storage/belt/soviet_basic/soldier
/obj/item/weapon/storage/belt/soviet_basic/soldier/New()
	..()
/*	new /obj/item/weapon/gun/projectile/pistol/tokarev(src)
	new /obj/item/ammo_magazine/c762mm_tokarev(src)
	new /obj/item/ammo_magazine/c762mm_tokarev(src)*/
	new /obj/item/weapon/shovel/spade/russia(src)

/obj/item/weapon/storage/belt/soviet/anti_tank_crew
/obj/item/weapon/storage/belt/soviet/anti_tank_crew/New()
	..()

	for (var/v in 1 to 12)
		new /obj/item/ammo_casing/a145(src)

/obj/item/weapon/storage/belt/soviet/MP/New()
	..()
	new /obj/item/weapon/melee/classic_baton/MP/soviet(src)
	new /obj/item/weapon/gun/projectile/revolver/nagant_revolver(src)
	new /obj/item/flashlight(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)

/obj/item/weapon/storage/belt/german
	name = "German belt pouch"
	desc = "A belt that can hold gear like pistols, ammo and other things."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 12
	max_w_class = 3
	max_storage_space = 24
	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/weapon/material,
		/obj/item/weapon/gauze_pack,
		/obj/item/weapon/grenade,
		/obj/item/weapon/attachment,
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/weapon/melee/classic_baton,
		/obj/item/flashlight,
		/obj/item/weapon/handcuffs,
		/obj/item/ammo_casing/a145,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/canteen
		)

/obj/item/weapon/storage/belt/german_basic
	name = "German soldier belt"
	desc = "A basic belt. Only capable of storing a small arms pistol, clips, rations, gauze and a shovel."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 6
	max_w_class = 3
	max_storage_space = 12
	can_hold = list(
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/ammo_magazine/c763x25mm_mauser,
		/obj/item/ammo_magazine/c762mm_tokarev,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/luger,
		/obj/item/weapon/gauze_pack,
		/obj/item/weapon/shovel/spade/german,
		/obj/item/weapon/shovel/spade/russia,
		/obj/item/weapon/reagent_containers/food
		)

/obj/item/weapon/storage/belt/german_basic/soldier
/obj/item/weapon/storage/belt/german_basic/soldier/New()
	..()
/*	new /obj/item/weapon/gun/projectile/pistol/waltherp38(src)
	new /obj/item/ammo_magazine/p9x19mm(src)
	new /obj/item/ammo_magazine/p9x19mm(src)*/
	new /obj/item/weapon/shovel/spade/german(src)

/obj/item/weapon/storage/belt/german/anti_tank_crew
/obj/item/weapon/storage/belt/german/anti_tank_crew/New()
	..()

	for (var/v in 1 to 12)
		new /obj/item/ammo_casing/a145(src)

/obj/item/weapon/storage/belt/german/fallofficer
	name = "German belt"
	desc = "A belt that can hold gear like pistols, ammo and other things."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	max_storage_space = 20

/obj/item/weapon/storage/belt/german/fallofficer/New()
	..()
	new /obj/item/weapon/gun/projectile/pistol/mauser(src)
	new /obj/item/ammo_magazine/c763x25mm_mauser(src)
	new /obj/item/ammo_magazine/c763x25mm_mauser(src)
	new /obj/item/weapon/gauze_pack/gauze(src)
	new /obj/item/weapon/grenade/explosive/stgnade(src)
	new /obj/item/weapon/grenade/explosive/stgnade(src)
	new /obj/item/flashlight(src)

/obj/item/weapon/storage/belt/german/fallsoldier
	name = "German belt"
	desc = "A belt that can hold gear like pistols, ammo and other things."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	max_storage_space = 20

/obj/item/weapon/storage/belt/german/fallsoldier/New()
	..()
	new /obj/item/weapon/gun/projectile/pistol/mauser(src)
	new /obj/item/ammo_magazine/c763x25mm_mauser(src)
	new /obj/item/ammo_magazine/c763x25mm_mauser(src)
	new /obj/item/weapon/attachment/bayonet(src)
	new /obj/item/weapon/gauze_pack/gauze(src)
	new /obj/item/weapon/grenade/explosive/stgnade(src)
	new /obj/item/flashlight(src)

/obj/item/weapon/storage/belt/german/MP/New()
	..()
	new /obj/item/weapon/melee/classic_baton/MP/german(src)
	new /obj/item/weapon/gun/projectile/pistol/mauser(src)
	new /obj/item/flashlight(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/handcuffs(src)

/obj/item/weapon/storage/belt/german/SSTV/New()
	..()
	new /obj/item/weapon/melee/classic_baton/MP/SS(src)
	new /obj/item/weapon/gun/projectile/pistol/waltherp38(src)
	new /obj/item/flashlight(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/ammo_magazine/p9x19mm(src)

/obj/item/weapon/storage/belt/italy
	name = "Italian belt pouch"
	desc = "A belt that can hold gear like pistols, ammo and other things."
	icon_state = "gerbelt"
	item_state = "gerbelt"
	storage_slots = 12
	max_w_class = 3
	max_storage_space = 24
	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/weapon/material,
		/obj/item/weapon/gauze_pack,
		/obj/item/weapon/grenade,
		/obj/item/weapon/attachment,
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/weapon/melee/classic_baton,
		/obj/item/flashlight,
		/obj/item/weapon/handcuffs,
		/obj/item/ammo_casing/a145,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/canteen
		)

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

// italians

/obj/item/clothing/shoes/swat/italianboots
	name = "\improper Italian boots"
	icon_state = "italian_boots"
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

/obj/item/weapon/storage/backpack/italy
	name = "italian backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "germanpack"
	item_state_slots = null

//portable rations

/obj/item/weapon/storage/backpack/german/rations

/obj/item/weapon/storage/backpack/german/rations/New()
	..()
	for (var/v in 1 to 7)
		contents += new_ration(GERMAN, "solid")

/obj/item/weapon/storage/backpack/german/paratrooper
	desc = "A German paratrooper's backpack. Parachute built in."

/obj/item/weapon/storage/backpack/german/paratrooper/New()
	..()
	for (var/v in 1 to 3)
		contents += new/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/german
	for (var/v in 1 to 2)
		contents += new/obj/item/weapon/reagent_containers/food/drinks/bottle/water/filled
	for (var/v in 1 to 2)
		contents += new/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer

// todo: needs a new icon

/obj/item/weapon/storage/backpack/soviet
	name = "soviet backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "russianpack"
	item_state_slots = null

// coats

/obj/item/clothing/suit/storage/coat
	name = "generic coat"
	desc = "generic desc"
	allowed = list(/obj/item/radio/rbs,/obj/item/radio/feldfu,/obj/item/radio/partisan)

/obj/item/clothing/suit/storage/coat/civilian
	name = "Civilian's Coat"
	desc = "An ordinary winter coat."
	icon_state = "winter_coat"
	item_state = "winter_coat"
	worn_state = "winter_coat"

/obj/item/clothing/suit/storage/coat/german
	name = "German Soldier's Coat"
	desc = "An ordinary winter coat issued to Wehrmacht soldiers."
	icon_state = "nazi_coat"
	item_state = "nazi_coat"
	worn_state = "nazi_coat"

/obj/item/clothing/suit/storage/coat/german/SS
	name = "SS Soldier's Coat"
	desc = "An ordinary winter coat issued to SS soldiers."
	icon_state = "ss_coat"
	item_state = "ss_coat"
	worn_state = "ss_coat"

/obj/item/clothing/suit/storage/coat/german/officer
	name = "German Officer's Coat"
	desc = "An ordinary winter coat issued to Wehrmacht officers."
	icon_state = "nazimp_coat"
	item_state = "nazimp_coat"
	worn_state = "nazimp_coat"

/obj/item/clothing/suit/storage/coat/soviet
	name = "Soviet Soldier's Coat"
	desc = "An ordinary winter coat issued to Soviet soldiers."
	icon_state = "soviet_coat"
	item_state = "soviet_coat"
	worn_state = "soviet_coat"

/obj/item/clothing/suit/storage/coat/soviet/officer
	name = "Soviet Officer's Coat"
	desc = "An ordinary winter coat issued to Soviet officers."
	icon_state = "sovofficer_coat"
	item_state = "sovofficer_coat"
	worn_state = "sovofficer_coat"

/obj/item/clothing/suit/storage/coat/german/ghillie
	name = "Ghilie Ghillie Suit"
	desc =  "A standard ghillie suit."
	icon_state = "ger_ghillie"
	item_state = "ger_ghillie"
	allowed = list(/obj/item/radio/rbs,/obj/item/radio/feldfu,/obj/item/radio/partisan)

/obj/item/clothing/suit/storage/coat/italian
	name = "Italian Coat"
	desc = "An ordinary winter coat issued to Italian soldiers."
	icon_state = "italy_coat"
	item_state = "italy_coat"
	worn_state = "italy_coat"

// WEBBING - can hold everything but clothing

/obj/item/clothing/accessory/storage/webbing
	name = "webbing"
	desc = "A sturdy mess of cotton belts and buckles, ready to share your burden."
	icon_state = "webbing"
	slots = 8

	New()
		..()
		hold.cant_hold = list(/obj/item/clothing)

// CUSTOMIZED GAS MASKS

/obj/item/clothing/mask/gas/german
	icon_state = "m38_mask"
	item_state = "m38_mask"
	filtered_gases = list("xylyl_bromide", "mustard_gas", "white_phosphorus_gas", "chlorine_gas", "zyklon_b")

/obj/item/clothing/mask/gas/soviet
	icon_state = "gp5_mask"
	item_state = "gp5_mask"
	filtered_gases = list("xylyl_bromide", "mustard_gas", "white_phosphorus_gas", "chlorine_gas", "zyklon_b")
