var/process/obj/obj_process = null

/process/obj/setup()
	name = "obj"
	schedule_interval = 20 // every 2 seconds
	start_delay = 8
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	obj_process = src

/process/obj/fire()
	SCHECK
	for(last_object in processing_objects)
		var/obj/O = last_object
		if(isnull(O.gcDestroyed))
			try
				O.process()
			catch(var/exception/e)
				catchException(e, O)
		else
			catchBadType(O)
			processing_objects -= O
		SCHECK

/process/obj/statProcess()
	..()
	stat(null, "[processing_objects.len] objects in the vital loop")

/process/obj/htmlProcess()
	return ..() + "[processing_objects.len] objects in the vital loop"