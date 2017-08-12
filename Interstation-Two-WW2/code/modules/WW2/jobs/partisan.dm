/datum/job/partisan

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

/datum/job/partisan/civilian
	title = "Civilian"
	total_positions = 5
	spawn_positions = 5
	selection_color = "#530909"
	spawn_location = "JoinLateCivilian"

/datum/job/partisan/civilian/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	equip_random_uniform(H)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a simple civilian trying to live his life in the warzone. Survive.</span>"
	return 1

/datum/job/partisan/soldier
	title = "Partisan Soldier"
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	selection_color = "#530909"
	spawn_location = "JoinLatePartisan"

/datum/job/partisan/soldier/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	equip_random_uniform(H)
	if (prob(40))
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/material/knife/combat(H), slot_r_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a partisan soldier. You take orders from the <b>Partisan Leader</b> alone.</span>"
	H << "<br><span class = 'warning'>You have a stockpile of weapons at [partisan_stockpile.name]. Also, there are some stockpiles of medical items and tools around the town.</span>"
	return 1

/datum/job/partisan/commander
	title = "Partisan Commander"
	is_officer = 1
	is_commander = 1
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	head_position = 1
	selection_color = "#2d2d63"
	spawn_location = "JoinLatePartisanLeader"
	additional_languages = list( "Russian" = 100, "German" = 100)

/datum/job/partisan/commander/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	equip_random_uniform(H)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, the leader of the partisan forces in the town. Protect your men and the civilians!</span>"
	H << "<br><span class = 'warning'>You have a stockpile of weapons at [partisan_stockpile.name]. Also, there are some stockpiles of medical items and tools around the town.</span>"
	return 1
