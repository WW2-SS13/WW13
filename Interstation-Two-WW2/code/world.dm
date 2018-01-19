
var/global/list/serverswap = list()
var/global/serverswap_open_status = TRUE // if this is TRUE, we're the active server
var/global/serverswap_closed = FALSE

/*
	The initialization of the game happens roughly like this:

	1. All global variables are initialized (including the global_init instance).
	2. The map is initialized, and map objects are created.
	3. world/New() runs, creating the process scheduler (and the old master controller) and spawning their setup.
	4. processScheduler/setup() runs, creating all the processes. game_controller/setup() runs, calling initialize() on all movable atoms in the world.
	5. The gameticker is created.

*/
var/global/datum/global_init/init = new ()

/*
	Pre-map initialization stuff should go here.
*/
/datum/global_init/New()
	generate_gameid()

	makeDatumRefLists()
	load_configuration()

	initialize_chemical_reagents()
	initialize_chemical_reactions()

	qdel(src) //we're done

/datum/global_init/Destroy()
	return TRUE

/var/game_id = null
/proc/generate_gameid()
	if(game_id != null)
		return
	game_id = ""

	var/list/c = list("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	var/l = c.len

	var/t = world.timeofday
	for(var/_ = TRUE to 4)
		game_id = "[c[(t % l) + TRUE]][game_id]"
		t = round(t / l)
	game_id = "-[game_id]"
	t = round(world.realtime / (10 * 60 * 60 * 24))
	for(var/_ = TRUE to 3)
		game_id = "[c[(t % l) + TRUE]][game_id]"
		t = round(t / l)

var/world_is_open = TRUE

/world
	mob = /mob/new_player
	turf = /turf/floor/plating/grass/wild
	area = /area/prishtina
	view = "15x15"
	cache_lifespan = FALSE	//stops player uploaded stuff from being kept in the rsc past the current session

#define RECOMMENDED_VERSION 509
/world/New()

	log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")
	log << "STARTED RUNTIME LOGGING"

	attack_log = file("data/logs/attack/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-attack.log")
	log << "STARTED ATTACK LOGGING"

	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	diary << "[log_end]\n[log_end]\nStarting up. (ID: [game_id]) [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND."

	config.post_load()

	if(config && config.server_name != null && config.server_suffix && world.port > FALSE)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	for (var/W in (typesof(/datum/whitelist) - /datum/whitelist))
		var/datum/whitelist/whitelist = new W
		global_whitelists[whitelist.name] = whitelist

	callHook("startup")
	//Emergency Fix
//	load_mods()
	//end-emergency fix

	update_status()

	// make the database, or connect to it
	establish_db_connection()

	..()

// removed the 'sleep_offline' = TRUE here, it interferes with serverswap - kachnov
#ifdef UNIT_TEST
	log_unit_test("Unit Tests Enabled.  This will destroy the world when testing is complete.")
	load_unit_test_changes()
#endif

	// This is kinda important. Set up details of what the hell things are made of.
	populate_material_list()

	processScheduler = new
	master_controller = new /datum/controller/game_controller()

	spawn(1)
		processScheduler.deferSetupFor(/datum/controller/process/ticker)
		processScheduler.setup()
		master_controller.setup()
#ifdef UNIT_TEST
		initialize_unit_tests()
#endif

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()

#undef RECOMMENDED_VERSION

	return

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

// todo: add aspect to this
/world/proc/replace_custom_hub_text(T)

	if (!ticker || !ticker.mode)
		return ""

	// numerical constants
	T = replacetext(T, "{CLIENTS}", clients.len) // # of clients
	T = replacetext(T, "{PLAYERS}", player_list.len) // # of mobs w/ clients
	T = replacetext(T, "{MOBS}", mob_list.len) // # of mobs
	T = replacetext(T, "{LIVING}", living_mob_list.len) // # of /mob/living
	T = replacetext(T, "{HUMAN}", human_mob_list) // # of humans
	T = replacetext(T, "{HUMAN_CLIENTS}", human_clients_mob_list) // # of humans w/clients
	T = replacetext(T, "{DEAD}", dead_mob_list.len) // # of dead mobs
	T = replacetext(T, "{OBSERVERS}", observer_mob_list.len) // # of observers w/clients
	T = replacetext(T, "{ROUNDTIME}", roundduration2text())
	// UPPERCASE constants
	T = replacetextEx(T, "{TIMEOFDAY}", uppertext(time_of_day))
	T = replacetextEx(T, "{WEATHER}", uppertext(ticker.mode.weather()))
	T = replacetextEx(T, "{SEASON}", uppertext(ticker.mode.season()))
	T = replacetextEx(T, "{MAP}", uppertext(map.ID)) // name of the map
	// Capitalized constants - no change
	T = replacetextEx(T, "{Timeofday}", time_of_day)
	T = replacetextEx(T, "{Weather}", ticker.mode.weather())
	T = replacetextEx(T, "{Season}", ticker.mode.season())
	T = replacetextEx(T, "{Map}", map.ID) // name of the map
	// lowercase constants
	T = replacetextEx(T, "{timeofday}", lowertext(time_of_day))
	T = replacetextEx(T, "{weather}", lowertext(ticker.mode.weather()))
	T = replacetextEx(T, "{season}", lowertext(ticker.mode.season()))
	T = replacetextEx(T, "{map}", lowertext(map.ID)) // name of the map

	return T

/world/Topic(T, addr, master, key)
	diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key][log_end]"

	// custom WW13 hub modules

	if (T == "WW13.preinfo")
		return replace_custom_hub_text(config.ww13_hub_preinfo)

	else if (T == "WW13.title")
		return replace_custom_hub_text(config.ww13_hub_title)

	else if (T == "WW13.oocdesc")
		return replace_custom_hub_text(config.ww13_hub_oocdesc)

	else if (T == "WW13.icdesc")
		return replace_custom_hub_text(config.ww13_hub_icdesc)

	else if (T == "WW13.rplevel")
		return replace_custom_hub_text(config.ww13_hub_rplevel)

	else if (T == "WW13.hostedby")
		return replace_custom_hub_text(config.ww13_hub_hostedby)

	else if (T == "WW13.postinfo")
		return replace_custom_hub_text(config.ww13_hub_postinfo)

	// normal ss13 stuff

	else if (T == "ping")
		return clients.len + 1

	else if(T == "players")
		return clients.len

	else if (copytext(T,1,7) == "status")
		var/input[] = params2list(T)
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config.abandon_allowed
		s["enter"] = config.enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null

		// This is dumb, but spacestation13.com's banners break if player count isn't the 8th field of the reply, so... this has to go here.
		s["players"] = FALSE
		s["stationtime"] = stationtime2text()
		s["roundduration"] = roundduration2text()

		if(input["status"] == "2")
			var/list/players = list()
			var/list/admins = list()

			for(var/client/C in clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue
					admins[C.key] = C.holder.rank
				players += C.key

			s["players"] = players.len
			s["playerlist"] = list2params(players)
			s["admins"] = admins.len
			s["adminlist"] = list2params(admins)
		else
			var/n = FALSE
			var/admins = FALSE

			for(var/client/C in clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue	//so stealthmins aren't revealed by the hub
					admins++
				s["player[n]"] = C.key
				n++

			s["players"] = n
			s["admins"] = admins

		return list2params(s)

/world/Reboot(var/reason)

	save_all_whitelists()
	serverswap_pre_close_server()
	spawn (20)
		serverswap_close_server()

	// wait for serverswap to do its magic - kachnov
	spawn (90)

		if (serverswap.Find("snext"))
			if (serverswap.Find(serverswap["snext"]))
				var/new_address = "byond://[world.internet_address]:[serverswap[serverswap["snext"]]]"
				world << "<span class = 'danger'>Rebooting!</span> <span class='notice'>If you aren't taken there automatically, click here to join the linked server: <b>[new_address]</b></span>"
				for (var/client/C in clients)
					C << link(new_address)
			else
				world << "<span class = 'danger'>Rebooting!</span> <span class='notice'>Click here to rejoin (It may take a minute or two): <b>byond://[world.internet_address]:[port]</b></span>"
		else
			world << "<span class = 'danger'>Rebooting!</span> <span class='notice'>Click here to rejoin (It may take a minute or two): <b>byond://[world.internet_address]:[port]</b></span>"

		spawn(0)
			if (config.jojoreference)
				roundabout()

		spawn (10)

			processScheduler.stop()

			..(reason)

#define COLOR_LIGHT_SEPIA "#D4C6B8"
/world/proc/roundabout() // yes i know this is dumb - kachnov
	world << sound('sound/misc/roundabout.ogg')
	spawn (40)
		for (var/client/client in clients)
			client.color = COLOR_LIGHT_SEPIA
			client.screen += tobecontinued
			client.canmove = FALSE
#undef COLOR_SEPIA

/hook/startup/proc/loadMode()
	world.load_mode()
	return TRUE

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			log_misc("Saved mode is '[master_mode]'")

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/hook/startup/proc/loadMOTD()
	world.load_motd()
	return TRUE

/world/proc/load_motd()
//	join_motd = russian_to_cp1251(file2text("config/motd.txt"))
	join_motd = file2text("config/motd.txt")

/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt", "config")
	config.load("config/game_options.txt","game_options")
	config.load("config/hub.txt", "hub")
	config.load("config/game_schedule.txt", "game_schedule")

	/* config options get overwritten by global config options
	 * only useful for serverswap memery - Kachnov */
	if (config.global_config_path)
		config.load(config.global_config_path, "config")

/world/proc/update_status()

	if (world.port == config.testing_port)
		visibility = FALSE

	var/s = ""

	if (config.open_hub_discord_in_new_window)
		s += "<center><a href=\"[config.discordurl]\" target=\"_blank\"><b>[station_name()]</b></center><br>"
	else
		s += "<center><a href=\"[config.discordurl]\"><b>[station_name()]</b></center><br>"

	// for the custom WW13 hub only!

	// we can't execute code in config settings, so this is a workaround.
	config.hub_body = replacetext(config.hub_body, "TIME_OF_DAY", lowertext(time_of_day))

	if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/ww2))
		config.hub_body = replacetext(config.hub_body, "SEASON", lowertext(ticker.mode:season))
	else
		config.hub_body = replacetext(config.hub_body, "SEASON", "Spring")

	if (config.hub_body)
		s += config.hub_body

	if (config.hub_features)
		s += "<b>[config.hub_features]</b><br>"

	if (map)
		s += "<b>Map: [map.ID]</b><br>"

	if (config.hub_banner_url)
		s += config.hub_banner_url

	status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = FALSE
