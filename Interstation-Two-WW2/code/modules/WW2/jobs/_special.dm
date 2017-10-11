/proc/check_for_german_train_conductors()
	if (!game_started)
		return 1 // if we haven't started the game yet
	if (initial(grace_period) == grace_period)
		return 1 // if we started with a grace period and we're still in that
	for (var/mob/living/carbon/human/H in world)
		var/cont = 0
		if (locate(/obj/item/weapon/key/german/train) in H)
			cont = 1
		for (var/obj/item/clothing/clothing in H)
			if (locate(/obj/item/weapon/key/german/train) in clothing)
				cont = 1
				break
		if (cont)
			if (H.stat == CONSCIOUS && H.mind.assigned_job.base_type_flag() == GERMAN)
				return 1 // found a conscious german dude with the key
	return 0

/datum/job/var/allow_spies = 0
/datum/job/var/is_officer = 0
/datum/job/var/is_squad_leader = 0
/datum/job/var/is_commander = 0
/datum/job/var/is_nonmilitary = 0
/datum/job/var/spawn_delay = 0
/datum/job/var/delayed_spawn_message = ""
/datum/job/var/is_SS = 0
/datum/job/var/is_primary = 1
/datum/job/var/is_secondary = 0
/datum/job/var/is_paratrooper = 0
/datum/job/var/is_sturmovik = 0
/datum/job/var/is_guard = 0
/datum/job/var/is_tankuser = 0
/datum/job/var/absolute_limit = 0 // if this is 0 it's ignored

// type_flag() replaces flag, and base_type_flag() replaces department_flag
// this is a better solution than bit constants, in my opinion

/datum/job/proc/type_flag()
	return "[type]"

/datum/job/proc/base_type_flag()
	if (istype(src, /datum/job/russian))
		return RUSSIAN
	else if (istype(src, /datum/job/partisan))
		if (istype(src, /datum/job/partisan/civilian))
			return CIVILIAN
		return PARTISAN
	else if (istype(src, /datum/job/german))
		return GERMAN

/datum/job/proc/get_side_name()
	return capitalize(lowertext(base_type_flag()))

