var/process/client/client_process = null

/process/client
	var/list/logged_next_normal_respawns[500] // stop people from logging off to reset respawn delay

/process/client/setup()
	name = "client"
	schedule_interval = 50 // every 5 seconds
	start_delay = 10
	fires_at_gamestates = list()
	client_process = src

/process/client/fire()
	return