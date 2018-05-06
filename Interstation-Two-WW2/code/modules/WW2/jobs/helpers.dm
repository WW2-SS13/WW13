/proc/n_of_side(x)
	. = 0
	switch (x)
		if (PARTISAN)
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && H.stat != DEAD)
					if (H.original_job.base_type_flag() == PARTISAN)
						AZONE_CHECK(H)
							++.
		if (CIVILIAN)
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && H.stat != DEAD)
					if (H.original_job.base_type_flag() == CIVILIAN)
						AZONE_CHECK(H)
							++.
		if (GERMAN)
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && H.stat != DEAD)
					if (H.original_job.base_type_flag() == GERMAN)
						AZONE_CHECK(H)
							++.
		if (SOVIET)
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && H.stat != DEAD)
					if (H.original_job.base_type_flag() == SOVIET)
						AZONE_CHECK(H)
							++.
		if (ITALIAN)
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && H.stat != DEAD)
					if (H.original_job.base_type_flag() == ITALIAN)
						AZONE_CHECK(H)
							++.

/mob/living/carbon/human/proc/equip_coat(ctype)
	if (season == "WINTER")
		var/obj/item/radio/radio = null
		if (istype(wear_suit, /obj/item/clothing/suit/radio_harness))
			radio = s_store
			remove_from_mob(wear_suit)
		if (!wear_suit)
			equip_to_slot_or_del(new ctype(src), slot_wear_suit)
			if (radio && istype(radio))
				equip_to_slot_or_del(radio, slot_s_store)

/datum/job/proc/equip_random_civilian_clothing(var/mob/living/carbon/human/H)
	if (prob(33))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/civ1(H), slot_w_uniform)
	else if (prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/civ2(H), slot_w_uniform)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/under/civ3(H), slot_w_uniform)
