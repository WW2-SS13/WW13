//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = FALSE
	var/spawning = FALSE//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = FALSE		 //Player counts for the Lobby tab
	var/totalPlayersReady = FALSE
	var/desired_job = null // job title. This is for join queues.
	var/datum/job/delayed_spawning_as_job = null // job title. Self explanatory.
	universal_speak = TRUE

	invisibility = 101

	density = FALSE
	stat = 2
	canmove = FALSE

	anchored = TRUE	//  don't get pushed around

	var/on_welcome_popup = FALSE


/mob/new_player/New()
	mob_list += src

	spawn (1)
		if (client)
			client.remove_ghost_only_admin_verbs()

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()

/mob/new_player/proc/new_player_panel_proc()
	loc = null // so sometimes when people serverswap (tm) they get this window despite not being on the title screen - Kachnov
	// don't know if the above actually works

	var/output = "<div align='center'><b>Welcome, [key]!</b>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character & Preferences</A></p>"

	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		//output += fix_ru("<p>Отключено в целях отладки (<a href='byond://?src=\ref[src];ready=0'>Жми сюда в надежде, что появятся новые кнопки.</a>)</p>")
		//if(ready)
		//	output += "<p>\[ <b>Ready</b> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
		//else
		//	output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <b>Not Ready</b> \]</p>"
		output += "<p><a href='byond://?src=\ref[src];ready=0'>The game has not started yet. Please wait to join.</a></p>"
	else
	//	output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</a></p>"

	var/height = 350
	if (reinforcements_master && reinforcements_master.is_ready())
		height = 450
		if (!reinforcements_master.has(src))
			output += "<p><a href='byond://?src=\ref[src];re_german=1'>Join as a German reinforcement!</A></p>"
			output += "<p><a href='byond://?src=\ref[src];re_russian=1'>Join as a Russian reinforcement!</A></p>"
		else
			if (reinforcements_master.has(src, GERMAN))
				output += "<p><a href='byond://?src=\ref[src];unre_german=1'>Leave the German reinforcement pool.</A></p>"
			else if (reinforcements_master.has(src, SOVIET))
				output += "<p><a href='byond://?src=\ref[src];unre_russian=1'>Leave the Russian reinforcement pool.</A></p>"
	else
		output += "<p><i>Reinforcements won't be available until after the train is sent.</i></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	output += "</div>"

	src << browse(null, "window=playersetup;")
	src << browse(output, "window=playersetup;size=300x[height];can_close=0")
	return

/mob/new_player/Stat()
	..()

	if(statpanel("Lobby") && ticker)
		if(ticker.hide_mode)
			stat("Game Mode:", "Secret")
		else
			if(ticker.hide_mode == FALSE)
				stat("Game Mode:", "[master_mode]") // Old setting for showing the game mode

		// by counting observers, our playercount now looks more impressive - Kachnov
		if(ticker.current_state == GAME_STATE_PREGAME)
			stat("Time Until Joining Allowed:", "[ticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]")
			stat("","")
			stat("Players: [totalPlayers]")
			stat("","")

			totalPlayers = FALSE

			for(var/mob/new_player/player in player_list)
				stat("[player.key]", " (Playing)")
				++totalPlayers

			for (var/mob/observer/observer in player_list)
				stat("[observer.key]", " (Observing)")
				++totalPlayers

	stat("", "")

	if (reinforcements_master)
		var/list/reinforcements_info = reinforcements_master.get_status_addendums()
		for (var/v in reinforcements_info)
			var/split = splittext(v, ":")
			if (split[2])
				stat(split[1], split[2])
			else
				stat(split[1])


