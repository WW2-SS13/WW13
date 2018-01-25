var/list/gamemode_cache = list()

/datum/configuration

	var/global_config_path = null

	var/server_name = null				// server name (for world name / status)
	var/server_suffix = FALSE				// generate numeric suffix based on server port

	//var/nudge_script_path = "nudge.py"  // where the nudge.py script is located

	var/list/lobby_screens = list("1") // Which lobby screens are available

	var/lobby_countdown = 120
	var/round_end_countdown = 60

	var/log_ooc = FALSE						// log OOC channel
	var/log_access = FALSE					// log login/logout
	var/log_say = FALSE						// log client say
	var/log_admin = FALSE					// log admin actions
	var/log_debug = TRUE					// log debug output
	var/log_game = FALSE					// log game events
	var/log_vote = FALSE					// log voting
	var/log_whisper = FALSE					// log client whisper
	var/log_emote = FALSE					// log emotes
	var/log_attack = FALSE					// log attack messages
	var/log_adminchat = FALSE				// log admin chat messages
	var/log_adminwarn = FALSE				// log warnings admins get about bomb construction and such
	var/log_hrefs = FALSE					// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/log_runtimes = FALSE				// logs world.log to a file
	var/log_world_output = FALSE			// log world.log << messages
	var/sql_enabled = TRUE					// for sql switching
	var/allow_admin_ooccolor = FALSE		// Allows admins with relevant permissions to have their own ooc colour
	var/allow_vote_restart = FALSE 			// allow votes to restart
	var/ert_admin_call_only = FALSE
	var/allow_vote_mode = FALSE				// allow votes to change mode
	var/allow_admin_jump = TRUE			// allows admin jumping
	var/allow_admin_spawning = TRUE		// allows admin item spawning
	var/allow_admin_rev = TRUE				// allows admin revives
	var/vote_delay = 6000				// minimum time between voting sessions (deciseconds, 10 minute default)
	var/vote_period = 600				// length of voting period (deciseconds, default 1 minute)
	var/vote_autogamemode_timeleft = 100 //Length of time before round start when autogamemode vote is called (in seconds, default 100).
	var/vote_no_default = FALSE				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = FALSE				// dead people can't vote (tbi)
//	var/enable_authentication = FALSE		// goon authentication
	var/del_new_on_log = TRUE				// del's new players if they log before they spawn in
	var/feature_object_spell_system = FALSE //spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/traitor_scaling = FALSE 			//if amount of traitors scales based on amount of players
	var/objectives_disabled = FALSE 			//if objectives are disabled or not
	var/protect_roles_from_antagonist = FALSE// If security and such can be traitor/cult/other
	var/continous_rounds = FALSE			// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/popup_admin_pm = FALSE				//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/Ticklag = 0.9
	var/Tickcomp = FALSE
//	var/socket_talk	= FALSE					// use socket_talk to communicate with other processes
	var/list/resource_urls = null
	var/antag_hud_allowed = FALSE			// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/antag_hud_restricted = FALSE                    // Ghosts that turn on Antagovision cannot rejoin the round.
	var/list/mode_names = list()
	var/list/modes = list()				// allowed modes
	var/list/votable_modes = list()		// votable modes
	var/list/probabilities = list()		// relative probability of each mode
	var/humans_need_surnames = FALSE
	var/allow_random_events = FALSE			// enables random events mid-round when set to TRUE
	var/allow_ai = TRUE					// allow ai job
	var/hostedby = null
	var/respawn_delay = 30
	var/guest_jobban = TRUE
	var/usewhitelist = FALSE
	var/allow_testing_staff = FALSE
	var/use_job_whitelist =  FALSE
	var/kick_inactive = FALSE				//force disconnect for inactive players after this many minutes, if non-0
	var/show_mods = FALSE
	var/show_mentors = FALSE
	var/mods_can_tempban = FALSE
	var/mods_can_job_tempban = FALSE
	var/mod_tempban_max = 1440
	var/mod_job_tempban_max = 1440
	var/ToRban = FALSE
	var/automute_on = FALSE					//enables automuting/spam prevention
	var/jobs_have_minimal_access = FALSE	//determines whether jobs use minimal access or expanded access.

	var/character_slots = 10				// The number of available character slots

	var/disable_player_mice = FALSE
	var/uneducated_mice = FALSE //Set to TRUE to prevent newly-spawned mice from understanding human speech

	var/allow_extra_antags = FALSE
	var/guests_allowed = TRUE
	var/debugparanoid = FALSE

	var/serverurl
	var/server
	var/banappeals
	var/wikiurl
	var/websiteurl
	var/forumurl
	var/donationurl
	var/rulesurl
	var/discordurl
	var/githuburl

	//game_options.txt configs

	var/health_threshold_softcrit = FALSE
	var/health_threshold_crit = FALSE
	var/health_threshold_dead = -100

	var/organ_health_multiplier = 1.0
	var/organ_regeneration_multiplier = 1.0
	var/organs_decay
	var/default_brain_health = 400

	//Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
	//so that it's similar to HALLOSS. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
	var/organ_damage_spillover_multiplier = 0.5

	var/bones_can_break = FALSE
	var/limbs_can_break = FALSE

