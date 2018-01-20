/proc/civ_stat()
	return pick(ALL_STATS)

/datum/job/partisan/civilian
	title = "Civilian"
	total_positions = 5
	selection_color = "#530909"
	spawn_location = "JoinLateCivilian"

/datum/job/partisan/civilian/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	equip_random_uniform(H)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a simple civilian trying to live his life in the warzone. Survive.</span>"
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("medical", civ_stat())
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE