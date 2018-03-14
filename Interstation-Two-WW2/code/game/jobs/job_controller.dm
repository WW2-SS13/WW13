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
	if (!map)
		job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[GERMAN]
		job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[SOVIET]
		job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[ITALIAN]
		job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[UKRAINIAN]
		job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[CIVILIAN]
		job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[PARTISAN]
	else
		for (var/faction in map.faction_organization)
			job_master.faction_organized_occupations |= faction_organized_occupations_separate_lists[faction]

/datum/controller/occupations
		//List of all jobs
	var/list/occupations = list()
		//List of all jobs ordered by faction: German, Soviet, Italian, Ukrainian, Civilian, Partisan
	var/list/faction_organized_occupations = list()
		//Players who need jobs
	var/list/unassigned = list()
		//Debug info
	var/list/job_debug = list()

	var/soviet_count = 0
	var/german_count = 0
	var/civilian_count = 0
	var/partisan_count = 0

	var/current_german_squad = 1
	var/current_soviet_squad = 1

	var/german_squad_members = 0
	var/german_squad_leaders = 0

	var/soviet_squad_members = 0
	var/soviet_squad_leaders = 0

	var/german_squad_info[4]
	var/soviet_squad_info[4]

	var/german_officer_squad_info[4]
	var/soviet_officer_squad_info[4]

	var/expected_clients = 0

	proc/toggle_roundstart_autobalance(var/_clients = 0, var/announce = TRUE)

		_clients = max(max(_clients, (map ? map.min_autobalance_players : 0)), clients.len)

		if (expected_clients && expected_clients > _clients)
			_clients = expected_clients

		var/autobalance_for_players = round(max(_clients, (clients.len/config.max_expected_players) * 50))

		if (announce == TRUE)
			world << "<span class = 'warning'>Setting up roundstart autobalance for [max(_clients, autobalance_for_players)] players.</span>"
		else if (announce == 2)
			if (!roundstart_time)
				world << "<span class = 'warning'>An admin has changed autobalance to be set up for [max(_clients, autobalance_for_players)] players.</span>"
				expected_clients = _clients
			else
				world << "<span class = 'warning'>An admin has reset autobalance for [max(_clients, autobalance_for_players)] players.</span>"

		for (var/datum/job/J in occupations)
			if (map)
				if (J.is_SS)
					if (!map.available_subfactions.Find(SCHUTZSTAFFEL))
						J.total_positions = 0
						continue
				else if (J.base_type_flag() == ITALIAN)
					if (!map.available_subfactions.Find(ITALIAN))
						J.total_positions = 0
						continue

			if (autobalance_for_players >= J.player_threshold && J.title != "N/A" && J.title != "generic job")
				var/positions = round((autobalance_for_players/J.scale_to_players) * J.max_positions)
				positions = max(positions, J.min_positions)
				positions = min(positions, J.max_positions)
				J.total_positions = positions
			else
				J.total_positions = 0

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

		if(turfs && turfs.len > FALSE)
			H.loc = pick(turfs)

			if (!locate(H.loc) in turfs)
				var/tries = 0
				while (tries <= 5 && !locate(H.loc) in turfs)
					++tries
					H.loc = pick(turfs)

	proc/SetupOccupations(var/faction = "Station")
		occupations = list()
		var/list/all_jobs = typesof(/datum/job)
		if(!all_jobs.len)
			world << "<span class = 'red'>\b Error setting up jobs, no job datums found</span>"
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


	proc/EquipRank(var/mob/living/carbon/human/H, var/rank, var/joined_late = FALSE)
		if(!H)	return null

		H.stopDumbDamage = TRUE

		var/datum/job/job = GetJob(rank)

		if(job)

			//Equip job items.

			job.equip(H)

			// civs and partisans
			if (istype(job, /datum/job/partisan))
				H.equip_coat(/obj/item/clothing/suit/storage/coat/civilian)
			else if (istype(job, /datum/job/german))
				if (job.is_officer)
					H.equip_coat(/obj/item/clothing/suit/storage/coat/german/officer)
				else if (job.is_SS)
					H.equip_coat(/obj/item/clothing/suit/storage/coat/german/SS)
				else
					H.equip_coat(/obj/item/clothing/suit/storage/coat/german)
			else if (istype(job, /datum/job/soviet))
				if (job.is_officer)
					H.equip_coat(/obj/item/clothing/suit/storage/coat/soviet/officer)
				else
					H.equip_coat(/obj/item/clothing/suit/storage/coat/soviet)

			// Give the guy some ammo for his gun
			spawn (0)
				if (istype(ticker.mode, /datum/game_mode/ww2))
					for (var/obj/item/weapon/gun/projectile/gun in H.contents)
						if (gun.w_class == 4 && gun.gun_type == GUN_TYPE_MG) // MG
							if (H.back && istype(H.back, /obj/item/weapon/storage/backpack))
								for (var/v in 1 to 4)
									H.back.contents += new gun.magazine_type(H)
							else if (H.l_hand && istype(H.l_hand, /obj/item/weapon/storage/backpack))
								for (var/v in 1 to 4)
									H.l_hand.contents += new gun.magazine_type(H)
							else if (H.r_hand && istype(H.r_hand, /obj/item/weapon/storage/backpack))
								for (var/v in 1 to 4)
									H.r_hand.contents += new gun.magazine_type(H)
						else
							if (!H.r_store)
								if (gun.magazine_type)
									H.equip_to_slot_or_drop(new gun.magazine_type(H), slot_r_store)
							if (!H.l_store)
								if (gun.magazine_type)
									H.equip_to_slot_or_drop(new gun.magazine_type(H), slot_l_store)
						break // but only the first gun we find
					for (var/obj/item/weapon/gun/projectile/gun in H.belt)
						if (gun.w_class == 4) // MG

						else
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
				job.rank_abbreviation = capitalize(lowertext(job.rank_abbreviation))
				H.real_name = "[job.rank_abbreviation]. [H.real_name]"
				H.name = H.real_name

			switch (job.base_type_flag())
				if (SOVIET)
					++soviet_count
				if (CIVILIAN)
					++civilian_count
				if (PARTISAN)
					++partisan_count
				if (GERMAN)
					++german_count

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

			// fixes spawning at 1,1,1

			if (!spawn_location)
				if (findtext(H.original_job.spawn_location, "JoinLateHeer"))
					spawn_location = "JoinLateHeer"
				else if (findtext(H.original_job.spawn_location, "JoinLateSS"))
					spawn_location = "JoinLateSS"
				else if (findtext(H.original_job.spawn_location, "JoinLateRA"))
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

			if ((!map || map.squad_spawn_locations) && H.squad_faction)
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
								H.add_memory(german_squad_info[current_german_squad])
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
								H.add_memory(soviet_squad_info[current_soviet_squad])
						else
							spawn (2)
								H << "<i>Your squad, #[current_soviet_squad], does not have a Squad Leader yet. Consider waiting for one before deploying.</i>"

			else if (H.original_job.is_officer && H.original_job.base_type_flag() == SOVIET)
				spawn (5)
					for (var/i in 1 to soviet_officer_squad_info.len)
						if (soviet_officer_squad_info[i])
							H << "<br>[soviet_officer_squad_info[i]]"
							H.add_memory(soviet_officer_squad_info[i])

			else if (H.original_job.is_officer && H.original_job.base_type_flag() == GERMAN)
				spawn (5)
					for (var/i in 1 to german_officer_squad_info.len)
						if (german_officer_squad_info[i])
							H << "<br>[german_officer_squad_info[i]]"
							H.add_memory(german_officer_squad_info[i])

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
						H << "<span class = 'red'>Failed to locate a storage object on your mob, either you spawned with no arms and no backpack or this is a bug.</span>"
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

			if (!istype(H, /mob/living/carbon/human/corpse))
				relocate(H)
				if (H.client)
					H.client.remove_gun_icons()

			H.stopDumbDamage = FALSE

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
		else if (!H.belt) // first, try to equip it as their belt
			H.equip_to_slot_or_del(keychain, slot_belt)

		var/list/keys = job.get_keys()

		for (var/obj/item/weapon/key in keys)
			if (keychain.can_be_inserted(key))
				keychain.handle_item_insertion(key)
				keychain.keys += key
				keychain.update_icon_state()

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

	// this is a solution to 5 germans and 1 soviet, on lowpop.
	proc/side_is_hardlocked(side)

		// when it's highpop enough for partisans
		// there aren't enough partisan roles for hardlocking to matter
		// for soviets and Germans, it's another matter
		// the generation of these two lists may take a lot of extra CPU,
		// but it's important if we want to keep up to date.

		// todo: faction lists structured like player_list (ie german_list)
		var/germans = n_of_side(GERMAN)
		var/soviets = n_of_side(SOVIET)

		var/players_without_partisans = clients.len
		for (var/mob/living/carbon/human/H in player_list)
			if (istype(H))
				if (H.original_job)
					if (list(PARTISAN, CIVILIAN).Find(H.original_job.base_type_flag()))
						--players_without_partisans

		var/max_germans = ceil(players_without_partisans * 0.42)
		var/max_soviets = ceil(players_without_partisans * 0.58)

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
				if (player_list.len >= 2)
					if (germans >= max_germans)
						return TRUE
			if (SOVIET)
				if (soviets_forceEnabled)
					return FALSE
				if (player_list.len >= 2)
					if (soviets >= max_soviets)
						return TRUE
			if (UKRAINIAN)
				return TRUE
			if (ITALIAN)
				return side_is_hardlocked(GERMAN)

		return FALSE