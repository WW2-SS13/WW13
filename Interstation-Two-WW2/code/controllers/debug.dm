/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

var/list/special_globalobjects = list("processScheduler", "Master", "Ticker", "Configuration", "Observation","Primary German Train", "German Supply Train", "Russian Supply Lift", "Whitelists", "Reinforcements Master", "Job Master")
/client/proc/debug_controller()
	set category = "Debug"
	set name = "Debug Controller/GlobalObjects"
	set desc = "Debug various objects and loops for the game (be careful!)"

	if(!holder)	return

	var/list/globals = special_globalobjects.Copy()
	for (var/controller in processScheduler.nameToProcessMap)
		if (!globals.Find(controller))
			globals += controller

	var/datum = input("Which datum?") in globals

	switch(datum)

		if ("processScheduler")
			if (processScheduler)
				debug_variables(processScheduler)

		if ("Master")
			debug_variables(master_controller)

		if ("Ticker")
			debug_variables(ticker)

		if ("Configuration")
			debug_variables(config)

		if("Observation")
			debug_variables(all_observable_events)

		if ("Primary German Train")
			if (!german_train_master)
				src << "<span class = 'danger'>This object doesn't exist.</span>"
				return
			debug_variables(german_train_master)

		if ("German Supply Train")
			if (!german_supplytrain_master)
				src << "<span class = 'danger'>This object doesn't exist.</span>"
				return
			debug_variables(german_supplytrain_master)

		if ("Russian Supply Lift")
			var/which = input("Top or bottom?") in list("Top", "Bottom")
			if (which == "Top")
				for (var/obj/lift_controller/down/soviet/lift in world)
					debug_variables(lift)
					return
			else
				for (var/obj/lift_controller/up/soviet/lift in world)
					debug_variables(lift)
					return

		if ("Whitelists")
			var/which = input("Which whitelist?") in global_whitelists
			var/datum/whitelist/W = global_whitelists[which]
			if (W && istype(W))
				debug_variables(W)

		if ("Reinforcements Master")
			if (reinforcements_master)
				debug_variables(reinforcements_master)

		if ("Job Master")
			if (job_master)
				debug_variables(job_master)

		else
			log_debug(datum)
			debug_variables(processScheduler.nameToProcessMap[datum])

	message_admins("Admin [key_name_admin(usr)] is debugging the [datum] controller.")
	return
