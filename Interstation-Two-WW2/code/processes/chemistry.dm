var/process/chemistry/chemistryProcess

/process/chemistry
	var/list/active_holders
	var/list/chemical_reactions
	var/list/chemical_reagents

/process/chemistry/setup()
	name = "chemistry"
	schedule_interval = 10 // every second
	chemistryProcess = src
	active_holders = list()
	chemical_reactions = chemical_reactions_list
	chemical_reagents = chemical_reagents_list
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)

/process/chemistry/fire()
	SCHECK
	for(last_object in active_holders)
		var/datum/reagents/holder = last_object
		if(!holder.process_reactions())
			active_holders -= holder
		SCHECK

/process/chemistry/statProcess()
	..()
	stat(null, "[active_holders.len] reagent holder\s")

/process/chemistry/htmlProcess()
	return ..() + "[active_holders.len] reagent holders"

/process/chemistry/proc/mark_for_update(var/datum/reagents/holder)
	if(holder in active_holders)
		return

	//Process once, right away. If we still need to continue then add to the active_holders list and continue later
	if(holder.process_reactions())
		active_holders += holder
