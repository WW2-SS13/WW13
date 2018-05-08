var/process/burning/burning_process = null

/process/burning/setup()
	name = "burning"
	schedule_interval = 50 // every 5 seconds
	start_delay = 100
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	burning_process = src

/process/burning/fire()
	SCHECK

	FORNEXT(burning_objs)
		var/obj/O = current
		if(isnull(O.gcDestroyed))
			try
				if (prob(5))
					for (var/v in 2 to 3)
						new/obj/effect/decal/cleanable/ash(get_turf(O))
					burning_objs -= O
					qdel(O)
				else if (prob(10))
					new/obj/effect/effect/smoke/bad(get_turf(O), TRUE)
			catch(var/exception/e)
				catchException(e, O)
		else
			catchBadType(O)
			burning_objs -= O
		SCHECK

	FORNEXT(burning_turfs)
		var/turf/T = current
		if(isnull(T.gcDestroyed) && T.density)
			try
				if (prob(3))
					for (var/v in 4 to 5)
						new/obj/effect/decal/cleanable/ash(T)
					burning_turfs -= T
					O.ex_act(1.0)
				else if (prob(10))
					new/obj/effect/effect/smoke/bad(T, TRUE)
			catch(var/exception/e)
				catchException(e, T)
		else
			catchBadType(T)
			burning_turfs -= T
		SCHECK

	var/sound/S = sound('sound/effects/fire_loop.ogg')
	S.repeat = FALSE
	S.wait = FALSE
	S.volume = 50
	S.channel = 1

	FORNEXT(burning_objs|burning_turfs)
		// range(20, tcc) = checks ~500 objects (400 turfs)
		// player_list will rarely be above 100 objects
		// so this should be more efficient - Kachnov
		for (var/M in player_list)
			if (M:loc) // make sure we aren't in the lobby
				var/dist = abs_dist(M, current)
				if (dist <= 20)
					var/volume = 100
					volume -= (dist*3)
					S.volume = volume
					M << S
		SCHECK

/process/burning/statProcess()
	..()
	stat(null, "[burning_objs.len] objects")
	stat(null, "[burning_turfs.len] turfs")

/process/burning/htmlProcess()
	return ..() + "[burning_objs.len] objects<br>[burning_turfs.len] turfs"