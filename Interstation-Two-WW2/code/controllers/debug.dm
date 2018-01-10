/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/client/proc/debug_controller(controller in list("processScheduler", "World", "Master","Ticker","Ticker Process", "Garbage", "Jobs","Mob","Obj","Zoom", "Configuration","Nano","Chemistry","Observation","Primary German Train", "German Supply Train", "Russian Supply Lift", "Whitelists", "Game Schedule", "Reinforcements Controller"))
	set category = "Debug"
	set name = "Debug Controller/GlobalObjects"
	set desc = "Debug various objects and loops for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if ("processScheduler")
			if (processScheduler)
				debug_variables(processScheduler)

		if("World")
			debug_variables(world)

		if("Master")
			debug_variables(master_controller)

		if("Ticker")
			debug_variables(ticker)

		if("Ticker Process")
			debug_variables(tickerProcess)

		if ("Garbage")
			debug_variables(garbage_collector)

		if("Jobs")
			debug_variables(job_master)

		if ("Mob")
			debug_variables(mob_process)

		if ("Obj")
			debug_variables(obj_process)

	//	if ("Zoom")
	//		debug_variables(zoom_process)

		if("Configuration")
			debug_variables(config)

		if("Gas Data")
			debug_variables(gas_data)

		if("Nano")
			debug_variables(nanomanager)

		if("Chemistry")
			debug_variables(chemistryProcess)

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

		if ("Game Schedule")
			if (global_game_schedule)
				global_game_schedule.update()
				debug_variables(global_game_schedule)

		if ("Reinforcements Controller")
			if (reinforcements_master)
				debug_variables(reinforcements_master)

	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
