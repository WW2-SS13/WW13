
/datum/job/partisan/civilian
	title = "Civilian"
	faction = "Station"
	total_positions = 5
	selection_color = "#530909"
	spawn_location = "JoinLateCivilian"

/datum/job/partisan/civilian/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	equip_random_uniform(H)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a simple civilian trying to live his life in the warzone. Survive.</span>"
	return 1