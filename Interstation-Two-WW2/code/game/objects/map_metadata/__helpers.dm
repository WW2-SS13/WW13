/proc/WW2_soldiers_alive()

	var/de = 0
	var/ru = 0
	var/partisan = 0
	var/civilian = 0
	var/undead = 0

	for(var/mob/living/carbon/human/H in human_mob_list)

		var/datum/job/job = H.original_job

		if(!job)
			continue

		if(H.stat != DEAD && H.stat != UNCONSCIOUS && !H.restrained() && ((H.weakened+H.stunned) == 0) && H.client)
			switch(job.base_type_flag())
				if(GERMAN)
					++de
				if(SOVIET)
					++ru
				if (PARTISAN)
					++partisan
				if (CIVILIAN)
					++civilian
				if (PILLARMEN)
					++undead

	return list(GERMAN = de, SOVIET = ru, PARTISAN = partisan, CIVILIAN = civilian, PILLARMEN = undead)

/proc/WW2_soldiers_de_ru_ratio()

	var/list/soldiers = WW2_soldiers_alive()
	// prevents dividing by FALSE - Kachnov
	if (soldiers[GERMAN] > 0 && soldiers[SOVIET] == 0)
		return 1000
	else if (soldiers[SOVIET] > 0 && soldiers[GERMAN] == 0)
		return 1/1000
	else if (soldiers[SOVIET] == soldiers[GERMAN])
		return 1

	return max(soldiers[GERMAN], TRUE)/max(soldiers[SOVIET], TRUE) // we need decimals here so no rounding

/proc/is_soviet_contested_zone(var/area/a)
	if (istype(a, /area/prishtina/soviet/bunker))
		if (a.capturable)
			return TRUE
	else if (istype(a, /area/prishtina/soviet/small_map))
		if (a.capturable)
			return TRUE
	return FALSE

/proc/is_german_contested_zone(var/area/a)
	if (istype(a, /area/prishtina/german))
		if (a.capturable)
			return TRUE
	return FALSE

/proc/is_undead_contested_zone(var/area/a)
	if (istype(a, /area/prishtina/sewers))
		if (a.capturable)
			return TRUE
	return FALSE

/proc/get_stats()
	var/alive_soviets = 0
	var/alive_germans = 0

	var/soviets_in_russia = 0
	var/soviets_in_germany = 0

	var/germans_in_germany = 0
	var/germans_in_russia = 0

	for (var/mob/living/carbon/human/H in player_list)

		var/H_side = ""

		if (istype(H.original_job, /datum/job/soviet) || (istype(H.original_job, /datum/job/partisan) && soviet_civilian_mode))
			if (H.is_spy)
				H_side = GERMAN
			else
				H_side = SOVIET

		if (istype(H.original_job, /datum/job/german) || (istype(H.original_job, /datum/job/partisan) && german_civilian_mode) || istype(H.original_job, /datum/job/italian))
			if (H.is_spy)
				H_side = SOVIET
			else
				H_side = GERMAN

		if (H_side == SOVIET)
			if (H.stat != DEAD && H.stat != UNCONSCIOUS)
				++alive_soviets
				if (is_german_contested_zone(get_area(H)))
					++soviets_in_germany
				else if (is_soviet_contested_zone(get_area(H)))
					++soviets_in_russia

		else if (H_side == GERMAN)
			if (H.stat != DEAD && H.stat != UNCONSCIOUS)
				++alive_germans
				if (is_german_contested_zone(get_area(H)))
					++germans_in_germany
				else if (is_soviet_contested_zone(get_area(H)))
					++germans_in_russia

	return list ("alive_soviets" = alive_soviets, "alive_germans" = alive_germans,
		"soviets_in_russia" = soviets_in_russia, "soviets_in_germany" = soviets_in_germany,
			"germans_in_germany" = germans_in_germany, "germans_in_russia" = germans_in_russia)

/proc/has_occupied_base(var/side)
	var/stats = get_stats()
	switch (side)
		if (GERMAN)
			if (stats["soviets_in_germany"] > stats["germans_in_germany"])
				return TRUE
		if (SOVIET)
			if (stats["germans_in_russia"] > stats["soviets_in_russia"])
				return TRUE
	return FALSE