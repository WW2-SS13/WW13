/process/reinforcements

/process/reinforcements/setup()
	name = "reinforcements"
	schedule_interval = 10 // every second
	fires_at_gamestates = list(GAME_STATE_PLAYING)
	processes.reinforcements = src

/process/reinforcements/fire()
	SCHECK
	if (reinforcements_master && reinforcements_master.trytostartup())
		reinforcements_master.tick()