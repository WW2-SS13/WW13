/mob/living/simple_animal/complex_animal/canine/dog
	icon_state = null
	resting_state = null
	var/list/commands = list()
	wander = 0

/mob/living/simple_animal/complex_animal/canine/dog/german_shepherd
	icon_state = "g_shepherd"
	name = "German Shepherd"

/mob/living/simple_animal/complex_animal/canine/dog/samoyed
	icon_state = "samoyed"
	name = "Samoyed"

// parse messages that people say (WIP)
	// needs faction, friendly, etc support
	// commands list needs to be filled
/mob/living/carbon/human/post_say(var/message)
	..(message) // handle radio messages
	// parse message into a command
	var/rank = original_job ? lowertext(original_job.title) : null
	if (!rank)
		return
	else
		for (var/mob/living/simple_animal/complex_animal/canine/dog/pupper in view(world.view, src))
			for (var/command in pupper.commands)
				var/list/parts = splittext(command, ":")
				var/req_rank = parts[1]
				var/req_word = parts[2]
				var/_call = parts[3]

				if (req_rank == rank)
					if (dd_hasprefix(message, req_word))
						if (dd_hassuffix(message, "!"))
							call(pupper, _call)(src)

