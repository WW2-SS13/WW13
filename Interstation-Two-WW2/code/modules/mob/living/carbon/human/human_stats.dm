/mob/living/carbon/human/proc/getStat(statname)
	return stats[lowertext(statname)][1]

/mob/living/carbon/human/proc/getMaxStat(statname)
	return stats[lowertext(statname)][2]

/mob/living/carbon/human/proc/getStatCoeff(statname)
	return stats[lowertext(statname)][1]/100

/mob/living/carbon/human/proc/setStat(statname, statval)
	statname = lowertext(statname)
	if (!stats.Find(statname))
		return

	statval += rand(-5,5)
	// realism + balancing
	if (gender == FEMALE)
		switch (statname)
			if ("strength")
				statval -= 4
			if ("medical")
				statval += 4
	stats[statname] = list(statval, statval)

/mob/living/carbon/human/proc/adaptStat(statname, multiplier)
	statname = lowertext(statname)
	if (!stats.Find(statname))
		return

	if (statname == "mg")
		stats[statname][1] *= (1 + (multiplier/300))
		stats[statname][2] *= (1 + (multiplier/300))
	else
		stats[statname][1] *= (1 + (multiplier/100))
		stats[statname][2] *= (1 + (multiplier/100))