/datum/job/proc/assign_faction(var/mob/living/carbon/human/user)

	if (!spies[GERMAN])
		spies[GERMAN] = 0
	if (!spies[RUSSIAN])
		spies[RUSSIAN] = 0
	if (!spies[PARTISAN])
		spies[PARTISAN] = 0

	if (!squad_leaders[GERMAN])
		squad_leaders[GERMAN] = 0
	if (!squad_leaders[RUSSIAN])
		squad_leaders[RUSSIAN] = 0
	if (!squad_leaders[PARTISAN])
		squad_leaders[PARTISAN] = 0

	if (!officers[GERMAN])
		officers[GERMAN] = 0
	if (!officers[RUSSIAN])
		officers[RUSSIAN] = 0
	if (!officers[PARTISAN])
		officers[PARTISAN] = 0

	if (!commanders[GERMAN])
		commanders[GERMAN] = 0
	if (!commanders[RUSSIAN])
		commanders[RUSSIAN] = 0
	if (!commanders[PARTISAN])
		commanders[PARTISAN] = 0

	if (!soldiers[GERMAN])
		soldiers[GERMAN] = 0
	if (!soldiers[RUSSIAN])
		soldiers[RUSSIAN] = 0
	if (!soldiers[PARTISAN])
		soldiers[PARTISAN] = 0


	if (!squad_members[GERMAN])
		squad_members[GERMAN] = 0
	if (!squad_members[RUSSIAN])
		squad_members[RUSSIAN] = 0
	if (!squad_members[PARTISAN])
		squad_members[PARTISAN] = 0

	if (!istype(user))
		return

	if (istype(src, /datum/job/german))

		if (istype(src, /datum/job/german/soldier_ss))
			user.base_faction = new/datum/faction/german/SS(user, src)
		else
			user.base_faction = new/datum/faction/german(user, src)

		if (is_officer && !is_commander)
			user.officer_faction = new/datum/faction/german/officer(user, src)

		else if (is_commander)
			if (istype(src, /datum/job/german/squad_leader_ss))
				user.officer_faction = new/datum/faction/german/commander/SS(user, src)
			else
				user.officer_faction = new/datum/faction/german/commander(user, src)

		if (is_squad_leader)
			switch (squad_leaders[GERMAN])
				if (0)
					user.squad_faction = new/datum/faction/squad/one/leader(user, src)
				if (1)
					user.squad_faction = new/datum/faction/squad/two/leader(user, src)
				if (2)
					user.squad_faction = new/datum/faction/squad/three/leader(user, src)
				if (3)
					user.squad_faction = new/datum/faction/squad/four/leader(user, src)
		else if (!is_officer && !is_commander && !is_nonmilitary && !is_SS && !is_paratrooper && !is_guard && !is_tankuser)
			switch (squad_members[GERMAN]) // non officers
				if (0 to MEMBERS_PER_SQUAD-1)
					user.squad_faction = new/datum/faction/squad/one(user, src)
				if ((MEMBERS_PER_SQUAD) to (MEMBERS_PER_SQUAD*2)-1)
					user.squad_faction = new/datum/faction/squad/two(user, src)
				if ((MEMBERS_PER_SQUAD*2) to (MEMBERS_PER_SQUAD*3)-1)
					user.squad_faction = new/datum/faction/squad/three(user, src)
				if ((MEMBERS_PER_SQUAD*3) to (MEMBERS_PER_SQUAD*4)-1)
					user.squad_faction = new/datum/faction/squad/four(user, src)
				if ((MEMBERS_PER_SQUAD*4) to INFINITY) // latejoiners
					if (prob(50))
						if (prob(50))
							user.squad_faction = new/datum/faction/squad/one(user, src)
						else
							user.squad_faction = new/datum/faction/squad/two(user, src)
					else
						if (prob(50))
							user.squad_faction = new/datum/faction/squad/three(user, src)
						else
							user.squad_faction = new/datum/faction/squad/four(user, src)

	else if (istype(src, /datum/job/russian))
		user.base_faction = new/datum/faction/russian(user, src)

		if (is_officer && !is_commander)
			user.officer_faction = new/datum/faction/russian/officer(user, src)

		else if (is_commander)
			user.officer_faction = new/datum/faction/russian/commander(user, src)

		if (is_squad_leader)
			switch (squad_leaders[RUSSIAN])
				if (0)
					user.squad_faction = new/datum/faction/squad/one/leader(user, src)
				if (1)
					user.squad_faction = new/datum/faction/squad/two/leader(user, src)
				if (2)
					user.squad_faction = new/datum/faction/squad/three/leader(user, src)
				if (3)
					user.squad_faction = new/datum/faction/squad/four/leader(user, src)
		else if (!is_officer && !is_commander && !is_nonmilitary && !is_guard && !is_tankuser)
			switch (squad_members[RUSSIAN]) // non officers
				if (0 to 7-1)
					user.squad_faction = new/datum/faction/squad/one(user, src)
				if (8-1 to 14-1)
					user.squad_faction = new/datum/faction/squad/two(user, src)
				if (15-1 to 21-1)
					user.squad_faction = new/datum/faction/squad/three(user, src)
				if (22-1 to 28-1)
					user.squad_faction = new/datum/faction/squad/four(user, src)

	else if (istype(src, /datum/job/partisan))
		user.base_faction = new/datum/faction/partisan(user, src)
		if (is_officer && !is_commander)
			user.officer_faction = new/datum/faction/partisan/officer(user, src)
		else if (is_commander)
			user.officer_faction = new/datum/faction/partisan/commander(user, src)


/datum/job/proc/try_make_jew(var/mob/living/carbon/human/user)

	if (!istype(user))
		return

	if (!user.client.prefs.be_jew || !istype(src, /datum/job/german/soldier))
		return

	if (!job_master.allow_jews)
		return

	if (is_officer)
		return

	if (clients.len < config.min_players_for_jews && !config.debug) // too lowpop for spies! Todo: config setting
		return

	user << "<span class = 'danger'>You are the Jew.</span><br>"
	user << "<span class = 'notice'>Objective #1: Survive.</span>"

	user.add_memory("Jew Objectives")
	user.add_memory("")
	user.add_memory("")
	user.add_memory("Survive. Make sure nobody sees your face or knows your last name.")

	user.change_hair("Very Long Hair")
	user.change_facial_hair("Neckbeard")

	user.is_jew = 1

	user.real_name = user.species.get_random_german_name(user.gender, 1)
	user.name = user.real_name

