/datum/controller/process/game_schedule

/datum/controller/process/game_schedule/setup()
	name = "game schedule updater"
	schedule_interval = 100 // every 10 seconds
	start_delay = 50 // not vital

/datum/controller/process/game_schedule/started()
	..()
	if (!global_game_schedule)
		global_game_schedule = new

/datum/controller/process/game_schedule/doWork()
	if (global_game_schedule)
		global_game_schedule.update()
	SCHECK