/mob/new_player/Topic(href, href_list[])
	if(!client)	return FALSE

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return TRUE

	if(href_list["ready"])
		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = FALSE

	if(href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel_proc()

	if(href_list["observe"])

		if (client && client.quickBan_isbanned("Observe"))
			src << "<span class = 'danger'>You're banned from observing.</span>"
			return TRUE

		if(alert(src,"Are you sure you wish to observe?[config.respawn_delay ? " You will have to wait [config.respawn_delay] minutes before being able to respawn!" : ""]","Player Setup","Yes","No") == "Yes")
			if(!client)	return TRUE
			var/mob/observer/ghost/observer = new(150, 317, TRUE)

			spawning = TRUE
			src << sound(null, repeat = FALSE, wait = FALSE, volume = 85, channel = TRUE) // MAD JAMS cant last forever yo

			observer.started_as_observer = TRUE
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			if(istype(O))
				src << "<span class='notice'>Now teleporting.</span>"
				observer.loc = O.loc
			else
				src << "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>"
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			announce_ghost_joinleave(src)
			client.prefs.update_preview_icons()

			if (client.prefs.preview_icons.len)
				observer.icon = client.prefs.preview_icons[1]
			observer.alpha = 127

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
		//	if(!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
				//observer.verbs -= /mob/observer/ghost/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
			observer.key = key
			qdel(src)

			return TRUE

	if(href_list["re_german"])

		if (client && client.quickBan_isbanned("Playing"))
			src << "<span class = 'danger'>You're banned from playing.</span>"
			return TRUE

		if (!reinforcements_master.is_permalocked(GERMAN))
			if (client.prefs.s_tone < -30 && !client.untermensch)
				usr << "<span class='danger'>You are too dark to be a German soldier.</span>"
				return
			reinforcements_master.add(src, GERMAN)
		else
			src << "<span class = 'danger'>Sorry, this side already has too many reinforcements!</span>"
	if(href_list["re_russian"])

		if (client && client.quickBan_isbanned("Playing"))
			src << "<span class = 'danger'>You're banned from playing.</span>"
			return TRUE

		if (!reinforcements_master.is_permalocked(SOVIET))
			reinforcements_master.add(src, SOVIET)
		else
			src << "<span class = 'danger'>Sorry, this side already has too many reinforcements!</span>"
	if(href_list["unre_german"])
		reinforcements_master.remove(src, GERMAN)
	if(href_list["unre_russian"])
		reinforcements_master.remove(src, SOVIET)

	if(href_list["late_join"])

		if (client && client.quickBan_isbanned("Playing"))
			src << "<span class = 'danger'>You're banned from playing.</span>"
			return TRUE

		if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
			src << "\red The round is either not ready, or has already finished."
			return
/*
		if(!check_rights(R_ADMIN, FALSE))
			var/datum/species/S = all_species[client.prefs.species]

			if(!(S.spawn_flags & CAN_JOIN))
				alert(src, "Your current species, [client.prefs.species], is not available for play on the station.")
				return FALSE
*/
		if (client.next_normal_respawn > world.realtime && respawn_delays)
			var/wait = ceil((client.next_normal_respawn-world.realtime)/600)
			if (check_rights(R_ADMIN, FALSE, src))
				if ((input(src, "If you were a normal player, you would have to wait [wait] more minutes to respawn. Do you want to bypass this? You can still join as a reinforcement.") in list("Yes", "No")) == "Yes")
					LateChoices()
					return TRUE
			alert(src, "Because you died in combat, you must wait [wait] more minutes to respawn. You can still join as a reinforcement.")
			return FALSE
		LateChoices()
		return TRUE

/*
	if(href_list["manifest"])
		ViewManifest()*/

	if(href_list["SelectedJob"])

		var/datum/job/actual_job = null

		for (var/datum/job/j in job_master.occupations)
			if (j.title == href_list["SelectedJob"])
				actual_job = j
				break

		var/job_flag = actual_job.base_type_flag()

		if (job_flag == GERMAN || job_flag == SOVIET)
			// we're only accepting squad leaders right now
			if (!job_master.squad_leader_check(src, actual_job))
				return
			// we aren't accepting squad leaders right now
			if (!job_master.squad_member_check(src, actual_job))
				return

		if (job_flag == GERMAN)
			if (client.prefs.s_tone < -30 && !client.untermensch)
				usr << "<span class='danger'>You are too dark to be a German soldier.</span>"
				return

		if(!config.enter_allowed)
			usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
			return
		else if(ticker && ticker.mode && ticker.mode.explosion_in_progress)
			usr << "<span class='danger'>The station is currently exploding. Joining would go poorly.</span>"
			return

		if (job_flag == GERMAN && has_occupied_base(GERMAN))
			usr << "<span class='danger'>The Russians are currently occupying your base! You can't be deployed right now."
			return
		else if (job_flag == SOVIET && has_occupied_base(SOVIET))
			usr << "<span class='danger'>The Germans are currently occupying your base! You can't be deployed right now."
			return

		var/datum/species/S = all_species[client.prefs.species]

		if(!(S.spawn_flags & CAN_JOIN))
			alert(src, "Your current species, [client.prefs.species], is not available for play on the station.")
			return FALSE

		if (actual_job.spawn_delay)

			if (delayed_spawning_as_job)
				delayed_spawning_as_job.total_positions += TRUE
				delayed_spawning_as_job = null

			job_master.spawn_with_delay(src, actual_job)
		else
			AttemptLateSpawn(href_list["SelectedJob"])

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()
/*
	if(href_list["showpoll"])

		handle_player_polling()
		return*/
/*
	if(href_list["pollid"])

		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid))
			poll_player(pollid)
		return

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		switch(votetype)
			if("OPTION")
				var/optionid = text2num(href_list["voteoptionid"])
				vote_on_poll(pollid, optionid)
			if("TEXT")
				var/replytext = href_list["replytext"]
				log_text_poll_reply(pollid, replytext)
			if("NUMVAL")
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					usr << "The option ID difference is too big. Please contact administration or the database admin."
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating))
								return

						vote_on_numval_poll(pollid, optionid, rating)
			if("MULTICHOICE")
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					usr << "The option ID difference is too big. Please contact administration or the database admin."
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						vote_on_poll(pollid, optionid, TRUE)
*/
/mob/new_player/proc/IsJobAvailable(rank, var/list/restricted_choices)
	var/datum/job/job = job_master.GetJob(rank)
	if(!job)	return FALSE
	if(!job.is_position_available(restricted_choices)) return FALSE
	if(!job.player_old_enough(client))	return FALSE
	return TRUE

/mob/new_player/proc/jobBanned(title)
	if(client && client.quickBan_isbanned("Job", title))
		return TRUE
	return FALSE

/mob/new_player/proc/factionBanned(faction)
	if(client && client.quickBan_isbanned("Faction", faction))
		return TRUE
	return FALSE

/mob/new_player/proc/officerBanned()
	if(client && client.quickBan_isbanned("Officer"))
		return TRUE
	return FALSE

/mob/new_player/proc/LateSpawnForced(rank, needs_random_name = FALSE, var/reinforcements = FALSE)

	spawning = TRUE
	close_spawn_windows()

	job_master.AssignRole(src, rank, TRUE, reinforcements)
	var/mob/living/character = create_character()	//creates the human and transfers vars and mind
	character = job_master.EquipRank(character, rank, TRUE)					//equips the human

	job_master.relocate(character)

	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	if(character.mind.assigned_role != "Cyborg")
	//	data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

	character.lastarea = get_area(loc)



	qdel(src)

/mob/new_player/proc/AttemptLateSpawn(rank, var/nomsg = FALSE)

	if (src != usr)
		return FALSE
	if (!ticker || ticker.current_state != GAME_STATE_PLAYING)
		if (!nomsg)
			usr << "\red The round is either not ready, or has already finished..."
		return FALSE
	if (!config.enter_allowed)
		if (!nomsg)
			usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
		return FALSE
	if (jobBanned(rank))
		if (!nomsg)
			usr << "<span class = 'warning'>You're banned from this role!</span>"
		return FALSE
	if (!IsJobAvailable(rank))
		if (!nomsg)
			alert(src, "[rank] has already been taken by someone else.")
		return FALSE

	var/datum/job/job = job_master.GetJob(rank)

	if (factionBanned(job.base_type_flag(1)))
		if (!nomsg)
			usr << "<span class = 'warning'>You're banned from this faction!</span>"
		return FALSE

	if (officerBanned() && job.is_officer)
		if (!nomsg)
			usr << "<span class = 'warning'>You're banned from officer positions!</span>"
		return FALSE

	if(job_master.is_side_locked(job.base_type_flag()))
		if (!nomsg)
			src << "\red Currently this side is locked for joining."
		return

	spawning = TRUE
	close_spawn_windows()
	job_master.AssignRole(src, rank, TRUE)
	var/mob/living/character = create_character()	//creates the human and transfers vars and mind
	character = job_master.EquipRank(character, rank, TRUE)					//equips the human
	job_master.relocate(character)

	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	if(character.mind.assigned_role != "Cyborg")
	//	data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

	character.lastarea = get_area(loc)

	if (character.original_job)
		if (character.original_job.base_type_flag() == SOVIET)
			var/obj/item/device/radio/R = main_radios[SOVIET]
			if (R && R.loc)
				spawn (5)
					R.announce("[character.real_name], [rank], has arrived.", "Arrivals Announcement System")
		else if (character.original_job.base_type_flag() == GERMAN)
			var/obj/item/device/radio/R = main_radios[GERMAN]
			if (R && R.loc)
				spawn (5)
					R.announce("[character.real_name], [rank], has arrived.", "Arrivals Announcement System")

	spawn (10)
		qdel(src)

	return TRUE

/mob/new_player/proc/LateChoices()

	src << browse(null, "window=latechoices")

	var/list/dat = list("<html><body style='background-color:#1D2951; color:#ffffff'><center>")
	dat += "<b>Welcome, [key].<br></b>"
	dat += "Round Duration: [roundduration2text()]<br>"
	dat += "<b>Current Autobalance Status</b>: [alive_germans.len] Germans and [alive_russians.len] Russians.<br>"

	var/list/restricted_choices = list()
	var/list/available_jobs_per_side = list(
		GERMAN = FALSE,
		SOVIET = FALSE,
		PARTISAN = FALSE,
		CIVILIAN = FALSE,
		ITALIAN = FALSE,
		UKRAINIAN = FALSE)

	var/prev_side = FALSE

	dat += "<b>Choose from the following open positions:</b><br>"

	for(var/datum/job/job in job_master.faction_organized_occupations)

		try

		//	var/unavailable_message = ""
			if (job.title == "generic job")
				continue

			if (job && !job.train_check())
				continue

			var/job_is_available = (job && IsJobAvailable(job.title, restricted_choices))

			if (job.is_paratrooper)
				job_is_available = (allow_paratroopers && fallschirm_landmarks.len && clients.len >= 20)

			if (!job.validate(src))
				job_is_available = FALSE
			//	unavailable_message = " <span class = 'color: rgb(255,215,0);'>{WHITELISTED}</span> "

			if (job_master.side_is_hardlocked(job.base_type_flag()))
				job_is_available = FALSE
			//	unavailable_message = " <span class = 'color: rgb(255,215,0);'>{DISABLED BY AUTOBALANCE}</span> "

		//	if (jobBanned(job.title))
		//		job_is_available = FALSE
			//	unavailable_message = " <span class = 'color: rgb(255,0,0);'>{BANNED}</span> "

		//	if (factionBanned(job.base_type_flag(1)))
			//	job_is_available = FALSE
			//	unavailable_message = " <span class = 'color: rgb(255,0,0);'>{BANNED FROM FACTION}</span> "

		//	if (officerBanned() && job.is_officer)
			//	job_is_available = FALSE
			//	unavailable_message = " <span class = 'color: rgb(255,0,0);'>{BANNED FROM OFFICER POSITIONS}</span> "

			// check if the faction is admin-locked

			if (istype(job, /datum/job/german/paratrooper) && !paratroopers_toggled)
				job_is_available = FALSE

			if ((istype(job, /datum/job/german/soldier_ss) || istype(job, /datum/job/german/squad_leader_ss)) && !SS_toggled)
				job_is_available = FALSE

			if (istype(job, /datum/job/partisan) && !istype(job, /datum/job/partisan/civilian) && !partisans_toggled)
				job_is_available = FALSE

			if (istype(job, /datum/job/partisan/civilian) && !civilians_toggled)
				job_is_available = FALSE

			// check if the job is admin-locked or disabled codewise

			if (!job.enabled)
				job_is_available = FALSE

			// check if the faction is autobalance-locked

			if (istype(job, /datum/job/partisan) && !istype(job, /datum/job/partisan/civilian) && !job_master.allow_partisans)
				job_is_available = FALSE

			if (istype(job, /datum/job/partisan/civilian) && !job_master.allow_civilians)
				job_is_available = FALSE

			// check if the job is autobalance-locked

			if(job)
				var/active = FALSE
				// Only players with the job assigned and AFK for less than 10 minutes count as active
				for(var/mob/M in player_list) if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 * 60 * 10)
					active++
				if(job.base_type_flag() != prev_side)
					prev_side = job.base_type_flag()
					var/side_name = "<b><span style = 'font-size: 3.0em;'>[job.get_side_name()]</span></b>&&[job.base_type_flag()]&&"
					if(side_name)
						dat += "[side_name]<br>"

				var/extra_span = ""
				var/end_extra_span = ""

				if (job.is_officer && !job.is_commander)
					extra_span = "<span style = 'font-size: 1.5em;'>"
					end_extra_span = "</span>"
				else if (job.is_commander)
					extra_span = "<span style = 'font-size: 2.0em;'>"
					end_extra_span = "</span>"

				if (!job.en_meaning)
					if (job_is_available)
						dat += "&[job.base_type_flag()]&[extra_span]<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions]/[job.total_positions]) (Active: [active])</a>[end_extra_span]<br>"
						++available_jobs_per_side[job.base_type_flag()]
				/*	else
						dat += "&[job.base_type_flag()]&[unavailable_message]<span style = 'color:red'><strike>[job.title] ([job.current_positions]/[job.total_positions]) (Active: [active])</strike></span><br>"
					*/
				else
					if (job_is_available)
						dat += "&[job.base_type_flag()]&[extra_span]<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.en_meaning]) ([job.current_positions]/[job.total_positions]) (Active: [active])</a>[end_extra_span]<br>"
						++available_jobs_per_side[job.base_type_flag()]
			/*		else
						dat += "&[job.base_type_flag()]&[unavailable_message]<span style = 'color:red'><strike>[job.title] ([job.en_meaning]) ([job.current_positions]/[job.total_positions]) (Active: [active])</strike></span><br>"
					*/
		catch ()

	dat += "</center>"

	// shitcode to hide jobs that aren't available
	for (var/key in available_jobs_per_side)
		var/val = available_jobs_per_side[key]
		if (val == FALSE)
			var/replaced_faction_title = FALSE
			for (var/v in TRUE to dat.len)
				if (findtext(dat[v], "&[key]&") && !findtext(dat[v], "&&[key]&&"))
					dat[v] = null
				else if (!replaced_faction_title && findtext(dat[v], "&&[key]&&"))
					dat[v] = "[replacetext(dat[v], "&&[key]&&", "")] (<span style = 'color:red'>FACTION DISABLED BY AUTOBALANCE</span>)"
					replaced_faction_title = TRUE
		else
			var/replaced_faction_title = FALSE
			for (var/v in TRUE to dat.len)
				if (findtext(dat[v], "&[key]&") && !findtext(dat[v], "&&[key]&&"))
					dat[v] = replacetext(dat[v], "&[key]&", "")
				else if (!replaced_faction_title && findtext(dat[v], "&&[key]&&"))
					dat[v] = replacetext(dat[v], "&&[key]&&", "")
					replaced_faction_title = TRUE


	var/data = ""
	for (var/line in dat)
		if (line != null)
			data += line
			data += "<br>"

	spawn (1)
		src << browse(data, "window=latechoices;size=600x640;can_close=1")

