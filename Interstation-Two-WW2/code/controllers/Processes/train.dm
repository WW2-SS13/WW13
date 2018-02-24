var/datum/controller/process/train/train_process = null
var/supplytrain_may_process = FALSE

/datum/controller/process/train
	var/tmpTime = 0
	var/firstTmpTime = TRUE

/datum/controller/process/train/setup()
	name = "train process"
	schedule_interval = 10
	start_delay = 100
	train_process = src

/datum/controller/process/train/doWork()
	..()

	if (!map || map.uses_main_train || map.uses_supply_train)
		try
			normal_train_processes()
			tmpTime += schedule_interval
			if (tmpTime >= 1200 || firstTmpTime)
				tmpTime = 0
				supplytrain_may_process = TRUE // not sure how else to do this without breaking the process
			firstTmpTime = FALSE

		catch(var/exception/e)
			catchException(e)
		SCHECK