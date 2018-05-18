var/process/dog/dog_process = null

/process/dog

/process/dog/setup()
	name = "dog process"
	schedule_interval = 2 // a bit slower than humans run (1.42 to 1.76 deciseconds)
	start_delay = 300
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	dog_process = src

/process/dog/fire()
	SCHECK
	try
		for (var/D in dog_mob_list)
			if (!isDeleted(D))
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
			else
				catchBadType(D)
				dog_mob_list -= D
			SCHECK

	catch(var/exception/e)
		catchException(e)

/process/dog/statProcess()
	..()
	stat(null, "[dog_mob_list.len] mobs")

/process/dog/htmlProcess()
	return ..() + "[dog_mob_list.len] mobs"