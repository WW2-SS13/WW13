/* this is to fix invisible objects caused by zooming. In the future
 * it may do more. */

var/datum/controller/process/zoom/zoom_process = null

/datum/controller/process/zoom/setup()
	name = "zoom"
	schedule_interval = 5
	start_delay = 8
	zoom_process = src

/datum/controller/process/zoom/doWork()

	for(last_object in zoom_processing_objects)
		var/obj/O = last_object
		if(isnull(O.gcDestroyed))
			try
				var/check = 0
				if (isturf(O.loc) || isobj(O.loc))
					check = 1
				if (ishud(O))
					var/obj/screen/S = O
					if (S.parentmob)
						if (!ishuman(S.parentmob))
							check = 1
						else
							var/mob/living/carbon/human/H = S.parentmob
							if (!H.using_zoom())
								check = 1
				if (ismob(O.loc))
					var/mob/M = O.loc
					if (!ishuman(M))
						check = 1
					else
						var/mob/living/carbon/human/H = M
						if (!H.using_zoom())
							check = 1

				if (check)
					if (O.scoped_invisible)
						if (O.invisibility == 100)
							O.invisibility = 0
							O.scoped_invisible = 0
							zoom_processing_objects -= O
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			zoom_processing_objects -= O

/datum/controller/process/zoom/statProcess()
	..()
	stat(null, "[zoom_processing_objects.len] objects")

/datum/controller/process/zoom/proc/add(var/obj/O)
	O.scoped_invisible = 1
	O.invisibility = 100
	zoom_processing_objects += O