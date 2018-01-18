var/train_loop_interval = -1
var/next_supplytrain_message = -1
var/supplytrain_interval = 1200 // todo: config setting

/proc/start_train_loop()

	world << "<span class = 'notice'>Setting up the train system.</span>"
	german_train_master = new/datum/train_controller/german_train_controller()
	german_supplytrain_master = new/datum/train_controller/german_supplytrain_controller()

	spawn while (1)
		// main train
		german_train_master.Process()

		if (german_train_master.moving)
			german_train_master.sound_loop()

		// supply train
		german_supplytrain_master.Process()

		if (german_supplytrain_master.moving)
			german_supplytrain_master.sound_loop()

		train_loop_interval = round(8/german_train_master.velocity)

		sleep (train_loop_interval)


	spawn while (1)
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
					german_supplytrain_master.announce("The Supply Train is either occupied by a person, has a person standing in its way, or has not had its crates unloaded. Its departure has been delayed until this condition is solved.")
					next_supplytrain_message = world.time + 600
				goto skipmovement

			switch (german_supplytrain_master.direction)
				if ("FORWARDS")
					german_supplytrain_master.direction = "BACKWARDS"
					german_supplytrain_master.announce("The Supply Train is now departing from the armory. It will arrive again in [supplytrain_interval/600] minutes.")
					if (!german_supplytrain_master.invisible)
						german_supplytrain_master.update_invisibility(1)
					german_supplytrain_master.here = FALSE
				if ("BACKWARDS")
					german_supplytrain_master.direction = "FORWARDS"
					german_supplytrain_master.announce("The Supply Train is now arriving at the armory. It will depart in [supplytrain_interval/600] minutes.")
					if (german_supplytrain_master.invisible)
						german_supplytrain_master.update_invisibility(0)
					german_supplytrain_master.here = TRUE

			german_supplytrain_master.moving = TRUE

		skipmovement

		sleep (rand(supplytrain_interval-100, supplytrain_interval+100)) // around every three minutes