//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/desired_job = null // job title. This is for join queues.
	var/datum/job/delayed_spawning_as_job = null // job title. Self explanatory.
	universal_speak = 1

	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around



/mob/new_player/New()
	mob_list += src

	spawn (1)
		if (client)
			client.remove_ghost_only_admin_verbs()

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'><B>New Player Options</B>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		//output += fix_ru("<p>Отключено в целях отладки (<a href='byond://?src=\ref[src];ready=0'>Жми сюда в надежде, что появятся новые кнопки.</a>)</p>")
		//if(ready)
		//	output += "<p>\[ <b>Ready</b> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
		//else
		//	output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <b>Not Ready</b> \]</p>"
		output += "<p><a href='byond://?src=\ref[src];ready=0'>The game has not started yet. Please wait to join.</a></p>"
	else
	//	output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	if (reinforcements_master && reinforcements_master.is_ready())
		if (!reinforcements_master.has(src))
			output += "<p><a href='byond://?src=\ref[src];re_german=1'>Join as a German reinforcement!</A></p>"
			output += "<p><a href='byond://?src=\ref[src];re_russian=1'>Join as a Russian reinforcement!</A></p>"
		else
			if (reinforcements_master.has(src, GERMAN))
				output += "<p><a href='byond://?src=\ref[src];unre_german=1'>Leave the German reinforcement pool.</A></p>"
			else if (reinforcements_master.has(src, RUSSIAN))
				output += "<p><a href='byond://?src=\ref[src];unre_russian=1'>Leave the Russian reinforcement pool.</A></p>"
	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

/*	if(!IsGuestKey(src.key))
	//	establish_db_connection()
	//	if(dbcon.IsConnected())
		var/isadmin = 0
		if(src.client && src.client.holder)
			isadmin = 1
		// TODO: reimplement database interaction
		var/list/rowdata = database.execute("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
		var/newpoll = 0
		if (islist(rowdata) && !isemptylist(rowdata))
			newpoll = 1
			break

		if(newpoll)
			output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
		else
			output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"
*/
	output += "</div>"

	src << browse(output,"window=playersetup;size=210x280;can_close=0")
	return

