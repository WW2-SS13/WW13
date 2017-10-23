// IF the job whitelist is enabled, are we whitelisted?
/datum/job/var/whitelisted = 0

// validate a new_player via the "jobs" whitelist datum
/datum/job/proc/validate(var/mob/new_player/np)
	var/datum/whitelist/W = global_whitelists["jobs"]
	if (!W)
		return 1
	else
		return W.validate(np.client)
	return 1
