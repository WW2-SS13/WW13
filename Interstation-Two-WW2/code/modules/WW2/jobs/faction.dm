/* Job Factions

 - These are/will be used for spies, partisans, and squads.
 - They're like antagonist datums but much simpler. This is because
 it's extremely likely to end up with multiple of these
 - The main thing these do is give you a HUD that anyone with the same
 job faction can see

*/

// level 1 subtypes

/datum/job_faction

/datum/job_faction/partisan

/datum/job_faction/german

/datum/job_faction/russian

/datum/job_faction/spy_for_german

/datum/job_faction/spy_for_russian

// level 2 subtypes

// german squads

/datum/job_faction/german/alpha
/datum/job_faction/german/bravo
/datum/job_faction/german/charlie
/datum/job_faction/german/delta

// russian squads

/datum/job_faction/russian/alpha
/datum/job_faction/russian/bravo
/datum/job_faction/russian/charlie
/datum/job_faction/russian/delta

// CODE

/datum/job_faction/New(var/mob/living/carbon/human/H)
	if (!H || !istype(H))
