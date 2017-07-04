var/datum/reinforcements/reinforcements_master


/proc/len(var/list/l)
	return l.len


/datum/reinforcements
	var/russian_countdown = 50
	var/german_countdown = 50

	var/tick_len = 1 // a decisecond

	// for now
	var/russian_countdown_failure_reset = 50
	var/german_countdown_failure_reset = 50

	var/russian_countdown_success_reset = 300
	var/german_countdown_success_reset = 300

	var/reinforcement_add_limit = 7

	var/reinforcement_spawn_req = 3

	var/reinforcement_difference_cutoff = 7 // once one side has this many more reinforcements than the other, lock it until that's untrue

	var/reinforcements_granted[2] // keep track of how many troops we've given to germans, how many to russians, for autobalance

	var/locked[2] // lock german or russian based on reinforcements_granted[]

	var/reinforcement_pool[2] // how many people are trying to join for each side

	var/allow_quickspawn[2]

/datum/reinforcements/New()
	..()

	if (config && config.debug)
		russian_countdown = 10
		german_countdown = 10
		russian_countdown_failure_reset = 10
		german_countdown_failure_reset = 10

	reinforcements_granted["RUSSIAN"] = 0
	reinforcements_granted["GERMAN"] = 0

	locked["RUSSIAN"] = 0
	locked["GERMAN"] = 0

	reinforcement_pool["RUSSIAN"] = list()
	reinforcement_pool["GERMAN"] = list()

	allow_quickspawn["RUSSIAN"] = 0
	allow_quickspawn["GERMAN"] = 0

	tick()


/datum/reinforcements/proc/is_ready()
	return game_started // no reinforcements until the train is sent

/datum/reinforcements/proc/tick()

	spawn while (1)

		if (reinforcement_pool["RUSSIAN"] && reinforcement_pool["GERMAN"])
			for (var/mob/new_player/np in reinforcement_pool["RUSSIAN"])
				if (!np || !np.client)
					reinforcement_pool["RUSSIAN"] -= np
			for (var/mob/new_player/np in reinforcement_pool["GERMAN"])
				if (!np || !np.client)
					reinforcement_pool["GERMAN"] -= np

		russian_countdown = russian_countdown - tick_len
		if (russian_countdown < 1)
			if (!reset_russian_timer())
				russian_countdown = russian_countdown_failure_reset
			else
				russian_countdown = russian_countdown_success_reset
				allow_quickspawn["RUSSIAN"] = 0

		german_countdown = german_countdown - tick_len
		if (german_countdown < 1)
			if (!reset_german_timer())
				german_countdown = german_countdown_failure_reset
			else
				german_countdown = german_countdown_success_reset
				allow_quickspawn["GERMAN"] = 0

		sleep(10)

/datum/reinforcements/proc/add(var/mob/new_player/np, side)

	var/nope[2]

	switch (side)
		if ("RUSSIAN")
			if (len(reinforcement_pool["RUSSIAN"]) >= reinforcement_add_limit)
				nope["RUSSIAN"] = 1
			else
				nope["RUSSIAN"] = 0
		if ("GERMAN")
			if (len(reinforcement_pool["GERMAN"]) >= reinforcement_add_limit)
				nope["GERMAN"] = 1
			else
				nope["GERMAN"] = 0

	if (locked[side])
		np << "<span class = 'danger'>This side is locked.</span>"
		return

	if (nope[side])
		np << "<span class = 'danger'>Too many people are attempting to join this side.</span>"
		return

	//remove them from all pools, just in case
	var/list/r = reinforcement_pool["RUSSIAN"]
	var/list/g = reinforcement_pool["GERMAN"]

	if (r.Find(np))
		r -= np
	if (g.Find(np))
		g -= np

	var/sname[0]

	sname["RUSSIAN"] = "the Russians"
	sname["GERMAN"] = "the Germans"

	np << "<span class = 'danger'>You joined the queue for the reinforcement group for [sname[side]], please wait.</span>"
	var/list/l = reinforcement_pool[side]
	l += np

