var/global/datum/controller/occupations/job_master

#define GET_RANDOM_JOB FALSE
#define BE_ASSISTANT TRUE
#define RETURN_TO_LOBBY 2

#define MEMBERS_PER_SQUAD 6
#define LEADERS_PER_SQUAD TRUE

#define SL_LIMIT 4

/proc/setup_autobalance(var/announce = TRUE)
	spawn (0)
		if (job_master)
			job_master.toggle_roundstart_autobalance(0, announce)
	var/list/faction_organized_occupations_separate_lists = list()
	for (var/datum/job/J in job_master.occupations)
		var/Jflag = J.base_type_flag()
		if (!faction_organized_occupations_separate_lists.Find(Jflag))
			faction_organized_occupations_separate_lists[Jflag] = list()
		faction_organized_occupations_separate_lists[Jflag] += J
	job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[GERMAN]
	job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[SOVIET]
	job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[ITALIAN]
	job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[UKRAINIAN]
	job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[CIVILIAN]
	job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[PARTISAN]

/datum/controller/occupations
		//List of all jobs
	var/list/occupations = list()
		//List of all jobs ordered by faction: German, Soviet, Italian, Ukrainian, Civilian, Partisan
	var/list/faction_organized_occupations = list()
		//Players who need jobs
	var/list/unassigned = list()
		//Debug info
	var/list/job_debug = list()

	var/ruforce_count = FALSE
	var/geforce_count = FALSE
	var/civilian_count = FALSE
	var/partisan_count = FALSE

//	var/allow_jews = FALSE
//	var/allow_spies = FALSE
	var/allow_civilians = TRUE
	var/allow_partisans = TRUE

	var/allow_ukrainians = FALSE
	var/allow_italians = FALSE

	var/german_job_slots = 40
	var/soviet_job_slots = 40
	var/civilian_job_slots = 10
	var/partisan_job_slots = 10

	// How much of certain jobs can join at roundstart?
		// (after roundstart, only squad leaders and soldats for now)

	// Primary jobs:
	   // engineers, scouts, kanoniers, guards, etc
	// Secondary jobs:
	   // flammenwerfers, officers, etc
	 // Soldats:
	   // self explanatory
	 // Commander:
	   // always TRUE slot no matter what (for now)

	var/german_primary_job_slots = FALSE
	var/german_secondary_job_slots = FALSE
	var/german_soldat_slots = FALSE
	var/german_commander_slots = FALSE
	var/german_ss_slots = FALSE
	var/german_paratrooper_slots = FALSE
	var/german_ss_commander_slots = FALSE

	var/soviet_primary_job_slots = FALSE
	var/soviet_secondary_job_slots = FALSE
	var/soviet_soldat_slots = FALSE
	var/soviet_commander_slots = FALSE
	var/soviet_sturmovik_slots = FALSE

	var/italy_soldier_slots = FALSE
	var/italy_medic_slots = FALSE
	var/italy_SL_slots = FALSE

	var/ukraine_soldier_slots = FALSE
	var/ukraine_medic_slots = FALSE
	var/ukraine_SL_slots = FALSE

	// which squad are we trying to fill right now?
		// doesn't apply to partisans

	var/current_german_squad = TRUE
	var/current_soviet_squad = TRUE

	var/german_squad_members = FALSE
	var/german_squad_leaders = FALSE

	var/soviet_squad_members = FALSE
	var/soviet_squad_leaders = FALSE

	var/german_squad_info[4]
	var/soviet_squad_info[4]

	var/german_officer_squad_info[4]
	var/soviet_officer_squad_info[4]

	var/expected_clients = 0

	proc/total_german_slots()
		. = FALSE
		. += german_primary_job_slots = FALSE
		. += german_secondary_job_slots = FALSE
		. += german_soldat_slots = FALSE
		. += german_commander_slots = FALSE
		. += german_ss_slots = FALSE
		. += german_paratrooper_slots = FALSE
		. += german_ss_commander_slots = FALSE

	proc/total_soviet_slots()
		. = FALSE
		. += soviet_primary_job_slots = FALSE
		. += soviet_secondary_job_slots = FALSE
		. += soviet_soldat_slots = FALSE
		. += soviet_commander_slots = FALSE
		. += soviet_sturmovik_slots = FALSE

	proc/remaining_german_slots()
		. = german_job_slots
		. -= german_primary_job_slots
		. -= german_secondary_job_slots
		. -= german_soldat_slots
		. -= german_commander_slots
		. -= german_ss_commander_slots
		. -= german_ss_slots
		. -= german_paratrooper_slots

	proc/remaining_soviet_slots()
		. = soviet_job_slots
		. -= soviet_primary_job_slots
		. -= soviet_secondary_job_slots
		. -= soviet_soldat_slots
		. -= soviet_commander_slots
		. -= soviet_sturmovik_slots

	proc/n_percent_of_job_slots(n, team)
		switch (team)
			if (GERMAN)
				return max(1, round((german_job_slots * n)/100))
			if (SOVIET)
				return max(1, round((soviet_job_slots * n)/100))
			if (CIVILIAN)
				return max(1, round((civilian_job_slots * n)/100))
			if (PARTISAN)
				return max(1, round((partisan_job_slots * n)/100))

	// sets up the new autobalance system based on the assumption that
	// ~90% of clients in the lobby will join as a role prior to the train
	// being sent

	proc/toggle_roundstart_autobalance(var/_clients = 0, var/announce = TRUE)

		if (_clients != 0)
			expected_clients = _clients

		if (expected_clients)
			_clients = expected_clients
		else
			_clients = clients.len

		if (announce)
			world << "<span class = 'warning'>Setting up roundstart autobalance for [_clients] players.</span>"

		var/expected_players = _clients * 0.9

		// number of roles, between both sides, that will be open.
		// greater than the number of expected players to account for
		// newcomers, and people who die before the train is sent,
		// but respawn

		var/total_job_slots = ceil(expected_players * 1.4)

		// unique job slots. These will result in slightly more than
		// total_job_slots if you add all 3 up, but that isn't important.
		// total_job_slots isn't used after this

		german_job_slots = round(total_job_slots * 0.4)

		soviet_job_slots = german_job_slots + 5

		civilian_job_slots = round(soviet_job_slots/4)

		partisan_job_slots = civilian_job_slots


