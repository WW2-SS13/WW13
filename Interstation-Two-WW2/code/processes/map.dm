/process/map

/process/map/setup()
	name = "map process"
	schedule_interval = 20 // every 2 seconds
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	processes.map = src

/process/map/fire()
	SCHECK
	if (map)
		map.tick()