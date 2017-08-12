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

/datum/job/var/allow_spies = 0
/datum/job/var/is_officer = 0
/datum/job/var/is_squad_leader = 0
/datum/job/var/is_commander = 0
/datum/job/var/is_nonmilitary = 0

/datum/job/proc/assign_faction(var/mob/living/carbon/human/user)

	if (!spies["GERMAN"])
		spies["GERMAN"] = 0
	if (!spies["RUSSIAN"])
		spies["RUSSIAN"] = 0
	if (!spies["PARTISAN"])
		spies["PARTISAN"] = 0

	if (!squad_leaders["GERMAN"])
		squad_leaders["GERMAN"] = 0
	if (!squad_leaders["RUSSIAN"])
		squad_leaders["RUSSIAN"] = 0
	if (!squad_leaders["PARTISAN"])
		squad_leaders["PARTISAN"] = 0

	if (!officers["GERMAN"])
		officers["GERMAN"] = 0
	if (!officers["RUSSIAN"])
		officers["RUSSIAN"] = 0
	if (!officers["PARTISAN"])
		officers["PARTISAN"] = 0

	if (!commanders["GERMAN"])
		commanders["GERMAN"] = 0
	if (!commanders["RUSSIAN"])
		commanders["RUSSIAN"] = 0
	if (!commanders["PARTISAN"])
		commanders["PARTISAN"] = 0

	if (!soldiers["GERMAN"])
		soldiers["GERMAN"] = 0
	if (!soldiers["RUSSIAN"])
		soldiers["RUSSIAN"] = 0
	if (!soldiers["PARTISAN"])
		soldiers["PARTISAN"] = 0


	if (!squad_members["GERMAN"])
		squad_members["GERMAN"] = 0
	if (!squad_members["RUSSIAN"])
		squad_members["RUSSIAN"] = 0
	if (!squad_members["PARTISAN"])
		squad_members["PARTISAN"] = 0

	if (!istype(user))
		return

	if (istype(src, /datum/job/german))

		if (istype(src, /datum/job/german/soldier_ss))
			user.base_job_faction = new/datum/job_faction/german/SS(user, src)
		else
			user.base_job_faction = new/datum/job_faction/german(user, src)

		if (is_officer && !is_commander)
			user.officer_job_faction = new/datum/job_faction/german/officer(user, src)

		else if (is_commander)
			if (istype(src, /datum/job/german/squad_leader_ss))
				user.officer_job_faction = new/datum/job_faction/german/commander/SS(user, src)
			else
				user.officer_job_faction = new/datum/job_faction/german/commander(user, src)

		if (is_squad_leader)
			switch (squad_leaders["GERMAN"])
				if (0)
					user.squad_job_faction = new/datum/job_faction/squad/one/leader(user, src)
				if (1)
					user.squad_job_faction = new/datum/job_faction/squad/two/leader(user, src)
				if (2)
					user.squad_job_faction = new/datum/job_faction/squad/three/leader(user, src)
				if (3)
					user.squad_job_faction = new/datum/job_faction/squad/four/leader(user, src)
		else if (!is_officer && !is_commander && !is_nonmilitary && !istype(src, /datum/job/german/soldier_ss))
			switch (squad_members["GERMAN"]) // non officers
				if (0 to 7-1)
					user.squad_job_faction = new/datum/job_faction/squad/one(user, src)
				if (8-1 to 14-1)
					user.squad_job_faction = new/datum/job_faction/squad/two(user, src)
				if (15-1 to 21-1)
					user.squad_job_faction = new/datum/job_faction/squad/three(user, src)
				if (22-1 to 28-1)
					user.squad_job_faction = new/datum/job_faction/squad/four(user, src)

	else if (istype(src, /datum/job/russian))
		user.base_job_faction = new/datum/job_faction/russian(user, src)

		if (is_officer && !is_commander)
			user.officer_job_faction = new/datum/job_faction/russian/officer(user, src)

		else if (is_commander)
			user.officer_job_faction = new/datum/job_faction/russian/commander(user, src)

		if (is_squad_leader)
			switch (squad_leaders["RUSSIAN"])
				if (0)
					user.squad_job_faction = new/datum/job_faction/squad/one/leader(user, src)
				if (1)
					user.squad_job_faction = new/datum/job_faction/squad/two/leader(user, src)
				if (2)
					user.squad_job_faction = new/datum/job_faction/squad/three/leader(user, src)
				if (3)
					user.squad_job_faction = new/datum/job_faction/squad/four/leader(user, src)
		else if (!is_officer && !is_commander && !is_nonmilitary)
			switch (squad_members["RUSSIAN"]) // non officers
				if (0 to 7-1)
					user.squad_job_faction = new/datum/job_faction/squad/one(user, src)
				if (8-1 to 14-1)
					user.squad_job_faction = new/datum/job_faction/squad/two(user, src)
				if (15-1 to 21-1)
					user.squad_job_faction = new/datum/job_faction/squad/three(user, src)
				if (22-1 to 28-1)
					user.squad_job_faction = new/datum/job_faction/squad/four(user, src)

	else if (istype(src, /datum/job/partisan))
		user.base_job_faction = new/datum/job_faction/partisan(user, src)
		if (is_officer && !is_commander)
			user.officer_job_faction = new/datum/job_faction/partisan/officer(user, src)
		else if (is_commander)
			user.officer_job_faction = new/datum/job_faction/partisan/commander(user, src)


/datum/job/proc/try_make_jew(var/mob/living/carbon/human/user)

	if (!istype(user))
		return

	if (!user.client.prefs.be_jew || !istype(src, /datum/job/german/soldier))
		return

	if (clients.len < -1) // too lowpop for jews! Todo: config setting
		return

	if (is_officer)
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

	if (clients.len < 25) // too lowpop for spies! Todo: config setting
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
		return "German"
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
		if (!H.languages.Find("Russian"))
			H.add_language("Russian")
		H.spy_job_faction = new/datum/job_faction/russian()
	else
		if (!H.languages.Find("German"))
			H.add_language("German")
		H.spy_job_faction = new/datum/job_faction/german()


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

	src << "<span class = 'notice'><b>You have a radio in your suit storage. To use it while on your back, prefix your message with ':b'.</b></span>"