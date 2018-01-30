var/datum/controller/process/battlereport/battlereport

/datum/controller/process/battlereport
	var/BR_ticks = 0
	var/max_BR_ticks = 600 // 10 minutes

/datum/controller/process/battlereport/setup()
	name = "Battle Report"
	schedule_interval = 10 // every second
	battlereport = src

/datum/controller/process/battlereport/statProcess()
	..()
	stat(null, "Next battle report: [max_BR_ticks - BR_ticks] seconds")

/datum/controller/process/battlereport/doWork()
	++BR_ticks
	if (BR_ticks >= max_BR_ticks)
		show_global_battle_report(null)
		BR_ticks = 0