var/global/datum/controller/gameticker/ticker
var/global/datum/lobby_music_player/lobby_music_player = null


/datum/controller/gameticker
	var/const/restart_timeout = 300
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = FALSE
	var/datum/game_mode/mode = null
	var/post_game = FALSE
	var/event_time = null
	var/event = FALSE

	var/login_music			// music played in pregame lobby

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/random_players = FALSE 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/list/syndicate_coalition = list() // list of traitor-compatible factions
	var/list/factions = list()			  // list of all factions
	var/list/availablefactions = list()	  // list of factions with openings

	var/pregame_timeleft = FALSE

	var/delay_end = FALSE	//if set to nonzero, the round will not restart on it's own

//	var/triai = FALSE//Global holder for Triumvirate

	var/round_end_announced = FALSE // Spam Prevention. Announce round end only once.

	var/can_latejoin_ruforce = TRUE
	var/can_latejoin_geforce = TRUE

	var/players_can_join = TRUE

/datum/controller/gameticker/proc/pregame()

	spawn (0)

		if (!lobby_music_player)
			lobby_music_player = new

		login_music = lobby_music_player.get_song()

		do
			pregame_timeleft = 180
			if (serverswap_open_status)
				world << "<B><FONT color='blue'>Welcome to the pre-game lobby!</FONT></B>"
				world << "Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds"
			while(current_state == GAME_STATE_PREGAME)
				for(var/i=0, i<10, i++)
					sleep(1)
					vote.process()
				if(round_progressing)
					pregame_timeleft--
				if(pregame_timeleft == config.vote_autogamemode_timeleft)
					if(!vote.time_remaining)
						vote.autogamemode()	//Quit calling this over and over and over and over.
						while(vote.time_remaining)
							for(var/i=0, i<10, i++)
								sleep(1)
								vote.process()
				if(pregame_timeleft == 20)
					if (roundstart_tips.len)
						if (serverswap_open_status)
							world << "<span class = 'notice'><b>Tip of the Round:</b> [pick(roundstart_tips)]</span>"
							roundstart_tips.Cut() // prevent tip spam if we're paused here
				if(pregame_timeleft <= 0)
					current_state = GAME_STATE_SETTING_UP
					/* if we were force started, still show the tip */
					if (roundstart_tips.len)
						if (serverswap_open_status)
							world << "<span class = 'notice'><b>Tip of the Round:</b> [pick(roundstart_tips)]</span>"
							roundstart_tips.Cut() // prevent tip spam if we're paused here

		while (!setup())


/datum/controller/gameticker/proc/setup()
	//Create and announce mode
	if(master_mode=="secret")
		hide_mode = TRUE

	var/list/runnable_modes = config.get_runnable_modes()
	if((master_mode=="random") || (master_mode=="secret"))
		if(!runnable_modes.len)
			current_state = GAME_STATE_PREGAME
			if (serverswap_open_status)
				world << "<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby."
			return FALSE
		if(secret_force_mode != "secret")
			mode = config.pick_mode(secret_force_mode)
		if(!mode)
			var/list/weighted_modes = list()
			for(var/datum/game_mode/GM in runnable_modes)
				weighted_modes[GM.config_tag] = config.probabilities[GM.config_tag]
			mode = gamemode_cache[pickweight(weighted_modes)]
	else
		mode = config.pick_mode(master_mode)

	if(!mode)
		current_state = GAME_STATE_PREGAME
		if (serverswap_open_status)
			world << "<span class='danger'>Serious error in mode setup!</span> Reverting to pre-game lobby."
		return FALSE

	job_master.ResetOccupations()
	mode.create_antagonists()
	mode.pre_setup()
	job_master.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	if(!mode.can_start())
		if (serverswap_open_status)
			world << "<B>Unable to start [mode.name].</B> Not enough players, [mode.required_players] players needed. Reverting to pre-game lobby."
		current_state = GAME_STATE_PREGAME
		mode.fail_setup()
		mode = null
		job_master.ResetOccupations()
		return FALSE

	if(hide_mode)
		world << "<B>The current game mode is - Secret!</B>"
		if(runnable_modes.len)
			var/list/tmpmodes = new
			for (var/datum/game_mode/M in runnable_modes)
				tmpmodes+=M.name
			tmpmodes = sortList(tmpmodes)
			if(tmpmodes.len)
				world << "<B>Possibilities:</B> [english_list(tmpmodes)]"
	else
		mode.announce()

	current_state = GAME_STATE_PLAYING
	create_characters() //Create player characters and transfer them
	collect_minds()
	equip_characters()
