/datum/job/ukrainian
	faction = "Station"

/* Soldier */

/datum/job/ukrainian/soldier
	title = "ukrainian Soldier" // WIP
	en_meaning = "ukrainian Infantry Soldier"
	total_positions = 5
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer" // WIP

/datum/job/ukrainian/soldier/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, an ukrainian infantry unit assisting the Wehrmacht. Your job is to participate in front line combat.</span>"
	return TRUE

/datum/job/ukrainian/soldier/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)

/* Medic */

/datum/job/ukrainian/medic
	title = "Ukrainian Medic" // WIP
	en_meaning = "Medic"
	total_positions = 5
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer" // WIP

/datum/job/ukrainian/medic/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/doctor_handbook(H), slot_l_store)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a medic. Your job is to keep your squad healthy and in good condition.</span>"
	H.give_radio()
	return TRUE

/datum/job/ukrainian/medic/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/medic)

/* Squad Leader/Commander */

/datum/job/ukrainian/squad_leader
	title = "SS-Untersharffuhrer" // WIP
	en_meaning = "ukrainian Squad Leader"
	total_positions = TRUE
	head_position = TRUE
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateSS-Officer" // WIP
	additional_languages = list( "German" = 100, "Russian" = 10)
	is_officer = TRUE
	is_commander = TRUE // not a squad leader despite the title
	is_petty_commander = TRUE

/datum/job/ukrainian/squad_leader/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/ssuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/akm(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a squad leader for the ukrainian unit fighting alongside the Wehrmacht. Your job is to work alongside <b>Gruppenfuhrer</b>s and the <b>Feldwebel</b> to defeat the Russians.</span>"
	H.give_radio()
	return TRUE

/datum/job/ukrainian/squad_leader/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat,
		new/obj/item/weapon/key/german/command_intermediate, new/obj/item/weapon/key/german/SS)