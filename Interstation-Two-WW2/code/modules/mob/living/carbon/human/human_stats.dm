/mob/living/carbon/human/proc/getStat(statname)
	return stats[lowertext(statname)][1]

/mob/living/carbon/human/proc/getMaxStat(statname)
	return stats[lowertext(statname)][2]

/mob/living/carbon/human/proc/getStatCoeff(statname)
	return stats[lowertext(statname)][1]/100

/* if strength were '1.5' and engineering '1.6', then
 * getLesserStatCombinedCoeff(list("strength", "engineering")) would
 * return 1.31 */

/mob/living/carbon/human/proc/getLesserStatCombinedCoeff(var/list/statnames = list())
	. = 1 - (statnames.len/10)
	for (var/statname in statnames)
		. += stats[lowertext(statname)][1]/1000

/mob/living/carbon/human/proc/setStat(statname, statval)

	statname = lowertext(statname)
	if (!stats.Find(statname))
		return

	if (use_initial_stats)
		if (stats[statname] > statval)
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

	var/increase_multiple = 0.001 // 1 / 1000, to prevent crazy ugly decimals

	if (statname == "mg")
		stats[statname][1] *= (1 + round(multiplier/400, increase_multiple))
		stats[statname][2] *= (1 + round(multiplier/400, increase_multiple))

	else if (statname == "rifle" || statname == "pistol" || statname == "heavy")
		stats[statname][1] *= (1 + round(multiplier/150, increase_multiple))
		stats[statname][2] *= (1 + round(multiplier/150, increase_multiple))

	else if (statname == "medical")
		stats[statname][1] *= (1 + round(multiplier/300, increase_multiple))
		stats[statname][2] *= (1 + round(multiplier/300, increase_multiple))

	else
		stats[statname][1] *= (1 + round(multiplier/100, increase_multiple))
		stats[statname][2] *= (1 + round(multiplier/100, increase_multiple))

	// stats may not go over 1000
	for (var/sname in stats)
		stats[sname][1] = min(stats[sname][1], 1000.00)
		stats[sname][2] = min(stats[sname][1], 1000.00)