// more modulized way to handle supply drops I guess - Kachnov

var/datum/controller/process/supplydrop/supplydrop_process = null

/datum/controller/process/supplydrop/setup()
	name = "supplydrop"
	schedule_interval = 200
	start_delay = 8
	supplydrop_process = src

/datum/controller/process/supplydrop/doWork()

	for(var/last_path in supplydrop_processing_objects_german)
		if(ispath(last_path))
			try
				var/tries = 0
				retry
				var/turf/T = pick(german_supplydrop_spots)
				if (!T.density && !locate(/obj/structure) in T && !locate(/mob/living) in T)
					var/atom/A = new last_path (T)
					A.visible_message("<span class = 'notice'>[A] falls from the sky!</span>")
					playsound(T, 'sound/effects/bamf.ogg', rand(70,80))
				else
					++tries
					if (tries > 20) // we already tried 20 turfs (retried 19 times)
						goto finish
					else
						goto retry
				finish
				supplydrop_processing_objects_german -= last_path
			catch(var/exception/e)
				catchException(e, last_path)
			SCHECK
		else
			catchBadType(last_path)
			supplydrop_processing_objects_german -= last_path
	for(var/last_path in supplydrop_processing_objects_soviet)
		if(ispath(last_path))
			try
				var/tries = 0
				retry
				var/turf/T = pick(soviet_supplydrop_spots)
				if (!T.density && !locate(/obj/structure) in T && !locate(/mob/living) in T)
					var/atom/A = new last_path (T)
					A.visible_message("<span class = 'notice'>[A] falls from the sky!</span>")
					playsound(T, 'sound/effects/bamf.ogg', rand(70,80))
				else
					++tries
					if (tries > 20) // we already tried 20 turfs (retried 19 times)
						goto finish
					else
						goto retry
				finish
				supplydrop_processing_objects_soviet -= last_path
			catch(var/exception/e)
				catchException(e, last_path)
			SCHECK
		else
			catchBadType(last_path)
			supplydrop_processing_objects_soviet -= last_path

/datum/controller/process/supplydrop/statProcess()
	..()
	stat(null, "[supplydrop_processing_objects_german.len+supplydrop_processing_objects_soviet.len] objects")

/datum/controller/process/supplydrop/proc/add(var/object_path, var/faction)
	switch (faction)
		if (GERMAN)
			supplydrop_processing_objects_german += object_path
		if (RUSSIAN)
			supplydrop_processing_objects_soviet += object_path