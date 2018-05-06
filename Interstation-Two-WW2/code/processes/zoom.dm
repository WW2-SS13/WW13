/* the old zoom process was too laggy, so now we have this. We don't use the
 * mob process because it doesn't update often enough and it would cause too
 * much lag to make it update 3x faster. (3x the Life() calls) - Kachnov */

var/process/zoom/zoom_process = null

/process/zoom
	var/tmp/datum/updateQueue/updateQueueInstance
	var/list/recent_scopes = list()

/process/zoom/setup()
	name = "zoom"
	schedule_interval = 7 // every 0.7 seconds
	start_delay = 100
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	zoom_process = src

/process/zoom/started()
	..()
	if(!zoom_processing_objects)
		zoom_processing_objects = list()

/process/zoom/fire()
	SCHECK

	// remove gun action buttons that we can't use
	for (var/last_client in clients)
		var/client/C = last_client
		var/leftshift = 0
		var/list/checked = list()
		for (var/obj/screen/movable/action_button/AB in C.screen)
			if (checked.Find(AB))
				C.screen -= AB
				continue
			checked += AB
			AB.invisibility = 0
			AB.pixel_x = 0
			AB.transform = initial(AB.transform)
			if (C.mob && ishuman(C.mob))
				var/mob/living/carbon/human/H = C.mob
				if (H.using_zoom())
					AB.transform *= (C.view/world.view)
			if (AB.name == "Toggle Sights")
				var/datum/action/toggle_scope/TS = AB.owner
				if (TS && istype(TS))
					if (TS.scope)
						if (C.mob && TS.scope.loc == C.mob)
							if (!list(C.mob.r_hand, C.mob.l_hand).Find(TS.scope))
								AB.invisibility = 100
								leftshift += 32
						else if (istype(TS.scope.loc, /obj/item/weapon/gun/projectile))
							var/obj/item/weapon/gun/projectile/G = TS.scope.loc
							if (!list(C.mob.r_hand, C.mob.l_hand).Find(G))
								AB.invisibility = 100
								leftshift += 32
				if (!AB.invisibility)
					AB.pixel_x = -leftshift
					AB.UpdateIcon()

	// fix gun, scope invisibility
	for (last_object in recent_scopes)
		var/obj/item/weapon/attachment/scope/S = last_object

		if(isnull(S))
			continue

		if(isnull(S.gcDestroyed))
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
		SCHECK

	// make stuff invisible while we're scoping
	for(last_object in zoom_processing_objects)

		var/mob/living/carbon/human/H = last_object

		if(isnull(H))
			continue

		if(isnull(H.gcDestroyed))
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
						H.pixel_x = 0
						H.pixel_y = 0

			catch(var/exception/e)
				catchException(e, H)
		else
			catchBadType(H)
			zoom_processing_objects -= H
		SCHECK

/process/zoom/statProcess()
	..()
	stat(null, "[zoom_processing_objects.len] mobs")

/process/zoom/htmlProcess()
	return ..() + "[zoom_processing_objects.len] mobs"
