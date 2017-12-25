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
	"stop everything;default;stop", // stop doing everything
	"follow;default;follow", // makes the dog follow you
	"stop following;default;stop_following", // makes the stop following who its following
	)

	faction = null

	var/attack_mode = -1
	var/patrolling = 0
	var/following = null

	var/last_patrol_area = null

	maxHealth = 50


/mob/living/simple_animal/complex_animal/canine/dog/proc/check_can_command(var/list/ranks, var/mob/living/carbon/human/H)
	if (!islist(ranks))
		. = list()
		. += ranks
		ranks = .
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
/mob/living/simple_animal/complex_animal/canine/dog/proc/hear_command(var/message, var/mob/living/carbon/human/H)
	if (!dd_hassuffix(message, "!"))
		return
	message = copytext(message, 1, lentext(message))
//	world << "1. [message]"
	// parse message into a command
	var/rank = H.original_job ? lowertext(H.original_job.title) : null
	if (!rank)
	//	world << "1.5: bad"
		return
	else if (stat == CONSCIOUS)
	//	world << "2. [src]"
		for (var/command in commands)
			var/list/parts = splittext(command, ";")
			var/req_word = lowertext(parts[1])
			var/list/req_ranks = splittext(parts[2], "&")
			if (!islist(req_ranks))
				. = list()
				. += req_ranks
				req_ranks = .

			for (var/RR in req_ranks)
			//	world << "2.5: [RR]"
				req_ranks += lowertext(RR)
				req_ranks -= RR

			// DEBUG BLOCK
			var/d1 = ""
			for (var/RR in req_ranks)
				d1 += RR
				d1 += ";"
		//	world << "2.6: [d1]"
			// END DEBUG BLOCK

			for (var/RR in req_ranks)
				if (RR == "default")
					req_ranks += "master"
					req_ranks += "^master"
					req_ranks -= RR

			// DEBUG BLOCK
			d1 = ""
			for (var/RR in req_ranks)
				d1 += RR
				d1 += ";"
		//	world << "2.7: [d1]"
			// END DEBUG BLOCK

			var/_call = parts[3]
		//	world << "3. [req_word];[req_ranks[1]];[_call]"

			if ((rank != null && req_ranks.Find(rank)) || check_can_command(req_ranks, H))
			//	world << "3.5"
				if (dd_hasprefix(lowertext(message), req_word) || lowertext(message) == req_word)
				//	world << "4. [message] v. [req_word]"
					if (hascall(src, _call))
						call(src, _call)(H)


/mob/living/simple_animal/complex_animal/canine/dog/can_wander_specialcheck()
	if (pulledby && check_can_command(list("master", "^master", "team"), pulledby))
		return 0
	return 1

/mob/living/simple_animal/complex_animal/canine/dog/can_rest_specialcheck()
	if (!can_wander_specialcheck())
		return 0
	if (attack_mode != -1 || patrolling)
		return 0

// "frontend" procs
/mob/living/simple_animal/complex_animal/canine/dog/proc/defend(var/mob/living/carbon/human/H)
	if (!(attack_mode == "defend"))
		visible_message("<span class = 'warning'>The [src] looks around defensively.</span>")
	attack_mode = "defend"
	onModeChange()

/mob/living/simple_animal/complex_animal/canine/dog/proc/attack(var/mob/living/carbon/human/H)
	if (!(attack_mode == "attack"))
		visible_message("<span class = 'warning'>The [src] looks around aggressively.</span>")
	attack_mode = "attack"
	onModeChange()

/mob/living/simple_animal/complex_animal/canine/dog/proc/guard(var/mob/living/carbon/human/H)
	if (!(attack_mode == "guard"))
		visible_message("<span class = 'warning'>The [src] starts guarding their domain.</span>")
	attack_mode = "guard"
	onModeChange()

/mob/living/simple_animal/complex_animal/canine/dog/proc/patrol(var/mob/living/carbon/human/H)
	if (!patrolling)
		visible_message("<span class = 'warning'>The [src] starts patrolling.</span>")
	patrolling = 1
	allow_moving_outside_home = 1
	wander_probability = 80
	onModeChange()

/mob/living/simple_animal/complex_animal/canine/dog/proc/stop_patrol(var/mob/living/carbon/human/H)
	if (patrolling)
		visible_message("<span class = 'warning'>The [src] stops patrolling.</span>")
	patrolling = 0
	allow_moving_outside_home = 0
	wander_probability = 20
	onModeChange()

/mob/living/simple_animal/complex_animal/canine/dog/proc/passive(var/mob/living/carbon/human/H)
	if (attack_mode != -1)
		visible_message("<span class = 'notice'>The [src] looks calm.</span>")
	attack_mode = -1
	onModeChange()

/mob/living/simple_animal/complex_animal/canine/dog/proc/stop(var/mob/living/carbon/human/H)
	passive()
	stop_patrol()
	visible_message("<span class = 'notice'>The [src] stops doing everything they were doing.</span>")
	onModeChange()

/mob/living/simple_animal/complex_animal/canine/dog/proc/follow(var/mob/living/carbon/human/H)
	visible_message("<span class = 'notice'>The [src] starts following [H].</span>")
	if (following)
		stop_following(H, 0)
	else
		walk_to(src, 0)
	walk_to(src, H, 1, H.run_delay_maximum*1.33)
	following = H

