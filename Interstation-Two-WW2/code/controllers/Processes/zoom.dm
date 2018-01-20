/* the old zoom process was too laggy, so now we have this. We don't use the
 * mob process because it doesn't update often enough and it would cause too
 * much lag to make it update 3x faster. (3x the Life() calls) - Kachnov */

var/datum/controller/process/zoom/zoom_process = null

/datum/controller/process/zoom
	var/tmp/datum/updateQueue/updateQueueInstance
	var/list/recent_scopes = list()

/datum/controller/process/zoom/setup()
	name = "zoom"
	schedule_interval = 7 // every 0.7 seconds
	start_delay = 100
	zoom_process = src

/datum/controller/process/zoom/started()
	..()
	if(!zoom_processing_objects)
		zoom_processing_objects = list()

/datum/controller/process/zoom/doWork()
	for(last_object in recent_scopes)
		var/obj/item/weapon/attachment/scope/S = last_object

		if(isnull(S))
			continue

		if(isnull(S.gcDestroyed))
			try
				if (S.scoped_invisible)
					S.invisibility = FALSE
					S.scoped_invisible = FALSE
				else if (istype(S.loc, /obj/item/weapon/gun))
					var/obj/item/weapon/gun/G = S.loc
					G.invisibility = FALSE
					G.scoped_invisible = FALSE
				recent_scopes -= S
			catch(var/exception/e)
				catchException(e, S)
			SCHECK
		else
			catchBadType(S)
			recent_scopes -= S

	for(last_object in zoom_processing_objects)

		var/mob/living/carbon/human/H = last_object

		if(isnull(H))
			continue

		if(isnull(H.gcDestroyed))
			try
				if (H.client && H.using_zoom())
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
			catch(var/exception/e)
				catchException(e, H)
			SCHECK
		else
			catchBadType(H)
			zoom_processing_objects -= H

/datum/controller/process/zoom/statProcess()
	..()
	stat(null, "[zoom_processing_objects.len] mobs")
