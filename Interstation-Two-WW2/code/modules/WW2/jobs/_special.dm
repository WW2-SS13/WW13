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