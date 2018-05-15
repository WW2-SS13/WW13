var/global/process/supply/supplyProcess

/process/supply
	var/tmpTime1 = 0
	var/tmpTime2 = 0

/process/supply/setup()
	name = "supply points"
	schedule_interval = 20 // every 2 seconds
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	supplyProcess = src

/process/supply/fire()
	SCHECK

	tmpTime1 += schedule_interval
	tmpTime2 += schedule_interval

	if (!map)
		return

	if (german_supplytrain_master)
		german_supplytrain_master.supply_points += map.supply_points_per_tick[GERMAN]
	else
		supply_points[GERMAN] += map.supply_points_per_tick[GERMAN]

	supply_points[SOVIET] += map.supply_points_per_tick[SOVIET]

	// change supply codes every 10 minutes (but not both at once) to stop metagaming
	if (prob(10) && tmpTime1 >= 6000 && !german_supplytrain_master)
		var/original_code = supply_codes[GERMAN]
		supply_codes[GERMAN] = rand(1000,9999)
		for (var/mob/living/carbon/human/H in human_mob_list)
			if (H.original_job && H.original_job.is_officer)
				if (H.original_job.base_type_flag() == GERMAN)
					H.replace_memory(original_code, supply_codes[GERMAN])
		radio2germans("The supply passcode has been changed to [supply_codes[GERMAN]] for security reasons.", "High Command Private Announcements")
		tmpTime1 = 0

	if (prob(10) && tmpTime2 >= 6000)
		var/original_code = supply_codes[SOVIET]
		supply_codes[SOVIET] = rand(1000,9999)
		for (var/mob/living/carbon/human/H in human_mob_list)
			if (H.original_job && H.original_job.is_officer)
				if (H.original_job.base_type_flag() == SOVIET)
					H.replace_memory(original_code, supply_codes[SOVIET])
		radio2soviets("The supply passcode has been changed to [supply_codes[SOVIET]] for security reasons.", "High Command Private Announcements")
		tmpTime2 = 0