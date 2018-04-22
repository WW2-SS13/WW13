var/process/mob/mob_process = null

/process/mob

/process/mob/setup()
	name = "mob"
	schedule_interval = 20 // every 2 seconds
	start_delay = 16
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	mob_process = src

/process/mob/started()
	..()
	if(!mob_list)
		mob_list = list()

/process/mob/fire()
	SCHECK
	for(last_object in mob_list)

		var/mob/M = last_object

		if(isnull(M))
			continue

		else if (istype(M, /mob/new_player))
			if (!M.client || M.client.mob != M)
				qdel(M)
			continue

		// if we're a spawned in, jobless mob: don't handle processing
		/* todo: these mobs SHOULD process if they have clients.
			right now, letting jobless mobs with or w/o clients process
			results in a lot of obscure runtimes, possibly associated
			with human.Life() calling back to living.Life() - Kachnov */

		/* this will probably be removed soon because the job-vanishing error has gone,
		 * and soon spawned in mobs will get jobs. */

		else if (ishuman(M))
			if (!M.original_job)
				// runtime prevention hackcode
				if (M.client || M.ckey) // we have, or had, a client
					if (M.original_job_title)
						for (var/datum/job/J in job_master.occupations)
							if (J.title == M.original_job_title)
								M.original_job = J
								goto skip1
					else
						for (var/datum/job/german/soldier/J in job_master.occupations)
							M.original_job = J
							M.original_job_title = J.title
							break
				continue
			else if (istype(M.original_job, /datum/job/german/trainsystem))
				continue

		skip1

		if(isnull(M.gcDestroyed))
			try
				M.Life()
				if (world.time - M.last_movement > 7)
					M.velocity = 0
				if (ishuman(M) && M.client)
					zoom_processing_objects |= M
				else
					zoom_processing_objects -= M
			catch (var/exception/e)
				catchException(e, M)
		else
			catchBadType(M)
			mob_list -= M
		SCHECK

/process/mob/statProcess()
	..()
	stat(null, "[mob_list.len] mobs")

/process/mob/htmlProcess()
	return ..() + "[mob_list.len] mobs"