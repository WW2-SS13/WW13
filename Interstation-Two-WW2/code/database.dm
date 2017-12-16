var/database/database = null

/database/New(filename)
	..(filename)

	// lets make some tables
	spawn (1)

		// where we store bans
		if (!execute("TABLE ban EXISTS;"))
			execute("CREATE TABLE ban (id STRING, bantime STRING, serverip STRING, bantype STRING, reason STRING, job STRING, duration STRING, rounds STRING, expiration_time INTEGER, ckey STRING, computerid STRING, ip STRING, a_ckey STRING, a_computerid STRING, a_ip STRING , who STRING, adminwho STRING, edits STRING, unbanned STRING, unbanned_datetime STRING, unbanned_ckey STRING, unbanned_computerid STRING, unbanned_ip STRING);")

		// where we store admin data
		if (!execute("TABLE admin EXISTS;"))
			execute("CREATE TABLE admin (id STRING, ckey STRING, rank STRING, flags INTEGER);")

		// where we store player data
		if (!execute("TABLE player EXISTS;"))
			execute("CREATE TABLE player (id STRING, ckey STRING, firstseen STRING, lastseen STRING, ip STRING, computerid STRING, lastadminrank STRING);")

		// where we store connection logs
		if (!execute("TABLE connection_log EXISTS;"))
			execute("CREATE TABLE connection_log (id STRING, datetime STRING, serverip STRING, ckey STRING, ip STRING, computerid STRING);")

		// where we store bug reports
		if (!execute("TABLE bug_reports EXISTS;"))
			execute("CREATE TABLE bug_reports (name STRING, desc STRING, steps STRING, other STRING);")

		// where we store suggestions
		if (!execute("TABLE suggestions EXISTS;"))
			execute("CREATE TABLE suggestions (name STRING, desc STRING);")

		// where we store all the whitelists
		if (!execute("TABLE whitelists EXISTS;"))
			execute("CREATE TABLE whitelists (key STRING, val STRING);")

		// where we store raw patreon data
		if (!execute("TABLE patreon EXISTS;"))
			execute("CREATE TABLE patreon (user STRING, pledge STRING);")

		// where we store redeemed patreon rewards
		if (!execute("TABLE patreon_rewards EXISTS;"))
			execute("CREATE TABLE patreon_rewards (user STRING, data STRING);")

/database/proc/Now()
	if (!global_game_schedule)
		global_game_schedule = new
	return global_game_schedule.getNewRealtime()

/database/proc/After(minutes = 1, hours = 0)
	return Now()+(minutes*600)+(hours*600*60)

/database/proc/execute(querytext)
	. = FALSE

	if (findtext(querytext, regex("TABLE.*EXISTS")))
		querytext = replacetext(querytext, " ", "")
		querytext = replacetext(querytext, "TABLE", "")
		querytext = replacetext(querytext, "EXISTS", "")
		return table_exists(querytext)

	else if (findtext(querytext, regex("TABLE.*FILLED")))
		querytext = replacetext(querytext, " ", "")
		querytext = replacetext(querytext, "TABLE", "")
		querytext = replacetext(querytext, "FILLED", "")
		return table_filled(querytext)

	// clean up extra spaces in querytext
	var/empty_space = " " // don't replace single spaces
	for (var/v in 1 to 10)
		empty_space += " " // replaces up to 11 spaces at once
		querytext = replacetext(querytext, empty_space, v)

	// ensure we end with ;
	if (dd_hassuffix(querytext, ";"))
		querytext = copytext(querytext, 1, length(querytext))

	querytext = "[querytext];"

	var/database/query/Q = new(querytext)
	if (Q.Execute(database))
		. = TRUE
		if (findtext(querytext, "SELECT"))

			. = list()
			var/occurences_of = list()

			while (Q.NextRow())
				for (var/x in Q.GetRowData())
					if (!.[x])
						.[x] = Q.GetRowData()[x]
						.["[x]_1"] = .[x]
						occurences_of[x] = 1
					else // handle duplicate values
						var/occ = ++occurences_of[x]
						.["[x]_[occ]"] = Q.GetRowData()[x]
						// let us count how many 'x's there are
					.["occurences_of_[x]"] = occurences_of[x]

			return .

/* handle custom queries TABLE EXISTS and TABLE FILLED */
/proc/table_exists(tablename)
	var/database/query/Q = new("SELECT * FROM [tablename];")
	if (Q.Execute(database))
		return TRUE
	return FALSE

/database/proc/table_filled(tablename)
	if (!table_exists(tablename))
		return FALSE
	var/database/query/Q = new("SELECT * FROM [tablename];")
	if (Q.Execute(database) && Q.NextRow())
		return TRUE
	return FALSE

// patreon rewards

// actual rewards:
#define PATREON_COLOR "patreon_color"
#define PATREON_CHAT "patreon_chat"

#define TEST_SERVER_ACCESS "test_server_access"
#define CUSTOM_DISCORD_ROLE "custom_discord_role"

#define ROLE_PREFERENCE "role_preference"
#define CUSTOM_LOADOUT "custom_loadout"

#define SHORTENED_RESPAWN_TIME "delayed_respawn_time"
#define TEST_ROLE_ELIGIBILITY "rare_role_eligibility"

// tiers: lists of rewards based on donation amounts
#define PLEDGE_TIER_1 list(PATREON_COLOR, PATREON_CHAT)
#define PLEDGE_TIER_2 list(TEST_SERVER_ACCESS, CUSTOM_DISCORD_ROLE)
#define PLEDGE_TIER_3 list(ROLE_PREFERENCE, CUSTOM_LOADOUT)
#define PLEDGE_TIER_4 list(SHORTENED_RESPAWN_TIME, TEST_ROLE_ELIGIBILITY)

/database/proc/get_possible_patreon_rewards(var/client/C)
	. = list()
	var/list/data = execute("SELECT * FROM patreon WHERE user = '[C.patreon_id]'")
	if (!islist(data) || isemptylist(data))
		return .
	var/user = data["user"]
	var/pledge = data["pledge"]

	if (user == C.patreon_id)
		if (pledge >= 3)
			. += PLEDGE_TIER_1
		if (pledge >= 5)
			. += PLEDGE_TIER_2
		if (pledge >= 10)
			. += PLEDGE_TIER_3
		if (pledge >= 20)
			. += PLEDGE_TIER_4

/database/proc/grant_patreon_reward(var/client/C, reward)
	var/list/possible_rewards = get_possible_patreon_rewards(C)
	if (!possible_rewards.Find(reward))
		return
	var/data = execute("SELECT * FROM patreon_rewards WHERE user = '[C.ckey]'")
	if (!findtext(data, reward))
		data += ";[reward]"
	execute("INSERT INTO patreon_rewards data VALUES ('[data]');")
	C.update_patreon_rewards()

/database/proc/remove_patreon_reward(var/client/C, reward)
	var/data = execute("SELECT * FROM patreon_rewards WHERE user = '[C.ckey]'")
	if (findtext(";[data]", reward))
		data = replacetext(data, ";[reward]", "")
	else if (findtext(data, reward))
		data = replacetext(data, reward, "")

	execute("INSERT INTO patreon_rewards data VALUES ('[data]');")
	C.update_patreon_rewards()

/client/var/list/patreon_rewards = list()
/client/var/patreon_id = "not_a_patron"
/client/proc/update_patreon_rewards()
	// get data from database, parse into rewards list