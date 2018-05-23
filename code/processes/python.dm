/process/python

/process/python/setup()
	name = "python"
	schedule_interval = 50 // every 5 seconds
	start_delay = 10
	fires_at_gamestates = list()
	processes.python = src

/process/python/fire()
	return

/process/python/proc/execute(var/command, var/list/args = list())
	for (var/argument in args)
		command = "[command] [argument]"
	log_debug("Executing python3 command '[command]'")
	return shell("cd && cd WW13/scripts && sudo python3 [command]")
