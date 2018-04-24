var/global/process/supply/supplyProcess

/process/supply

/process/supply/setup()
	name = "supply points"
	schedule_interval = 20 // every 2 seconds
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	supplyProcess = src

/process/supply/fire()
	SCHECK

	if (!map)
		return

	if (german_supplytrain_master)
		german_supplytrain_master.supply_points += map.supply_points_per_tick[GERMAN]
	else
		supply_points[GERMAN] += map.supply_points_per_tick[GERMAN]

	supply_points[SOVIET] += map.supply_points_per_tick[SOVIET]