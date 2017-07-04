/proc/flog(x, file)
	if (config.debug)
		world << "<span class = 'danger'>[x]</span>"
	var/last_log = world.log
	if (!file)
		world.log = file("flog.txt")
	else
		world.log = file("[file].txt")
	world.log << x
	world.log = last_log