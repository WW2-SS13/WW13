// more modulized way to handle supply drops I guess - Kachnov

var/datum/controller/process/supplydrop/supplydrop_process = null

/datum/controller/process/supplydrop/setup()
	name = "supplydrop"
	schedule_interval = 200
	start_delay = 8
	supplydrop_process = src

/datum/controller/process/supplydrop/doWork()

	for(var/v in 1 to supplydrop_processing_objects_german.len)
		spawn (2 * v)
			var/last_path = supplydrop_processing_objects_german[v]
			if(ispath(last_path))
				try
					turf_loop:
						for (var/turf/T in german_supplydrop_spots)
							if (T.density)
								continue turf_loop
							// evidently more accurate than locate(/obj/structure) in T
							for (var/obj/structure/S in T)
								if (S.density)
									continue turf_loop
							for (var/mob/living/L in T)
								continue turf_loop
							var/atom/A = new last_path (T)
							A.visible_message("<span class = 'notice'>[A] falls from the sky!</span>")
							playsound(T, 'sound/effects/bamf.ogg', rand(70,80))
							break

					supplydrop_processing_objects_german -= last_path
				catch(var/exception/e)
					catchException(e, last_path)
				SCHECK
			else
				catchBadType(last_path)
				supplydrop_processing_objects_german -= last_path
	for(var/v in 1 to supplydrop_processing_objects_soviet.len)
		spawn (2*v)
			var/last_path = supplydrop_processing_objects_soviet[v]
			if(ispath(last_path))
				try
					turf_loop:
						for (var/turf/T in soviet_supplydrop_spots)
							if (T.density)
								continue turf_loop
							// evidently more accurate than locate(/obj/structure) in T
							for (var/obj/structure/S in T)
								if (S.density)
									continue turf_loop
							for (var/mob/living/L in T)
								continue turf_loop
							var/atom/A = new last_path (T)
							A.visible_message("<span class = 'notice'>[A] falls from the sky!</span>")
							playsound(T, 'sound/effects/bamf.ogg', 90)
							break

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
		if (SOVIET)
			supplydrop_processing_objects_soviet += object_path