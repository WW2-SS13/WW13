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
				H_side = "GERMAN"
			else
				H_side = "RUSSIAN"

		if (istype(H.original_job, /datum/job/german))
			if (H.is_spy)
				H_side = "RUSSIAN"
			else
				H_side = "GERMAN"

		if (H_side == "RUSSIAN")
			if (H.stat != DEAD && H.stat != UNCONSCIOUS)
				++alive_russians
				if (is_german_contested_zone(get_area(H)))
					++russians_in_germany
				else if (is_russian_contested_zone(get_area(H)))
					++russians_in_russia

		else if (H_side == "GERMAN")
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
		if ("GERMAN")
			if (stats["russians_in_germany"] > stats["germans_in_germany"])
				return 1
		if ("RUSSIAN")
			if (stats["germans_in_russia"] > stats["russians_in_russia"])
				return 1
	return 0