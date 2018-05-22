/process/projectile

/process/projectile/setup()
	name = "projectile movement"
	schedule_interval = 0.1
	start_delay = 10
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	subsystem = TRUE
	processes.projectile = src

/process/projectile/fire()

	SCHECK

	if (!projectile_list.len)
		return

	FORNEXT(projectile_list)

		var/obj/item/projectile/P = current

		// projectiles will qdel() and remove themselves from projectile_list automatically
		if (!isDeleted(P))
			if (P.loc)
				try
					P.process()
				catch (var/exception/e)
					catchException(e, P)
		else
			catchBadType(P)
			projectile_list -= P

		SCHECK

/process/projectile/statProcess()
	..()
	stat(null, "[mob_list.len] projectiles")

/process/projectile/htmlProcess()
	return ..() + "[mob_list.len] projectiles"