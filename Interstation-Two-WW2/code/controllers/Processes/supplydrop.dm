// more modulized way to handle supply drops I guess - Kachnov

var/datum/controller/process/supplydrop/supplydrop_process = null

/datum/controller/process/supplydrop

/datum/controller/process/supplydrop/setup()
	name = "supplydrop process"
	schedule_interval = 300
	start_delay = 100
	supplydrop_process = src

/datum/controller/process/supplydrop/doWork()
	for (var/l in 1 to 2)

		var/list/objects = null
		var/list/dropspots = null

		switch (l)
			if (1)
				objects = supplydrop_processing_objects_german
				dropspots = german_supplydrop_spots
			if (2)
				objects = supplydrop_processing_objects_soviet
				dropspots = soviet_supplydrop_spots

		if (!islist(objects) || !islist(dropspots))
			continue

		for (var/v in 1 to objects.len)
			spawn (v * 2)
				if (objects.len >= v)
					var/last_path = objects[v]
					if(last_path)
						try
							var/spawned = FALSE
							for (var/turf/T in dropspots)

								if (!T || !istype(T))
									continue

								if (T.density)
									continue

								if (searchloc(T, /obj/structure, TRUE))
									continue

								if (searchloc(T, /mob/living, FALSE))
									continue

								if (searchloc(T, /obj/item/weapon, FALSE))
									continue

								var/real_path = text2path(last_path)

								if (ispath(real_path))
									var/atom/A = new real_path(T)

									if (A)
										A.visible_message("<span class = 'notice'>[A] falls from the sky!</span>")
										playsound(T, 'sound/effects/bamf.ogg', rand(70,80))
										spawned = TRUE

									break

							if (spawned)
								if (objects.Find(last_path))
									objects -= last_path

						catch (var/exception/e)
							catchException(e)
						SCHECK
					else
						if (objects.Find(last_path))
							objects -= last_path

/datum/controller/process/supplydrop/statProcess()
	..()
	stat(null, "[supplydrop_processing_objects_german.len+supplydrop_processing_objects_soviet.len] objects")

/datum/controller/process/supplydrop/proc/add(var/object_path, var/faction)
	if (object_path)
		switch (faction)
			if (GERMAN)
				supplydrop_processing_objects_german += object_path
			if (SOVIET)
				supplydrop_processing_objects_soviet += object_path

/datum/controller/process/supplydrop/proc/searchloc(turf/location, _type, dense = FALSE)
	for (var/atom/movable/A in location.contents)
		if (istype(A, _type))
			if (!dense || (dense && A.density))
				return TRUE
	return FALSE