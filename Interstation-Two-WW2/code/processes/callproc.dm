/var/process/callproc/callproc_process = null

/process/callproc
	var/list/queue = list()
	var/list/helpers = list()

/process/callproc/setup()
	name = "callproc"
	schedule_interval = 0.3 // every 1/33th second
	start_delay = 10
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	callproc_process = src
	subsystem = TRUE

	for (var/v in 1 to 5000)
		helpers += new /callproc_helper

/process/callproc/fire()
	SCHECK

	for (current in queue)
		var/callproc_helper/C = current
		if (!C || !C.object || !C.function)
			queue -= C
			continue
		if (world.time >= C.time)
			if (hascall(C.object, C.function))
				var/arg1 = (C.args && C.args.len) ? C.args[1] : null
				if (arg1)
					call(C.object, C.function)(arg1) // > can't use arglist() proc here
				else
					call(C.object, C.function)()
			else
				log_debug("Callproc process callproc for a '[C.object]' failed because it didn't have the proc '[C.function]'")
			queue -= C
			helpers += C
		SCHECK

/process/callproc/proc/queue(object, function, args = null, time = 10)
	var/callproc_helper/C = helpers[1]
	C.object = object
	C.function = function
	C.args = args
	C.time = world.time + time
	helpers -= C
	queue += C

/callproc_helper
	parent_type = /datum
	var/object = null
	var/function = ""
	var/list/args = null
	var/time = -1