// basic dog stuff
/mob/living/simple_animal/complex_animal/canine/dog
	icon_state = null
	resting_state = null
	wander = 0
	var/mob/owner = null

	// COMMANDS
	// format is "word;jobtitle;proc"
	// special values that are permitted for jobtitle are:
		//'master' - the dog's owner
		//'^master' - a superior of the dog's owner
		//'team' - anyone on the dog's faction
		//'everyone' - anyone at all

	var/list/commands = list(
	"sit;everyone;sit",
	"follow;master&^master;follow",
	"rest;team;nap",
	)

	faction = null

/mob/living/simple_animal/complex_animal/canine/dog/proc/check_can_command(var/list/ranks, var/mob/living/carbon/human/H)
	// no 'else's here, because we accept multiple ranks
	if (ranks.Find("master"))
		if (H == owner)
			return 1
	if (ranks.Find("^master"))
		if (owner && H.is_superior_of(owner))
			return 1
	if (ranks.Find("team"))
		if (H.original_job && H.original_job.base_type_flag() == faction)
			return 1
	if (ranks.Find("everyone"))
		return 1
	return 0

// types of puppers

/mob/living/simple_animal/complex_animal/canine/dog/german_shepherd
	icon_state = "g_shepherd"
	name = "German Shepherd"
	faction = GERMAN

/mob/living/simple_animal/complex_animal/canine/dog/samoyed
	icon_state = "samoyed"
	name = "Samoyed"
	faction = RUSSIAN

// "backend" procs

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
				var/list/parts = splittext(command, ";")

				var/req_word = lowertext(parts[1])
				var/list/req_ranks = splittext(parts[2], "&")
				for (var/RR in req_ranks)
					RR = lowertext(RR)
				var/_call = parts[3]

				if (req_ranks.Find(rank) || pupper.check_can_command(req_ranks, src))
					if (dd_hasprefix(message, req_word))
						if (hascall(pupper, _call))
							call(pupper, _call)(src)

// "frontend" procs
/mob/living/simple_animal/complex_animal/canine/dog/proc/follow(var/mob/living/carbon/human/H)
	//...

/mob/living/simple_animal/complex_animal/canine/dog/proc/guard(var/mob/living/carbon/human/H)
	//...

/mob/living/simple_animal/complex_animal/canine/dog/proc/attack(var/mob/living/carbon/human/H)
	//...