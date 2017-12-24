
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
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND"

	config.post_load()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	if(config && config.log_runtime)
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.txt")

	for (var/W in (typesof(/datum/whitelist) - /datum/whitelist))
		var/datum/whitelist/whitelist = new W
		global_whitelists[whitelist.name] = whitelist

	callHook("startup")
	//Emergency Fix
//	load_mods()
	//end-emergency fix

	src.update_status()

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

	/* patreon data: we send nothing back
	  example: "patreon.data.user,pledge" */

	/* How this works: the WW13 hub uses patreon's PHP library
	  to obtain info from the patreon. Then the WW13 hub pings
	  the server with this data. */

	// todo: patreon_ids that go in player preferences.
	// WW13 hub should send patreon data every 0.5 minutes,
	// but only retrieve it every 10 minutes

	if (findtext(T, "patreon.data"))
		var/list/datalist = splittext(T, ".")
		var/data = datalist[datalist.len]
		var/list/data_kvs = splittext(data, ",")
		var/user = data_kvs["user"]
		var/pledge = data_kvs["pledge"]
		establish_db_connection()

		var/list/patrons = database.execute("SELECT * FROM player WHERE patreon_id = '[user]';")
		if (islist(patrons) && !isemptylist(patrons))
			database.execute("INSERT INTO patreon user, pledge VALUES('[user]', '[pledge]');")

		return ""

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
/*
	else if(T == "manifest")
		var/list/positions = list()
		var/list/set_names = list(
				"heads" = command_positions,
				"sec" = security_positions,
				"eng" = engineering_positions,
				"med" = medical_positions,
				"sci" = science_positions,
				"car" = cargo_positions,
				"civ" = civilian_positions,
				"bot" = nonhuman_positions
			)

		for(var/datum/data/record/t in data_core.general)
			var/name = t.fields["name"]
			var/rank = t.fields["rank"]
			var/real_rank = make_list_rank(t.fields["real_rank"])

			var/department = 0
			for(var/k in set_names)
				if(real_rank in set_names[k])
					if(!positions[k])
						positions[k] = list()
					positions[k][name] = rank
					department = 1
			if(!department)
				if(!positions["misc"])
					positions["misc"] = list()
				positions["misc"][name] = rank

		for(var/k in positions)
			positions[k] = list2params(positions[k]) // converts positions["heads"] = list("Bob"="Captain", "Bill"="CMO") into positions["heads"] = "Bob=Captain&Bill=CMO"

		return list2params(positions)*/
/*
	else if(T == "revision")
		if(revdata.revision)
			return list2params(list(branch = revdata.branch, date = revdata.date, revision = revdata.revision))
		else
			return "unknown"*/
