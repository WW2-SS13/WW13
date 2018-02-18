var/datum/controller/process/dog/dog_process = null

/datum/controller/process/dog

/datum/controller/process/dog/setup()
	name = "dog process"
	schedule_interval = 2 // a bit slower than humans run (1.42 to 1.76 deciseconds)
	start_delay = 300
	dog_process = src

/datum/controller/process/dog/doWork()
	..()
	try
		for (var/D in dog_mob_list)
			var/mob/living/simple_animal/complex_animal/canine/dog/dog = D
			if (dog.walking_to)
				if (ismob(dog.walking_to))
					var/mob/M = dog.walking_to
					if (world.time - M.last_movement >= 10)
						continue
				var/dist_x = abs(dog.x - dog.walking_to.x)
				var/dist_y = abs(dog.y - dog.walking_to.y)
				if (dist_x > 2 || dist_y > 2 || dog.walking_to != dog.following)
					var/turf/target = get_step(dog.loc, get_dir(dog, dog.walking_to))
					if (target.density)
						continue
					if (locate(/obj/structure) in target)
						continue
					step(dog, get_dir(dog, dog.walking_to))

	catch(var/exception/e)
		catchException(e)
	SCHECK

/datum/controller/process/dog/statProcess()
	..()
	stat(null, "[dog_mob_list.len] mobs")