//	var/revival_pod_plants = TRUE
//	var/revival_cloning = TRUE
	var/revival_brain_life = -1

//	var/use_loyalty_implants = FALSE

//	var/welder_vision = TRUE
	var/generate_asteroid = FALSE
	var/no_click_cooldown = FALSE

//	var/asteroid_z_levels = list()

	//Used for modifying movement speed for mobs.
	//Unversal modifiers
	var/run_speed = FALSE
	var/walk_speed = FALSE

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/human_delay = FALSE
	var/robot_delay = FALSE
	var/monkey_delay = FALSE
	var/alien_delay = FALSE
	var/slime_delay = FALSE
	var/animal_delay = FALSE

	var/simultaneous_pm_warning_timeout = 100

	var/use_recursive_explosions //Defines whether the server uses recursive or circular explosions.

	var/ghost_interaction = FALSE

	var/enter_allowed = TRUE

	var/list/station_levels = list(1, 2, 3, 4, 5)	// Defines which Z-levels the station exists on.
	var/list/admin_levels= list(6)					// Defines which Z-levels which are for admin functionality, for example including such areas as Central Command and the Syndicate Shuttle
	var/list/contact_levels = list(1, 2, 3, 4, 5)	// Defines which Z-levels which, for example, a Code Red announcement may affect
	var/list/player_levels = list(1, 2, 3, 4, 5)	// Defines all Z-levels a character can typically reach
	var/list/sealed_levels = list() 				// Defines levels that do not allow random transit at the edges.

	var/abandon_allowed = TRUE
	var/ooc_allowed = TRUE
	var/looc_allowed = TRUE
	var/dooc_allowed = TRUE
	var/dsay_allowed = TRUE

	var/list/language_prefixes = list(",","#","-")//Default language prefixes

	var/ghosts_can_possess_animals = FALSE

	// hub stuff

	var/hub = FALSE
	var/jojoreference = FALSE
	var/testing_port = -1
	var/hubtesting_port = -2
	var/open_hub_discord_in_new_window = TRUE
	var/hub_body = ""
	var/hub_features = ""
	var/hub_banner_url = ""

	// TRAINS

	var/german_train_cars_officer = TRUE
	var/german_train_cars_storage = TRUE
	var/german_train_cars_supply = TRUE
	var/german_train_cars_soldier = TRUE
	var/german_train_cars_conductor = TRUE

	//WW2

	var/lighting_is_rustic = FALSE
	var/machinery_does_not_use_power = FALSE

	var/paratrooper_drop_time = 3000

	//WW2 donor shit

	var/list/job_specific_custom_loadouts = list() // format is a triple list, first of jobs, second of ckeys containing a list of items
	var/list/people_with_role_preference = list() // just a list of ckeys
	var/list/untermenschen = list() // just a list of ckeys

	//WW13 hub stuff

	var/ww13_hub_preinfo
	var/ww13_hub_title
	var/ww13_hub_oocdesc
	var/ww13_hub_icdesc
	var/ww13_hub_rplevel
	var/ww13_hub_hostedby
	var/ww13_hub_postinfo

	// misc
	var/resource_website = null

	// dumb memes
	var/allow_dabbing = FALSE

/datum/configuration/New()
	var/list/L = typesof(/datum/game_mode) - /datum/game_mode
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()
		if (M.config_tag)
			gamemode_cache[M.config_tag] = M // So we don't instantiate them repeatedly.
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				log_misc("Adding game mode [M.name] ([M.config_tag]) to configuration.")
				modes += M.config_tag
				mode_names[M.config_tag] = M.name
				probabilities[M.config_tag] = M.probability
				if (M.votable)
					votable_modes += M.config_tag
	votable_modes += "secret"

