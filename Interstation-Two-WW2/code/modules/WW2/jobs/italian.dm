/datum/job/italian
	faction = "Station"
	additional_languages = list( "German" = 100 )

/* Soldier */

/datum/job/italian/soldier
	title = "Soldato"
	en_meaning = "Infantry Soldier"
	total_positions = 5
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateIT" // WIP

	// AUTOBALANCE
	min_positions = 3
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/italian/soldier/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, an Italian infantry unit assisting the Wehrmacht. Your job is to participate in front line combat.</span>"
	H.give_radio()
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_NORMAL)
	H.setStat("mg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_NORMAL)
	return TRUE

/datum/job/italian/soldier/get_keys()
	return list(new/obj/item/weapon/key/italian, new/obj/item/weapon/key/italian/soldat)

/* Medic */

/datum/job/italian/medic
	title = "Medico"
	en_meaning = "Medic"
	total_positions = 1
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateIT-Medic" // WIP

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/italian/medic/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/doctor_handbook(H), slot_l_store)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a medic. Your job is to keep your squad healthy and in good condition.</span>"
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_LOW)
	H.setStat("engineering", STAT_LOW)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_MEDIUM_LOW)
	H.setStat("medical", STAT_MEDIUM_HIGH)
	return TRUE

/datum/job/italian/medic/get_keys()
	return list(new/obj/item/weapon/key/italian, new/obj/item/weapon/key/italian/soldat, new/obj/item/weapon/key/italian/medic)

/* Squad Leader/Commander */

/datum/job/italian/squad_leader
	title = "Capo Squadra"
	en_meaning = "Squad Leader"
	head_position = TRUE
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateIT-Officer"
	additional_languages = list( "German" = 50 )
	is_officer = TRUE
	is_commander = TRUE // not a squad leader despite the title
	is_petty_commander = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10

/datum/job/italian/squad_leader/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/ssuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/akm(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a squad leader for an elite SS unit. Your job is to work alongside normal <b>Gruppenfuhrer</b>s and the <b>Hauptmann</b>, while setting your own goals. Also, kill any jews you find on sight. They usually have long hair and beards.</span>"
	H.give_radio()
	if (secret_ladder_message)
		H << "<br>[secret_ladder_message]"

	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_LOW)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_MEDIUM_LOW)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_LOW)
	return TRUE

/datum/job/italian/squad_leader/update_character(var/mob/living/carbon/human/H)
	..()

	H.make_artillery_officer()

/datum/job/italian/squad_leader/get_keys()
	return list(new/obj/item/weapon/key/italian, new/obj/item/weapon/key/italian/soldat,
		new/obj/item/weapon/key/italian/command_intermediate, new/obj/item/weapon/key/italian/command_high)