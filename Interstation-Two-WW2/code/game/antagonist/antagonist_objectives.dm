/datum/antagonist/proc/create_global_objectives()
	if(config.objectives_disabled)
		return FALSE
	if(global_objectives && global_objectives.len)
		return FALSE
	return TRUE

/datum/antagonist/proc/create_objectives(var/datum/mind/player)
	if(config.objectives_disabled)
		return FALSE
	if(create_global_objectives() || global_objectives.len)
		player.objectives |= global_objectives
	return TRUE

/datum/antagonist/proc/get_special_objective_text()
	return ""

/datum/antagonist/proc/check_victory()
	var/result = TRUE
	if(config.objectives_disabled)
		return TRUE
	if(global_objectives && global_objectives.len)
		for(var/datum/objective/O in global_objectives)
			if(!O.completed && !O.check_completion())
				result = FALSE
		if(result && victory_text)
			world << "<span class='danger'><font size = 3>[victory_text]</font></span>"

		else if(loss_text)
			world << "<span class='danger'><font size = 3>[loss_text]</font></span>"


