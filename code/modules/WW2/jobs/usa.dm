
/datum/job/usa
	faction = "Station"

/datum/job/usa/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_name(H.gender)
	H.real_name = H.name

/datum/job/usa/commander
	title = "Captain"
	en_meaning = "Company Commander"
	rank_abbreviation = "Cpt"
	head_position = TRUE
	selection_color = "#2d2d63"
	spawn_location = "JoinLateUSACO"
	additional_languages = list( "German" = 100, "Japanese" = 75)
	is_officer = TRUE
	is_commander = TRUE
	whitelisted = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1

/datum/job/usa/commander/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/usuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/usnco(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_r_hand)
	world << "<b><big>[H.real_name] is the [title] of the American forces!</big></b>"
	H.add_note("Role", "You are a <b>[title]</b>, the highest ranking officer present. Your job is the organize the American forces and lead them to victory. You take orders from the <b>US Army High Command</b>.")
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
	return TRUE

///datum/job/usa/soldier/get_keys()
//	return list(new/obj/item/weapon/key/usa)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/usa/MP
	title = "Militärpolizei"
	en_meaning = "MPO"
	rank_abbreviation = "2Sgt"
	selection_color = "#2d2d63"
	spawn_location = "JoinLateUSAMP"
	additional_languages = list( "German" = 100, "Japanese" = 33, "Russian" = 100)
	is_officer = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 3
	player_threshold = PLAYER_THRESHOLD_LOW
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/usa/MP/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/usboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/usuni_mp(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/usmphelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/MP(H), slot_belt)
	H.add_note("Role", "You are a <b>[title]</b>, a military police officer. Keep the <b>Private</b>s in line.")
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
	return TRUE

///datum/job/usa/soldier/get_keys()
//	return list(new/obj/item/weapon/key/usa)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/usa/squad_leader
	title = "Sergeant"
	en_meaning = "Squad Leader"
	rank_abbreviation = "Sgt"
	head_position = FALSE
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateUSASL"
	additional_languages = list( "German" = 33, "Japanese" = 10)
	is_officer = TRUE
	is_squad_leader = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 4
	max_positions = 4

/datum/job/usa/squad_leader/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/usboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/usuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/usnco(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/submachinegun/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_belt)
	H.add_note("Role", "You are a <b>[title]</b>. Your job is to lead offensive units of the US Army force according to the <b>Captain</b>'s orders.")
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
	return TRUE

/datum/job/usa/squad_leader/update_character(var/mob/living/carbon/human/H)
	..()
	H.make_artillery_officer()

///datum/job/usa/soldier/get_keys()
//	return list(new/obj/item/weapon/key/usa)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/usa/soldier
	title = "Private"
	en_meaning = "Infantry Soldier"
	rank_abbreviation = "Pvt"
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateUSA"
	allow_spies = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 5
	max_positions = 12
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/usa/soldier/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/usboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/usuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/ushelm(H), slot_head)
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
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/semiautomatic/g41(H), slot_back)
	return TRUE

///datum/job/usa/soldier/get_keys()
//	return list(new/obj/item/weapon/key/usa)