// try to make someone a spy if they DONT spawn in a reinforcement wave
//: 12% chance for soldats only. Now 20% for German soldats,
// because Germans have so many more roles
/datum/job/proc/try_make_initial_spy(var/mob/living/carbon/human/user)

	if (!istype(user))
		return

	if (!user.client.prefs.be_spy)
		return

	if (!job_master.allow_spies)
		return

	if ((prob(20) && istype(src, /datum/job/german/soldier)) || (prob(12) && istype(src, /datum/job/russian/soldier)))
		if (allow_spies)
			make_spy(user)
			user.give_radio()
			return 1
	else
		if (prob(20)) // give 20% of soldats radios so it's not suspicious when spies get them
			user.give_radio()
	return 0

/datum/job/proc/try_make_latejoin_spy(var/mob/user)
	return //disabled

/datum/job/proc/opposite_faction_name()
	if (istype(src, /datum/job/german))
		return "Soviet"
	else
		return GERMAN
// make someone a spy regardless, allowing them to swap uniforms
/datum/job/proc/make_spy(var/mob/living/carbon/human/user)

	user << "<span class = 'danger'>You are the spy.</span><br>"
	user << "<span class = 'warning'>Sabotage your own team wherever possible. To change your uniform and radio to the [opposite_faction_name()] one, right click your uniform and use 'Swap'. You know both Russian and German; to change your language, use the IC tab.</span>"

	user.add_memory("Spy Objectives")
	user.add_memory("")
	user.add_memory("")
	user.add_memory("Sabotage your own team wherever possible. To change your uniform and radio to the [opposite_faction_name()] one, right click your uniform and use 'Swap'. You know both Russian and German; to change your language, use the IC tab.")

	user.is_spy = 1 // lets admins see who's a spy

	var/mob/living/carbon/human/H = user

	if (istype(H))
		var/obj/item/clothing/under/under = H.w_uniform
		if (under && istype(under))
			under.add_alternative_setting()

	if (istype(src, /datum/job/german))
		if (!H.languages.Find(RUSSIAN))
			H.add_language(RUSSIAN)
		H.spy_faction = new/datum/faction/russian()
	else
		if (!H.languages.Find(GERMAN))
			H.add_language(GERMAN)
		H.spy_faction = new/datum/faction/german()


/proc/get_side_name(var/side, var/datum/job/j)
	if (j && (istype(j, /datum/job/german/squad_leader_ss) || istype(j, /datum/job/german/soldier_ss)))
		return "Waffen-S.S."
	if(side == PARTISAN)
		return CIVILIAN
	if(side == RUSSIAN)
		return "Red Army"
	if(side == GERMAN)
		return "German Wehrmacht"
	return null

// here's a story
// the lines to give people radios and harnesses are really long and go off screen like this one
// and I got tired of constantly having to readd radios because merge conflicts
// so now there's this magical function that equips a human with a radio and harness
//	- Kachnov

/mob/living/carbon/human/var/gave_radio = 0

/mob/living/carbon/human/proc/give_radio()

	if (gave_radio)
		return

	gave_radio = 1

	spawn (1)

		// we already have something that holds radios
		if (!original_job.is_paratrooper && !original_job.is_sturmovik && !(original_job.is_SS && !original_job.is_commander))
			equip_to_slot_or_del(new /obj/item/clothing/suit/radio_harness(src), slot_wear_suit)

		spawn (0)
			if (istype(original_job, /datum/job/russian))
				equip_to_slot_or_del(new /obj/item/device/radio/rbs(src), slot_s_store)
			else if (istype(original_job, /datum/job/german))
				equip_to_slot_or_del(new /obj/item/device/radio/feldfu(src), slot_s_store)
			else if (istype(original_job, /datum/job/partisan))
				equip_to_slot_or_del(new /obj/item/device/radio/partisan(src), slot_s_store)

		src << "<span class = 'notice'><b>You have a radio in your suit storage. To use it while its on your back, prefix your message with ':b'.</b></span>"