//	data_core.manifest()

	// trains setup before roundstart hooks called because SS train ladders rely on it
	if (map.uses_main_train)
		start_train_loop()

	callHook("roundstart")

	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			if (S.name != "AI")
				qdel(S)

	//	world << "<FONT color='blue'><B>Enjoy the game!</B></FONT>"
		//Holiday Round-start stuff	~Carn

		// todo: make these hooks. Apparently they all fail on /hook/roundstart
		handle_lifts()
		setup_autobalance()
		reinforcements_master = new


	//close_jobs()//Makes certain jobs unselectable past roundstart. Unneeded atm.
	//start_events() //handles random events and space dust.
	//new random event system is handled from the MC.

	/* TODO: discord bot - Kachnov
	var/admins_number = FALSE
	for(var/client/C)
		if(C.holder)
			admins_number++

	if(admins_number == FALSE)
		send2adminirc("Round has started with no admins online.")*/

	processScheduler.start()

	return TRUE

/datum/controller/gameticker/proc/close_jobs()
	for(var/datum/job/job in job_master.occupations)
		if(job.title == "Captain")
			job.total_positions = FALSE

/datum/controller/gameticker
	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
	proc/station_explosion_cinematic(var/station_missed=0, var/override = null)
		if( cinematic )	return	//already a cinematic in progress!

		//initialise our cinematic screen object
		cinematic = new(src)
		cinematic.icon = 'icons/effects/station_explosion.dmi'
		cinematic.icon_state = "station_intact"
		cinematic.layer = 20
		cinematic.mouse_opacity = FALSE
		cinematic.screen_loc = "1,0"

		var/obj/structure/bed/temp_buckle = new(src)
		//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
		if(station_missed)
			for(var/mob/living/M in living_mob_list)
				M.buckled = temp_buckle				//buckles the mob so it can't do anything
				if(M.client)
					M.client.screen += cinematic	//show every client the cinematic
		else	//nuke kills everyone on z-level TRUE to prevent "hurr-durr I survived"
			for(var/mob/living/M in living_mob_list)
				M.buckled = temp_buckle
				if(M.client)
					M.client.screen += cinematic

				switch(M.z)
					if(0)	//inside a crate or something
						var/turf/T = get_turf(M)
						if(T && T.z in config.station_levels)				//we don't use M.death(0) because it calls a for(/mob) loop and
							M.health = FALSE
							M.stat = DEAD
					if(1)	//on a z-level TRUE turf.
						M.health = FALSE
						M.stat = DEAD

		//Now animate the cinematic
		switch(station_missed)
			if(1)	//nuke was nearby but (mostly) missed
				if( mode && !override )
					override = mode.name
				switch( override )
					if("mercenary") //Nuke wasn't on station when it blew up
						flick("intro_nuke",cinematic)
						sleep(35)
						world << sound('sound/effects/explosionfar.ogg')
						flick("station_intact_fade_red",cinematic)
						cinematic.icon_state = "summary_nukefail"
					else
						flick("intro_nuke",cinematic)
						sleep(35)
						world << sound('sound/effects/explosionfar.ogg')
						//flick("end",cinematic)


			if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
				sleep(50)
				world << sound('sound/effects/explosionfar.ogg')


			else	//station was destroyed
				if( mode && !override )
					override = mode.name
				switch( override )
					if("mercenary") //Nuke Ops successfully bombed the station
						flick("intro_nuke",cinematic)
						sleep(35)
						flick("station_explode_fade_red",cinematic)
						world << sound('sound/effects/explosionfar.ogg')
						cinematic.icon_state = "summary_nukewin"
					if("AI malfunction") //Malf (screen,explosion,summary)
						flick("intro_malf",cinematic)
						sleep(76)
						flick("station_explode_fade_red",cinematic)
						world << sound('sound/effects/explosionfar.ogg')
						cinematic.icon_state = "summary_malf"
					if("blob") //Station nuked (nuke,explosion,summary)
						flick("intro_nuke",cinematic)
						sleep(35)
						flick("station_explode_fade_red",cinematic)
						world << sound('sound/effects/explosionfar.ogg')
						cinematic.icon_state = "summary_selfdes"
					else //Station nuked (nuke,explosion,summary)
						flick("intro_nuke",cinematic)
						sleep(35)
						flick("station_explode_fade_red", cinematic)
						world << sound('sound/effects/explosionfar.ogg')
						cinematic.icon_state = "summary_selfdes"
				for(var/mob/living/M in living_mob_list)
					if(M.loc.z in config.station_levels)
						M.death()//No mercy
		//If its actually the end of the round, wait for it to end.
		//Otherwise if its a verb it will continue on afterwards.
		sleep(300)

		if(cinematic)	qdel(cinematic)		//end the cinematic
		if(temp_buckle)	qdel(temp_buckle)	//release everybody
		return


	proc/create_characters()
		for(var/mob/new_player/player in player_list)
			if(player && player.ready && player.mind)
				if(!player.mind.assigned_role)
					continue
				else
					player.create_character()
					qdel(player)


	proc/collect_minds()
		for(var/mob/living/player in player_list)
			if(player.mind)
				ticker.minds += player.mind


	proc/equip_characters()
		var/captainless=1
		for(var/mob/living/carbon/human/player in player_list)
			if(player && player.mind && player.mind.assigned_role)
				if(player.mind.assigned_role == "Captain")
					captainless=0
				if(!player_is_antag(player.mind, only_offstation_roles = TRUE))
					job_master.EquipRank(player, player.mind.assigned_role, FALSE)
			//		equip_custom_items(player)
		if(captainless)
			for(var/mob/M in player_list)
				if(!istype(M,/mob/new_player))
					M << "Captainship not forced on anyone."


	proc/process()
		if(current_state != GAME_STATE_PLAYING)
			return FALSE

		mode.process()

