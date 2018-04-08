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
	var/KD_chance = 5
	var/stat = "rifle"
	var/effectiveness_mod = 1.00
	var/load_delay = 0

/obj/item/weapon/gun/projectile/proc/calculate_miss_chance(zone, var/mob/target)

	var/mob/living/carbon/human/firer = loc
	if (!firer || !target || !istype(target))
		return 0
	if (!istype(firer))
		return 0

	var/moving_target = target.lastMovedRecently(target.get_run_delay())
	var/abs_x = abs(firer.x - target.x)
	var/abs_y = abs(firer.y - target.y)
	var/pythag = (abs_x + abs_y)/2
	var/distance = max(abs_x, abs_y, pythag)
	var/accuracy_sublist = accuracy_list["large"]

	switch (zone)
		if ("l_leg", "r_leg", "l_arm", "r_arm")
			accuracy_sublist = accuracy_list["medium"]
		if ("l_hand", "r_hand", "l_foot", "r_foot", "head", "mouth", "eyes")
			accuracy_sublist = accuracy_list["small"]

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

	var/firer_stat = firer.getStatCoeff(stat)
	var/miss_chance_modifier = 1.00

//	log_debug("initial miss chance: [.]")

	if (firer_stat > 1.00)
		miss_chance_modifier -= ((firer_stat - 1.00) * accuracy_increase_mod)/5
	else if (firer_stat < 1.00)
		miss_chance_modifier += ((1.00 - firer_stat) * accuracy_decrease_mod)/5

	. *= miss_chance_modifier
	. /= effectiveness_mod

	. = min(CLAMP0100(.), 98)

	if (list("mouth", "eyes").Find(zone))
		. = min(. * 2, 100)

//	log_debug("final miss chance: [.]")

	return .