/datum/configuration/proc/load(filename, type = "config") //the type can also be game_options, in which case it uses a different switch. not making it separate to not copypaste code - Urist

	var/list/Lines = file2list(filename)

	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		if(type == "config")
			switch (name)

				if ("global_config_path")
					if (list("null", "Null", "NULL", "nil", "Nil", "NILL").Find(value))
						config.global_config_path = null
					else
						config.global_config_path = value

				if ("resource_website")
					if (!list("null", "Null", "NULL", "nil", "Nil", "NILL").Find(value))
						config.resource_website = value
					else
						config.resource_website = null
				// allows the global_config to override us with YES/NO
				if ("hub")
					if (!value || !list("yes", "Yes", "YES", "no", "No", "NO").Find(value))
						config.hub = TRUE
					else
						switch (lowertext(value))
							if ("yes")
								config.hub = TRUE
							if ("no")
								config.hub = FALSE
				if ("jojoreference")
					config.jojoreference = TRUE
				if ("testing_port")
					config.testing_port = text2num(value)
				if ("hubtesting_port")
					config.hubtesting_port = text2num(value)
				if ("open_hub_discord_in_new_window")
					config.open_hub_discord_in_new_window = text2num(value)
				if ("hub_body")
					config.hub_body = value
				if ("hub_features")
					config.hub_features = value
				if ("hub_banner_url")
					config.hub_banner_url = value

				// WW2 MISC
				if ("machinery_does_not_use_power")
					config.machinery_does_not_use_power = text2num(value)

				// TRAINS

				if ("german_train_cars_officer")
					config.german_train_cars_officer = text2num(value)
				if ("german_train_cars_storage")
					config.german_train_cars_storage = text2num(value)
				if ("german_train_cars_soldier")
					config.german_train_cars_soldier = text2num(value)
				if ("german_train_cars_conductor")
					config.german_train_cars_conductor = text2num(value)
				if ("german_supplytrain_cars")
					config.german_train_cars_supply = text2num(value)

				if ("lighting_is_rustic")
					config.lighting_is_rustic = text2num(value)

				if ("paratrooper_drop_time")
					config.paratrooper_drop_time = text2num(value)

				if ("resource_urls")
					config.resource_urls = splittext(value, " ")

				if ("jobs_have_minimal_access")
					config.jobs_have_minimal_access = TRUE

				if ("use_recursive_explosions")
					use_recursive_explosions = TRUE

				if ("log_ooc")
					config.log_ooc = TRUE

				if ("log_access")
					config.log_access = TRUE

				if ("sql_enabled")
					config.sql_enabled = text2num(value)

				if ("log_say")
					config.log_say = TRUE

				if ("debug_paranoid")
					config.debugparanoid = TRUE

				if ("log_admin")
					config.log_admin = TRUE

				if ("log_debug")
					config.log_debug = text2num(value)

				if ("log_game")
					config.log_game = TRUE

				if ("log_vote")
					config.log_vote = TRUE

				if ("log_whisper")
					config.log_whisper = TRUE

				if ("log_attack")
					config.log_attack = TRUE

				if ("log_emote")
					config.log_emote = TRUE

				if ("log_adminchat")
					config.log_adminchat = TRUE

				if ("log_adminwarn")
					config.log_adminwarn = TRUE

				if ("log_world_output")
					config.log_world_output = TRUE

				if ("log_hrefs")
					config.log_hrefs = TRUE

				if ("log_runtimes")
					config.log_runtimes = TRUE

				if ("generate_asteroid")
					config.generate_asteroid = TRUE

				if ("no_click_cooldown")
					config.no_click_cooldown = TRUE

				if("allow_admin_ooccolor")
					config.allow_admin_ooccolor = TRUE

				if ("allow_vote_restart")
					config.allow_vote_restart = TRUE

				if ("allow_vote_mode")
					config.allow_vote_mode = TRUE

				if ("allow_admin_jump")
					config.allow_admin_jump = TRUE

				if("allow_admin_rev")
					config.allow_admin_rev = TRUE

				if ("allow_admin_spawning")
					config.allow_admin_spawning = TRUE

				if ("no_dead_vote")
					config.vote_no_dead = TRUE

				if ("default_no_vote")
					config.vote_no_default = TRUE

				if ("vote_delay")
					config.vote_delay = text2num(value)

				if ("vote_period")
					config.vote_period = text2num(value)

				if ("vote_autogamemode_timeleft")
					config.vote_autogamemode_timeleft = text2num(value)

				if("ert_admin_only")
					config.ert_admin_call_only = TRUE

				if ("allow_ai")
					config.allow_ai = TRUE

				if ("respawn_delay")
					config.respawn_delay = text2num(value)

				if ("server_name")
					config.server_name = value

				if ("serversuffix")
					config.server_suffix = TRUE

				if ("hostedby")
					config.hostedby = value

				if ("serverurl")
					config.serverurl = value

				if ("server")
					config.server = value

				if ("banappeals")
					config.banappeals = value

				if ("wikiurl")
					config.wikiurl = value

				if ("websiteurl")
					config.websiteurl = value

				if ("forumurl")
					config.forumurl = value

				if ("donationurl")
					config.donationurl = value

				if ("rulesurl")
					config.rulesurl = value

				if ("discordurl")
					config.discordurl = value

				if ("githuburl")
					config.githuburl = value

				if ("ghosts_can_possess_animals")
					config.ghosts_can_possess_animals = value

				if ("guest_jobban")
					config.guest_jobban = TRUE

				if ("guest_ban")
					config.guests_allowed = FALSE

				if ("disable_ooc")
					config.ooc_allowed = FALSE
					config.looc_allowed = FALSE

				if ("disable_entry")
					config.enter_allowed = FALSE

				if ("disable_dead_ooc")
					config.dooc_allowed = FALSE

				if ("disable_dsay")
					config.dsay_allowed = FALSE

				if ("disable_respawn")
					config.abandon_allowed = FALSE

				if ("usewhitelist")
					if (!value || !list("yes", "Yes", "YES", "no", "No", "NO").Find(value))
						config.usewhitelist = TRUE
					else
						switch (lowertext(value))
							if ("yes")
								config.usewhitelist = TRUE
							if ("no")
								config.usewhitelist = FALSE

				if ("allow_testing_staff")
					config.allow_testing_staff = TRUE

				if ("use_job_whitelist")
					config.use_job_whitelist = TRUE

				if ("feature_object_spell_system")
					config.feature_object_spell_system = TRUE

				if ("traitor_scaling")
					config.traitor_scaling = TRUE

				if ("objectives_disabled")
					config.objectives_disabled = TRUE

				if("protect_roles_from_antagonist")
					config.protect_roles_from_antagonist = TRUE

				if ("probability")
					var/prob_pos = findtext(value, " ")
					var/prob_name = null
					var/prob_value = null

					if (prob_pos)
						prob_name = lowertext(copytext(value, 1, prob_pos))
						prob_value = copytext(value, prob_pos + 1)
						if (prob_name in config.modes)
							config.probabilities[prob_name] = text2num(prob_value)
						else
							log_misc("Unknown game mode probability configuration definition: [prob_name].")
					else
						log_misc("Incorrect probability configuration definition: [prob_name]  [prob_value].")

				if("kick_inactive")
					config.kick_inactive = text2num(value)

				if("show_mods")
					config.show_mods = TRUE

				if("show_mentors")
					config.show_mentors = TRUE

				if("mods_can_tempban")
					config.mods_can_tempban = TRUE

				if("mods_can_job_tempban")
					config.mods_can_job_tempban = TRUE

				if("mod_tempban_max")
					config.mod_tempban_max = text2num(value)

				if("mod_job_tempban_max")
					config.mod_job_tempban_max = text2num(value)

				if("popup_admin_pm")
					config.popup_admin_pm = TRUE

				if("ticklag")
					Ticklag = text2num(value)

				if("allow_antag_hud")
					config.antag_hud_allowed = TRUE

				if("antag_hud_restricted")
					config.antag_hud_restricted = TRUE

				if("tickcomp")
					Tickcomp = TRUE

				if("humans_need_surnames")
					humans_need_surnames = TRUE

				if("tor_ban")
					ToRban = TRUE

				if("automute_on")
					automute_on = TRUE

				if("continuous_rounds")
					config.continous_rounds = TRUE

				if("ghost_interaction")
					config.ghost_interaction = TRUE

				if("disable_player_mice")
					config.disable_player_mice = TRUE

				if("uneducated_mice")
					config.uneducated_mice = TRUE

				if("character_slots")
					config.character_slots = text2num(value)

				if("station_levels")
					config.station_levels = text2numlist(value, ";")

				if("admin_levels")
					config.admin_levels = text2numlist(value, ";")

				if("contact_levels")
					config.contact_levels = text2numlist(value, ";")

				if("player_levels")
					config.player_levels = text2numlist(value, ";")

				if("allow_extra_antags")
					config.allow_extra_antags = TRUE

				if("default_language_prefixes")
					var/list/values = splittext(value, " ")
					if(values.len > 0)
						language_prefixes = values

				if ("lobby_screens")
					config.lobby_screens = splittext(value, ";")

				if ("lobby_countdown")
					config.lobby_countdown = text2num(value)

				if ("round_end_countdown")
					config.round_end_countdown = text2num(value)

				if ("allow_dabbing")
					config.allow_dabbing = TRUE

				else
					log_misc("Unknown setting in configuration: '[name]'")

		else if(type == "game_options")
			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			switch(name)
				if("health_threshold_crit")
					config.health_threshold_crit = value
				if("health_threshold_softcrit")
					config.health_threshold_softcrit = value
				if("health_threshold_dead")
					config.health_threshold_dead = value
				if("organ_health_multiplier")
					config.organ_health_multiplier = value / 100
				if("organ_regeneration_multiplier")
					config.organ_regeneration_multiplier = value / 100
				if("organ_damage_spillover_multiplier")
					config.organ_damage_spillover_multiplier = value / 100
				if("organs_can_decay")
					config.organs_decay = TRUE
				if("default_brain_health")
					config.default_brain_health = text2num(value)
					if(!config.default_brain_health || config.default_brain_health < 1.0)
						config.default_brain_health = initial(config.default_brain_health)
				if("bones_can_break")
					config.bones_can_break = value
				if("limbs_can_break")
					config.limbs_can_break = value

				if("run_speed")
					config.run_speed = text2num(value)

				if("walk_speed")
					config.walk_speed = text2num(value)

				if("human_delay")
					config.human_delay = value
				if("robot_delay")
					config.robot_delay = value
				if("monkey_delay")
					config.monkey_delay = value
				if("alien_delay")
					config.alien_delay = value
				if("slime_delay")
					config.slime_delay = value
				if("animal_delay")
					config.animal_delay = value
				else
					log_misc("Unknown setting in game_options configuration: '[name]'")

		else if (type == "hub")

			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")

			switch (name)
				if ("preinfo")
					config.ww13_hub_preinfo = value
				if ("title")
					config.ww13_hub_title = value
				if ("oocdesc")
					config.ww13_hub_oocdesc = value
				if ("icdesc")
					config.ww13_hub_icdesc = value
				if ("rplevel")
					config.ww13_hub_rplevel = value
				if ("hostedby")
					config.ww13_hub_hostedby = value
				if ("postinfo")
					config.ww13_hub_postinfo = value

		else if (type == "game_schedule")

			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			if (!global_game_schedule)
				global_game_schedule = new

			switch (name)
				if ("game_schedule_starttime")
					if (value)
						global_game_schedule.starttime = text2num(value)
				if ("game_schedule_endtime")
					if (value)
						global_game_schedule.endtime = text2num(value)
				if ("game_schedule_days_closed")
					if (value)
						var/list/days_closed = splittext(value, ",")
						for (var/day in days_closed)
							global_game_schedule.days_closed += capitalize(ckey(day))
				if ("game_schedule_days_always_open")
					if (value)
						var/list/days_always_open = splittext(value, ",")
						for (var/day in days_always_open)
							global_game_schedule.days_always_open += capitalize(ckey(day))

			global_game_schedule.update()
			global_game_schedule.loadFromDB()

	if (config.hub)
		world.visibility = TRUE
	else
		world.visibility = FALSE