/mob/living/simple_animal/complex_animal/canine/dog/proc/stop_following(var/mob/living/carbon/human/H, var/message = 1)
	if (following)
		if (message)
			visible_message("<span class = 'notice'>The [src] stops following [following].</span>")
		walk_to(src, 0)

/mob/living/simple_animal/complex_animal/canine/dog/proc/onModeChange()
	for (var/mob/living/carbon/human/H in view(10, src))
		onHumanMovement(H)

// dog life
/mob/living/simple_animal/complex_animal/canine/dog/onEveryLifeTick()
	. = ..()
	if (. == 1)
		if (patrolling)
			for (var/mob/living/carbon/human/H in human_mob_list)
				if (H.client && (!H.original_job || H.original_job.base_type_flag() != faction))
					var/dist = get_dist(src,H)
					if (!locate(H) in view(world.view, src) && dist <= ((world.maxx + world.maxy) / 6))
						if (prob(7))
							visible_message("<span class = 'danger'>The [src] starts barking in fear! It smells an enemy!</span>")
							return

// dog combat

/mob/living/simple_animal/complex_animal/canine/dog/var/next_shred = -1
/mob/living/simple_animal/complex_animal/canine/dog/proc/shred(var/mob/living/carbon/human/H)
	if (stat == CONSCIOUS && !resting && H.stat != DEAD && H.getBruteLoss() <= 500)
		if (world.time >= next_shred)
			if (H in range(1, src))
				dir = get_dir(src, H)
				visible_message("<span class = 'warning'>The [src] shreds [H] with their teeth!</span>")
				H.adjustBruteLoss(rand(8,12))
				playsound(get_turf(src), 'sound/weapons/bite.ogg', rand(70,80))
			/*	if (prob(20)) // I think this stuns people forever, not sure how
					H.stun_effect_act(rand(1,2), rand(2,3)) */
				next_shred = world.time + 20
				spawn (20)
					shred(H)
		else if (H in range(1, src))
			spawn (20)
				shred(H)

// things we do when someone touches us
/mob/living/simple_animal/complex_animal/canine/dog/onTouchedBy(var/mob/living/carbon/human/H, var/intent = I_HELP)
	if (..(H, intent) && stat == CONSCIOUS && !resting)
		switch (intent)
			if (I_HURT)
				if (H.original_job && H.original_job.base_type_flag() == faction) // ignore it
					return

				enemies |= H

				spawn (rand(2,3))
					shred(H)

				// make other dogs go after them too
				for (var/mob/living/simple_animal/complex_animal/canine/dog/D in view(7, H))
					if (D.faction == faction)
						D.enemies |= H
						D.onHumanMovement(H)

/* things we do when someone attacks us */
/mob/living/simple_animal/complex_animal/canine/dog/onAttackedBy(var/mob/living/carbon/human/H, var/obj/item/weapon/W)
	if (..(H, W) && stat == CONSCIOUS && !resting)
		if (W.force > resistance)
			if (H.original_job && H.original_job.base_type_flag() == faction) // ignore it
				return
			enemies |= H

			spawn (rand(2,3))
				shred(H)

			// make other dogs go after them too
			for (var/mob/living/simple_animal/complex_animal/canine/dog/D in view(7, H))
				if (D.faction == faction)
					D.enemies |= H
					D.onHumanMovement(H)

/* check if we should go after an enemy */
/mob/living/simple_animal/complex_animal/canine/dog/proc/shouldGoAfter(var/mob/living/carbon/human/H)
	. = 0 // when can we attack random enemies who enter our area
	if (attack_mode == "attack") // wip
		. = 1
	else if (attack_mode == "defend")
		if (istype(H.l_hand, /obj/item/weapon/gun) || istype(H.r_hand, /obj/item/weapon/gun))
			. = 1
	else if (attack_mode == "guard")
		if (get_area(H) == get_area(src))
			. = 1

/* called after H added to knows_about_mobs() */
/mob/living/simple_animal/complex_animal/canine/dog/onHumanMovement(var/mob/living/carbon/human/H)
	if (..(H) && stat == CONSCIOUS && !resting)
		if (shouldGoAfter(H) || enemies.Find(H))
			if (assess_hostility(H) || ((!H.original_job || H.original_job.base_type_flag() != faction)))
				enemies |= H
				if (get_dist(src, H) > 1 && H.stat != DEAD)
					walk_to(src, H, 1, H.run_delay_maximum*1.33)
				else
					shred(H)
	else if (stat != CONSCIOUS && !resting)
		walk_to(src, 0)

/mob/living/simple_animal/complex_animal/canine/dog/Move()
	. = ..()
	if (stat == CONSCIOUS && !resting)
		for (var/mob/living/carbon/human/H in get_step(src, dir))
			if (assess_hostility(H) && shouldGoAfter(H))
				shred(H)

/mob/living/simple_animal/complex_animal/canine/dog/onEveryBaseTypeMovement(var/mob/living/simple_animal/complex_animal/C)
	return

/mob/living/simple_animal/complex_animal/canine/dog/onEveryXMovement(var/mob/X)
	return