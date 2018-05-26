/process/menacing/setup()
	name = "menacing"
	schedule_interval = 50 // every 5 seconds
	start_delay = 50
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	priority = PROCESS_PRIORITY_MEDIUM
	processes.menacing = src

/process/menacing/fire()
	for (current in current_list)
		var/atom/A = current
		if (!isDeleted(A))
			try
				var/list/turfs = list(get_turf(A))
				for (var/turf/T in range(1, turfs[1]))
					turfs += T
				for (var/turf/T in turfs)
					if (prob(33))
						if (ismovable(A))
							new /obj/effect/kana (T, A)
						else
							new /obj/effect/kana (T)
			catch(var/exception/e)
				catchException(e, A)
		else
			catchBadType(A)
			menacing_atoms -= A
		current_list -= current
		PROCESS_TICK_CHECK

/process/menacing/reset_current_list()
	if (current_list)
		current_list = null
	current_list = menacing_atoms.Copy()

/process/menacing/statProcess()
	..()
	stat(null, "[menacing_atoms.len] atoms")

/process/menacing/htmlProcess()
	return ..()  + "[menacing_atoms.len] atoms"