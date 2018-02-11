/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/client/proc/debug_controller(controller in list("processScheduler", "Master","Ticker", "Configuration", "Observation","Primary German Train", "German Supply Train", "Russian Supply Lift", "Whitelists", "Reinforcements Master", "Job Master") + processScheduler.nameToProcessMap)
	set category = "Debug"
	set name = "Debug Controller/GlobalObjects"
	set desc = "Debug various objects and loops for the game (be careful!)"

	if(!holder)	return

	switch(controller)
		if ("processScheduler")
			if (processScheduler)
				debug_variables(processScheduler)

		else if("Master")
			debug_variables(master_controller)

		else if("Ticker")
			debug_variables(ticker)

		else if("Configuration")
			debug_variables(config)

		else if("Observation")
			debug_variables(all_observable_events)

		else if ("Primary German Train")
			if (!german_train_master)
				src << "<span class = 'danger'>This object doesn't exist.</span>"
				return
			debug_variables(german_train_master)

		else if ("German Supply Train")
			if (!german_supplytrain_master)
				src << "<span class = 'danger'>This object doesn't exist.</span>"
				return
			debug_variables(german_supplytrain_master)

		else if ("Russian Supply Lift")
			var/which = input("Top or bottom?") in list("Top", "Bottom")
			if (which == "Top")
				for (var/obj/lift_controller/down/soviet/lift in world)
					debug_variables(lift)
					return
			else
				for (var/obj/lift_controller/up/soviet/lift in world)
					debug_variables(lift)
					return

		else if ("Whitelists")
			var/which = input("Which whitelist?") in global_whitelists
			var/datum/whitelist/W = global_whitelists[which]
			if (W && istype(W))
				debug_variables(W)

		else if ("Reinforcements Master")
			if (reinforcements_master)
				debug_variables(reinforcements_master)

		else if ("Job Master")
			if (job_master)
				debug_variables(job_master)

		else if (processScheduler.nameToProcessMap.Find(controller))
			if (processScheduler.nameToProcessMap[controller])
				debug_variables(processScheduler.nameToProcessMap[controller])


	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
