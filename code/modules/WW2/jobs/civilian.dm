/proc/civ_stat()
	return pick(ALL_STATS)

/datum/job/partisan/civilian
	title = "Civilian"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilian"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), pick(slot_l_hand, slot_r_hand))
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, a simple civilian trying to live his life in the warzone. Survive.")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE