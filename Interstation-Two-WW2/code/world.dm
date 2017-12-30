
var/global/list/serverswap = list()
var/global/serverswap_open_status = 1 // if this is 1, we're the active server
var/global/serverswap_closing = 0

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
	return 1

/var/game_id = null
/proc/generate_gameid()
	if(game_id != null)
		return
	game_id = ""

	var/list/c = list("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	var/l = c.len

	var/t = world.timeofday
	for(var/_ = 1 to 4)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)
	game_id = "-[game_id]"
	t = round(world.realtime / (10 * 60 * 60 * 24))
	for(var/_ = 1 to 3)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)

var/world_is_open = 1

/world
	mob = /mob/new_player
	turf = /turf/floor/plating/grass/wild
	area = /area/prishtina
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session

#define RECOMMENDED_VERSION 509
/world/New()
	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	diary << "[log_end]\n[log_end]\nStarting up. (ID: [game_id]) [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND."

	config.post_load()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	if(config && config.log_runtimes)
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")
		log << "STARTED RUNTIME LOGGING"

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

	. = ..()

#ifndef UNIT_TEST

	sleep_offline = 1

#else
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

	T = replacetext(T, "{CLIENTS}", clients.len)
	T = replacetext(T, "{PLAYERS}", player_list.len)
	T = replacetext(T, "{MOBS}", mob_list.len)
	T = replacetext(T, "{LIVING}", living_mob_list.len)
	T = replacetext(T, "{HUMAN}", human_mob_list)
	T = replacetext(T, "{TIMEOFDAY}", time_of_day)
	T = replacetext(T, "{WEATHER}", "clear skies")

	if (ticker.mode.vars.Find("season"))
		T = replacetext(T, "{SEASON}", ticker.mode:season)
	else
		T = replacetext(T, "{SEASON}", "Spring")

	T = replacetext(T, "{ROUNDTIME}", roundduration2text())

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

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

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
		s["players"] = 0
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
			var/n = 0
			var/admins = 0

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

	world << "<span class = 'danger'>Rebooting!</span> <span class='notice'>Click this link to rejoin (You may have to wait anywhere from 20 seconds to a few minutes): <b>byond://[world.internet_address]:[serverswap.Find("snext") ? serverswap[serverswap["snext"]] : world.port]</b></span>"

	spawn(0)
		if (config.jojoreference)
			roundabout()

	serverswap_closing = 1

	spawn (100)

		processScheduler.stop()

		for(var/client/C in clients)
			if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
				C << link("byond://[config.server]")

		..(reason)

#define COLOR_LIGHT_SEPIA "#D4C6B8"
/world/proc/roundabout() // yes i know this is dumb - kachnov
	world << sound('sound/misc/roundabout.ogg')
	spawn (40)
		for (var/client/client in clients)
			client.color = COLOR_LIGHT_SEPIA
			client.screen += tobecontinued
			client.canmove = 0
#undef COLOR_SEPIA

/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

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
	return 1

/world/proc/load_motd()
//	join_motd = russian_to_cp1251(file2text("config/motd.txt"))
	join_motd = file2text("config/motd.txt")

/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.load("config/hub.txt", "hub")
	config.load("config/game_schedule.txt", "game_schedule")

/world/proc/update_status()

	if (world.port == config.testing_port)
		visibility = 0

	var/s = ""

	if (config.open_hub_discord_in_new_window)
		s += "<center><a href=\"[config.discordurl]\" target=\"_blank\"><b>[station_name()]</b></center><br>"
	else
		s += "<center><a href=\"[config.discordurl]\"><b>[station_name()]</b></center><br>"

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

	if (config.hub_banner_url)
		s += config.hub_banner_url

	status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0
var/failed_old_db_connections = 0
var/setting_up_db_connection = 0

/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
	return 1

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!database)
		return setup_database_connection()
	else
		return 1


/proc/DEBUG_SERVERSWAP(var/x)
	world.log << "SERVERSWAP DEBUG: [x]"

/proc/setup_database_connection()

	if (setting_up_db_connection)
		return

	setting_up_db_connection = 1

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		setting_up_db_connection = 0
		return 0

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
					DEBUG_SERVERSWAP(5.1)
					serverswap_open_status = 1
				else
					DEBUG_SERVERSWAP(5.2)
					serverswap_open_status = 0

			DEBUG_SERVERSWAP(6)
			if (serverswap.Find("masterdir"))
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
				serverswap["ready"] = 1
		else
			database = new("SQL/database.db")

	. = TRUE
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << "The database failed to start up for the [failed_db_connections == 1 ? "1st" : "[failed_db_connections]st"] time."

	setting_up_db_connection = 0
	return .

#undef FAILED_DB_CONNECTION_CUTOFF

var/global/serverswap_loop_cooldown = 0

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
				if (our_number > 1)
					waiting_on_id = "s[our_number-1]" // "s2" waits on "s1", "s3" waits on "s2"
				else if (our_number == 1)
					waiting_on_id = serverswap["sfinal"]
				if (fexists("[serverswap["masterdir"]]/sharedinfo/[waiting_on_id]_normal.txt"))
					// do nothing for now
				else if (fexists("[serverswap["masterdir"]]/sharedinfo/[waiting_on_id]_closing.txt"))
					// other server is closing, time to open
					serverswap_open_status = 1
					// don't start looping until other server is closed
					serverswap_loop_cooldown = 25
					DEBUG_SERVERSWAP("13.1")
			if (1) // we're going to send updates every second in the form of text files telling the server after us what to do

				if (!serverswap_closing)

					// delete the other file, if it exists
					if (fexists("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_closing.txt"))
						DEBUG_SERVERSWAP("13.29")
						fdel("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_closing.txt")

					wdir = "[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_normal.txt"
					F = file(wdir)
					fdel(F)
					F << "testing"
					DEBUG_SERVERSWAP("13.3: [wdir]")
				else
					// delete the other file, if it exists
					if (fexists("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_normal.txt"))
						DEBUG_SERVERSWAP("13.39")
						fdel("[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_normal.txt")

					wdir = "[serverswap["masterdir"]]/sharedinfo/[serverswap["this"]]_closing.txt"
					F = file(wdir)
					fdel(F)
					F << "testing"
					DEBUG_SERVERSWAP("13.4: [wdir]")

					// time to close this server
					serverswap_open_status = 0
					// don't start looping again until other server is open
					serverswap_loop_cooldown = 25

		sleep(10+serverswap_loop_cooldown)
		serverswap_loop_cooldown = 0