// new randomness proc that generates a new seed every call. sprob() and spick() use this
var/srand_calls = 0
/proc/srand(a, b)
	var/seed = (projectile_process && projectile_process.ticks) ? projectile_process.ticks : (world.realtime+round(world.time)+world.timeofday)
	seed += srand_calls
	++srand_calls
	rand_seed(seed)
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
