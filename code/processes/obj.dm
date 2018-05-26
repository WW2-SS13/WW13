/process/obj/setup()
	name = "obj"
	schedule_interval = 20 // every 2 seconds
	start_delay = 8
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	priority = PROCESS_PRIORITY_MEDIUM
	processes.obj = src

/process/obj/fire()
	for (current in current_list)
		var/obj/O = current
		if (!isDeleted(O))
			try
				O.process()
			catch(var/exception/e)
				catchException(e, O)
		else
			catchBadType(O)
			processing_objects -= O

		current_list -= current
		PROCESS_TICK_CHECK

/process/obj/reset_current_list()
	if (current_list)
		current_list = null
	current_list = processing_objects.Copy()

/process/obj/statProcess()
	..()
	stat(null, "[processing_objects.len] objects in the vital loop")

/process/obj/htmlProcess()
	return ..() + "[processing_objects.len] objects in the vital loop"