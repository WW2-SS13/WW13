var/datum/controller/process/burning/burning_process = null

/datum/controller/process/burning/setup()
	name = "burning"
	schedule_interval = 50 // every 5 seconds
	start_delay = 100
	burning_process = src

/datum/controller/process/burning/doWork()

	for(last_object in burning_objs)
		var/obj/O = last_object
		if(isnull(O.gcDestroyed))
			try
				if (prob(5))
					for (var/v in 2 to 3)
						new/obj/effect/decal/cleanable/ash(get_turf(O))
					burning_objs -= O
					qdel(O)
				else if (prob(10))
					new/obj/effect/effect/smoke/bad(get_turf(O), TRUE)
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			burning_objs -= O

	for(last_object in burning_turfs)
		var/turf/O = last_object
		if(isnull(O.gcDestroyed) && O.density)
			try
				if (prob(3))
					for (var/v in 4 to 5)
						new/obj/effect/decal/cleanable/ash(O)
					burning_turfs -= O
					O.ex_act(1.0)
				else if (prob(10))
					new/obj/effect/effect/smoke/bad(O, TRUE)
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			burning_turfs -= O

/datum/controller/process/burning/statProcess()
	..()
	stat(null, "[burning_objs.len] objects")
	stat(null, "[burning_turfs.len] objects")
