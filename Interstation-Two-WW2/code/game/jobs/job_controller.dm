var/global/datum/controller/occupations/job_master

#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

#define MEMBERS_PER_SQUAD 6
#define LEADERS_PER_SQUAD 1

#define SL_LIMIT 4

//#define DEBUG_AUTOBALANCE

//#define SPAWNLOC_DEBUG

var/global/list/fallschirm_landmarks = list()

/proc/setup_autobalance(var/announce = 1)
	spawn (0)
		if (job_master)
			job_master.toggle_roundstart_autobalance(0, announce)

/datum/controller/occupations
		//List of all jobs
	var/list/occupations = list()
		//Players who need jobs
	var/list/unassigned = list()
		//Debug info
	var/list/job_debug = list()

	var/ruforce_count = 0
	var/geforce_count = 0
	var/civilian_count = 0
	var/partisan_count = 0

	var/allow_jews = 0
	var/allow_spies = 0
	var/allow_civilians = 1
	var/allow_partisans = 1

	var/german_job_slots = 40
	var/russian_job_slots = 40
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
	 // Comannder:
	   // always 1 slot no matter what (for now)

	var/german_primary_job_slots = 0
	var/german_secondary_job_slots = 0
	var/german_soldat_slots = 0
	var/german_commander_slots = 0
	var/german_ss_slots = 0
	var/german_paratrooper_slots = 0
	var/german_ss_commander_slots = 0

	var/russian_primary_job_slots = 0
	var/russian_secondary_job_slots = 0
	var/russian_soldat_slots = 0
	var/russian_commander_slots = 0
	var/russian_sturmovik_slots = 0

	// which squad are we trying to fill right now?
		// doesn't apply to partisans

	var/current_german_squad = 1
	var/current_russian_squad = 1

	var/german_squad_members = 0
	var/german_squad_leaders = 0

	var/russian_squad_members = 0
	var/russian_squad_leaders = 0

	var/german_squad_info[4]
	var/russian_squad_info[4]

	var/german_officer_squad_info[4]
	var/russian_officer_squad_info[4]
	// new autobalance system helpers lambdas when byond ree

	proc/total_german_slots()
		. = 0
		. += german_primary_job_slots = 0
		. += german_secondary_job_slots = 0
		. += german_soldat_slots = 0
		. += german_commander_slots = 0
		. += german_ss_slots = 0
		. += german_paratrooper_slots = 0
		. += german_ss_commander_slots = 0

	proc/total_russian_slots()
		. = 0
		. += russian_primary_job_slots = 0
		. += russian_secondary_job_slots = 0
		. += russian_soldat_slots = 0
		. += russian_commander_slots = 0
		. += russian_sturmovik_slots = 0

	proc/remaining_german_slots()
		. = german_job_slots
		. -= german_primary_job_slots
		. -= german_secondary_job_slots
		. -= german_soldat_slots
		. -= german_commander_slots
		. -= german_ss_commander_slots
		. -= german_ss_slots
		. -= german_paratrooper_slots

	proc/remaining_russian_slots()
		. = russian_job_slots
		. -= russian_primary_job_slots
		. -= russian_secondary_job_slots
		. -= russian_soldat_slots
		. -= russian_commander_slots
		. -= russian_sturmovik_slots

	proc/n_percent_of_job_slots(n, team)
		switch (team)
			if (GERMAN)
				return max(1, round((german_job_slots * n)/100))
			if (RUSSIAN)
				return max(1, round((russian_job_slots * n)/100))
			if (CIVILIAN)
				return max(1, round((civilian_job_slots * n)/100))
			if (PARTISAN)
				return max(1, round((partisan_job_slots * n)/100))

	// sets up the new autobalance system based on the assumption that
	// ~90% of clients in the lobby will join as a role prior to the train
	// being sent

	proc/toggle_roundstart_autobalance(var/_clients = 0, var/announce = 1)

		// how many unique clients we expect to play
		var/expected_players = 0

		#ifdef DEBUG_AUTOBALANCE
		if (!_clients)
			_clients = 100
		#else
		if (!_clients)
			_clients = clients.len
		#endif

		if (announce)
			world << "<span class = 'warning'>Setting up roundstart autobalance for [_clients] players.</span>"

		expected_players = _clients * 0.9

		// number of roles, between both sides, that will be open.
		// greater than the number of expected players to account for
		// newcomers, and people who die before the train is sent,
		// but respawn

		var/total_job_slots = ceil(expected_players * 1.4)

		// unique job slots. These will result in slightly more than
		// total_job_slots if you add all 3 up, but that isn't important.
		// total_job_slots isn't used after this

		german_job_slots = round(total_job_slots * 0.4)

		russian_job_slots = german_job_slots + 5

		civilian_job_slots = round(russian_job_slots/4)

		partisan_job_slots = civilian_job_slots


		allow_jews = initial(allow_jews)
		allow_spies = initial(allow_spies)
		allow_civilians = initial(allow_civilians)
		allow_partisans = initial(allow_partisans)
		// what else do we want to do based on how many players we expect

		switch (expected_players)
			if (-INFINITY to 24)
				allow_jews = 0
				allow_spies = 0
				allow_civilians = 0
				allow_partisans = 0
			if (25 to 29)
				allow_spies = 0
				allow_civilians = 0
				allow_partisans = 0
			if (30 to 34)
				allow_civilians = 0
				allow_partisans = 0

		if (allow_civilians)
			for (var/datum/job/partisan/civilian/j in occupations)
				if (istype(j))
					j.total_positions = civilian_job_slots

		if (allow_partisans)
			for (var/datum/job/partisan/soldier/j in occupations)
				if (istype(j))
					j.total_positions = partisan_job_slots-1
			for (var/datum/job/partisan/commander/j in occupations)
				if (istype(j))
					j.total_positions = 1

		// GERMAN jobs

		// decide how many positions of each job type we have based on
		// number of open slots

		switch (german_job_slots)
			if (-INFINITY to 7) // this is so few slots, don't bother with special jobs
				german_primary_job_slots = 0
				german_secondary_job_slots = 0
				german_commander_slots = 1
				german_ss_slots = 0
				german_paratrooper_slots = 0
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = 0
			if (8 to 14) // small but not tiny. Deserves a few primary roles, and no secondary/tertiary
				german_primary_job_slots = n_percent_of_job_slots(50, GERMAN)
				german_secondary_job_slots = 0
				german_commander_slots = 1
				german_ss_slots = 0
				german_paratrooper_slots = 0
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = 0
			if (15 to 19) // decent sized team. Some primary and secondary roles.
				german_primary_job_slots = n_percent_of_job_slots(30, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(20, GERMAN)
				german_commander_slots = 1
				german_ss_slots = 0
				german_paratrooper_slots = 0
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = 0
			if (20 to 24) // good sized team, some of every role but no SS/para
				german_primary_job_slots = n_percent_of_job_slots(30, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(20, GERMAN)
				german_commander_slots = 1
				german_ss_slots = 0
				german_paratrooper_slots = 0
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = 0
			if (25 to 29) // good sized team. Let's give them SS or paratroopers, but not both. And more officers.
				german_primary_job_slots = n_percent_of_job_slots(30, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(20, GERMAN)
				german_commander_slots = 1
				german_ss_slots = 0
				german_paratrooper_slots = n_percent_of_job_slots(25, GERMAN)
				german_ss_commander_slots = 0
				german_soldat_slots = remaining_german_slots() + 2
			if (30 to 34) // large team. They get SS and paratroopers.
				german_primary_job_slots = n_percent_of_job_slots(25, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(25, GERMAN)
				german_commander_slots = 1
				german_ss_slots = n_percent_of_job_slots(25, GERMAN)
				german_paratrooper_slots = n_percent_of_job_slots(25, GERMAN)
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = 1
			if (35 to INFINITY) // largest team
				german_primary_job_slots = n_percent_of_job_slots(25, GERMAN)
				german_secondary_job_slots = n_percent_of_job_slots(25, GERMAN)
				german_commander_slots = 1
				german_ss_slots = n_percent_of_job_slots(20, GERMAN)
				german_paratrooper_slots = n_percent_of_job_slots(20, GERMAN)
				german_soldat_slots = remaining_german_slots() + 2
				german_ss_commander_slots = 1

		// useful information

		var/primary_german_jobs = 0
		var/secondary_german_jobs = 0

		for (var/datum/job/german/j in occupations)
			if (istype(j))
				if (j.is_primary && !j.is_secondary && !j.is_commander && !j.is_officer && !j.is_SS && !j.is_paratrooper && !istype(j, /datum/job/german/soldier) && !j.is_squad_leader)
					++primary_german_jobs
				else if (j.is_secondary)
					++secondary_german_jobs


		#ifdef OCCDEBUG
		world << "german primary slots/jobs = [round(german_primary_job_slots/primary_german_jobs)]"
		world << "german secondary slots/jobs = [round(german_secondary_job_slots/secondary_german_jobs)]"
		#endif

		for (var/datum/job/german/j in occupations)

			if (istype(j))
				if (istype(j, /datum/job/german/soldier))
					j.total_positions = german_soldat_slots
				else if (j.is_primary && !j.is_secondary && !j.is_commander && !j.is_paratrooper && !j.is_SS && !j.is_officer)
					j.total_positions = max(round(german_primary_job_slots/primary_german_jobs), 1)
				else if (j.is_secondary && !j.is_commander && !j.is_officer && !j.is_paratrooper && !j.is_SS)
					j.total_positions = max(round(german_secondary_job_slots/secondary_german_jobs), 1)
				else if (j.is_commander)
					if (j.is_SS)
						j.total_positions = german_ss_commander_slots
					else
						j.total_positions = german_commander_slots
				else if (j.is_officer)
					if (!j.is_squad_leader)
						j.total_positions = max(round(german_secondary_job_slots/secondary_german_jobs), 1)
					else
						j.total_positions = SL_LIMIT
				else if (j.is_SS)
					j.total_positions = german_ss_slots
				if (j.absolute_limit)
					j.total_positions = min(j.total_positions, j.absolute_limit)
		// RUSSIAN jobs

		// decide how many positions of each job type we have based on
		// number of open slots

		switch (russian_job_slots)
			if (-INFINITY to 7) // this is so few slots, don't bother with special jobs
				russian_primary_job_slots = 0
				russian_secondary_job_slots = 0
				russian_sturmovik_slots = 0
				russian_commander_slots = 1
				russian_soldat_slots = remaining_russian_slots() + 2
			if (8 to 14) // small but not tiny. Deserves a few primary roles, and no secondary/tertiary
				russian_primary_job_slots = n_percent_of_job_slots(60, RUSSIAN)
				russian_secondary_job_slots = 0
				russian_sturmovik_slots = 0
				russian_commander_slots = 1
				russian_soldat_slots = remaining_russian_slots() + 2
			if (15 to 19) // decent sized team. Some primary and secondary roles.
				russian_primary_job_slots = n_percent_of_job_slots(35, RUSSIAN)
				russian_secondary_job_slots = n_percent_of_job_slots(25, RUSSIAN)
				russian_sturmovik_slots = 0
				russian_commander_slots = 1
				russian_soldat_slots = remaining_russian_slots() + 2
			if (20 to 24) // good sized team, some of every role but no sturms
				russian_primary_job_slots = n_percent_of_job_slots(30, RUSSIAN)
				russian_secondary_job_slots = n_percent_of_job_slots(30, RUSSIAN)
				russian_sturmovik_slots = 0
				russian_commander_slots = 1
				russian_soldat_slots = remaining_russian_slots() + 2
			if (25 to 29) // good sized team, they get sturms
				russian_primary_job_slots = n_percent_of_job_slots(30, RUSSIAN)
				russian_secondary_job_slots = n_percent_of_job_slots(30, RUSSIAN)
				russian_commander_slots = 1
				russian_sturmovik_slots = n_percent_of_job_slots(15, RUSSIAN)
				russian_soldat_slots = remaining_russian_slots() + 2
			if (30 to 34) // large team, they get sturms
				russian_primary_job_slots = n_percent_of_job_slots(30, RUSSIAN)
				russian_secondary_job_slots = n_percent_of_job_slots(30, RUSSIAN)
				russian_sturmovik_slots = n_percent_of_job_slots(15, RUSSIAN)
				russian_commander_slots = 1
				russian_soldat_slots = remaining_russian_slots() + 2
			if (35 to INFINITY) // largest team
				russian_primary_job_slots = n_percent_of_job_slots(30, RUSSIAN)
				russian_secondary_job_slots = n_percent_of_job_slots(30, RUSSIAN)
				russian_sturmovik_slots = n_percent_of_job_slots(15, RUSSIAN)
				russian_commander_slots = 1
				russian_soldat_slots = remaining_russian_slots() + 2

		// useful information

		var/primary_russian_jobs = 0
		var/secondary_russian_jobs = 0

		for (var/datum/job/russian/j in occupations)
			if (istype(j))
				if (j.is_primary && !j.is_secondary && !j.is_commander && !j.is_officer && !istype(j, /datum/job/russian/soldier) && !j.is_squad_leader)
					j.is_primary = 1
					j.is_secondary = 0
					++primary_russian_jobs
				else if (j.is_secondary)
					j.is_primary = 0
					j.is_secondary = 1
					++secondary_russian_jobs
				else
					j.is_primary = 0
					j.is_secondary = 0

		for (var/datum/job/russian/j in occupations)

			if (istype(j))
				if (istype(j, /datum/job/russian/soldier))
					j.total_positions = russian_soldat_slots
				else if (j.is_primary)
					j.total_positions = max(round(russian_primary_job_slots/primary_russian_jobs), 1)
				else if (j.is_secondary)
					j.total_positions = max(round(russian_secondary_job_slots/secondary_russian_jobs), 1)
				else if (j.is_commander)
					j.total_positions = russian_commander_slots
				else if (j.is_officer)
					if (!j.is_squad_leader)
						j.total_positions = max(round(russian_secondary_job_slots/secondary_russian_jobs), 1)
					else
						j.total_positions = SL_LIMIT

				if (j.absolute_limit)
					j.total_positions = min(j.total_positions, j.absolute_limit)
		// equalize amount of jobs

		while (total_german_slots() > total_russian_slots())
			++russian_soldat_slots
			for (var/datum/job/russian/soldier/j in occupations)
				if (istype(j))
					j.total_positions = russian_soldat_slots

		while (total_russian_slots() > total_german_slots())
			++german_soldat_slots
			for (var/datum/job/german/soldier/j in occupations)
				if (istype(j))
					j.total_positions = german_soldat_slots

		// fixes the weirdest bug
		for (var/datum/job/j in occupations)
			if (j.total_positions == -1)
				j.total_positions = 0


	proc/spawn_with_delay(var/mob/new_player/np, var/datum/job/j)
		// for delayed spawning, wait the spawn_delay of the job
		// and lock up one job position while np is spawning
		if (!j.spawn_delay)
			return

		if (j.delayed_spawn_message)
			np << j.delayed_spawn_message

		np.delayed_spawning_as_job = j

		// occupy a position slot

		j.total_positions -= 1

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
			if (RUSSIAN)
				return round(russian_squad_members/MEMBERS_PER_SQUAD)
		return 0
/*
	proc/can_have_squad_leader(var/team)
		switch (team)
			if (GERMAN)
				switch (german_squad_members)
					if (1 to 6)
						if (!german_squad_leaders)
							return 1
					if (7 to 12)
						if (german_squad_leaders <= 1)
							return 1
					if (13 to 18)
						if (german_squad_leaders <= 2)
							return 1
					if (19 to INFINITY)
						if (german_squad_leaders <= 3)
							return 1
				return 0
			if (RUSSIAN)
				switch (russian_squad_members)
					if (1 to 6)
						if (!russian_squad_leaders)
							return 1
					if (7 to 12)
						if (russian_squad_leaders <= 1)
							return 1
					if (13 to 18)
						if (russian_squad_leaders <= 2)
							return 1
					if (19 to INFINITY)
						if (russian_squad_leaders <= 3)
							return 1
				return 0
		return 0 // if we aren't german or russian this is irrelevant
			// and will never be called anyway
			*/
	proc/must_have_squad_leader(var/team)
		switch (team)
			if (GERMAN)
				if (full_squads(team) > german_squad_leaders)
					return 1
			if (RUSSIAN)
				if (full_squads(team) > russian_squad_leaders)
					return 1
		return 0 // not relevant for other teams

	proc/must_not_have_squad_leader(var/team)
		switch (team)
			if (GERMAN)
				if (german_squad_leaders > full_squads(team))
					return 1
			if (RUSSIAN)
				if (russian_squad_leaders > full_squads(team))
					return 1
		return 0 // not relevant for other teams


	// too many people joined as a soldier and not enough as SL
	// return 0 if j is anything but a squad leader
	proc/squad_leader_check(var/mob/new_player/np, var/datum/job/j)
		if (!j.is_commander && !j.is_nonmilitary && !j.is_SS && !j.is_paratrooper)
			// we're trying to join as a soldier or officer
			if (j.is_officer) // handle officer
				if (must_have_squad_leader(j.base_type_flag())) // only accept SLs
					if (!istype(j, /datum/job/german/squad_leader) && !istype(j, /datum/job/russian/squad_leader))
						np << "<span class = 'danger'>Squad #[current_german_squad] needs a Squad Leader! You can't join as anything else until it has one.</span>"
						return 0
					else // we're joining as the SL, chill fam
						return 1
			else
				if (must_have_squad_leader(j.base_type_flag())) // only accept SLs
					np << "<span class = 'danger'>Squad #[current_german_squad] needs a Squad Leader! You can't join as anything else until it has one.</span>"
					return 0
		else
			if (must_have_squad_leader(j.base_type_flag()))
				np << "<span class = 'danger'>Squad #[current_german_squad] needs a Squad Leader! You can't join as anything else until it has one.</span>"
				return 0
		return 1

	// too many people joined as a SL and not enough as soldier
	// return 0 if j is a squad leader
	proc/squad_member_check(var/mob/new_player/np, var/datum/job/j)
		if (!j.is_commander && !j.is_nonmilitary && !j.is_SS && !j.is_paratrooper)
			// we're trying to join as a soldier or officer
			if (j.is_officer) // handle officer
				if (must_not_have_squad_leader(j.base_type_flag())) // don't accept SLs
					if (istype(j, /datum/job/german/squad_leader) || istype(j, /datum/job/russian/squad_leader))
						np << "<span class = 'danger'>Squad #[current_german_squad] already has a Squad Leader! You can't join as one yet.</span>"
						return 0
					else
						return 1
		else
			if (must_have_squad_leader(j.base_type_flag()))
				np << "<span class = 'danger'>Squad #[current_german_squad] needs a Squad Leader! You can't join as anything else until it has one.</span>"
				return 0
		return 1

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

		if(turfs && turfs.len > 0)
			H.loc = pick(turfs)

			if (!locate(H.loc) in turfs)
				var/tries = 0
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
			return 0
		for(var/J in all_jobs)
			var/datum/job/job = new J()
			if(!job)	continue
			if(job.faction != faction)	continue
			occupations += job

		return 1


	proc/Debug(var/text)
		if(!Debug2)	return 0
		job_debug.Add(text)
		return 1


	proc/GetJob(var/rank)
		if(!rank)	return null
		for(var/datum/job/J in occupations)
			if(!J)	continue
			if(J.title == rank)	return J
		return null

	proc/GetPlayerAltTitle(var/mob/new_player/player, rank)
		return player.original_job.title
	//	return player.client.prefs.GetPlayerAltTitle(GetJob(rank))

	proc/AssignRole(var/mob/new_player/player, var/rank, var/latejoin = 0)
		Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
		if(player && player.mind && rank)
			var/datum/job/job = GetJob(rank)
			if(!job)	return 0
			if(jobban_isbanned(player, rank))	return 0
			if(!job.player_old_enough(player.client)) return 0
			var/position_limit = job.total_positions
			if((job.current_positions < position_limit) || position_limit == -1)
				Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
				player.mind.assigned_role = rank
				player.mind.assigned_job = job
				player.original_job = job
				player.mind.role_alt_title = GetPlayerAltTitle(player, rank)
				unassigned -= player
				job.current_positions++
				return 1
		Debug("AR has failed, Player: [player], Rank: [rank]")
		return 0

	proc/FreeRole(var/rank)	//making additional slot on the fly
		var/datum/job/job = GetJob(rank)
		if(job && job.current_positions >= job.total_positions && job.total_positions != -1)
			job.total_positions++
			return 1
		return 0

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
		for(var/level = 1 to 3)
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
							if(candidates.len == 1) weightedCandidates[V] = 1


				var/mob/new_player/candidate = pickweight(weightedCandidates)
				if(AssignRole(candidate, command_position))
					return 1
		return 0


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
		var/ai_selected = 0
		var/datum/job/job = GetJob("AI")
		if(!job)	return 0
		if((job.title == "AI") && (config) && (!config.allow_ai))	return 0

		for(var/i = job.total_positions, i > 0, i--)
			for(var/level = 1 to 3)
				var/list/candidates = list()
				if(ticker.mode.name == "AI malfunction")//Make sure they want to malf if its malf
					candidates = FindOccupationCandidates(job, level, BE_MALF)
				else
					candidates = FindOccupationCandidates(job, level)
				if(candidates.len)
					var/mob/new_player/candidate = pick(candidates)
					if(AssignRole(candidate, "AI"))
						ai_selected++
						break
			//Malf NEEDS an AI so force one if we didn't get a player who wanted it
			if((ticker.mode.name == "AI malfunction")&&(!ai_selected))
				unassigned = shuffle(unassigned)
				for(var/mob/new_player/player in unassigned)
					if(jobban_isbanned(player, "AI"))	continue
					if(AssignRole(player, "AI"))
						ai_selected++
						break
			if(ai_selected)	return 1
			return 0


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
		if(unassigned.len == 0)	return 0

		//Shuffle players and jobs
		unassigned = shuffle(unassigned)
		var/list/shuffledoccupations = shuffle(occupations)

		HandleFeedbackGathering()

		for(var/level = 1 to 3) //Spawn civs
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
		var/spawnto = RUSSIAN
		for(var/level = 1 to 3)
			var/list/rucandidates = FindSideOccupationCandidates(RUSSIAN, level)
			var/list/encandidates = FindSideOccupationCandidates(GERMAN, level)




			while(1)
				if(ticker.ruforce_count < ticker.enforce_count)
					department = RUSSIAN
				else
					department = GERMAN
				Debug("DO working, Department: [department]")

				var/list/candidates = FindSideOccupationCandidates(department, level)

				if(!candidates.len)
					if(department == CIVILIAN)
						Debug("DO no civ candidades, Level: [level]")
						civ_no_candidates = 1
						continue
					else
						Debug("DO no available players, Level: [level]")
						break

				var/mob/new_player/player = pick(candidates)

				if(department == CIVILIAN)
					civ_full = 1
					for(var/datum/job/job in shuffledoccupations)
						if(!job)	continue
						if(job.department_flag != CIVILIAN)	continue
						if(job.current_positions < job.total_positions || job.total_positions == -1)
							civ_full = 0
							break
					Debug("DO no more civilian slots")

				var/no_job = 1
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
							no_job = 0
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
		Debug("DO, Running Assistant Check 1")
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
		for(var/level = 1 to 3)
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
		for(var/level = 1 to 3)
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
				player.ready = 0
				player.new_player_panel_proc()
				unassigned -= player
		return 1
		*/ */

	proc/EquipRank(var/mob/living/carbon/human/H, var/rank, var/joined_late = 0)
		if(!H)	return null

		var/datum/job/job = GetJob(rank)
		var/list/spawn_in_storage = list()

		if(job)
			// Equip custom gear loadout.
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
									permitted = 1
						else
							permitted = 1

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
							spawn_in_storage += thing
			//Equip job items.

			job.equip(H)

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

			// get our new real name based on jobspecific language ( and more
			job.update_character(H)
			job.apply_fingerprints(H)

			if (names_used[H.real_name])
				H.original_job.give_random_name(H)
			names_used[H.real_name] = 1

			switch (job.base_type_flag())
				if (RUSSIAN)
					++ruforce_count
				if (CIVILIAN)
					++civilian_count
				if (PARTISAN)
					++partisan_count
				if (GERMAN)
					++geforce_count

			//If some custom items could not be equipped before, try again now.
			for(var/thing in custom_equip_leftovers)
				var/datum/gear/G = gear_datums[thing]
				if(G.slot in custom_equip_slots)
					spawn_in_storage += thing
				else
					if(H.equip_to_slot_or_del(new G.path(H), G.slot))
						H << "\blue Equipping you with [thing]!"
						custom_equip_slots.Add(G.slot)
					else
						spawn_in_storage += thing

			job.assign_faction(H)

			if (!game_started)
				if (!job.try_make_initial_spy(H))
					job.try_make_jew(H)
			else
				job.try_make_latejoin_spy(H)

			// removed /mob/living/job since it was confusing; it wasn't a job, but a job title
			H.original_job = job

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
					if (RUSSIAN)
						spawn_location = "JoinLateRA"

			// may fix russians spawning in the german train, unknown - Kach
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
			else if (H.original_job.base_type_flag() == RUSSIAN)
				current_russian_squad = max(current_russian_squad, H.squad_faction ? H.squad_faction.actual_number : current_russian_squad)

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
					// Russian
					if ("JoinLateRA")
						spawn_location = "JoinLateRA-S[current_russian_squad]"
					if ("JoinLateRASL")
						spawn_location = "JoinLateRA-S[current_russian_squad]-Leader"

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
								H << "<i>Your squad, #[current_german_squad], does not have a Squad Leader yet. Wait for one before deploying.</i>"

			else if (isrussiansquadmember_or_leader(H))
				if (isrussiansquadleader(H))
					russian_squad_info[current_russian_squad] = "<b>The leader of your squad (#[current_russian_squad]) is [H.real_name]. He has a golden HUD.</b>"
					world << "<b>The leader of Soviet Squad #[current_russian_squad] is [H.real_name]!</b>"
					russian_officer_squad_info[current_russian_squad] = "<b><i>The leader of squad #[current_russian_squad] is [H.real_name].</i></b>"
					++russian_squad_leaders
				else
					if (!job.is_officer)
						++russian_squad_members
						if (russian_squad_info[current_russian_squad])
							spawn (0)
								H << russian_squad_info[current_russian_squad]
						else
							spawn (2)
								H << "<i>Your squad, #[current_russian_squad], does not have a Squad Leader yet. Wait for one before deploying.</i>"

			else if (H.original_job.is_officer && H.original_job.base_type_flag() == RUSSIAN)
				spawn (5)
					for (var/i in 1 to russian_officer_squad_info.len)
						if (russian_officer_squad_info[i])
							H << "<br>[russian_officer_squad_info[i]]"
			else if (H.original_job.is_officer && H.original_job.base_type_flag() == GERMAN)
				spawn (5)
					for (var/i in 1 to german_officer_squad_info.len)
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
			// this spawns keys now
			spawnId(H, rank, alt_title)

			#ifdef SPAWNLOC_DEBUG
			world << "[H] ([rank]) GOT TO after spawnID()"
			#endif

			if(job.req_admin_notify)
				H << "<b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b>"
			//Gives glasses to the vision impaired
			if(H.disabilities & NEARSIGHTED)
				var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
				if(equipped != 1)
					var/obj/item/clothing/glasses/G = H.glasses
					G.prescription = 1

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


	proc/spawnId(var/mob/living/carbon/human/H, rank, title)

		if(!H)	return 0

		var/datum/job/job = null
		for(var/datum/job/J in occupations)
			if(J.title == rank)
				job = J
				break

		if (job.uses_keys)
			spawn_keys(H, rank, job)
			H << "<i>Click on a door with your <b>keychain</b> to open it. It will select the right key for you.</i>"

		return 1

	proc/spawn_keys(var/mob/living/carbon/human/H, rank, var/datum/job/job)

		var/list/_keys = job.get_keys()
		if (!_keys.len)
			return

		var/obj/item/weapon/storage/belt/keychain/keychain = new/obj/item/weapon/storage/belt/keychain()

		if (!H.belt) // first, try to equip it as their belt
			H.equip_to_slot_or_del(keychain, slot_belt)
		else // DISABLED because bugs, failing that
			if (istype(H.belt, /obj/item/weapon/storage/belt) && 0 == 1) // try to put it in their belt
				var/obj/item/weapon/storage/belt/belt = H.belt
				if (belt.can_be_inserted(keychain))
					belt.handle_item_insertion(keychain)
			else // then try to put it in their ID slot
				H.equip_to_slot_if_possible(keychain, slot_wear_id)
				if (H.wear_id != keychain) // wow
					H.equip_to_slot_if_possible(keychain, slot_l_store)
					if (H.l_store != keychain)
						H.equip_to_slot_if_possible(keychain, slot_r_store)


		var/list/keys = job.get_keys()

		for (var/obj/item/weapon/key in keys)
			if (keychain.can_be_inserted(key))
				keychain.handle_item_insertion(key)
				keychain.update_icon_state()
				keychain.keys += key

	proc/LoadJobs(jobsfile) //ran during round setup, reads info from jobs.txt -- Urist
		if(!config.load_jobs_from_txt)
			return 0

		var/list/jobEntries = file2list(jobsfile)

		for(var/job in jobEntries)
			if(!job)
				continue

			job = trim(job)
			if (!length(job))
				continue

			var/pos = findtext(job, "=")
			var/name = null
			var/value = null

			if(pos)
				name = copytext(job, 1, pos)
				value = copytext(job, pos + 1)
			else
				continue

			if(name && value)
				var/datum/job/J = GetJob(name)
				if(!J)	continue
				J.total_positions = text2num(value)
				if(name == "AI" || name == "Cyborg")//I dont like this here but it will do for now
					J.total_positions = 0

		return 1


	proc/HandleFeedbackGathering()
		return
	/*
		for(var/datum/job/job in occupations)
			var/tmp_str = "|[job.title]|"

			var/level1 = 0 //high
			var/level2 = 0 //medium
			var/level3 = 0 //low
			var/level4 = 0 //never
			var/level5 = 0 //banned
			var/level6 = 0 //account too young
			for(var/mob/new_player/player in player_list)
				if(!(player.ready && player.mind && !player.mind.assigned_role))
					continue //This player is not ready
				if(jobban_isbanned(player, job.title))
					level5++
					continue
				if(!job.player_old_enough(player.client))
					level6++
					continue
				if(player.client.prefs.GetJobDepartment(job, 1) & job.flag)
					level1++
				else if(player.client.prefs.GetJobDepartment(job, 2) & job.flag)
					level2++
				else if(player.client.prefs.GetJobDepartment(job, 3) & job.flag)
					level3++
				else level4++ //not selected

			tmp_str += "HIGH=[level1]|MEDIUM=[level2]|LOW=[level3]|NEVER=[level4]|BANNED=[level5]|YOUNG=[level6]|-"
		//	feedback_add_details("job_preferences",tmp_str)
*/
/datum/controller/occupations/proc/is_side_locked(side)
	if(!ticker)
		return 1
	if(side == RUSSIAN)
		return !ticker.can_latejoin_ruforce
	else if(side == GERMAN)
		return !ticker.can_latejoin_geforce
	else if (side == PARTISAN)
		return game_started
	return 0

// this works in favor of the soviets since they don't get SS
/datum/controller/occupations/proc/get_max_autobalance_diff()

	var/clients_len = 0

	if (clients)
		clients_len = clients.len

	switch (clients_len)

		if (0 to 10)

			return 1

		if (11 to 20)

			return 2

		if (21 to 30)

			return 3

		if (31 to 49)

			return 4

		if (50 to 59)

			return 5

		if (60 to INFINITY)

			return 6


