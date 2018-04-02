/datum/controller/process/nanoui/setup()
	name = "nanoui"
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/nanoui/statProcess()
	..()
	stat(null, "[nanomanager.processing_uis.len] UIs")

/datum/controller/process/nanoui/doWork()
	for(last_object in nanomanager.processing_uis)
		var/datum/nanoui/NUI = last_object
		if(istype(NUI) && isnull(NUI.gcDestroyed))
			try
				NUI.process()
			catch(var/exception/e)
				catchException(e, NUI)
		else
			catchBadType(NUI)
			nanomanager.processing_uis -= NUI
		SCHECK
