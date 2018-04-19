/proc/srand(a, b)
	rand_seed((projectile_process && projectile_process.ticks) ? projectile_process.ticks : world.realtime)
	return rand(a, b)

/proc/spick(var/list/L)
	rand_seed((projectile_process && projectile_process.ticks) ? projectile_process.ticks : world.realtime)
	if (!L || !istype(L) || !L.len)
		return null
	return pick(L)

/proc/sprob(x)
	return ceil(x) >= srand(1,100)