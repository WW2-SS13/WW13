/datum/game_schedule
	var/starttime = -1
	var/endtime = -1

/datum/game_schedule/New(starttime, endttime)
	establish_db_connection()
	if (!database)
		return