var/failed_old_db_connections = FALSE
var/setting_up_db_connection = FALSE

/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
	return TRUE

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return FALSE

	if(!database)
		return setup_database_connection()
	else
		return TRUE


//#define SERVERSWAP_DEBUGGING
/proc/DEBUG_SERVERSWAP(var/x)
	#ifdef SERVERSWAP_DEBUGGING
	world.log << "SERVERSWAP DEBUG: [x]"
	#endif

/proc/setup_database_connection()

	if (setting_up_db_connection)
		return

	setting_up_db_connection = TRUE

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		setting_up_db_connection = FALSE
		return FALSE

	if(!database)
		if (fexists("config/serverswap.txt"))
			DEBUG_SERVERSWAP(3)
			var/list/lines = file2list("config/serverswap.txt")
			for (var/line in lines)
				var/split = splittext(line, " = ")
				var/p1 = split[1]
				var/p2 = split[2]
				var/numcheck = text2num(p2)
				if (isnum(numcheck) && !isnull(numcheck))
					// "s1" = 2000
					serverswap[p1] = text2num(p2)
				else if (p1 == "this" || p1 == "sfinal" || p1 == "snext")
					// "this" = "s1" or "sfinal" = "s2" or "snext" = "s2"
					serverswap[p1] = p2
				else if (p1 == "masterdir")
					// "masterdir" = "server/WW13/..."
					if (p2 == "nil")
						serverswap.Cut()
						goto end_serverswap
					else
						serverswap[p1] = p2
				else if (p1 == "enabled")
					if (p2 == "false")
						serverswap.Cut()
						goto end_serverswap

			end_serverswap

			for (var/x in serverswap)
				DEBUG_SERVERSWAP("4.5: [x] = [serverswap[x]]")

			DEBUG_SERVERSWAP(5)

			if (serverswap.Find("this"))
				if (serverswap["this"] == "s1")
				/*
					// we're starting up for the first time, so clear the sharedinfo folder
					for (var/i in TRUE to 10)
						var/d1 = "[serverswap["masterdir"]]/sharedinfo/s[i]_normal.txt"
						var/d2 = "[serverswap["masterdir"]]/sharedinfo/s[i]_closed.txt"
						if (fexists(d1))
							fdel(d1)
						if (fexists(d2))
							fdel(d2)
						*/
					DEBUG_SERVERSWAP(5.1)
					if (fexists("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_closed.txt"))
						serverswap_open_status = FALSE
						DEBUG_SERVERSWAP(5.11)
					else
						serverswap_open_status = TRUE
						DEBUG_SERVERSWAP(5.12)
				else
					DEBUG_SERVERSWAP(5.2)
					serverswap_open_status = FALSE

			DEBUG_SERVERSWAP(6)
			if (serverswap.Find("masterdir") && serverswap["masterdir"] != "nil")
				DEBUG_SERVERSWAP(7.1)
				database = new("[serverswap["masterdir"]]/SQL/database.db")
				if (!database)
					DEBUG_SERVERSWAP(7.15)
			else
				DEBUG_SERVERSWAP(7.2)
				database = new("SQL/database.db")
				if (!database)
					DEBUG_SERVERSWAP(7.25)

			if (serverswap.len)
				serverswap["ready"] = TRUE
		else
			database = new("SQL/database.db")

	. = TRUE
	if ( . )
		failed_db_connections = FALSE	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << "The database failed to start up for the [failed_db_connections == TRUE ? "1st" : "[failed_db_connections]st"] time."

	setting_up_db_connection = FALSE
	return .

