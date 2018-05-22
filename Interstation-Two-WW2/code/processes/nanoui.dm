/process/nanoUI/setup()
	name = "nanoui"
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	schedule_interval = 5 // every half second (more responsive) - Kachnov
	processes.nanoUI = src

/process/nanoUI/fire()
	SCHECK

	FORNEXT(nanomanager.processing_uis)
		var/datum/nanoui/NUI = current
		if(!isDeleted(NUI))
			try
				NUI.process()
			catch(var/exception/e)
				catchException(e, NUI)
		else
			catchBadType(NUI)
			nanomanager.processing_uis -= NUI
		SCHECK

/process/nanoUI/statProcess()
	..()
	stat(null, "[nanomanager.processing_uis.len] UIs")

/process/nanoUI/htmlProcess()
	return ..() + "[nanomanager.processing_uis.len] UIs"