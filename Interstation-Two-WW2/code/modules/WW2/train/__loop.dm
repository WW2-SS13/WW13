/proc/start_train_loop()
	german_train_master = new/datum/train_controller/german_train_controller()
	german_supplytrain_master = new/datum/train_controller/german_supplytrain_controller()

	spawn while (1)
		german_train_master.Process()
		german_train_master.sound_loop()
		// new system. movement will be smoother, but possibly laggy
		german_supplytrain_master.Process()
		german_supplytrain_master.sound_loop()

		sleep (round(8/german_train_master.velocity))


