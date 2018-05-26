/process/chemistry
	var/list/active_holders
	var/list/chemical_reactions
	var/list/chemical_reagents

/process/chemistry/setup()
	name = "chemistry"
	schedule_interval = 10 // every second
	active_holders = list()
	chemical_reactions = chemical_reactions_list
	chemical_reagents = chemical_reagents_list
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	priority = PROCESS_PRIORITY_MEDIUM
	processes.chemistry = src

/process/chemistry/fire()

	for (current in current_list)
		var/datum/reagents/holder = current
		if (!isDeleted(holder))
			if (!holder.process_reactions())
				active_holders -= holder
		else
			catchBadType(holder)
			active_holders -= holder
		current_list -= current
		PROCESS_TICK_CHECK

/process/chemistry/reset_current_list()
	if (current_list)
		current_list = null
	current_list = active_holders.Copy()

/process/chemistry/statProcess()
	..()
	stat(null, "[active_holders.len] reagent holder\s")

/process/chemistry/htmlProcess()
	return ..() + "[active_holders.len] reagent holders"

/process/chemistry/proc/mark_for_update(var/datum/reagents/holder)
	if (holder in active_holders)
		return

	//Process once, right away. If we still need to continue then add to the active_holders list and continue later
	if (holder.process_reactions())
		active_holders += holder
