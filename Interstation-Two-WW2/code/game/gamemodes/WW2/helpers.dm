/proc/WW2_soldiers_alive()

	var/de = 0
	var/ru = 0
	var/partisan = 0
	var/civilian = 0

	for(var/mob/living/carbon/human/H in human_mob_list)

		var/datum/job/job = H.original_job

		if(!job)
			continue

		if(H.stat != DEAD && !H.restrained() && H.client)
			switch(job.base_type_flag())
				if(GERMAN)
					++de
				if(RUSSIAN)
					++ru
				if (PARTISAN)
					++partisan
				if (CIVILIAN)
					++civilian

	return list("de" = de, "ru" = ru, PARTISAN = partisan, CIVILIAN = civilian)

/proc/WW2_soldiers_en_ru_ratio()

	var/list/soldiers = WW2_soldiers_alive()
	// prevents dividing by 0 - Kachnov
	if (soldiers["en"] > 0 && soldiers["ru"] == 0)
		return 1000
	else if (soldiers["ru"] > 0 && soldiers["en"] == 0)
		return 1/1000
	else if (soldiers["ru"] == soldiers["en"])
		return 1

	return max(soldiers["en"], 1)/max(soldiers["ru"], 1) // we need decimals here so no rounding

/proc/is_russian_contested_zone(var/area/a)
	if (istype(a, /area/prishtina/soviet/bunker))
		if (!istype(a, /area/prishtina/soviet/bunker/tunnel))
			return 1
	return 0

/proc/is_german_contested_zone(var/area/a)
	if (istype(a, /area/prishtina/german))
		if (!istype(a, /area/prishtina/german/train_landing_zone))
			if (!istype(a, /area/prishtina/german/train_zone))
				return 1
	return 0


/proc/get_russian_german_stats()
	var/alive_russians = 0
	var/alive_germans = 0

	var/russians_in_russia = 0
	var/russians_in_germany = 0

	var/germans_in_germany = 0
	var/germans_in_russia = 0

	for (var/mob/living/carbon/human/H in player_list)

		var/H_side = ""

		if (istype(H.original_job, /datum/job/russian))
			if (H.is_spy)
				H_side = GERMAN
			else
				H_side = RUSSIAN

		if (istype(H.original_job, /datum/job/german))
			if (H.is_spy)
				H_side = RUSSIAN
			else
				H_side = GERMAN

		if (H_side == RUSSIAN)
			if (H.stat != DEAD && H.stat != UNCONSCIOUS)
				++alive_russians
				if (is_german_contested_zone(get_area(H)))
					++russians_in_germany
				else if (is_russian_contested_zone(get_area(H)))
					++russians_in_russia

		else if (H_side == GERMAN)
			if (H.stat != DEAD && H.stat != UNCONSCIOUS)
				++alive_germans
				if (is_german_contested_zone(get_area(H)))
					++germans_in_germany
				else if (is_russian_contested_zone(get_area(H)))
					++germans_in_russia

	return list ("alive_russians" = alive_russians, "alive_germans" = alive_germans,
		"russians_in_russia" = russians_in_russia, "russians_in_germany" = russians_in_germany,
			"germans_in_germany" = germans_in_germany, "germans_in_russia" = germans_in_russia)

/proc/has_occupied_base(var/side)
	var/stats = get_russian_german_stats()
	switch (side)
		if (GERMAN)
			if (stats["russians_in_germany"] > stats["germans_in_germany"])
				return 1
		if (RUSSIAN)
			if (stats["germans_in_russia"] > stats["russians_in_russia"])
				return 1
	return 0