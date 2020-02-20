datum/job/german/croation
	faction = "Station"

datum/job/german/croation/soldier
	title = "Croation Soldier"
	selection_color = "#530909"
	spawn_location = "JoinLateHeer"
	is_croation = TRUE
	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST
	//scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

datum/job/german/croation/soldier/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/croation(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/croation(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/coat/croation(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/submachinegun/stenmk2(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/submachinegun/tz45(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/material/knife/combat(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), slot_l_hand)
	H.give_radio()
	H.add_note("Role", "You are a <b>[title]</b>, a Croation soldier. You take orders from the <b>Croation Leader</b> alone.")
	if (partisan_stockpile)
		H << "<br><span class = 'warning'>You have a stockpile of weapons at [partisan_stockpile.name]. Also, there are some stockpiles of medical items and tools around the town.</span>"
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("medical", civ_stat())
	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))

	H.setStat("shotgun", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	return TRUE

datum/job/german/croation/commander
	title = "Croation Commander"
	is_officer = TRUE
	is_commander = TRUE
	head_position = TRUE
	selection_color = "#2d2d63"
	spawn_location = "JoinLateHeer"
	additional_languages = list( "Russian" = 100, "German" = 100)
	is_croation = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST

datum/job/german/croation/commander/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/croation(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/croation(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/coat/croationofficer(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/submachinegun/stenmk2(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/submachinegun/tz45(H), slot_belt)

	H.give_radio()

	H.add_note("Role", "You are a <b>[title]</b>, the leader of the Croation forces in the town. Protect your men and the civilians!")
	if (partisan_stockpile)
		H << "<br><span class = 'warning'>You have a stockpile of weapons at [partisan_stockpile.name]. Also, there are some stockpiles of medical items and tools around the town.</span>"
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))

	H.setStat("shotgun", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	return TRUE
