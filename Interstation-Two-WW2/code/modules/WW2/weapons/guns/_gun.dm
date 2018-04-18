#define SHORT_RANGE_STILL "short_range_still"
#define SHORT_RANGE_MOVING "short_range_moving"

#define MEDIUM_RANGE_STILL "medium_range_still"
#define MEDIUM_RANGE_MOVING "medium_range_moving"

#define LONG_RANGE_STILL "long_range_still"
#define LONG_RANGE_MOVING "long_range_moving"

#define VERY_LONG_RANGE_STILL "very_long_range_still"
#define VERY_LONG_RANGE_MOVING "very_long_range_moving"

#define KD_CHANCE_VERY_LOW 20
#define KD_CHANCE_LOW 40
#define KD_CHANCE_MEDIUM 60
#define KD_CHANCE_HIGH 80

/obj/item/weapon/gun/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/attachment))
		var/obj/item/weapon/attachment/A = I
		if(A.attachable)
			try_attach(A, user)
	..()

/obj/item/weapon/gun/projectile
	var/accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 100,
			SHORT_RANGE_MOVING = 50,

			MEDIUM_RANGE_STILL = 50,
			MEDIUM_RANGE_MOVING = 25,

			LONG_RANGE_STILL = 25,
			LONG_RANGE_MOVING = 12,

			VERY_LONG_RANGE_STILL = 12,
			VERY_LONG_RANGE_MOVING = 6),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 100,
			SHORT_RANGE_MOVING = 50,

			MEDIUM_RANGE_STILL = 50,
			MEDIUM_RANGE_MOVING = 25,

			LONG_RANGE_STILL = 25,
			LONG_RANGE_MOVING = 12,

			VERY_LONG_RANGE_STILL = 12,
			VERY_LONG_RANGE_MOVING = 6),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 100,
			SHORT_RANGE_MOVING = 50,

			MEDIUM_RANGE_STILL = 50,
			MEDIUM_RANGE_MOVING = 25,

			LONG_RANGE_STILL = 25,
			LONG_RANGE_MOVING = 12,

			VERY_LONG_RANGE_STILL = 12,
			VERY_LONG_RANGE_MOVING = 6)
	)

	var/accuracy_increase_mod = 1.00
	var/accuracy_decrease_mod = 1.00
	var/effectiveness_mod = 1.00
	var/KD_chance = 5
	var/stat = "rifle"
	var/load_delay = 0

	// does not need to include all organs
	var/list/redirection_chances = list(
		"l_hand" = list("l_arm" = 30, "chest" = 10, "groin" = 10),
		"r_hand" = list("r_arm" = 30, "chest" = 10, "groin" = 10),
		"l_foot" = list("l_leg" = 50),
		"r_foot" = list("r_leg" = 50)
	)

	// must include all organs
	var/list/adjacent_redirections = list(
		"head" = list("head", "chest", "l_arm", "r_arm"), // "shoulders"
		"chest" = list("chest", "head", "l_arm", "r_arm", "l_leg", "r_leg"),
		"groin" = list("groin", "chest", "l_leg", "r_leg"),
		"l_arm" =  list("l_arm", "l_hand", "chest"),
		"r_arm" =  list("r_arm", "r_hand", "chest"),
		"l_leg" =  list("l_leg", "l_foot", "groin"),
		"r_leg" =  list("r_leg", "r_foot", "groin"),
		"l_hand" =  list("l_arm", "chest", "groin"),
		"r_hand" =  list("r_arm", "chest", "groin"),
		"l_foot" =  list("l_foot", "l_leg"),
		"r_foot" =  list("r_foot", "r_leg")
	)

	var/aim_miss_chance_divider = 1.50
	var/mob/living/carbon/human/firer = null

/obj/item/weapon/gun/projectile/proc/calculate_miss_chance(zone, var/mob/target)

	firer = loc
	if (!firer || !target || !istype(target))
		return 0
	if (!istype(firer))
		return 0

	var/accuracy_sublist = accuracy_list["large"]

	switch (zone)
		if ("l_leg", "r_leg", "l_arm", "r_arm")
			accuracy_sublist = accuracy_list["medium"]
		if ("l_hand", "r_hand", "l_foot", "r_foot", "head", "mouth", "eyes")
			accuracy_sublist = accuracy_list["small"]

	. = get_base_miss_chance(accuracy_sublist, target)

	var/firer_stat = firer.getStatCoeff(stat)
	var/miss_chance_modifier = 1.00

