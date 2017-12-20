// basic dog stuff
/mob/living/simple_animal/complex_animal/canine/dog
	icon_state = null
	resting_state = null
	wander = 0
	var/mob/owner = null

	// COMMANDS
	// format is "word;jobtitle&jobtitle;proc"
	// special values that are permitted for jobtitle are:
		//'master' - the dog's owner
		//'^master' - a superior of the dog's owner
		//'team' - anyone on the dog's faction
		//'everyone' - anyone at all
		//'default' - alias for "master&^master"

	var/list/commands = list(
	"defend;default;defend", // attack armed enemies
	"attack;default;attack", // attack enemies, armed or unarmed
	"guard;default;guard", // attack people who come into our area
	"patrol;default;patrol", // wander around the base, overlaps with other cmds
	"stop patrolling;default;stop_patrol",
	"be passive;default;passive", // only attack in self-defense
	"stop;default;stop", // stop doing everything
	)

	faction = null

	var/attack_mode = -1
	var/patrolling = 1

/mob/living/simple_animal/complex_animal/canine/dog/proc/check_can_command(var/list/ranks, var/mob/living/carbon/human/H)
	// no 'else's here, because we accept multiple ranks
	if (ranks.Find("master"))
		if (H == owner || (!owner && H.original_job && H.original_job.base_type_flag() == faction))
			return 1
	if (ranks.Find("^master"))
		if ((owner && H.is_superior_of(owner)) || (!owner && H.original_job && H.original_job.base_type_flag() == faction))
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
	if (!dd_hassuffix(message, "!"))
		return
	message = copytext(message, 1, lentext(message))
	world << "1. [message]"
	// parse message into a command
	var/rank = original_job ? lowertext(original_job.title) : null
	if (!rank)
		world << "1.5: bad"
		return
	else
		for (var/mob/living/simple_animal/complex_animal/canine/dog/pupper in view(world.view, src))
			if (pupper.stat == CONSCIOUS)
				world << "2. [pupper]"
				for (var/command in pupper.commands)
					var/list/parts = splittext(command, ";")
					var/req_word = lowertext(parts[1])
					var/list/req_ranks = splittext(parts[2], "&")
					if (!islist(req_ranks))
						. = list()
						. += req_ranks
						req_ranks = .

					for (var/RR in req_ranks)
						world << "2.5: [RR]"
						req_ranks += lowertext(RR)
						req_ranks -= RR

					// DEBUG BLOCK
					var/d1 = ""
					for (var/RR in req_ranks)
						d1 += RR
						d1 += ";"
					world << "2.6: [d1]"
					// END DEBUG BLOCK

					for (var/RR in req_ranks)
						if (RR == "default")
							req_ranks += "master&^master"
							req_ranks -= RR

					// DEBUG BLOCK
					d1 = ""
					for (var/RR in req_ranks)
						d1 += RR
						d1 += ";"
					world << "2.7: [d1]"
					// END DEBUG BLOCK

					var/_call = parts[3]
					world << "3. [req_word];[req_ranks[1]];[_call]"

					if (req_ranks.Find(rank) || pupper.check_can_command(req_ranks, src))
						if (dd_hasprefix(lowertext(message), req_word))
							if (hascall(pupper, _call))
								call(pupper, _call)(src)

// "frontend" procs
/mob/living/simple_animal/complex_animal/canine/dog/proc/defend(var/mob/living/carbon/human/H)
	if (!(attack_mode == "defend"))
		visible_message("<span class = 'warning'>The [src] looks around defensively.</span>")
	attack_mode = "defend"

/mob/living/simple_animal/complex_animal/canine/dog/proc/attack(var/mob/living/carbon/human/H)
	if (!(attack_mode == "attack"))
		visible_message("<span class = 'warning'>The [src] looks around aggressively.</span>")
	attack_mode = "attack"

/mob/living/simple_animal/complex_animal/canine/dog/proc/guard(var/mob/living/carbon/human/H)
	if (!(attack_mode == "guard"))
		visible_message("<span class = 'warning'>The [src] starts guarding their domain.</span>")
	attack_mode = "guard"

/mob/living/simple_animal/complex_animal/canine/dog/proc/patrol(var/mob/living/carbon/human/H)
	if (!patrolling)
		visible_message("<span class = 'warning'>The [src] starts patrolling.</span>")
	patrolling = 1
	allow_moving_outside_home = 1
	wander_probability = 80

/mob/living/simple_animal/complex_animal/canine/dog/proc/stop_patrol(var/mob/living/carbon/human/H)
	if (patrolling)
		visible_message("<span class = 'warning'>The [src] stops patrolling.</span>")
	patrolling = 0
	allow_moving_outside_home = 0
	wander_probability = 20

/mob/living/simple_animal/complex_animal/canine/dog/proc/passive(var/mob/living/carbon/human/H)
	if (attack_mode != -1)
		visible_message("<span class = 'notice'>The [src] looks calm.</span>")
	attack_mode = -1

/mob/living/simple_animal/complex_animal/canine/dog/proc/stop(var/mob/living/carbon/human/H)
	passive()
	stop_patrol()
	visible_message("<span class = 'notice'>The [src] stops doing everything they were doing.</span>")

// dog life
/mob/living/simple_animal/complex_animal/canine/dog/onEveryLifeTick()
	. = ..()
	if (. == 1)
		if (patrolling)
			for (var/mob/living/carbon/human/H in human_mob_list)
				if (H.client && (!H.original_job || H.original_job.base_type_flag() != faction))
					var/dist = get_dist(src,H)
					if (dist <= 60)
						if (prob(dist/10))
							visible_message("<span class = 'danger'>The [src] starts barking in fear! It smells an enemy!</span>")
							return
// dog combat

/mob/living/simple_animal/complex_animal/canine/dog/proc/shred(var/mob/living/carbon/human/H)
	if (H in range(1, src))
		visible_message("<span class = 'warning'>The [src] shreds [H] with their teeth!</span>")
		H.take_overall_damage(10, sharp = 1)
		if (prob(20))
			H.stun_effect_act(rand(1,2), rand(2,3))

// things we do when someone touches us
/mob/living/simple_animal/complex_animal/canine/dog/onTouchedBy(var/mob/living/carbon/human/H, var/intent = I_HELP)
	if (..(H, intent))
		switch (intent)
			if (I_HURT)
				if (H.original_job && H.original_job.base_type_flag() == faction) // ignore it
					return
				enemies |= H
				shred(H)

// things we do when someone attacks us
/mob/living/simple_animal/complex_animal/canine/dog/onAttackedBy(var/mob/living/carbon/human/H, var/obj/item/weapon/W)
	if (..(H, W))
		if (W.force > resistance)
			if (H.original_job && H.original_job.base_type_flag() == faction) // ignore it
				return
			enemies |= H
			shred(H)

/* called after H added to knows_about_mobs() */
/mob/living/simple_animal/complex_animal/canine/dog/onHumanMovement(var/mob/living/carbon/human/H)
	if (..(H))
		if (!assess_friendlyness(H))
			enemies |= H
			walk_to(src, H)
			if (get_dist(src, H) == 1)
				shred(H)

/mob/living/simple_animal/complex_animal/canine/dog/onEveryBaseTypeMovement(var/mob/living/simple_animal/complex_animal/C)
	return

/mob/living/simple_animal/complex_animal/canine/dog/onEveryXMovement(var/mob/X)
	return