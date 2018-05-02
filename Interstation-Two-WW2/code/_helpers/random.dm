// new randomness proc that generates a new seed every call. sprob() and spick() use this

/* a couple very important things that you should know about this proc:
  * world.time can be a decimal, that's why its rounded, it might not make a difference
  * The projectile_process is used because it ticks every 1/100th second = many unique seeds
  * The original formula for pre-projectile-process srand() was realtime+time+timeofday. For an unknown reason,
  * this caused pre-projectile-process randomness to get fucked, but only on the server, not locally.
  * Out of a list of 41 tips, the 17th tip (field strip one) was always selected, no matter what, round after round
  * This is inexplicable but it seems to be fixed since I changed the formula. Maybe something about the server's
  * OS at the time (Ubuntu 16) and BYOND wasn't compatible with calling rand_seed on such a huge number?
  * Who knows. So, basically, don't use world.realtime in the srand() formula if you change it - Kachnov */

// update: rand_seed() is now called no more than once a second, experimental - Kachnov

var/srand_calls = 0
var/next_rand_seed = -1

/proc/srand(a, b)
	if (world.time >= next_rand_seed)
		var/seed = (round(world.time)+world.timeofday)+(projectile_process ? projectile_process.ticks : 0)+srand_calls
		++srand_calls
		rand_seed(seed)
		next_rand_seed = world.time + 10
	return rand(a, b)

// new probability. Only accurate with whole numbers
/proc/sprob(x)
	return ceil(x) >= srand(1,100)

// new pick()
/proc/spick()
	switch (args.len)
		if (0)
			return null
		if (1)
			return spick_list(args[1])
		if (2 to INFINITY)
			var/_tmp = list()
			for (var/x in args)
				_tmp += x
			return spick_list(_tmp)

/proc/spick_list(var/list/L)
	if (!L || !istype(L) || !L.len)
		return null
	return L[srand(1, L.len)]
