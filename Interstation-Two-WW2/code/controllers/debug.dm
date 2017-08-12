/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/client/proc/debug_controller(controller in list("World", "Master","Ticker","Ticker Process","Air","Jobs","Sun","Radio","Supply","Shuttles","Emergency Shuttle","Configuration","pAI", "Cameras", "Transfer Controller", "Gas Data","Event","Plants","Alarm","Nano","Chemistry","Wireless","Observation","German Train System", "Russian Train System"))
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

		if("Air")
			debug_variables(air_master)

		if("Jobs")
			debug_variables(job_master)


		if("Radio")
			debug_variables(radio_controller)

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

		if ("German Train System")
			if (!german_train_master)
				src << "<span class = 'danger'>This object doesn't exist.</span>"
				return
			debug_variables(german_train_master)

		if ("Russian Train System")
			if (!russian_train_master)
				src << "<span class = 'danger'>This object doesn't exist.</span>"
				return
			debug_variables(russian_train_master)

	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