#undef FAILED_DB_CONNECTION_CUTOFF

/proc/get_packaged_server_status_data()
	. = ""
	. += "<b>Server Status</b>: Online"
	. += ";"
	. += "<b>Address</b>: byond://[world.internet_address]:[world.port]"
	. += ";"
	. += "<b>Map</b>: [map.ID]"
	. += ";"
	. += "<b>Players</b>: [clients.len]"
	if (config.usewhitelist)
		. += ";"
		. += "<b>Whitelist</b>: Enabled"

/proc/start_serverdata_loop()
	spawn while (1)
		var/F = file("serverdata.txt")
		if (fexists("serverdata.txt"))
			fdel(F)
		if (!serverswap.len || !serverswap.Find("masterdir") || serverswap_open_status)
			F << get_packaged_server_status_data()
		sleep (100)

/proc/start_serverswap_loop()
	spawn while (1)
		DEBUG_SERVERSWAP(8)
		if (!serverswap.len)
			break
		DEBUG_SERVERSWAP(9)
		if (!serverswap.Find("masterdir")) // we can't do anything without this!
			break
		DEBUG_SERVERSWAP(10)
		if (!serverswap.Find("this")) // ditto
			break
		DEBUG_SERVERSWAP(11)
		if (!serverswap.Find("sfinal")) // ditto
			break
		DEBUG_SERVERSWAP(12)
		var/wdir = ""
		var/F = ""
		DEBUG_SERVERSWAP("13 = [serverswap_open_status]")
		switch (serverswap_open_status)
			if (0) // we're waiting for the server before us or the very last server to tell us its ok to go up
				var/our_server_id = serverswap["this"] // "s1"
				var/our_number = text2num(replacetext(our_server_id, "s", "")) // '1'
				var/waiting_on_id = null
				if (our_number > TRUE)
					waiting_on_id = "s[our_number-1]" // "s2" waits on "s1", "s3" waits on "s2"
				else if (our_number == TRUE)
					waiting_on_id = serverswap["sfinal"]

				DEBUG_SERVERSWAP("13.01 = [waiting_on_id]")
				DEBUG_SERVERSWAP("13.02 = [serverswap["masterdir"]]/sharedinfo/[waiting_on_id]_closed.txt")
				DEBUG_SERVERSWAP("13.03 = [serverswap_open_status]")
				DEBUG_SERVERSWAP("13.04 = [serverswap_closed]")

				if (fexists("[serverswap["masterdir"]]/sharedinfo/[waiting_on_id]_closed.txt"))
					// other server is closed, time to open (if we aren't already open)
					serverswap_open_status = TRUE
					serverswap_closed = FALSE
					if (ticker)
						ticker.pregame_timeleft = initial(ticker.pregame_timeleft)
					DEBUG_SERVERSWAP("13.1")

					// make sure we aren't marked as closed anymore
					wdir = "[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_closed.txt"
					if (fexists(wdir))
						fdel(wdir)
			/*	else
					F = file("test_[waiting_on_id].txt")
					fdel(F)
					F << "hello world!"*/
			if (1) // we're going to send updates every second in the form of text files telling the server after us what to do

		/*		if (!serverswap_closed)
					// delete the other file, if it exists
					if (fexists("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_closed.txt"))
						DEBUG_SERVERSWAP("13.29")
						fdel("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_closed.txt")*/

				wdir = "[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_normal.txt"
				F = file(wdir)
				fdel(F)
				F << "testing"
				DEBUG_SERVERSWAP("13.3: [wdir]")
				// otherwise do nothing - code moved to serverswap_close_server()

		sleep(10)

/proc/serverswap_pre_close_server()
	// don't let the loop delete any file we create or make any new files
	serverswap_closed = TRUE
	serverswap_open_status = FALSE

/proc/serverswap_close_server()

	if (fexists("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_normal.txt"))
		DEBUG_SERVERSWAP("13.39")
		fdel("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_normal.txt")

	var/F = file("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_closed.txt")
	fdel(F)
	F << "testing"