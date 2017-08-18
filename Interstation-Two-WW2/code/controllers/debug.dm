/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/client/proc/debug_controller(controller in list("World", "Master","Ticker","Ticker Process","Jobs","Sun","Supply","Configuration", "Gas Data","Nano","Chemistry","Observation","Primary German Train", "German Supply Train", "Russian Supply Lift"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("World")
			debug_variables(world)

		if("Master")
			debug_variables(master_controller)

		if("Ticker")
			debug_variables(ticker)

		if("Ticker Process")
			debug_variables(tickerProcess)

		if("Jobs")
			debug_variables(job_master)

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

	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
