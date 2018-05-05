// the old RNG system made things worse and more predictable, lets try a new one - Kachnov
var/process/RNG/RNG_process = null

/process/RNG

/process/RNG/setup()
	name = "RNG"
	schedule_interval = 1 // every tenth second: 600 for a full minute
	start_delay = 10
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	RNG_process = src

/process/RNG/fire()
	SCHECK
	if (ticks && ticks % 600 == 0)
		var/seed = ticks + (ticks/(1000*1000))
		rand_seed(seed)