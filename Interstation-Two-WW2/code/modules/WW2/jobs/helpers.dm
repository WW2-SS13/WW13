/proc/n_of_side(x)
	. = FALSE
	switch (x)
		if (PARTISAN)
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && H.stat != DEAD)
					if (H.original_job.base_type_flag() == PARTISAN)
						++.
		if (CIVILIAN)
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && H.stat != DEAD)
					if (H.original_job.base_type_flag() == CIVILIAN)
						++.
		if (GERMAN)
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && H.stat != DEAD)
					if (H.original_job.base_type_flag() == GERMAN)
						++.
		if (SOVIET)
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && H.stat != DEAD)
					if (H.original_job.base_type_flag() == SOVIET)
						++.

/mob/living/carbon/human/proc/equip_coat(ctype)
	if (ticker && ticker.mode)
		var/datum/game_mode/ww2/mode = ticker.mode
		if (istype(mode) && mode.season == "WINTER")
			var/obj/item/device/radio/radio = null
			if (istype(wear_suit, /obj/item/clothing/suit/radio_harness))
				radio = s_store
				remove_from_mob(wear_suit)
			if (!wear_suit)
				equip_to_slot_or_del(new ctype(src), slot_wear_suit)
				if (radio && istype(radio))
					equip_to_slot_or_del(radio, slot_s_store)
