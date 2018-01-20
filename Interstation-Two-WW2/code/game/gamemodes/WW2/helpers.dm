/proc/WW2_soldiers_alive()

	var/de = FALSE
	var/ru = FALSE
	var/partisan = FALSE
	var/civilian = FALSE

	for(var/mob/living/carbon/human/H in human_mob_list)

		var/datum/job/job = H.original_job

		if(!job)
			continue

		if(H.stat != DEAD && !H.restrained() && H.client)
			switch(job.base_type_flag())
				if(GERMAN)
					++de
				if(SOVIET)
					++ru
				if (PARTISAN)
					++partisan
				if (CIVILIAN)
					++civilian

	return list("de" = de, "ru" = ru, PARTISAN = partisan, CIVILIAN = civilian)

/proc/WW2_soldiers_en_ru_ratio()

	var/list/soldiers = WW2_soldiers_alive()
	// prevents dividing by FALSE - Kachnov
	if (soldiers["en"] > FALSE && soldiers["ru"] == FALSE)
		return 1000
	else if (soldiers["ru"] > FALSE && soldiers["en"] == FALSE)
		return TRUE/1000
	else if (soldiers["ru"] == soldiers["en"])
		return TRUE

	return max(soldiers["en"], TRUE)/max(soldiers["ru"], TRUE) // we need decimals here so no rounding

/proc/is_soviet_contested_zone(var/area/a)
	if (istype(a, /area/prishtina/soviet/bunker))
		if (!istype(a, /area/prishtina/soviet/bunker/tunnel))
			return TRUE
	else if (istype(a, /area/prishtina/soviet/small_map))
		return TRUE
	return FALSE

/proc/is_german_contested_zone(var/area/a)
	if (istype(a, /area/prishtina/german))
		if (!istype(a, /area/prishtina/german/train_landing_zone))
			if (!istype(a, /area/prishtina/german/train_zone))
				return TRUE
	return FALSE


/proc/get_soviet_german_stats()
	var/alive_soviets = FALSE
	var/alive_germans = FALSE

	var/soviets_in_russia = FALSE
	var/soviets_in_germany = FALSE

	var/germans_in_germany = FALSE
	var/germans_in_russia = FALSE

	for (var/mob/living/carbon/human/H in player_list)

		var/H_side = ""

		if (istype(H.original_job, /datum/job/soviet) || (istype(H.original_job, /datum/job/partisan) && soviet_civilian_mode))
			if (H.is_spy)
				H_side = GERMAN
			else
				H_side = SOVIET

		if (istype(H.original_job, /datum/job/german) || (istype(H.original_job, /datum/job/partisan) && german_civilian_mode))
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
	var/stats = get_soviet_german_stats()
	switch (side)
		if (GERMAN)
			if (stats["soviets_in_germany"] > stats["germans_in_germany"])
				return TRUE
		if (SOVIET)
			if (stats["germans_in_russia"] > stats["soviets_in_russia"])
				return TRUE
	return FALSE