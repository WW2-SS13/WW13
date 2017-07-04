var/datum/train_controller/german_train_controller/german_train_master = null
var/datum/train_controller/russian_train_controller/russian_train_master = null

/proc/start_train_loop()
	german_train_master = new/datum/train_controller/german_train_controller()

	spawn while (1)
		german_train_master.Process()
		german_train_master.sound_loop()
		// new system. movement will be smoother, but possibly laggy
		sleep (round(8/german_train_master.velocity))
