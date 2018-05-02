var/global/datum/controller/gameticker/ticker
var/global/datum/lobby_music_player/lobby_music_player = null

/datum/controller/gameticker
	var/const/restart_timeout = 300
	var/current_state = GAME_STATE_PREGAME
	var/admin_started = FALSE

//	var/hide_mode = FALSE
//	var/datum/game_mode/mode = null
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

	var/tip = null
	var/maytip = TRUE

	var/finished = FALSE // set to TRUE by the map object

/datum/controller/gameticker/proc/pregame()

	spawn (0)

		if (serverswap_open_status)
			if (!processScheduler.isRunning)
				processScheduler.start()
				message_admins("processScheduler.start() was called at gameticker.pregame().")
				log_admin("processScheduler.start() was called at gameticker.pregame().")

		if (!lobby_music_player)
			lobby_music_player = new

		login_music = lobby_music_player.get_song()

		do
			pregame_timeleft = 180
			maytip = TRUE
			if (serverswap_open_status)
				world << "<b><span style = 'notice'>Welcome to the pre-game lobby!</span></b>"
				world << "The game will start in [pregame_timeleft] seconds."

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
					if (tip)
						world << "<span class = 'notice'><b>Tip of the Round:</b> [tip]</span>"
					else
						var/list/tips = file2list("config/tips.txt")
						if (tips.len)
							if (serverswap_open_status)
								world << "<span class = 'notice'><b>Tip of the Round:</b> [spick(tips)]</span>"
								qdel_list(tips)
					maytip = FALSE
				if(pregame_timeleft <= 0)
					current_state = GAME_STATE_SETTING_UP
					/* if we were force started, still show the tip */
					if (maytip)
						if (tip)
							world << "<span class = 'notice'><b>Tip of the Round:</b> [tip]</span>"
						else
							var/list/tips = file2list("config/tips.txt")
							if (tips.len)
								if (serverswap_open_status)
									world << "<span class = 'notice'><b>Tip of the Round:</b> [spick(tips)]</span>"
									qdel_list(tips)

		while (!setup())


/datum/controller/gameticker/proc/setup()
	//Create and announce mode
	/*if(master_mode=="secret")
		hide_mode = TRUE*/
/*
	var/list/runnable_modes = config.get_runnable_modes()
	if((master_mode=="random") || (master_mode=="secret"))
		if(!runnable_modes.len)
			current_state = GAME_STATE_PREGAME
			if (serverswap_open_status)
				world << "<b>Unable to choose playable game mode.</b> Reverting to pre-game lobby."
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
		return FALSE*/

	job_master.ResetOccupations()
//	mode.create_antagonists()
//	mode.pre_setup()
//	job_master.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	if(!map || !map.can_start() && !admin_started)
		if (serverswap_open_status)
			world << "<b>Unable to start the game.</b> Not enough players, [map.required_players] players needed. Reverting to the pre-game lobby."
		current_state = GAME_STATE_PREGAME
		job_master.ResetOccupations()
		return FALSE
/*
	if(hide_mode)
		world << "<b>The current game mode is - Secret!</b>"
		if(runnable_modes.len)
			var/list/tmpmodes = new
			for (var/datum/game_mode/M in runnable_modes)
				tmpmodes+=M.name
			tmpmodes = sortList(tmpmodes)
			if(tmpmodes.len)
				world << "<b>Possibilities:</b> [english_list(tmpmodes)]"
	else
		mode.announce()*/

	current_state = GAME_STATE_PLAYING
	create_characters() //Create player characters and transfer them
	collect_minds()
	equip_characters()
//	data_core.manifest()

	// trains setup before roundstart hooks called because SS train ladders rely on it
	if (map.uses_main_train)
		setup_trains()
		train_loop()

	TOD_loop()

	callHook("roundstart")

	spawn(0)//Forking here so we dont have to wait for this to finish
//		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			if (S.name != "AI")
				qdel(S)

	//	world << "<span class = 'notice'><b>Enjoy the game!</b></FONT>"
		//Holiday Round-start stuff	~Carn

		// todo: make these hooks. Apparently they all fail on /hook/roundstart
		handle_lifts()
		setup_autobalance()
		reinforcements_master = new


	//close_jobs()//Makes certain jobs unselectable past roundstart. Unneeded atm.
	//start_events() //handles random events and space dust.
	//new random event system is handled from the MC.

	/* TODO: discord bot - Kachnov
	var/admins_number = 0
	for(var/client/C)
		if(C.holder)
			admins_number++

	if(admins_number == 0)
		send2adminirc("Round has started with no admins online.")*/

	if (!processScheduler.isRunning)
		processScheduler.start()
		message_admins("processScheduler.start() was called at gameticker.setup().")
		log_admin("processScheduler.start() was called at gameticker.setup().")

	return TRUE

/datum/controller/gameticker/proc/close_jobs()
	for(var/datum/job/job in job_master.occupations)
		if(job.title == "Captain")
			job.total_positions = FALSE


	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	//var/obj/screen/cinematic = null
/*
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
		return*/


/datum/controller/gameticker/proc/create_characters()
	for(var/mob/new_player/player in player_list)
		if(player && player.ready && player.mind)
			if(!player.mind.assigned_role)
				continue
			else
				player.create_character()
				qdel(player)


/datum/controller/gameticker/proc/collect_minds()
	for(var/mob/living/player in player_list)
		if(player.mind)
			ticker.minds += player.mind

/datum/controller/gameticker/proc/equip_characters()
	for(var/mob/living/carbon/human/player in player_list)
		if(player && player.mind && player.mind.assigned_role)
		//	if(!player_is_antag(player.mind, only_offstation_roles = TRUE))
			job_master.EquipRank(player, player.mind.assigned_role, FALSE)
		//		equip_custom_items(player)

/datum/controller/gameticker/proc/process()
	if(current_state != GAME_STATE_PLAYING)
		return FALSE

//		mode.process()

//		emergency_shuttle.process() //handled in scheduler
/*
	var/game_finished = FALSE
	var/mode_finished = FALSE
	if (config.continous_rounds)
		game_finished = (mode.station_was_nuked)
		mode_finished = (!post_game && mode.check_finished())
	else
		game_finished = (mode.check_finished())
		mode_finished = game_finished
*/
	if (finished)
		current_state = GAME_STATE_FINISHED

/*		spawn
			declare_completion()*/

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

	return TRUE