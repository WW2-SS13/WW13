var/datum/controller/process/projectile/projectile_process = null

/datum/controller/process/projectile

/datum/controller/process/projectile/setup()
	name = "projectile movement"
	schedule_interval = 0.1
	start_delay = 10
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	projectile_process = src
	DO_INTERNAL_SUBSYSTEM(src)

/datum/controller/process/projectile/doWork()
	if (!projectile_list.len)
		return
	SCHECK
	for(last_object in projectile_list)

		var/obj/item/projectile/P = last_object

		// projectiles will qdel() and remove themselves from projectile_list automatically
		if (!P)
			continue

		if (!P.loc)
			continue

		if (isnull(P.gcDestroyed))
			try
				P.process()
			catch (var/exception/e)
				catchException(e, P)
		else
			catchBadType(P)
			projectile_list -= P

		SCHECK

/datum/controller/process/projectile/statProcess()
	..()
	stat(null, "[mob_list.len] projectiles")

/datum/controller/process/projectile/htmlProcess()
	return ..() + "[mob_list.len] projectiles"