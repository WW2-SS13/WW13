var/datum/controller/process/movement/movement_process = null

/datum/controller/process/movement
	var/last_move_attempt[1000]

/datum/controller/process/movement/setup()
	name = "mob movement"
	schedule_interval = 0.1
	start_delay = 10
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	movement_process = src
	DO_INTERNAL_SUBSYSTEM(src)

/datum/controller/process/movement/doWork()
	for(last_object in mob_list)

		var/mob/M = last_object

		if(isnull(M))
			continue

		if(last_move_attempt[M.ckey] && (world.time - last_move_attempt[M.ckey]) == 0)
			continue

		if (!M.movement_process_dir)
			continue

		if(!M.client)
			continue

		if(isnull(M.gcDestroyed))
			try
				last_move_attempt[M.ckey] = world.time
				M.client.Move(get_step(M, M.movement_process_dir), M.movement_process_dir)
			catch(var/exception/e)
				catchException(e, M)
		else
			catchBadType(M)
			mob_list -= M

/datum/controller/process/movement/statProcess()
	..()
	stat(null, "[mob_list.len] mobs")

/datum/controller/process/mob/htmlProcess()
	return ..() + "[mob_list.len] mobs"