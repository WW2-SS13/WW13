
/datum/job/japanese
	faction = "Station"

/datum/job/japanese/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_name(H.gender)
	H.real_name = H.name

/datum/job/japanese/commander
	title = "Captain"
	en_meaning = "Company Commander"
	rank_abbreviation = "Cpt"
	head_position = TRUE
	selection_color = "#2d2d63"
	spawn_location = "JoinLateHeerCO"
	additional_languages = list( "Russian" = 100, "Ukrainian" = 50, "Italian" = 100)
	is_officer = TRUE
	is_commander = TRUE
	whitelisted = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1

/datum/job/japanese/commander/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/japuni_officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/japnco(H), slot_head)
	if (istype(H, /mob/living/carbon/human/mechahitler))
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger/gibber(H), slot_belt)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_r_hand)
	spawn (5) // after we have our name
		if (!istype(H, /mob/living/carbon/human/mechahitler))
			if (!istype(get_area(H), /area/prishtina/admin))
				world << "<b><big>[H.real_name] is the [title] of the German forces!</big></b>"
	H.add_note("Role", "You are a <b>[title]</b>, the highest ranking officer present. Your job is the organize the German forces and lead them to victory, while working alongside the <b>SS-Untersharffuhrer</b>. You take orders from the <b>German High Command</b>.")
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_LOW)
	H.setStat("engineering", STAT_VERY_LOW)
	H.setStat("rifle", STAT_LOW)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("smg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_VERY_LOW)
	H.setStat("shotgun", STAT_NORMAL)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/arisaka(H), slot_back)
	return TRUE

///datum/job/japanese/soldier/get_keys()
//	return list(new/obj/item/weapon/key/japanese)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/japanese/MP
	title = "Militärpolizei"
	en_meaning = "MPO"
	rank_abbreviation = "uffz"
	selection_color = "#2d2d63"
	spawn_location = "JoinLateHeerMP"
	additional_languages = list( "Russian" = 100, "Ukrainian" = 33, "Italian" = 100)
	is_officer = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 3
	player_threshold = PLAYER_THRESHOLD_LOW
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/japanese/MP/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/japunimp(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/japmphat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/MP(H), slot_belt)
	H.add_note("Role", "You are a <b>[title]</b>, a military police officer. Keep the <b>Soldat</b>en in line.")
	H.give_radio()
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_VERY_LOW)
	H.setStat("rifle", STAT_LOW)
	H.setStat("mg", STAT_LOW)
	H.setStat("smg", STAT_MEDIUM_LOW)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_VERY_LOW)
	H.setStat("shotgun", STAT_NORMAL)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/arisaka(H), slot_back)

	return TRUE

///datum/job/japanese/soldier/get_keys()
//	return list(new/obj/item/weapon/key/japanese)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/japanese/squad_leader
	title = "Sergeant"
	en_meaning = "Squad Leader"
	rank_abbreviation = "Sgt"
	head_position = FALSE
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerSL"
	additional_languages = list( "Russian" = 33, "Italian" = 50)
	is_officer = TRUE
	is_squad_leader = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 4
	max_positions = 4

/datum/job/japanese/squad_leader/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/japuni_officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/japnco(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_belt)
	H.add_note("Role", "You are a <b>[title]</b>. Your job is to lead offensive units of the German force according to the <b>Hauptmann</b>'s and <b>Stabsoffizier</b>en's orders.")
	H.give_radio()
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_LOW)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("smg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_MEDIUM_LOW)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_LOW)
	H.setStat("shotgun", STAT_NORMAL)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/arisaka(H), slot_back)
	return TRUE

/datum/job/japanese/squad_leader/update_character(var/mob/living/carbon/human/H)
	..()
	H.make_artillery_officer()

///datum/job/japanese/soldier/get_keys()
//	return list(new/obj/item/weapon/key/japanese)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/japanese/soldier
	title = "Private"
	en_meaning = "Infantry Soldier"
	rank_abbreviation = "Pvt"
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 5
	max_positions = 12
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/japanese/soldier/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/japuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/japanhelm(H), slot_head)
//	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german_basic/soldier(H), slot_belt)
	H.add_note("Role", "You are a <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.")
	H.give_radio()
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_NORMAL)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("smg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_NORMAL)
	H.setStat("shotgun", STAT_NORMAL)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/arisaka(H), slot_back)
	return TRUE

///datum/job/japanese/soldier/get_keys()
//	return list(new/obj/item/weapon/key/japanese)