/*
	else if(copytext(T,1,5) == "info")
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

		var/list/search = params2list(input["info"])
		var/list/ckeysearch = list()
		for(var/text in search)
			ckeysearch += ckey(text)

		var/list/match = list()

		for(var/mob/M in mob_list)
			var/strings = list(M.name, M.ckey)
			if(M.mind)
				strings += M.mind.assigned_role
				strings += M.mind.special_role
			for(var/text in strings)
				if(ckey(text) in ckeysearch)
					match[M] += 10 // an exact match is far better than a partial one
				else
					for(var/searchstr in search)
						if(findtext(text, searchstr))
							match[M] += 1

		var/maxstrength = 0
		for(var/mob/M in match)
			maxstrength = max(match[M], maxstrength)
		for(var/mob/M in match)
			if(match[M] < maxstrength)
				match -= M

		if(!match.len)
			return "No matches"
		else if(match.len == 1)
			var/mob/M = match[1]
			var/info = list()
			info["key"] = M.key
			info["name"] = M.name == M.real_name ? M.name : "[M.name] ([M.real_name])"
			info["role"] = M.mind ? (M.mind.assigned_role ? M.mind.assigned_role : "No role") : "No mind"
			var/turf/MT = get_turf(M)
			info["loc"] = M.loc ? "[M.loc]" : "null"
			info["turf"] = MT ? "[MT] @ [MT.x], [MT.y], [MT.z]" : "null"
			info["area"] = MT ? "[MT.loc]" : "null"
			info["antag"] = M.mind ? (M.mind.special_role ? M.mind.special_role : "Not antag") : "No mind"
			info["hasbeenrev"] = M.mind ? M.mind.has_been_rev : "No mind"
			info["stat"] = M.stat
			info["type"] = M.type
			if(isliving(M))
				var/mob/living/L = M
				info["damage"] = list2params(list(
							oxy = L.getOxyLoss(),
							tox = L.getToxLoss(),
							fire = L.getFireLoss(),
							brute = L.getBruteLoss(),
							clone = L.getCloneLoss(),
							brain = L.getBrainLoss()
						))
			else
				info["damage"] = "non-living"
			info["gender"] = M.gender
			return list2params(info)
		else
			var/list/ret = list()
			for(var/mob/M in match)
				ret[M.key] = M.name
			return list2params(ret)
*/
/*
	else if(copytext(T,1,9) == "adminmsg")
		/*
			We got an adminmsg from IRC bot lets split the input then validate the input.
			expected output:
				1. adminmsg = ckey of person the message is to
				2. msg = contents of message, parems2list requires
				3. validatationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
				4. sender = the ircnick that send the message.
		*/


		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

		var/client/C
		var/req_ckey = ckey(input["adminmsg"])

		for(var/client/K in clients)
			if(K.ckey == req_ckey)
				C = K
				break
		if(!C)
			return "No client with that name on server"

		var/rank = input["rank"]
		if(!rank)
			rank = "Admin"

		var/message =	"<font color='red'>IRC-[rank] PM from <b><a href='?irc_msg=[input["sender"]]'>IRC-[input["sender"]]</a></b>: [input["msg"]]</font>"
		var/amessage =  "<font color='blue'>IRC-[rank] PM from <a href='?irc_msg=[input["sender"]]'>IRC-[input["sender"]]</a> to <b>[key_name(C)]</b> : [input["msg"]]</font>"

		C.received_irc_pm = world.time
		C.irc_admin = input["sender"]

		C << 'sound/effects/adminhelp.ogg'
		C << message


		for(var/client/A in admins)
			if(A != C)
				A << amessage

		return "Message Successful"

	else if(copytext(T,1,6) == "notes")
		/*
			We got a request for notes from the IRC Bot
			expected output:
				1. notes = ckey of person the notes lookup is for
				2. validationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
		*/
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr
			return "Bad Key"

		return show_player_info_irc(ckey(input["notes"]))

	else if(copytext(T,1,4) == "age")
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)
				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr
			return "Bad Key"

		var/age = get_player_age(input["age"])
		if(isnum(age))
			if(age >= 0)
				return "[age]"
			else
				return "Ckey not found"
		else
			return "Database connection failed or not set up"
*/

/world/Reboot(var/reason)

	save_all_whitelists()

	spawn(0)
		roundabout()

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
	// new
	config.load("config/hub.txt", "hub")
	config.load("config/game_schedule.txt", "game_schedule")
	// being phased out
	//config.loadsql("config/dbconfig.txt")
	//config.loadforumsql("config/forumdbconfig.txt")
/*
/hook/startup/proc/loadMods()
	world.load_mods()
	world.load_mentors() // no need to write another hook.
	return 1

/world/proc/load_mods()
	return
/*	if(config.admin_legacy_system)
		var/text = file2text("config/moderators.txt")
		if (!text)
			error("Failed to load config/mods.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Moderator"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(directory[ckey])
*/
/world/proc/load_mentors()
	return
/*	if(config.admin_legacy_system)
		var/text = file2text("config/mentors.txt")
		if (!text)
			error("Failed to load config/mentors.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue
				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Mentor"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(directory[ckey])
*/
*/
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

proc/setup_database_connection()

	if (setting_up_db_connection)
		return

	setting_up_db_connection = 1

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		setting_up_db_connection = 0
		return 0

	if(!database)
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
