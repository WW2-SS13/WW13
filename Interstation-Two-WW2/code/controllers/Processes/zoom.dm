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
		var/obj/item/I = last_object
		if(isnull(I.gcDestroyed))
			try
				if (isturf(I.loc) || isobj(I.loc))
					if (I.scoped_invisible)
						if (I.invisibility == 100)
							I.invisibility = 0
							I.scoped_invisible = 0
							zoom_processing_objects -= I
			catch(var/exception/e)
				catchException(e, I)
			SCHECK
		else
			catchBadType(I)
			zoom_processing_objects -= I

/datum/controller/process/zoom/statProcess()
	..()
	stat(null, "[zoom_processing_objects.len] objects being processed")

/datum/controller/process/zoom/proc/add(var/obj/item/I)
	I.scoped_invisible = 1
	I.invisibility = 100
	zoom_processing_objects += I