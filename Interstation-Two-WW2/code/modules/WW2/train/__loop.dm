var/train_loop_interval = -1
var/next_supplytrain_message = -1
var/next_german_supplytrain_master_process = -1

/proc/setup_trains()
	spawn (1)
		world << "<span class = 'notice'>Setting up the train system.</span>"
	german_train_master = new/datum/train_controller/german_train_controller()
	german_supplytrain_master = new/datum/train_controller/german_supplytrain_controller()
	train_process.schedule_interval = round(8/german_train_master.velocity)

/proc/train_loop()
	spawn while (1)
		if (supplytrain_may_process)
			supplytrain_may_process = FALSE
			supplytrain_processes()
		sleep (50)

/proc/normal_train_processes()

	// main train
	german_train_master.Process()

	if (german_train_master.moving)
		german_train_master.sound_loop()

	// supply train
	if (world.realtime > next_german_supplytrain_master_process)
		german_supplytrain_master.Process()
		if (prob(1) && prob(2) && !german_supplytrain_master.here)
			radio2germans("The Supply Train has broken down. It will not be functional for ten minutes.", "Supply Train Announcement System")
			next_german_supplytrain_master_process = world.realtime + 5400

	if (german_supplytrain_master.moving)
		german_supplytrain_master.sound_loop()

/proc/supplytrain_processes()

	if (next_german_supplytrain_master_process > world.realtime)
		return

	// make us visible if we're docking at the armory
	// make us invisible if we're leaving

	if (!german_supplytrain_master.moving)

		var/stopthetrain = FALSE

		for (var/obj/train_car_center/tcc in german_supplytrain_master.train_car_centers)
			for (var/obj/train_pseudoturf/tpt in tcc.forwards_pseudoturfs)
				if (locate(/obj/structure/closet/crate) in get_turf(tpt))
					if (german_supplytrain_master.direction == "FORWARDS")
						stopthetrain = TRUE
						break

		for (var/mob/living/m in living_mob_list)
			if (m.stat != DEAD)
				if (!istype(m.loc, /obj/structure/largecrate)) // puppers
					if (istype(get_area(m), /area/prishtina/german/armory/train))
						stopthetrain = TRUE
						break

		if (stopthetrain)
			if (world.time > next_supplytrain_message)
				radio2germans("The Supply Train is either occupied by a person, has a person standing in its way, or has not had its crates unloaded. Its departure has been delayed until this condition is solved.", "Supply Train Announcement System")
				next_supplytrain_message = world.time + 600
			goto skipmovement

		switch (german_supplytrain_master.direction)
			if ("FORWARDS")
				german_supplytrain_master.direction = "BACKWARDS"
				radio2germans("The Supply Train is departing from the armory. It will arrive again in 2 minutes.", "Supply Train Announcement System")
				if (!german_supplytrain_master.invisible)
					german_supplytrain_master.update_invisibility(1)
				german_supplytrain_master.here = FALSE
			if ("BACKWARDS")
				german_supplytrain_master.direction = "FORWARDS"
				radio2germans("The Supply Train is arriving at the armory. It will depart in 2 minutes.", "Supply Train Announcement System")
				if (german_supplytrain_master.invisible)
					german_supplytrain_master.update_invisibility(0)
				german_supplytrain_master.here = TRUE

		german_supplytrain_master.moving = TRUE

	skipmovement