/mob/new_player/Stat()
	..()

	if(statpanel("Lobby") && ticker)
		if(ticker.hide_mode)
			stat("Game Mode:", "Secret")
		else
			if(ticker.hide_mode == 0)
				stat("Game Mode:", "[master_mode]") // Old setting for showing the game mode

		// by counting observers, our playercount now looks more impressive - Kachnov
		if(ticker.current_state == GAME_STATE_PREGAME)
			stat("Time Until Joining Allowed:", "[ticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]")
			stat("","")
			stat("Players: [totalPlayers]")
			stat("","")

			totalPlayers = 0

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
	if(!client)	return 0

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel_proc()

	if(href_list["observe"])

		if(alert(src,"Are you sure you wish to observe? You will have to wait 30 minutes before being able to respawn!","Player Setup","Yes","No") == "Yes")
			if(!client)	return 1
			var/mob/observer/ghost/observer = new(150, 317, 1)

			spawning = 1
			src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			if(istype(O))
				src << "<span class='notice'>Now teleporting.</span>"
				observer.loc = O.loc
			else
				src << "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>"
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			announce_ghost_joinleave(src)
			client.prefs.update_preview_icon()
			observer.icon = client.prefs.preview_icon
			observer.alpha = 127

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
		//	if(!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
				//observer.verbs -= /mob/observer/ghost/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
			observer.key = key
			qdel(src)

			return 1

	if(href_list["re_german"])
		if (!reinforcements_master.is_permalocked(GERMAN))
			if (client.prefs.s_tone < -30 && !client.untermensch)
				usr << "<span class='danger'>You are too dark to be a German soldier.</span>"
				return
			reinforcements_master.add(src, GERMAN)
		else
			src << "<span class = 'danger'>Sorry, this side already has too many reinforcements!</span>"
	if(href_list["re_russian"])
		if (!reinforcements_master.is_permalocked(RUSSIAN))
			reinforcements_master.add(src, RUSSIAN)
		else
			src << "<span class = 'danger'>Sorry, this side already has too many reinforcements!</span>"
	if(href_list["unre_german"])
		reinforcements_master.remove(src, GERMAN)
	if(href_list["unre_russian"])
		reinforcements_master.remove(src, RUSSIAN)

	if(href_list["late_join"])

		if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
			usr << "\red The round is either not ready, or has already finished."
			return

		if(!check_rights(R_ADMIN, 0))
			var/datum/species/S = all_species[client.prefs.species]

			if(!(S.spawn_flags & CAN_JOIN))
				src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
				return 0

		LateChoices()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])

		var/datum/job/actual_job = null

		for (var/datum/job/j in job_master.occupations)
			if (j.title == href_list["SelectedJob"])
				actual_job = j
				break

		if (actual_job.base_type_flag() == GERMAN || actual_job.base_type_flag() == RUSSIAN)
			// we're only accepting squad leaders right now
			if (!job_master.squad_leader_check(src, actual_job))
				return
			// we aren't accepting squad leaders right now
			if (!job_master.squad_member_check(src, actual_job))
				return

		if (actual_job.base_type_flag() == GERMAN)
			if (client.prefs.s_tone < -30 && !client.untermensch)
				usr << "<span class='danger'>You are too dark to be a German soldier.</span>"
				return

		if(!config.enter_allowed)
			usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
			return
		else if(ticker && ticker.mode && ticker.mode.explosion_in_progress)
			usr << "<span class='danger'>The station is currently exploding. Joining would go poorly.</span>"
			return

		var/datum/species/S = all_species[client.prefs.species]

		if(!(S.spawn_flags & CAN_JOIN))
			src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
			return 0

		if (actual_job.spawn_delay)

			if (delayed_spawning_as_job)
				delayed_spawning_as_job.total_positions += 1
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
			src.poll_player(pollid)
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
						vote_on_poll(pollid, optionid, 1)
*/
/mob/new_player/proc/IsJobAvailable(rank, var/list/restricted_choices)
	var/datum/job/job = job_master.GetJob(rank)
	if(!job)	return 0
	if(!job.is_position_available(restricted_choices)) return 0
	if(jobban_isbanned(src,rank))	return 0
	if(!job.player_old_enough(src.client))	return 0
	return 1

/mob/new_player/proc/LateSpawnForced(rank, needs_random_name = 0)

	spawning = 1
	close_spawn_windows()

	job_master.AssignRole(src, rank, 1)
	var/mob/living/character = create_character()	//creates the human and transfers vars and mind
	character = job_master.EquipRank(character, rank, 1)					//equips the human

	job_master.relocate(character)

	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	if(character.mind.assigned_role != "Cyborg")
		data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

	character.lastarea = get_area(loc)

	qdel(src)

/mob/new_player/proc/AttemptLateSpawn(rank, var/nomsg = 0)

	if(src != usr)
		return 0
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		if (!nomsg)
			usr << "\red The round is either not ready, or has already finished..."
		return 0
	if(!config.enter_allowed)
		if (!nomsg)
			usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
		return 0
	if(!IsJobAvailable(rank))
		if (!nomsg)
			src << alert("[rank] is not available. Perhaps too many people are already attempting to join as it?")
		return 0

	var/datum/job/job = job_master.GetJob(rank)

	if(job_master.is_side_locked(job.base_type_flag()))
		if (!nomsg)
			src << "\red Currently this side is locked for joining."
		return

	spawning = 1
	close_spawn_windows()
	job_master.AssignRole(src, rank, 1)
	var/mob/living/character = create_character()	//creates the human and transfers vars and mind
	character = job_master.EquipRank(character, rank, 1)					//equips the human
	job_master.relocate(character)

	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	if(character.mind.assigned_role != "Cyborg")
		data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

	character.lastarea = get_area(loc)

	qdel(src)

	return 1

