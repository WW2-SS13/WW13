/datum/job/partisan
	faction = "Station"

/datum/job/partisan/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_ukrainian_name(H.gender)
	H.real_name = H.name

/datum/job/partisan/proc/equip_random_uniform(var/mob/living/carbon/human/H)
	if (prob(33))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/civ1(H), slot_w_uniform)
	else if (prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/civ2(H), slot_w_uniform)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/under/civ3(H), slot_w_uniform)

/datum/job/partisan/soldier
	title = "Partisan Soldier"
	total_positions = 4
	selection_color = "#530909"
	spawn_location = "JoinLatePartisan"

/datum/job/partisan/soldier/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	equip_random_uniform(H)
	if (prob(40))
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/material/knife/combat(H), slot_r_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a partisan soldier. You take orders from the <b>Partisan Leader</b> alone.</span>"
	if (partisan_stockpile)
		H << "<br><span class = 'warning'>You have a stockpile of weapons at [partisan_stockpile.name]. Also, there are some stockpiles of medical items and tools around the town.</span>"
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("medical", civ_stat())
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	return TRUE

/datum/job/partisan/commander
	title = "Partisan Commander"
	is_officer = TRUE
	is_commander = TRUE
	total_positions = TRUE
	head_position = TRUE
	selection_color = "#2d2d63"
	spawn_location = "JoinLatePartisanLeader"
	additional_languages = list( "Russian" = 100, "German" = 100)

/datum/job/partisan/commander/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	equip_random_uniform(H)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/heavysniper/ptrd(H), slot_back)
	H.give_radio()

	H << "<span class = 'notice'>You are the <b>[title]</b>, the leader of the partisan forces in the town. Protect your men and the civilians!</span>"
	if (partisan_stockpile)
		H << "<br><span class = 'warning'>You have a stockpile of weapons at [partisan_stockpile.name]. Also, there are some stockpiles of medical items and tools around the town.</span>"
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("medical", civ_stat())
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	return TRUE
