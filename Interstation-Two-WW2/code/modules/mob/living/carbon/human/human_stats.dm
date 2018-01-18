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
		stats[statname][1] *= (1 + (multiplier/400))
		stats[statname][2] *= (1 + (multiplier/400))
	else if (statname == "rifle" || statname == "pistol" || statname == "heavy")
		stats[statname][1] *= (1 + (multiplier/200))
		stats[statname][2] *= (1 + (multiplier/200))
	else
		stats[statname][1] *= (1 + (multiplier/100))
		stats[statname][2] *= (1 + (multiplier/100))

	// stats may not go over 500
	for (var/sname in stats)
		stats[sname][1] = min(stats[sname][1], 500.00)
		stats[sname][2] = min(stats[sname][1], 500.00)