/datum/reinforcements/proc/remove(var/mob/new_player/np, side)
	var/list/l = reinforcement_pool[side]
	if (l.Find(np))
		l -= np

/datum/reinforcements/proc/has(var/mob/new_player/np, side_or_null)

	if (side_or_null)
		var/side = side_or_null
		var/list/l = reinforcement_pool[side]
		if (l.Find(np))
			return 1
	else
		var/list/r = reinforcement_pool["RUSSIAN"]
		var/list/g = reinforcement_pool["GERMAN"]

		if (r.Find(np) || g.Find(np))
			return 1

	return 0

/datum/reinforcements/proc/reset_russian_timer()
	var/ret = 0
	var/list/l = reinforcement_pool["RUSSIAN"]
	if (l.len < reinforcement_spawn_req && !allow_quickspawn["RUSSIAN"])
		for (var/mob/new_player/np in l)
			l << "<span class='danger'>Failed to spawn a new Russian squadron. [reinforcement_spawn_req - l.len] more draftees needed."
		return 0
	for (var/mob/new_player/np in l)
		if (np)
			np.LateSpawnForced("Sovietsky Soldat", 1)
			reinforcements_granted["RUSSIAN"] = reinforcements_granted["RUSSIAN"]+1
			ret = 1
	reinforcement_pool["RUSSIAN"] = list()
	lock_check()
	world << "<font size=3>Fireteams report: New Russian squadron has been deployed.</font>"
	return ret

/datum/reinforcements/proc/reset_german_timer()
	var/ret = 0
	var/list/l = reinforcement_pool["GERMAN"]
	if (l.len < reinforcement_spawn_req && !allow_quickspawn["GERMAN"])
		for (var/mob/new_player/np in l)
			l << "<span class='danger'>Failed to spawn a new German squadron. [reinforcement_spawn_req - l.len] more draftees needed."
		return 0
	for (var/mob/new_player/np in l)
		if (np) // maybe helps with logged out nps
			np.LateSpawnForced("Soldat", 1)
			reinforcements_granted["GERMAN"] = reinforcements_granted["GERMAN"]+1
			ret = 1
	reinforcement_pool["GERMAN"] = list()
	lock_check()
	world << "<font size=3>Fireteams report: New German squadron has been deployed.</font>"
	return ret

/datum/reinforcements/proc/r_german()
	var/list/l = reinforcement_pool["GERMAN"]
	return l.len

/datum/reinforcements/proc/r_russian()
	var/list/l = reinforcement_pool["RUSSIAN"]
	return l.len

/datum/reinforcements/proc/lock_check()
	var/r = reinforcements_granted["RUSSIAN"]
	var/g = reinforcements_granted["GERMAN"]

	if (abs(r-g) >= reinforcement_difference_cutoff)

		if (max(r,g) == r)
			locked["RUSSIAN"] = 1
		else
			locked["GERMAN"] = 1

	else
		locked["RUSSIAN"] = 0
		locked["GERMAN"] = 0

/datum/reinforcements/proc/is_permalocked(side)
	switch (side)
		if ("GERMAN")
			if (reinforcements_granted["GERMAN"] > config.max_german_reinforcements)
				return 1
		if ("RUSSIAN")
			if (reinforcements_granted["RUSSIAN"] > config.max_german_reinforcements)
				return 1
	return 0

/datum/reinforcements/proc/get_status_addendums()

	var/list/l = list()
	l += "GERMAN REINFORCEMENTS:"
	l += "Deployed: [reinforcements_granted["GERMAN"]]"
	l += "Deploying: [r_german()]/[reinforcement_add_limit] in [german_countdown] seconds"
	l += "Locked: [locked["GERMAN"] ? "Yes" : "No"]"
	l += "RUSSIAN REINFORCEMENTS:"
	l += "Deployed: [reinforcements_granted["RUSSIAN"]]"
	l += "Deploying: [r_russian()]/[reinforcement_add_limit] in [russian_countdown] seconds"
	l += "Locked: [locked["RUSSIAN"] ? "Yes" : "No"]"

	return l