/mob/new_player/proc/LateChoices()

	var/dat = "<html><body><center>"
	dat += "<b>Welcome, [key].<br></b>"
	dat += "Round Duration: [roundduration2text()]<br>"

	var/list/restricted_choices = list()

	if (world.time <= ticker.role_preference_grace_period) // people with preference get 45 seconds to choose

		for (var/client/c in clients)
			if (c.role_preference_sov && c.role_preference_sov != client.role_preference_sov)
				if (!restricted_choices[c.role_preference_sov])
					restricted_choices[c.role_preference_sov] = 0
				else
					restricted_choices[c.role_preference_sov]++
			if (c.role_preference_ger && c.role_preference_ger != client.role_preference_ger)
				if (!restricted_choices[c.role_preference_ger])
					restricted_choices[c.role_preference_ger] = 0
				else
					restricted_choices[c.role_preference_ger]++

	var/prev_side = 0

	dat += "Choose from the following open positions:<br>"
	for(var/datum/job/job in job_master.occupations)

		if(job && !job.train_check())
			continue

		var/job_is_available = (job && IsJobAvailable(job.title, restricted_choices))

		if (job.is_paratrooper)
			job_is_available = allow_paratroopers

		if (config.use_job_whitelist && !check_job_whitelist(src, job.title))
			job_is_available = 0

		// check if the faction is admin-locked

		if (istype(job, /datum/job/german/paratrooper) && !paratroopers_toggled)
			job_is_available = 0

		if ((istype(job, /datum/job/german/soldier_ss) || istype(job, /datum/job/german/squad_leader_ss)) && !SS_toggled)
			job_is_available = 0

		if (istype(job, /datum/job/partisan) && !istype(job, /datum/job/partisan/civilian) && !partisans_toggled)
			job_is_available = 0

		if (istype(job, /datum/job/partisan/civilian) && !civilians_toggled)
			job_is_available = 0

		// check if the job is admin-locked or disabled codewise

		if (!job.enabled)
			job_is_available = 0

		// check if the faction is autobalance-locked

		if (istype(job, /datum/job/partisan) && !istype(job, /datum/job/partisan/civilian) && !job_master.allow_partisans)
			job_is_available = 0

		if (istype(job, /datum/job/partisan/civilian) && !job_master.allow_civilians)
			job_is_available = 0

		// check if the job is autobalance-locked

		if(job)
			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in player_list) if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 * 60 * 10)
				active++
			if(job.base_type_flag() != prev_side)
				prev_side = job.base_type_flag()
				var/side_name = "<b>[job.get_side_name()]</b>"
				if(side_name)
					dat += "[side_name]<br>"

			if (!job.en_meaning)
				if (job_is_available)
					dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions]/[job.total_positions]) (Active: [active])</a><br>"
				else
					dat += "<span style = 'color:red'><strike>[job.title] ([job.current_positions]/[job.total_positions]) (Active: [active])</strike></span><br>"

			else
				if (job_is_available)
					dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.en_meaning]) ([job.current_positions]/[job.total_positions]) (Active: [active])</a><br>"
				else
					dat += "<span style = 'color:red'><strike>[job.title] ([job.en_meaning]) ([job.current_positions]/[job.total_positions]) (Active: [active])</strike></span><br>"

	dat += "</center>"
	src << browse(dat, "window=latechoices;size=600x640;can_close=1")


/mob/new_player/proc/create_character()

	if (delayed_spawning_as_job)
		delayed_spawning_as_job.total_positions += 1
		delayed_spawning_as_job = null

	spawning = 1
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

	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.original_job = original_job
	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()

	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
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

/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Show Crew Manifest</h4>"
	dat += data_core.get_manifest(OOC = 1)
	src << browse(dat, "window=manifest;size=370x420;can_close=1")

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window

/mob/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/new_player/proc/is_species_whitelisted(datum/species/S)
	return 0

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
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0)
	return

mob/new_player/MayRespawn()
	return 1
