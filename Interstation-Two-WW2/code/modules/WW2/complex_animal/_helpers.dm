// return values: 1 = M is a neutral mob, 0 = M is a hostile mob
/mob/living/simple_animal/complex_animal/proc/assess_neutrality(var/mob/M)
	if (friendly_to_base_type && M.vars.Find("base_type") && M:base_type == base_type)
		if (!enemies.Find(M))
			return 1
		else
			return 0
	else
		var/M_faction = null
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.original_job)
				M_faction = H.original_job.base_type_flag()

		for (var/_type in unfriendly_types)
			if (istype(M, _type))
				if (friendly_factions.Find(M_faction))
					if (enemies.Find(M))
						return 0
					return 1
				else if (friends.Find(M))
					return 1
		// we aren't an unfriendly type, so ignore them
		return 1
	return 1

// return values: 1 = M is a friendly mob, 0 = M is a hostile mob
/mob/living/simple_animal/complex_animal/proc/assess_friendlyness(var/mob/M)
	. = assess_neutrality(M)
	if (. == 0)
		return .
	else

		var/M_faction = null
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.original_job)
				M_faction = H.original_job.base_type_flag()

		if (friendly_factions.Find(M_faction))
			if (!enemies.Find(M))
				return 1
		else if (friends.Find(M))
			return 1

/mob/living/simple_animal/complex_animal/proc/wander()
	for (var/turf/T in view(1, src))
		if (T.density)
			continue
		for (var/atom/movable/dense in T)
			if (dense.density)
				continue
		Move(T)
		break

/mob/living/simple_animal/complex_animal/proc/nap()
	for (var/mob/M in knows_about_mobs)
		if (!assess_friendlyness(M)) // bad time to nap
			return 0
		else // we're going to nap so stop knowing about them
			knows_about_mobs -= M
	resting = 1
	update_icon()

/mob/living/simple_animal/complex_animal/proc/stop_napping()
	if (!resting)
		return 0
	resting = 0
	update_icon()

/mob/living/simple_animal/complex_animal/proc/update_icon()
	if (resting)
		icon_state = "resting_state"
	else
		icon_state = initial(icon_state)