//		allow_jews = initial(allow_jews)
//		allow_spies = initial(allow_spies)
		allow_civilians = initial(allow_civilians)
		allow_partisans = initial(allow_partisans)

		// WIP
		allow_ukrainians = FALSE
		allow_italians = FALSE
		// what else do we want to do based on how many players we expect

		switch (expected_players)
			if (-INFINITY to 24)
			//	allow_jews = FALSE
			//	allow_spies = FALSE
				allow_civilians = FALSE
				allow_partisans = FALSE
			if (25 to 29)
		//		allow_spies = FALSE
				allow_civilians = FALSE
				allow_partisans = FALSE
			if (30 to 34)
				allow_civilians = FALSE
				allow_partisans = FALSE

		if (allow_civilians)
			for (var/datum/job/partisan/civilian/j in occupations)
				if (istype(j))
					j.total_positions = civilian_job_slots
		else
			for (var/datum/job/partisan/civilian/j in occupations)
				if (istype(j))
					j.total_positions = FALSE

		if (allow_partisans)
			for (var/datum/job/partisan/soldier/j in occupations)
				if (istype(j))
					j.total_positions = partisan_job_slots-1

			for (var/datum/job/partisan/commander/j in occupations)
				if (istype(j))
					j.total_positions = TRUE
		else
			for (var/datum/job/partisan/soldier/j in occupations)
				if (istype(j))
					j.total_positions = FALSE

			for (var/datum/job/partisan/commander/j in occupations)
				if (istype(j))
					j.total_positions = FALSE

		// disable base job types like '/datum/job/german'

		for (var/datum/job/j in occupations)
			switch (j.type)
				if (/datum/job/german)
					j.total_positions = FALSE
				if (/datum/job/soviet)
					j.total_positions = FALSE
				if (/datum/job/italian)
					j.total_positions = FALSE
				if (/datum/job/ukrainian)
					j.total_positions = FALSE
				if (/datum/job/partisan)
					j.total_positions = FALSE
				// but NOT /datum/job/partisan/civilian as its a 'singleton'

		// GERMAN jobs

		// decide how many positions of each job type we have based on
		// number of open slots

		switch (german_job_slots)
			if (-INFINITY to 7) // this is so few slots, don't bother with special jobs
				german_primary_job_slots = FALSE
				german_secondary_job_slots = FALSE
				german_commander_slots = TRUE
				german_ss_slots = FALSE
				german_paratrooper_slots = FALSE
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = FALSE
			if (8 to 14) // small but not tiny. Deserves a few primary roles, and no secondary/tertiary
				german_primary_job_slots = n_percent_of_job_slots(50, GERMAN)
				german_secondary_job_slots = FALSE
				german_commander_slots = TRUE
				german_ss_slots = FALSE
				german_paratrooper_slots = FALSE
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = FALSE
			if (15 to 19) // decent sized team. Some primary and secondary roles.
				german_primary_job_slots = n_percent_of_job_slots(30, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(20, GERMAN)
				german_commander_slots = TRUE
				german_ss_slots = FALSE
				german_paratrooper_slots = FALSE
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = FALSE
			if (20 to 24) // good sized team, some of every role but no SS/para
				german_primary_job_slots = n_percent_of_job_slots(30, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(20, GERMAN)
				german_commander_slots = TRUE
				german_ss_slots = FALSE
				german_paratrooper_slots = FALSE
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = FALSE
			if (25 to 29) // good sized team. Let's give them SS or paratroopers, but not both. And more officers.
				german_primary_job_slots = n_percent_of_job_slots(30, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(20, GERMAN)
				german_commander_slots = TRUE
				german_ss_slots = FALSE
				german_paratrooper_slots = n_percent_of_job_slots(25, GERMAN)
				german_ss_commander_slots = FALSE
				german_soldat_slots = remaining_german_slots() + 2
			if (30 to 34) // large team. They get SS and paratroopers.
				german_primary_job_slots = n_percent_of_job_slots(25, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(25, GERMAN)
				german_commander_slots = TRUE
				german_ss_slots = n_percent_of_job_slots(25, GERMAN)
				german_paratrooper_slots = n_percent_of_job_slots(25, GERMAN)
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = TRUE
			if (35 to INFINITY) // largest team
				german_primary_job_slots = n_percent_of_job_slots(25, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(25, GERMAN)
				german_commander_slots = TRUE
				german_ss_slots = n_percent_of_job_slots(20, GERMAN)
				german_paratrooper_slots = n_percent_of_job_slots(20, GERMAN)
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = TRUE


		// useful information

		var/primary_german_jobs = FALSE
		var/secondary_german_jobs = FALSE

		for (var/datum/job/german/j in occupations)
			if (istype(j))
				if (j.is_primary && !j.is_secondary && !j.is_commander && !j.is_officer && !j.is_SS && !j.is_paratrooper && !istype(j, /datum/job/german/soldier) && !j.is_squad_leader)
					++primary_german_jobs
				else if (j.is_secondary)
					++secondary_german_jobs


		for (var/datum/job/german/j in occupations)

			if (istype(j))
				if (istype(j, /datum/job/german/soldier))
					j.total_positions = german_soldat_slots
				else if (j.is_primary && !j.is_secondary && !j.is_commander && !j.is_paratrooper && !j.is_SS && !j.is_officer)
					j.total_positions = max(round(german_primary_job_slots/primary_german_jobs), TRUE)
				else if (j.is_secondary && !j.is_commander && !j.is_officer && !j.is_paratrooper && !j.is_SS)
					j.total_positions = max(round(german_secondary_job_slots/secondary_german_jobs), TRUE)
				else if (j.is_commander)
					if (j.is_SS)
						j.total_positions = german_ss_commander_slots
					else
						j.total_positions = german_commander_slots
				else if (j.is_officer)
					if (!j.is_squad_leader)
						j.total_positions = max(round(german_secondary_job_slots/secondary_german_jobs), TRUE)
					else
						j.total_positions = SL_LIMIT
				else if (j.is_SS)
					j.total_positions = german_ss_slots
				if (j.absolute_limit)
					j.total_positions = min(j.total_positions, j.absolute_limit)

			// SPECIAL
			if (istype(j, /datum/job/german/flamethrower_man))
				if (clients.len <= 15)
					j.total_positions = FALSE
					for (var/obj/item/weapon/storage/backpack/flammenwerfer/F in world)
						qdel(F)

			else if (istype(j, /datum/job/german/artyman))
				if (!locate(/obj/machinery/artillery) in world)
					j.total_positions = FALSE
				else if (clients.len <= 15)
					j.total_positions = FALSE

			else if (istype(j, /datum/job/german/anti_tank_crew) || istype(j, /datum/job/german/tankcrew))
				spawn (5)
					if (!locate(/obj/tank) in world)
						j.total_positions = FALSE

			else if (istype(j, /datum/job/german/paratrooper) && (!fallschirm_landmarks.len || clients.len <= 20))
				german_soldat_slots += german_paratrooper_slots
				german_paratrooper_slots = FALSE
				j.total_positions = FALSE

		for (var/datum/job/soviet/j in occupations)
			if (istype(j, /datum/job/soviet/anti_tank_crew) || istype(j, /datum/job/soviet/tankcrew))
				spawn (5)
					if (!locate(/obj/tank) in world)
						j.total_positions = FALSE

		for (var/datum/job/j in occupations)
			if (j.title == "generic job")
				j.total_positions = FALSE

		// SOVIET jobs

		// decide how many positions of each job type we have based on
		// number of open slots

		switch (soviet_job_slots)
			if (-INFINITY to 7) // this is so few slots, don't bother with special jobs
				soviet_primary_job_slots = FALSE
				soviet_secondary_job_slots = FALSE
				soviet_sturmovik_slots = FALSE
				soviet_commander_slots = TRUE
				soviet_soldat_slots = remaining_soviet_slots() + 2
			if (8 to 14) // small but not tiny. Deserves a few primary roles, and no secondary/tertiary
				soviet_primary_job_slots = n_percent_of_job_slots(60, SOVIET)
				soviet_secondary_job_slots = FALSE
				soviet_sturmovik_slots = FALSE
				soviet_commander_slots = TRUE
				soviet_soldat_slots = remaining_soviet_slots() + 2
			if (15 to 19) // decent sized team. Some primary and secondary roles.
				soviet_primary_job_slots = n_percent_of_job_slots(35, SOVIET)
				soviet_secondary_job_slots = n_percent_of_job_slots(25, SOVIET)
				soviet_sturmovik_slots = FALSE
				soviet_commander_slots = TRUE
				soviet_soldat_slots = remaining_soviet_slots() + 2
			if (20 to 24) // good sized team, some of every role but no sturms
				soviet_primary_job_slots = n_percent_of_job_slots(30, SOVIET)
				soviet_secondary_job_slots = n_percent_of_job_slots(30, SOVIET)
				soviet_sturmovik_slots = FALSE
				soviet_commander_slots = TRUE
				soviet_soldat_slots = remaining_soviet_slots() + 2
			if (25 to 29) // good sized team, they get sturms
				soviet_primary_job_slots = n_percent_of_job_slots(30, SOVIET)
				soviet_secondary_job_slots = n_percent_of_job_slots(30, SOVIET)
				soviet_commander_slots = TRUE
				soviet_sturmovik_slots = n_percent_of_job_slots(15, SOVIET)
				soviet_soldat_slots = remaining_soviet_slots() + 2
			if (30 to 34) // large team, they get sturms
				soviet_primary_job_slots = n_percent_of_job_slots(30, SOVIET)
				soviet_secondary_job_slots = n_percent_of_job_slots(30, SOVIET)
				soviet_sturmovik_slots = n_percent_of_job_slots(15, SOVIET)
				soviet_commander_slots = TRUE
				soviet_soldat_slots = remaining_soviet_slots() + 2
			if (35 to INFINITY) // largest team
				soviet_primary_job_slots = n_percent_of_job_slots(30, SOVIET)
				soviet_secondary_job_slots = n_percent_of_job_slots(30, SOVIET)
				soviet_sturmovik_slots = n_percent_of_job_slots(15, SOVIET)
				soviet_commander_slots = TRUE
				soviet_soldat_slots = remaining_soviet_slots() + 2

		// useful information

		var/primary_soviet_jobs = FALSE
		var/secondary_soviet_jobs = FALSE

		for (var/datum/job/soviet/j in occupations)
			if (istype(j))
				if (j.is_primary && !j.is_secondary && !j.is_commander && !j.is_officer && !istype(j, /datum/job/soviet/soldier) && !j.is_squad_leader)
					j.is_primary = TRUE
					j.is_secondary = FALSE
					++primary_soviet_jobs
				else if (j.is_secondary)
					j.is_primary = FALSE
					j.is_secondary = TRUE
					++secondary_soviet_jobs
				else
					j.is_primary = FALSE
					j.is_secondary = FALSE

		for (var/datum/job/soviet/j in occupations)

			if (istype(j))
				if (istype(j, /datum/job/soviet/soldier))
					j.total_positions = soviet_soldat_slots
				else if (j.is_primary)
					j.total_positions = max(round(soviet_primary_job_slots/primary_soviet_jobs), TRUE)
				else if (j.is_secondary)
					j.total_positions = max(round(soviet_secondary_job_slots/secondary_soviet_jobs), TRUE)
				else if (j.is_commander)
					j.total_positions = soviet_commander_slots
				else if (j.is_officer)
					if (!j.is_squad_leader)
						j.total_positions = max(round(soviet_secondary_job_slots/secondary_soviet_jobs), TRUE)
					else
						j.total_positions = SL_LIMIT

				if (j.absolute_limit)
					j.total_positions = min(j.total_positions, j.absolute_limit)

		// equalize amount of jobs

		while (total_german_slots() > total_soviet_slots())
			++soviet_soldat_slots
			for (var/datum/job/soviet/soldier/j in occupations)
				if (istype(j))
					j.total_positions = soviet_soldat_slots

		while (total_soviet_slots() > total_german_slots())
			++german_soldat_slots
			for (var/datum/job/german/soldier/j in occupations)
				if (istype(j))
					j.total_positions = german_soldat_slots

		// helper faction jobs
		for (var/datum/job/J in occupations)
			if (allow_italians)
				if (istype(J, /datum/job/italian))
					J.total_positions = TRUE
			else // not sure why I have to do this
				if (istype(J, /datum/job/italian))
					J.total_positions = FALSE

			if (allow_ukrainians)
				if (istype(J, /datum/job/ukrainian))
					J.total_positions = TRUE
			else
				if (istype(J, /datum/job/ukrainian))
					J.total_positions = FALSE

		// fixes the weirdest bug where total_positions == -1
		for (var/datum/job/j in occupations)
			if (j.total_positions == -1)
				j.total_positions = FALSE


	proc/spawn_with_delay(var/mob/new_player/np, var/datum/job/j)
		// for delayed spawning, wait the spawn_delay of the job
		// and lock up one job position while np is spawning
		if (!j.spawn_delay)
			return

		if (j.delayed_spawn_message)
			np << j.delayed_spawn_message

		np.delayed_spawning_as_job = j

		// occupy a position slot

		j.total_positions -= TRUE

		spawn (j.spawn_delay)
			if (np && np.delayed_spawning_as_job == j) // if np hasn't already spawned
				// if np did spawn, unoccupy the position slot
				np.AttemptLateSpawn(j.title)
				return

	// full squads, not counting SLs
	proc/full_squads(var/team)
		switch (team)
			if (GERMAN)
				return round(german_squad_members/MEMBERS_PER_SQUAD)
			if (SOVIET)
				return round(soviet_squad_members/MEMBERS_PER_SQUAD)
		return FALSE
/*
	proc/can_have_squad_leader(var/team)
		switch (team)
			if (GERMAN)
				switch (german_squad_members)
					if (1 to 6)
						if (!german_squad_leaders)
							return TRUE
					if (7 to 12)
						if (german_squad_leaders <= TRUE)
							return TRUE
					if (13 to 18)
						if (german_squad_leaders <= 2)
							return TRUE
					if (19 to INFINITY)
						if (german_squad_leaders <= 3)
							return TRUE
				return FALSE
			if (SOVIET)
				switch (soviet_squad_members)
					if (1 to 6)
						if (!soviet_squad_leaders)
							return TRUE
					if (7 to 12)
						if (soviet_squad_leaders <= TRUE)
							return TRUE
					if (13 to 18)
						if (soviet_squad_leaders <= 2)
							return TRUE
					if (19 to INFINITY)
						if (soviet_squad_leaders <= 3)
							return TRUE
				return FALSE
		return FALSE // if we aren't german or soviet this is irrelevant
			// and will never be called anyway
			*/
	proc/must_have_squad_leader(var/team)
		switch (team)
			if (GERMAN)
				if (full_squads(team) > german_squad_leaders && !(german_squad_leaders == 4))
					return TRUE
			if (SOVIET)
				if (full_squads(team) > soviet_squad_leaders && !(soviet_squad_leaders == 4))
					return TRUE
		return FALSE // not relevant for other teams

	proc/must_not_have_squad_leader(var/team)
		switch (team)
			if (GERMAN)
				if (german_squad_leaders > full_squads(team))
					return TRUE
			if (SOVIET)
				if (soviet_squad_leaders > full_squads(team))
					return TRUE
		return FALSE // not relevant for other teams


	// too many people joined as a soldier and not enough as SL
	// return FALSE if j is anything but a squad leader or special roles
	proc/squad_leader_check(var/mob/new_player/np, var/datum/job/j)
		var/current_squad = istype(j, /datum/job/german) ? current_german_squad : current_soviet_squad
		if (!j.is_commander && !j.is_nonmilitary && !j.is_SS && !j.is_paratrooper)
			// we're trying to join as a soldier or officer
			if (j.is_officer) // handle officer
				if (must_have_squad_leader(j.base_type_flag())) // only accept SLs
					if (!j.SL_check_independent)
						np << "<span class = 'danger'>Squad #[current_squad] needs a Squad Leader! You can't join as anything else until it has one. You can still spawn in through reinforcements, though.</span>"
						return FALSE
					else // we're joining as the SL or another allowed role
						return TRUE
			else
				if (must_have_squad_leader(j.base_type_flag())) // only accept SLs
					if (!j.SL_check_independent)
						np << "<span class = 'danger'>Squad #[current_squad] needs a Squad Leader! You can't join as anything else until it has one. You can still spawn in through reinforcements, though.</span>"
						return FALSE
		else
			if (must_have_squad_leader(j.base_type_flag()))
				if (!j.SL_check_independent)
					np << "<span class = 'danger'>Squad #[current_german_squad] needs a Squad Leader! You can't join as anything else until it has one. You can still spawn in through reinforcements, though.</span>"
					return FALSE
		return TRUE

	// too many people joined as a SL and not enough as soldier
	// return FALSE if j is a squad leader
	proc/squad_member_check(var/mob/new_player/np, var/datum/job/j)
		if (!j.is_commander && !j.is_nonmilitary && !j.is_SS && !j.is_paratrooper)
			// we're trying to join as a soldier or officer
			if (j.is_officer) // handle officer
				if (must_not_have_squad_leader(j.base_type_flag())) // don't accept SLs
					if (istype(j, /datum/job/german/squad_leader) || istype(j, /datum/job/soviet/squad_leader))
						np << "<span class = 'danger'>Squad #[current_german_squad] already has a Squad Leader! You can't join as one yet.</span>"
						return FALSE
					else
						return TRUE
		else
			if (must_have_squad_leader(j.base_type_flag()))
				if (!j.SL_check_independent)
					np << "<span class = 'danger'>Squad #[current_german_squad] needs a Squad Leader! You can't join as anything else until it has one.</span>"
					return FALSE
		return TRUE

	proc/relocate(var/mob/living/carbon/human/H)

		var/spawn_location = H.job_spawn_location

		if (!spawn_location && H.original_job)
			spawn_location = H.original_job.spawn_location

		#ifdef SPAWNLOC_DEBUG
		world << "[H]([H.original_job.title]) job spawn location = [H.job_spawn_location]"
		world << "[H]([H.original_job.title]) original job spawn location = [H.original_job.spawn_location]"
		world << "[H]([H.original_job.title]) spawn location = [spawn_location]"
		#endif

		var/list/turfs = latejoin_turfs[spawn_location]

		if(istype(H.original_job, /datum/job/german/paratrooper))
			return

		if(turfs && turfs.len > FALSE)
			H.loc = pick(turfs)

			if (!locate(H.loc) in turfs)
				var/tries = FALSE
				while (tries <= 5 && !locate(H.loc) in turfs)
					++tries
					H.loc = pick(turfs)
		// custom spawning
		else if (!istype(H.original_job, /datum/job/german/paratrooper))
			H << "\red Something went wrong while spawning you. Please contact an admin."

	proc/SetupOccupations(var/faction = "Station")
		occupations = list()
		var/list/all_jobs = typesof(/datum/job)
		if(!all_jobs.len)
			world << "\red \b Error setting up jobs, no job datums found"
			return FALSE
		for(var/J in all_jobs)
			var/datum/job/job = new J()
			if(!job)	continue
			if(job.faction != faction)	continue
			occupations += job

		return TRUE


	proc/Debug(var/text)
		if(!Debug2)	return FALSE
		job_debug.Add(text)
		return TRUE


	proc/GetJob(var/rank)
		if(!rank)	return null
		for(var/datum/job/J in occupations)
			if(!J)	continue
			if(J.title == rank)	return J
		return null

	proc/GetPlayerAltTitle(var/mob/new_player/player, rank)
		return player.original_job.title
	//	return player.client.prefs.GetPlayerAltTitle(GetJob(rank))

	proc/AssignRole(var/mob/new_player/player, var/rank, var/latejoin = FALSE, var/reinforcements = FALSE)
		Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
		if(player && rank)
			var/datum/job/job = GetJob(rank)
			if(!job)	return FALSE
			if(!job.player_old_enough(player.client)) return FALSE
			var/position_limit = job.total_positions
			if((job.current_positions < position_limit) || position_limit == -1 || reinforcements)
				Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
				if (player.mind)
					player.mind.assigned_role = rank
					player.mind.assigned_job = job
				player.original_job = job
				player.original_job_title = player.original_job.title
				if (player.mind)
					player.mind.role_alt_title = GetPlayerAltTitle(player, rank)
				unassigned -= player
				job.current_positions++
				return TRUE
		Debug("AR has failed, Player: [player], Rank: [rank]")
		return FALSE

	proc/FreeRole(var/rank)	//making additional slot on the fly
		var/datum/job/job = GetJob(rank)
		if(job && job.current_positions >= job.total_positions && job.total_positions != -1)
			job.total_positions++
			return TRUE
		return FALSE

	proc/FindOccupationCandidates(datum/job/job, level, flag)
		return
	/*	Debug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
		var/list/candidates = list()
		for(var/mob/new_player/player in unassigned)
			if(jobban_isbanned(player, job.title))
				Debug("FOC isbanned failed, Player: [player]")
				continue
			if(!job.player_old_enough(player.client))
				Debug("FOC player not old enough, Player: [player]")
				continue
		/*	if(flag && (!player.client.prefs.be_special & flag))
				Debug("FOC flag failed, Player: [player], Flag: [flag], ")
				continue*/
			if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
				Debug("FOC pass, Player: [player], Level:[level]")
				candidates += player
		return candidates*/

	proc/FindSideOccupationCandidates(department, level)
		return
	/*	Debug("Running FSOC, Department: [department], Level: [level]")
		var/list/candidates = list()
		for(var/mob/new_player/player in unassigned)
			for(var/datum/job/job in occupations)
				if(job.department_flag != department)
					continue
				if(jobban_isbanned(player, job.title))
					Debug("FSOC isbanned failed, Player: [player]")
					continue
				if(!job.player_old_enough(player.client))
					Debug("FSOC player not old enough, Player: [player]")
					continue
				if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
					Debug("FSOC pass, Player: [player], Level:[level]")
					candidates += player
					break
		return candidates*/

	proc/GiveRandomJob(var/mob/new_player/player)
		return
	/*
		Debug("GRJ Giving random job, Player: [player]")
		for(var/datum/job/job in shuffle(occupations))
			if(!job)
				continue

			if(istype(job, GetJob("Assistant"))) // We don't want to give him assistant, that's boring!
				continue

			if(job in command_positions) //If you want a command position, select it!
				continue

			if(jobban_isbanned(player, job.title))
				Debug("GRJ isbanned failed, Player: [player], Job: [job.title]")
				continue

			if(!job.player_old_enough(player.client))
				Debug("GRJ player not old enough, Player: [player]")
				continue

			if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
				Debug("GRJ Random job given, Player: [player], Job: [job]")
				AssignRole(player, job.title)
				unassigned -= player
				break*/

	proc/ResetOccupations()

		for(var/mob/new_player/player in player_list)
			if((player) && (player.mind))
				player.mind.assigned_role = null
				player.mind.special_role = null
		SetupOccupations()
		unassigned = list()
		return


	///This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
	proc/FillHeadPosition()
		for(var/level = TRUE to 3)
			for(var/command_position in command_positions)
				var/datum/job/job = GetJob(command_position)
				if(!job)	continue
				var/list/candidates = FindOccupationCandidates(job, level)
				if(!candidates.len)	continue

				// Build a weighted list, weight by age.
				var/list/weightedCandidates = list()

				// Different head positions have different good ages.
				var/good_age_minimal = 25
				var/good_age_maximal = 60
				if(command_position == "Captain")
					good_age_minimal = 30
					good_age_maximal = 70 // Old geezer captains ftw

				for(var/mob/V in candidates)
					// Log-out during round-start? What a bad boy, no head position for you!
					if(!V.client) continue
					var/age = V.client.prefs.age
					switch(age)
						if(good_age_minimal - 10 to good_age_minimal)
							weightedCandidates[V] = 3 // Still a bit young.
						if(good_age_minimal to good_age_minimal + 10)
							weightedCandidates[V] = 6 // Better.
						if(good_age_minimal + 10 to good_age_maximal - 10)
							weightedCandidates[V] = 10 // Great.
						if(good_age_maximal - 10 to good_age_maximal)
							weightedCandidates[V] = 6 // Still good.
						if(good_age_maximal to good_age_maximal + 10)
							weightedCandidates[V] = 6 // Bit old, don't you think?
						if(good_age_maximal to good_age_maximal + 50)
							weightedCandidates[V] = 3 // Geezer.
						else
							// If there's ABSOLUTELY NOBODY ELSE
							if(candidates.len == TRUE) weightedCandidates[V] = TRUE


				var/mob/new_player/candidate = pickweight(weightedCandidates)
				if(AssignRole(candidate, command_position))
					return TRUE
		return FALSE


	///This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
	proc/CheckHeadPositions(var/level)
		for(var/command_position in command_positions)
			var/datum/job/job = GetJob(command_position)
			if(!job)	continue
			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)	continue
			var/mob/new_player/candidate = pick(candidates)
			AssignRole(candidate, command_position)
		return


	proc/FillAIPosition()
		return


/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
	proc/DivideOccupations()
		return // this no longer works. I disabled it to fix errors - Kachnov

	/*	//Setup new player list and get the jobs list
		Debug("Running DO")
		SetupOccupations()

		//Holder for Triumvirate is stored in the ticker, this just processes it
		if(ticker && ticker.triai)
			for(var/datum/job/A in occupations)
				if(A.title == "AI")
					A.spawn_positions = 3
					break

		//Get the players who are ready
		for(var/mob/new_player/player in player_list)
			if(player.ready && player.mind && !player.mind.assigned_role)
				unassigned += player

		Debug("DO, Len: [unassigned.len]")
		if(unassigned.len == FALSE)	return FALSE

		//Shuffle players and jobs
		unassigned = shuffle(unassigned)
		var/list/shuffledoccupations = shuffle(occupations)

		HandleFeedbackGathering()

		for(var/level = TRUE to 3) //Spawn civs
			var/list/candidates = FindSideOccupationCandidates(CIVILIAN, level)
			for(var/mob/new_player/player in candidates)
				for(var/datum/job/job in shuffledoccupations)
					if(!job)
						Debug("DO civ no job error, Player: [player]")
						continue

					if(job.department_flag != CIVILIAN)
						Debug("DO civ wrong department, Player: [player], Job:[job.title]")
						continue

					if(jobban_isbanned(player, job.title))
						Debug("DO civ isbanned failed, Player: [player], Job:[job.title]")
						continue

					if(!job.player_old_enough(player.client))
						Debug("DO civ player not old enough, Player: [player], Job:[job.title]")
						continue

					// If the player wants that job on this level, then try give it to him.
					if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
						// If the job isn't filled
						if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
							Debug("DO civ pass, Player: [player], Level:[level], Job:[job.title]")
							AssignRole(player, job.title)
							unassigned -= player
							break
		/*
		var/spawnto = SOVIET
		for(var/level = TRUE to 3)
			var/list/rucandidates = FindSideOccupationCandidates(SOVIET, level)
			var/list/encandidates = FindSideOccupationCandidates(GERMAN, level)




			while(1)
				if(ticker.ruforce_count < ticker.enforce_count)
					department = SOVIET
				else
					department = GERMAN
				Debug("DO working, Department: [department]")

				var/list/candidates = FindSideOccupationCandidates(department, level)

				if(!candidates.len)
					if(department == CIVILIAN)
						Debug("DO no civ candidades, Level: [level]")
						civ_no_candidates = TRUE
						continue
					else
						Debug("DO no available players, Level: [level]")
						break

				var/mob/new_player/player = pick(candidates)

				if(department == CIVILIAN)
					civ_full = TRUE
					for(var/datum/job/job in shuffledoccupations)
						if(!job)	continue
						if(job.department_flag != CIVILIAN)	continue
						if(job.current_positions < job.total_positions || job.total_positions == -1)
							civ_full = FALSE
							break
					Debug("DO no more civilian slots")

				var/no_job = TRUE
				for(var/datum/job/job in shuffledoccupations)
					if(!job)
						Debug("DO no job error, Player: [player]")
						continue

					if(job.department_flag != department)
						Debug("DO wrong department, Player: [player], Job:[job.title]")
						continue

					if(jobban_isbanned(player, job.title))
						Debug("DO isbanned failed, Player: [player], Job:[job.title]")
						continue

					if(!job.player_old_enough(player.client))
						Debug("DO player not old enough, Player: [player], Job:[job.title]")
						continue

					// If the player wants that job on this level, then try give it to him.
					if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
						// If the job isn't filled
						if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
							Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
							AssignRole(player, job.title)
							unassigned -= player
							no_job = FALSE
							break

				if(no_job)
					Debug("DO fail, no job found, Player: [player], Level:[level]")
					unassigned -= player
					unoccupated += player
				else
					Debug("DO pass, job successfully set, Player: [player], Level:[level]")

		Debug("DO finished.")
		*/
		for(var/mob/new_player/player in unassigned)
			player << "\red You wasn't spawned due to auto-balance."


		//People who wants to be assistants, sure, go on.
		/*
		Debug("DO, Running Assistant Check TRUE")
		var/datum/job/assist = new DEFAULT_JOB_TYPE ()
		var/list/assistant_candidates = FindOccupationCandidates(assist, 3)
		Debug("AC1, Candidates: [assistant_candidates.len]")
		for(var/mob/new_player/player in assistant_candidates)
			Debug("AC1 pass, Player: [player]")
			AssignRole(player, "Assistant")
			assistant_candidates -= player
		Debug("DO, AC1 end")
		*/
		/*
		//Select one head
		Debug("DO, Running Head Check")
		FillHeadPosition()
		Debug("DO, Head Check end")

		//Check for an AI
		//Debug("DO, Running AI Check")
		//FillAIPosition()
		//Debug("DO, AI Check end")

		//Other jobs are now checked
		Debug("DO, Running Standard Check")


		// New job giving system by Donkie
		// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
		// Hopefully this will add more randomness and fairness to job giving.

		// Loop through all levels from high to low
		var/list/shuffledoccupations = shuffle(occupations)
		for(var/level = TRUE to 3)
			//Check the head jobs first each level
			CheckHeadPositions(level)

			// Loop through all unassigned players
			for(var/mob/new_player/player in unassigned)

				// Loop through all jobs
				for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
					if(!job)
						continue

					if(jobban_isbanned(player, job.title))
						Debug("DO isbanned failed, Player: [player], Job:[job.title]")
						continue

					if(!job.player_old_enough(player.client))
						Debug("DO player not old enough, Player: [player], Job:[job.title]")
						continue

					// If the player wants that job on this level, then try give it to him.
					if(player.client.prefs.GetJobDepartment(job, level) & job.flag)

						// If the job isn't filled
						if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
							Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
							AssignRole(player, job.title)
							unassigned -= player
							break

		// Hand out random jobs to the people who didn't get any in the last check
		// Also makes sure that they got their preference correct
		for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
				GiveRandomJob(player)
		/*
		Old job system
		for(var/level = TRUE to 3)
			for(var/datum/job/job in occupations)
				Debug("Checking job: [job]")
				if(!job)
					continue
				if(!unassigned.len)
					break
				if((job.current_positions >= job.spawn_positions) && job.spawn_positions != -1)
					continue
				var/list/candidates = FindOccupationCandidates(job, level)
				while(candidates.len && ((job.current_positions < job.spawn_positions) || job.spawn_positions == -1))
					var/mob/new_player/candidate = pick(candidates)
					Debug("Selcted: [candidate], for: [job.title]")
					AssignRole(candidate, job.title)
					candidates -= candidate*/

		Debug("DO, Standard Check end")

		Debug("DO, Running AC2")

		// For those who wanted to be assistant if their preferences were filled, here you go.
		for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.alternate_option == BE_ASSISTANT)
				Debug("AC2 Assistant located, Player: [player]")
				AssignRole(player, "Assistant")

		//For ones returning to lobby
		for(var/mob/new_player/player in unassigned)
			if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
				player.ready = FALSE
				player.new_player_panel_proc()
				unassigned -= player
		return TRUE
		*/ */

	proc/EquipRank(var/mob/living/carbon/human/H, var/rank, var/joined_late = FALSE)
		if(!H)	return null

		var/datum/job/job = GetJob(rank)
	//	var/list/spawn_in_storage = list()

		if(job)
			// Equip custom gear loadout.
			/*
			var/list/custom_equip_slots = list() //If more than one item takes the same slot, all after the first one spawn in storage.
			var/list/custom_equip_leftovers = list()
			if(H.client.prefs.gear && H.client.prefs.gear.len && job.title != "Cyborg" && job.title != "AI")

				for(var/thing in H.client.prefs.gear)
					var/datum/gear/G = gear_datums[thing]
					if(G)
						var/permitted
						if(G.allowed_roles)
							for(var/job_name in G.allowed_roles)
								if(job.title == job_name)
									permitted = TRUE
						else
							permitted = TRUE

						if(!permitted)
							H << "\red Your current job or whitelist status does not permit you to spawn with [thing]!"
							continue

						if(G.slot && !(G.slot in custom_equip_slots))
							// This is a miserable way to fix the loadout overwrite bug, but the alternative requires
							// adding an arg to a bunch of different procs. Will look into it after this merge. ~ Z
							if(G.slot == slot_wear_mask || G.slot == slot_wear_suit || G.slot == slot_head)
								custom_equip_leftovers += thing
							else if(H.equip_to_slot_or_del(new G.path(H), G.slot))
								H << "\blue Equipping you with [thing]!"
								custom_equip_slots.Add(G.slot)
							else
								custom_equip_leftovers.Add(thing)
						else
							spawn_in_storage += thing*/
			//Equip job items.

			job.equip(H)

			// civs and partisans
			if (istype(job, /datum/job/partisan))
				H.equip_coat(/obj/item/clothing/suit/coat/civilian)
			else if (istype(job, /datum/job/german))
				if (job.is_officer)
					H.equip_coat(/obj/item/clothing/suit/coat/german/officer)
				else if (job.is_SS)
					H.equip_coat(/obj/item/clothing/suit/coat/german/SS)
				else
					H.equip_coat(/obj/item/clothing/suit/coat/german)
			else if (istype(job, /datum/job/soviet))
				if (job.is_officer)
					H.equip_coat(/obj/item/clothing/suit/coat/soviet/officer)
				else
					H.equip_coat(/obj/item/clothing/suit/coat/soviet)
			// Give the guy some ammo for his gun
			spawn (0)
				if (istype(ticker.mode, /datum/game_mode/ww2))
					for (var/obj/item/weapon/gun/projectile/gun in H)
						if (!H.r_store)
							if (gun.magazine_type)
								H.equip_to_slot_or_drop(new gun.magazine_type(H), slot_r_store)
						if (!H.l_store)
							if (gun.magazine_type)
								H.equip_to_slot_or_drop(new gun.magazine_type(H), slot_l_store)
						break // but only the first gun we find
					for (var/obj/item/weapon/gun/projectile/gun in H.belt)
						if (!H.r_store)
							if (gun.magazine_type)
								H.equip_to_slot_or_drop(new gun.magazine_type(H), slot_r_store)
						if (!H.l_store)
							if (gun.magazine_type)
								H.equip_to_slot_or_drop(new gun.magazine_type(H), slot_l_store)
						break // but only the first gun we find

			// get our new real name based on jobspecific language ( and more
			job.update_character(H)
			job.apply_fingerprints(H)

			if (names_used[H.real_name])
				job.give_random_name(H)
			names_used[H.real_name] = TRUE

			if (job.rank_abbreviation)
				H.real_name = "[job.rank_abbreviation]. [H.real_name]"
				H.name = H.real_name

			switch (job.base_type_flag())
				if (SOVIET)
					++ruforce_count
				if (CIVILIAN)
					++civilian_count
				if (PARTISAN)
					++partisan_count
				if (GERMAN)
					++geforce_count

			//If some custom items could not be equipped before, try again now.
			/*for(var/thing in custom_equip_leftovers)
				var/datum/gear/G = gear_datums[thing]
				if(G.slot in custom_equip_slots)
					spawn_in_storage += thing
				else
					if(H.equip_to_slot_or_del(new G.path(H), G.slot))
						H << "\blue Equipping you with [thing]!"
						custom_equip_slots.Add(G.slot)
					else
						spawn_in_storage += thing
*/
			job.assign_faction(H)

			if (!game_started)
				if (!job.try_make_initial_spy(H))
					job.try_make_jew(H)
			else
				job.try_make_latejoin_spy(H)

			// removed /mob/living/job since it was confusing; it wasn't a job, but a job title
			H.original_job = job
			H.original_job_title = H.original_job.title

			#ifdef SPAWNLOC_DEBUG
			if (H.original_job)
				world << "[H]'s original job: [H.original_job]"
			else
				world << "<span class = 'danger'>WARNING: [H] has no original job!!</span>"
			#endif

			var/spawn_location = H.original_job.spawn_location
			H.job_spawn_location = spawn_location

			#ifdef SPAWNLOC_DEBUG
			world << "[H] ([rank]) spawn location = [spawn_location]"
			#endif

			if (!spawn_location)
				switch (H.original_job.base_type_flag())
					if (GERMAN)
						spawn_location = "JoinLateHeer"
					if (SOVIET)
						spawn_location = "JoinLateRA"

			// may fix soviets spawning in the german train, unknown - Kach
			if (!spawn_location)
				switch (splittext(H.original_job.spawn_location, "-")[1])
					if ("JoinLateHeer")
						spawn_location = "JoinLateHeer"
					if ("JoinLateRA")
						spawn_location = "JoinLateRA"

			H.job_spawn_location = spawn_location

			#ifdef SPAWNLOC_DEBUG
			world << "got to squadsetting code"
			#endif

			if (H.original_job.base_type_flag() == GERMAN)
				current_german_squad = max(current_german_squad, H.squad_faction ? H.squad_faction.actual_number : current_german_squad)
			else if (H.original_job.base_type_flag() == SOVIET)
				current_soviet_squad = max(current_soviet_squad, H.squad_faction ? H.squad_faction.actual_number : current_soviet_squad)

			#ifdef SPAWNLOC_DEBUG
			world << "got past squadsetting code"
			#endif

			if (H.squad_faction)
				switch (spawn_location)
					// German
					if ("JoinLateHeer")
						spawn_location = "JoinLateHeer-S[current_german_squad]"
					if ("JoinLateHeerSL")
						spawn_location = "JoinLateHeer-S[current_german_squad]-Leader"
					// Soviet
					if ("JoinLateRA")
						spawn_location = "JoinLateRA-S[current_soviet_squad]"
					if ("JoinLateRASL")
						spawn_location = "JoinLateRA-S[current_soviet_squad]-Leader"

			H.job_spawn_location = spawn_location

			if (isgermansquadmember_or_leader(H))
				if (isgermansquadleader(H))
					++german_squad_leaders
					german_squad_info[current_german_squad] = "<b>The leader of your squad (#[current_german_squad]) is [H.real_name]. He has a golden HUD.</b>"
					world << "<b>The leader of Wehrmacht Squad #[current_german_squad] is [H.real_name]!</b>"
					german_officer_squad_info[current_german_squad] = "<b><i>The leader of squad #[current_german_squad] is [H.real_name].</i></b>"
				else
					if (!job.is_officer && !job.is_SS && !job.is_paratrooper && !job.is_nonmilitary)
						++german_squad_members
						if (german_squad_info[current_german_squad])
							spawn (0)
								H << german_squad_info[current_german_squad]
						else
							spawn (2)
								H << "<i>Your squad, #[current_german_squad], does not have a Squad Leader yet. Consider waiting for one before deploying.</i>"

			else if (issovietsquadmember_or_leader(H))
				if (issovietsquadleader(H))
					soviet_squad_info[current_soviet_squad] = "<b>The leader of your squad (#[current_soviet_squad]) is [H.real_name]. He has a golden HUD.</b>"
					world << "<b>The leader of Soviet Squad #[current_soviet_squad] is [H.real_name]!</b>"
					soviet_officer_squad_info[current_soviet_squad] = "<b><i>The leader of squad #[current_soviet_squad] is [H.real_name].</i></b>"
					++soviet_squad_leaders
				else
					if (!job.is_officer)
						++soviet_squad_members
						if (soviet_squad_info[current_soviet_squad])
							spawn (0)
								H << soviet_squad_info[current_soviet_squad]
						else
							spawn (2)
								H << "<i>Your squad, #[current_soviet_squad], does not have a Squad Leader yet. Consider waiting for one before deploying.</i>"

			else if (H.original_job.is_officer && H.original_job.base_type_flag() == SOVIET)
				spawn (5)
					for (var/i in TRUE to soviet_officer_squad_info.len)
						if (soviet_officer_squad_info[i])
							H << "<br>[soviet_officer_squad_info[i]]"
			else if (H.original_job.is_officer && H.original_job.base_type_flag() == GERMAN)
				spawn (5)
					for (var/i in TRUE to german_officer_squad_info.len)
						if (german_officer_squad_info[i])
							H << "<br>[german_officer_squad_info[i]]"

			#ifdef SPAWNLOC_DEBUG
			world << "[H] ([rank]) GOT TO job spawn location = [H.job_spawn_location]"
			#endif

			var/alt_title = null
			if(H.mind)
				H.mind.assigned_role = rank
				alt_title = H.mind.role_alt_title

				//Deferred item spawning.
				/*
				if(spawn_in_storage && spawn_in_storage.len)
					var/obj/item/weapon/storage/B
					for(var/obj/item/weapon/storage/S in H.contents)
						B = S
						break

					if(!isnull(B))
						for(var/thing in spawn_in_storage)
							H << "\blue Placing [thing] in your [B]!"
							var/datum/gear/G = gear_datums[thing]
							new G.path(B)
					else
						H << "\red Failed to locate a storage object on your mob, either you spawned with no arms and no backpack or this is a bug."
*/
			if(istype(H)) //give humans wheelchairs, if they need them.
				var/obj/item/organ/external/l_foot = H.get_organ("l_foot")
				var/obj/item/organ/external/r_foot = H.get_organ("r_foot")
				if((!l_foot || l_foot.status & ORGAN_DESTROYED) && (!r_foot || r_foot.status & ORGAN_DESTROYED))
					var/obj/structure/bed/chair/wheelchair/W = new /obj/structure/bed/chair/wheelchair(H.loc)
					H.buckled = W
					H.update_canmove()
					W.set_dir(H.dir)
					W.buckled_mob = H
					W.add_fingerprint(H)


			#ifdef SPAWNLOC_DEBUG
			world << "[H] ([rank]) GOT TO before spawnID()"
			#endif

			spawnKeys(H, rank, alt_title)

			#ifdef SPAWNLOC_DEBUG
			world << "[H] ([rank]) GOT TO after spawnID()"
			#endif

			if(job.req_admin_notify)
				H << "<b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b>"
			//Gives glasses to the vision impaired
			if(H.disabilities & NEARSIGHTED)
				var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
				if(equipped != TRUE)
					var/obj/item/clothing/glasses/G = H.glasses
					G.prescription = TRUE

			BITSET(H.hud_updateflag, ID_HUD)
			BITSET(H.hud_updateflag, IMPLOYAL_HUD)
			BITSET(H.hud_updateflag, SPECIALROLE_HUD)
			BITSET(H.hud_updateflag, FACTION_TO_ENEMIES)
			BITSET(H.hud_updateflag, SPY_FACTION)
			BITSET(H.hud_updateflag, OFFICER_FACTION)
			BITSET(H.hud_updateflag, BASE_FACTION)
			BITSET(H.hud_updateflag, SQUAD_FACTION)

			relocate(H)

			return H

	proc/spawnKeys(var/mob/living/carbon/human/H, rank, title)

		if(!H)	return FALSE

		var/datum/job/job = null
		for(var/datum/job/J in occupations)
			if(J.title == rank)
				job = J
				break

		if (job.uses_keys)
			spawn_keys(H, rank, job)
			H << "<i>Click on a door with your <b>keychain</b> to open it. It will select the right key for you. To put the keychain in your hand, <b>drag</b> it.</i>"

		return TRUE

	proc/spawn_keys(var/mob/living/carbon/human/H, rank, var/datum/job/job)

		var/list/_keys = job.get_keys()
		if (!_keys.len)
			return

		var/obj/item/weapon/storage/belt/keychain/keychain = new/obj/item/weapon/storage/belt/keychain()

		if (!H.wear_id) // first, try to equip it to their ID slot
			H.equip_to_slot_or_del(keychain, slot_wear_id)
		if (!H.belt) // first, try to equip it as their belt
			H.equip_to_slot_or_del(keychain, slot_belt)

		var/list/keys = job.get_keys()

		for (var/obj/item/weapon/key in keys)
			if (keychain.can_be_inserted(key))
				keychain.handle_item_insertion(key)
				keychain.update_icon_state()
				keychain.keys += key

	proc/is_side_locked(side)
		if(!ticker)
			return TRUE
		if(side == SOVIET)
			if (soviets_forceEnabled)
				return FALSE
			if (side_is_hardlocked(side))
				return 2
			return !ticker.can_latejoin_ruforce
		else if(side == GERMAN)
			if (germans_forceEnabled)
				return FALSE
			if (side_is_hardlocked(side))
				return 2
			return !ticker.can_latejoin_geforce
		else if (side == CIVILIAN)
			if (civilians_forceEnabled)
				return FALSE
			return map.game_really_started()
		else if (side == PARTISAN)
			if (partisans_forceEnabled)
				return FALSE
			return map.game_really_started()
		return FALSE

	// this is a solution to 5 germans and TRUE soviet, on lowpop.
	proc/side_is_hardlocked(side)
		// when it's highpop enough for partisans
		// there aren't enough partisan roles for hardlocking to matter
		// for soviets and Germans, it's another matter
		// the generation of these two lists may take a lot of extra CPU,
		// but it's important if we want to keep up to date.

		// todo: faction lists structured like player_list (ie german_list)
		var/germans = n_of_side(GERMAN)
		var/soviets = n_of_side(SOVIET)

		switch (side)
			if (PARTISAN)
				if (partisans_forceEnabled)
					return FALSE
				return FALSE
			if (CIVILIAN)
				if (civilians_forceEnabled)
					return FALSE
				return FALSE
			if (GERMAN)
				if (germans_forceEnabled)
					return FALSE
				if (player_list.len >= 2 && player_list.len <= 20)
					if (germans >= ceil(player_list.len/2))
						return TRUE
			if (SOVIET)
				if (soviets_forceEnabled)
					return FALSE
				if (player_list.len >= 2 && player_list.len <= 20)
					if (soviets >= ceil(player_list.len/2))
						return TRUE
			if (UKRAINIAN, ITALIAN)
				return TRUE