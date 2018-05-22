// WIP, currently unused so it probably doesn't work
/process/python

/process/python/setup()
	name = "python"
	schedule_interval = 50 // every 5 seconds
	start_delay = 10
	fires_at_gamestates = list()
	processes.python = src

/process/python/fire()
	return

/process/python/proc/execute(var/script, var/args, var/scriptsprefix = TRUE)
	if(scriptsprefix) script = "scripts/" + script

	if(world.system_type == MS_WINDOWS)
		script = replacetext(script, "/", "\\")

	var/command = script + " " + args

	return shell(command)