//	log_debug("initial miss chance: [.]")

	if (firer_stat > 1.00)
		miss_chance_modifier -= ((firer_stat - 1.00) * accuracy_increase_mod)/5
	else if (firer_stat < 1.00)
		miss_chance_modifier += ((1.00 - firer_stat) * accuracy_decrease_mod)/5

	. *= miss_chance_modifier
	. /= effectiveness_mod

	if (list("mouth", "eyes").Find(zone))
		var/hitchance = 100 - .
		hitchance /= 3
		. = round(100 - hitchance)

	else if (list("head").Find(zone))
		var/hitchance = 100 - .
		hitchance /= 2
		. = round(100 - hitchance)

	. = min(CLAMP0100(.), 99) // minimum hit chance is 2% no matter what

//	log_debug("final miss chance: [.]")

	return .

/obj/item/weapon/gun/projectile/proc/get_base_miss_chance(var/accuracy_sublist, var/mob/target)
	var/moving_target = target.lastMovedRecently(target.get_run_delay())
	var/abs_x = abs(firer.x - target.x)
	var/abs_y = abs(firer.y - target.y)
	var/pythag = (abs_x + abs_y)/2
	var/distance = max(abs_x, abs_y, pythag)
	// note: the screen is 15 tiles wide by default, so a person more than 7 tiles away from you x/y won't be on screen
	// . = miss chance
	switch (distance)
		if (0 to 1)
			. = 0
		if (2 to 3)
			if (!moving_target)
				. =  (100 - accuracy_sublist[SHORT_RANGE_STILL])
			else
				. =  (100 - accuracy_sublist[SHORT_RANGE_MOVING])
		if (4 to 5)
			if (!moving_target)
				. =  (100 - accuracy_sublist[MEDIUM_RANGE_STILL])
			else
				. =  (100 - accuracy_sublist[MEDIUM_RANGE_MOVING])
		if (6 to 7)
			if (!moving_target)
				. =  (100 - accuracy_sublist[LONG_RANGE_STILL])
			else
				. =  (100 - accuracy_sublist[LONG_RANGE_MOVING])
		if (7 to INFINITY)
			if (!moving_target)
				. =  (100 - accuracy_sublist[VERY_LONG_RANGE_STILL])
			else
				. =  (100 - accuracy_sublist[VERY_LONG_RANGE_MOVING])
	return .


// replaces proc/get_zone_with_miss_chance
/obj/item/weapon/gun/projectile/proc/get_zone(var/zone, var/mob/target, var/miss_chance = 0)
	// 10% miss chance = 90% hit chance, etc
	var/hit_chance = 100 - (miss_chance ? miss_chance : calculate_miss_chance(zone, target))
//	log_debug("MC: [miss_chance]")
	// We hit. Return the zone or a zone in redirection_chances[zone]
	if (prob(round(hit_chance)))
		if (redirection_chances.Find(zone))
			for (var/nzone in redirection_chances[zone])
				if (prob(redirection_chances[zone][nzone]))
					zone = nzone
		return zone
	// We didn't hit, and the target is running. Give us a chance to hit something in adjacent_redirections[zone]
	else if (target.lastMovedRecently(target.get_run_delay()))

		var/hitchance_still = round((accuracy_list["small"][SHORT_RANGE_STILL]/accuracy_list["small"][SHORT_RANGE_MOVING]) * hit_chance)
		var/hitchance_delta = hitchance_still - hit_chance

//		log_debug("1: [hitchance_still]")
//		log_debug("2: [hitchance_delta]")

		if (hitchance_still && hitchance_delta)
			if (prob(ceil(hitchance_delta * 0.75)))
				if (!adjacent_redirections.Find(zone)) // wtf
					log_debug("No '[zone]' found in '[src].adjacent_redirections'! Returning null (_gun.dm, ~line 200)")
					return null
				return pick(adjacent_redirections[zone])
		else if (!hitchance_delta)
			log_debug("hitchance_delta in '[src].get_zone()' was a value <= 0! ([hitchance_delta]) (_gun.dm, ~line 200)")
			return null
		else if (!hitchance_still)
			log_debug("hitchance_still in '[src].get_zone()' was a value <= 0! ([hitchance_still]) (_gun.dm, ~line 200)")
			return null

	// We missed.
	return null