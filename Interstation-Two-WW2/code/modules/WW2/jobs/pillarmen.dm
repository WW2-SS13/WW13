/datum/job/pillarman
	faction = "Station"

/datum/job/pillarman/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_ukrainian_name(H.gender)
	H.real_name = H.name

/datum/job/pillarman/pillarman
	title = "Pillar Man"
	en_meaning = ""
	total_positions = 3
	selection_color = "#4c4ca5"
	spawn_location = "JoinLatePillarMan"

/datum/job/pillarman/pillarman/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/stone(H), slot_r_hand)
	equip_random_civilian_clothing(H)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a fucking PILLAR MAN. You have a stone mask. Make humans wear it to turn them into Vampires.</span>"
	return TRUE

/datum/job/pillarman/vampire
	title = "Vampire"
	en_meaning = ""
	total_positions = 9
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateVampire"

/datum/job/pillarman/vampire/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	equip_random_civilian_clothing(H)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a fucking VAMPIRE. Listen to the Pillar Men. Wryyy.</span>"
	return TRUE
