/var/list/lighting_update_lights    = list()    // List of lighting sources queued for update.
/var/lighting_processing            = TRUE

/process/lighting

/process/lighting/setup()
	name = "lighting"
	schedule_interval = 1 // every 1/10th second
	start_delay = 10
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	lighting_processing = src

/process/lighting/fire()
	SCHECK

	FORNEXT(lighting_update_lights)
		if(!isDeleted(current))

			var/datum/light_source/L = current
			. = L.check()
			if(L.destroyed || . || L.force_update)
				L.remove_lum()
				if(!L.destroyed)
					L.apply_lum()

			else if(L.vis_update)	// We smartly update only tiles that became (in) visible to use.
				L.smart_vis_update()

			L.vis_update   = FALSE
			L.force_update = FALSE
			L.needs_update = FALSE
			lighting_update_lights -= L
		else
			catchBadType(current)
			lighting_update_lights -= current

		SCHECK

	FORNEXT(lighting_update_overlays)
		if(!isDeleted(current))
			var/atom/movable/lighting_overlay/L = current // Typecasting this later so BYOND doesn't istype each entry.
			L.update_overlay()
			L.needs_update = FALSE
			lighting_update_overlays -= L
		else
			catchBadType(current)
			lighting_update_overlays -= current

		SCHECK