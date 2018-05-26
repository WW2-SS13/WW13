/process/lighting_overlays

/process/lighting_overlays/setup()
	name = "lighting overlays process"
	schedule_interval = 1 // every 1/10th second
	start_delay = 10
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	priority = PROCESS_PRIORITY_HIGH
	processes.lighting_overlays = src

/process/lighting_overlays/fire()

	for (current in lighting_update_overlays)
		if (!isDeleted(current))
			var/atom/movable/lighting_overlay/L = current
			L.update_overlay()
			L.needs_update = FALSE
			lighting_update_overlays -= L
		else
			catchBadType(current)
			lighting_update_overlays -= current

		PROCESS_TICK_CHECK

/process/lighting_overlays/reset_current_list()
	return