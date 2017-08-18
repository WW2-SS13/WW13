var/datum/controller/process/battlereport/battlereport

/datum/controller/process/battlereport
	var/lastreport = -1
	var/nextreport = -1

/datum/controller/process/battlereport/setup()
	name = "Battle Report"
	schedule_interval = 6000 // every 10 minutes

/datum/controller/process/battlereport/statProcess()
	..()
	if (lastreport != -1 && nextreport != -1)
		stat(null, "Next battle report: ~[(nextreport - world.time)/600] minutes")
	else
		stat(null, "Next battle report: N/A")

/datum/controller/process/battlereport/doWork()
	lastreport = world.time
	nextreport = world.time + 6000
	show_global_battle_report()