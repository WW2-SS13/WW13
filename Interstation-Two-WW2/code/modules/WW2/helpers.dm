/proc/message_germans(msg)
	for (var/mob/living/carbon/human/H in human_mob_list)
		if (H.stat == CONSCIOUS && H.original_job && H.original_job.base_type_flag() == GERMAN)
			if (H.client)
				H << msg

/proc/message_soviets(msg)
	for (var/mob/living/carbon/human/H in human_mob_list)
		if (H.stat == CONSCIOUS && H.original_job && H.original_job.base_type_flag() == SOVIET)
			if (H.client)
				H << msg

/proc/radio2germans(msg)
	var/obj/item/device/radio/R = main_radios[GERMAN]
	if (R && R.loc)
		spawn (3)
			R.announce(msg, "High Command Announcement System")
		return TRUE
	return FALSE

/proc/radio2soviets(msg)
	var/obj/item/device/radio/R = main_radios[SOVIET]
	if (R && R.loc)
		spawn (3)
			R.announce(msg, "High Command Announcement System")
		return TRUE
	return FALSE

/*
/turf/proc/check_prishtina_block(var/mob/m, var/actual_movement = FALSE)

	if (isobserver(m))
		return FALSE

	for (var/obj/prishtina_block/pb in src)
		if (!istype(pb, /obj/prishtina_block/attackers) && !istype(pb, /obj/prishtina_block/defenders))
			if (istype(pb, /obj/prishtina_block/singleton))
				if (grace_period)
					return TRUE
				return FALSE
		else
			if (istype(pb, /obj/prishtina_block/attackers))
				if (!game_started)
					return TRUE // if the game has not started, nobody passes. For benefit of attacking commanders/defenders - prevents ramboing, allows setting up
			else if (istype(pb, /obj/prishtina_block/defenders))
				if (grace_period)
					var/mob/living/carbon/human/H = m
					if (H && H.original_job && istype(H.original_job, /datum/job/german))
						/*if (actual_movement)
							if (!istype(H.original_job, /datum/job/german/paratrooper))
								list_of_germans_who_crossed_the_river |= H
								if (list_of_germans_who_crossed_the_river.len >= clients.len/4 && grace_period)
									world << "<span class = 'notice'><big>A number of Germans have crossed the river; the Grace Period has been ended early.</span>"
									grace_period = FALSE*/
						return FALSE // germans can pass
					return TRUE // if the grace period is active, nobody south of the river passes. For the benefit of attackers, so they get time to set up.
	return FALSE

/obj/prishtina_block
	icon = null
	icon_state = null
	density = TRUE
	anchored = 1.0
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	name = ""

	New()
		icon = null
		icon_state = null
		layer = -1000

	ex_act(severity)
		return FALSE

/obj/prishtina_block/attackers // block the Germans (or whoever is attacking) from attacking early
/obj/prishtina_block/defenders // block the Russian (or whoever is defending) from attacking early
/obj/prishtina_block/singleton // stop everyone from attacking for 5 minutes
*/