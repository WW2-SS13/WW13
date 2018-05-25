/* the old zoom process was too laggy, so now we have this. We don't use the
 * mob process because it doesn't update often enough and it would cause too
 * much lag to make it update 3x faster. (3x the Life() calls) - Kachnov */
/process/zoom
	var/list/recent_scopes = list()

/process/zoom/setup()
	name = "zoom"
	schedule_interval = 7 // every 0.7 seconds
	start_delay = 100
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	priority = PROCESS_PRIORITY_HIGH
	processes.zoom = src

/process/zoom/started()
	..()
	if (!zoom_processing_objects)
		zoom_processing_objects = list()

/process/zoom/fire()

	// update gun, scope (in)visibility
	FORNEXT(recent_scopes)
		var/obj/item/weapon/attachment/scope/S = current

		if (!isDeleted(S))
			try
				if (S.scoped_invisible)
					S.invisibility = 0
					S.scoped_invisible = FALSE
				else if (istype(S.loc, /obj/item/weapon/gun))
					var/obj/item/weapon/gun/G = S.loc
					G.invisibility = 0
					G.scoped_invisible = FALSE
				recent_scopes -= S
			catch(var/exception/e)
				catchException(e, S)
		else
			catchBadType(S)
			recent_scopes -= S
		PROCESS_TICK_CHECK

	// make stuff invisible while we're scoping
	FORNEXT(zoom_processing_objects)

		var/mob/living/carbon/human/H = current

		if (!isDeleted(H))
			try
				if (H.client)
					if (H.using_zoom())
						for (var/obj/O in H.client.screen)
							if (O.invisibility)
								continue
							if (istype(O, /obj/screen/movable/action_button))
								var/obj/screen/movable/action_button/A = O
								if (A.name == "Toggle Sights" || (A.owner && istype(A.owner, /datum/action/toggle_scope)))
									continue
							O.invisibility = 100
							O.scoped_invisible = TRUE
							if (istype(O, /obj/item/weapon/attachment/scope))
								recent_scopes |= O
							else if (istype(O, /obj/item/weapon/gun))
								var/obj/item/weapon/gun/G = O
								for (var/obj/item/weapon/attachment/scope/S in G.attachments)
									recent_scopes |= S
					else
						for (var/obj/O in H.client.screen)
							if (O.scoped_invisible)
								O.invisibility = FALSE
						H.client.pixel_x = 0
						H.client.pixel_y = 0

			catch(var/exception/e)
				catchException(e, H)
		else
			catchBadType(H)
			zoom_processing_objects -= H
		PROCESS_TICK_CHECK

/process/zoom/statProcess()
	..()
	stat(null, "[zoom_processing_objects.len] mobs")

/process/zoom/htmlProcess()
	return ..() + "[zoom_processing_objects.len] mobs"
