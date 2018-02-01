var/global/datum/controller/process/ticker/reinforcements_process

/datum/controller/process/reinforcements

/datum/controller/process/reinforcements/setup()
	name = "reinforcements"
	schedule_interval = 10 // every second
	reinforcements_process = src

/datum/controller/process/reinforcements/doWork()
	if (reinforcements_master && reinforcements_master.trytostartup())
		reinforcements_master.tick()