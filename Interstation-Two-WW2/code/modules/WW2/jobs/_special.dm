/proc/check_for_german_train_conductors()
	if (!game_started)
		return 1 // if we haven't started the game yet
	if (initial(mercy_period) && mercy_period)
		return 1 // if we started with a mercy period and we're still in that
	for (var/mob/living/carbon/human/H in world)
		var/cont = 0
		if (locate(/obj/item/weapon/key/german/train) in H)
			cont = 1
		for (var/obj/item/clothing/clothing in H)
			if (locate(/obj/item/weapon/key/german/train) in clothing)
				cont = 1
				break
		if (cont)
			if (H.stat == CONSCIOUS && H.mind.assigned_job.team == "GERMAN")
				return 1 // found a conscious german dude with the key
	return 0

/datum/job/german
	uses_keys = 1
	team = "GERMAN"

/datum/job/russian
	uses_keys = 1
	team = "RUSSIAN"


/proc/get_side_name(var/side, var/datum/job/j)
	if (j && (istype(j, /datum/job/german/squad_leader_ss) || istype(j, /datum/job/german/soldier_ss)))
		return "Waffen-S.S."
	if(side == CIVILIAN)
		return "Civilian"
	if(side == RUFORCE)
		return "Red Army"
	if(side == GEFORCE)
		return "German Wehrmacht"
	return null

// here's a story
// the lines to give people radios and harnesses are really long and go off screen like this one
// and I got tired of constantly having to readd radios because merge conflicts
// so now there's this magical function that equips a human with a radio and harness
//	- Kachnov
/mob/living/carbon/human/proc/give_radio()
	equip_to_slot_or_del(new /obj/item/clothing/suit/radio_harness(src), slot_wear_suit)
	if (!istype(original_job, /datum/job/russian))
		equip_to_slot_or_del(new /obj/item/device/radio/feldfu(src), slot_s_store)
	else
		equip_to_slot_or_del(new /obj/item/device/radio/rbs(src), slot_s_store)

	src << "<span class = 'notice'><b>You have a radio in your suit storage. To use it, prefix your message with ':b'.</b></span>"