/mob/new_player/proc/create_character()

	if (delayed_spawning_as_job)
		delayed_spawning_as_job.total_positions += TRUE
		delayed_spawning_as_job = null

	spawning = TRUE
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if(chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(is_species_whitelisted(chosen_species) || has_admin_rights())
			new_character = new(loc, use_species_name)

	if(!new_character)
		new_character = new(loc)

	new_character.lastarea = get_area(loc)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			if(has_admin_rights() \
				|| (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)

	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_for(new_character)
	else
		client.prefs.copy_to(new_character)

	src << sound(null, repeat = FALSE, wait = FALSE, volume = 85, channel = TRUE) // MAD JAMS cant last forever yo

	if(mind)
		mind.active = FALSE					//we wish to transfer the key manually
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.original_job = original_job
	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()

	if(client.prefs.disabilities)
		// Set defer to TRUE if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()
	new_character.key = key		//Manually transfer the key to log them in

	return new_character
/*
/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Show Crew Manifest</h4>"
	dat += data_core.get_manifest(OOC = TRUE)
	src << browse(dat, "window=manifest;size=370x420;can_close=1")
*/
/mob/new_player/Move()
	return FALSE

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window

/mob/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, FALSE, src)

/mob/new_player/proc/is_species_whitelisted(datum/species/S)
	return FALSE

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!chosen_species)
		return "Human"

	if(is_species_whitelisted(chosen_species) || has_admin_rights())
		return chosen_species.name

	return "Human"

/mob/new_player/get_gender()
	if(!client || !client.prefs)
		return ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = FALSE, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = FALSE)
	return

mob/new_player/MayRespawn()
	return TRUE
