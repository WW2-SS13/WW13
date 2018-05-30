// the old RNG system made things worse and more predictable, lets try a new one - Kachnov
/process/RNG

/process/RNG/setup()
	name = "RNG"
	schedule_interval = 0.1 SECONDS // every tenth second: 600 for a full minute
	start_delay = 1 SECOND
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	priority = PROCESS_PRIORITY_IRRELEVANT
	processes.RNG = src

/process/RNG/fire()
	if (ticks >= 100000)
		ticks = 600
	if (ticks && ticks % 600 == 0)
		var/seed = Square(ticks + (ticks/(100*1000)))
		rand_seed(seed)

/* tests that proves that probability is not "static" with a new rand_seed(), should output around 50 */
#define TESTS 100
/process/RNG/proc/test(var/prob = 50)
	var/tests = TESTS
	var/list/probtest = list()
	for (var/v in 1 to tests)
		if (prob(prob))
			probtest += "placeholder"
	log_debug("RNG_process.test() returned: [probtest.len]/[(prob/100) * tests]") // define TESTS can't go here

/process/RNG/proc/test2()
	log_debug(pick(list(1,2,3,4,5)))
#undef TESTS
