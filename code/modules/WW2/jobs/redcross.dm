/datum/job/redcross
	faction = "Station"

/datum/job/redcross/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_ukrainian_name(H.gender)
	H.real_name = H.name

/datum/job/redcross/doctor
	title = "Red Cross Doctor"
	selection_color = "#530909"
	spawn_location = "JoinLateRedCross"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/redcross/doctor/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), suit)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), slot_l_hand)
	H.give_radio()
	H.add_note("Role", "You are a <b>[title]</b>, a red cross doctor. You take orders from the <b>Director</b> alone.")
	if (partisan_stockpile)
		H << "<br><span class = 'warning'>You have a stockpile of medical supplies at your base. Also, there are some stockpiles of supplies and tools around the town.</span>"
	H.setStat("strength", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	H.setStat("engineering", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	H.setStat("medical", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))

	H.setStat("rifle", civ_stat())
	H.setStat("mg", civ_stat())
	H.setStat("smg", civ_stat())
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))

	H.setStat("shotgun", civ_stat())
	return TRUE

/datum/job/redcross/guard
	title = "Red Cross Guard"
	is_officer = FALSE
	is_commander = FALSE
	head_position = FALSE
	selection_color = "#2d2d63"
	spawn_location = "JoinLateRedCrossGuard"
	additional_languages = list( "Russian" = 100, "German" = 100)

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 3
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 3

/datum/job/redcross/guard/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), suit)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), slot_r_hand)
	if (map && map.ID == "FOREST")
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/heavy/ptrd(H), slot_back)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/submachinegun/stenmk2(H), slot_back)
		// equipping the luger second means we get ammo for the PPSH instead
		// this works because the PPSH is added to our contents list first
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/tokarev(H), slot_belt)

	H.give_radio()

	H.add_note("Role", "You are a <b>[title]</b>, a guard for the red cross in the town. Protect your fellow red cross members and paitents. *YOU ARE A RED CROSS MEMBER, NOT A SOLDIER. GUARD THE RED CROSS AND ONLY KILL PEOPLE WHEN THEY POSE A THREAT TO THE RED CROSS AND THE PAITENTS*")
	if (partisan_stockpile)
		H << "<br><span class = 'warning'>YOU ARE A RED CROSS MEMBER, NOT A SOLDIER. GUARD THE RED CROSS AND ONLY KILL PEOPLE WHEN THEY POSE A THREAT TO THE RED CROSS AND THE PAITENTS.</span>"
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))

	H.setStat("shotgun", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	return TRUE

/datum/job/partisan/director
	title = "Red Cross Director"
	is_officer = TRUE
	is_commander = TRUE
	head_position = TRUE
	selection_color = "#2d2d63"
	spawn_location = "JoinLateRedCrossLeader"
	additional_languages = list( "Russian" = 100, "German" = 100)

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST

/datum/job/redcross/director/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), slot_r_hand)

	H.give_radio()

	H.add_note("Role", "You are a <b>[title]</b>, the leader of the Red Cross in the town. Protect your doctors and the lives of everyone!")
	if (partisan_stockpile)
		H << "<br><span class = 'warning'>You have a stockpile of weapons at [partisan_stockpile.name]. Also, there are some stockpiles of medical items and tools around the town.</span>"
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("medical", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))

	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))

	H.setStat("shotgun", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	return TRUE