/datum/configuration/proc/loadsql(filename)  // -- TLE
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("address")
				sqladdress = value
			if ("port")
				sqlport = value
			if ("database")
				sqldb = value
			if ("login")
				sqllogin = value
			if ("password")
				sqlpass = value
			if ("feedback_database")
				sqlfdbkdb = value
			if ("feedback_login")
				sqlfdbklogin = value
			if ("feedback_password")
				sqlfdbkpass = value
			if ("enable_stat_tracking")
				sqllogging = TRUE
			else
				log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration/proc/loadforumsql(filename)  // -- TLE
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("address")
				forumsqladdress = value
			if ("port")
				forumsqlport = value
			if ("database")
				forumsqldb = value
			if ("login")
				forumsqllogin = value
			if ("password")
				forumsqlpass = value
			if ("activatedgroup")
				forum_activated_group = value
			if ("authenticatedgroup")
				forum_authenticated_group = value
			else
				log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for (var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if (M.config_tag && M.config_tag == mode_name)
			return M
	return gamemode_cache["extended"]

/datum/configuration/proc/get_runnable_modes()
	var/list/runnable_modes = list()
	for(var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if(M && M.can_start() && !isnull(config.probabilities[M.config_tag]) && config.probabilities[M.config_tag] > 0)
			runnable_modes |= M
	return runnable_modes

/datum/configuration/proc/post_load()
	//apply a default value to config.python_path, if needed
	/*
	if (!config.python_path)
		if(world.system_type == UNIX)
			config.python_path = "/usr/bin/env python2"
		else //probably windows, if not this should work anyway
			config.python_path = "python"
*/