//		emergency_shuttle.process() //handled in scheduler

		var/game_finished = FALSE
		var/mode_finished = FALSE
		if (config.continous_rounds)
			game_finished = (mode.station_was_nuked)
			mode_finished = (!post_game && mode.check_finished())
		else
			game_finished = (mode.check_finished())
			mode_finished = game_finished

		if(!mode.explosion_in_progress && game_finished && (mode_finished || post_game))
			current_state = GAME_STATE_FINISHED

			spawn
				declare_completion()

			spawn(50)
				callHook("roundend")

				if(!delay_end)
					world << "<span class='notice'><b>Restarting in [restart_timeout/10] seconds</b></span>"

				if(!delay_end)
					sleep(restart_timeout)
					if(!delay_end)
						world.Reboot()
					else
						world << "<span class='notice'><b>An admin has delayed the round end</b></span>"
				else
					world << "<span class='notice'><b>An admin has delayed the round end</b></span>"

		else if (mode_finished)
			post_game = TRUE

			mode.cleanup()

			spawn(50)
				if(!round_end_announced) // Spam Prevention. Now it should announce only once.
					if (!istype(mode, /datum/game_mode/ww2))
						world << "<span class='danger'>The round has ended!</span>"
					round_end_announced = TRUE

		return TRUE

/datum/controller/gameticker/proc/declare_completion()
	if (!istype(mode, /datum/game_mode/ww2))
		world << "<br><br><br><H1>A round of [mode.name] has ended!</H1>"
		for(var/mob/Player in player_list)
			if(Player.mind && !isnewplayer(Player))

				if(Player.stat != DEAD)
					var/turf/playerTurf = get_turf(Player)
					if(isAdminLevel(playerTurf.z))
						Player << "<font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b></font>"
					else
						Player << "<font color='blue'><b>You missed the crew transfer after the events on [station_name()] as [Player.real_name].</b></font>"
				else
					if(isghost(Player))
						var/mob/observer/ghost/O = Player
						if(!O.started_as_observer)
							Player << "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>"
					else
						Player << "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>"
		world << "<br>"


	mode.declare_completion()//To declare normal completion.

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	return TRUE
