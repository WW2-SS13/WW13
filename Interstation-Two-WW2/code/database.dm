var/database/database = null

/database/New(filename)
	..(filename)

	// lets make some tables
	spawn (1)

		/* WW13 has 11 tables. ALL data should be stored in one of these tables,
	     * It is fine to make new tables - Kachnov */

		if (!execute("TABLE misc EXISTS;"))
			execute("CREATE TABLE misc (key STRING, val STRING);")

		if (!execute("TABLE preferences EXISTS;"))
			execute("CREATE TABLE preferences (ckey STRING, slot STRING, prefs STRING)")

		if (!execute("TABLE quick_bans EXISTS;"))
			execute("CREATE TABLE quick_bans (ckey STRING, cID STRING, ip STRING, type STRING, type_specific_info STRING, UID STRING, reason STRING, banned_by STRING, ban_date STRING, expire_realtime STRING, expire_info STRING);")

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

		// TODO: simple patreon table (user, pledge, metadata) to replace
		// these two patreon tables. Why? Because we probably won't have
		// specific rewards, we don't need a rewards table. But, the metadata
		// table will be there in case we do need to store more specific reward
		// info. Otherwise, for example, for the $3 reward, we simply check
		// if they're a $3 patron (client.isPatron("$3")), and if they are,
		// give them the OOC color pref. If they're a $5 patreon, when they
		// try to submit tips, ditto. $10 patreon, let them bypass whitelist
		// with the same check - Kachnov

		// where we store raw patreon data
		if (!execute("TABLE patreon EXISTS;"))
			execute("CREATE TABLE patreon (user STRING, pledge STRING);")

		// where we store player tip input
		if (!execute("TABLE player_tips EXISTS;"))
			execute("CREATE TABLE player_tips (UID STRING, submitter STRING, tip STRING);")

/database/proc/newUID()
	return num2text(rand(1, 1000*1000*1000), 20)

/database/proc/Now()
	if (!global_game_schedule)
		global_game_schedule = new
	return global_game_schedule.getNewRealtime()

/database/proc/After(minutes = TRUE, hours = FALSE)
	return Now()+(minutes*600)+(hours*600*60)

/* only_execute_once = FALSE is only safe when this is called from a verb
 * or proc behaving like a verb, otherwise it can bog down other procs */
/database/proc/execute(querytext, var/only_execute_once = TRUE)
	. = FALSE

	// fixes a common SQL typo
	querytext = replacetext(querytext, " == ", " = ")

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
	for (var/v in TRUE to 10)
		empty_space += " " // replaces up to 11 spaces at once
		querytext = replacetext(querytext, empty_space, v)

	// ensure we end with ;
	if (dd_hassuffix(querytext, ";"))
		querytext = copytext(querytext, TRUE, length(querytext))

	querytext = "[querytext];"

	var/database/query/Q = new(querytext)

	// try to execute 10 times over 5 seconds
	var/Q_executed = FALSE
	for (var/v in TRUE to 10)
		if (Q.Execute(src))
			Q_executed = TRUE
			goto finishloop
		if (only_execute_once)
			goto finishloop
		sleep(5)

	finishloop
	if (Q_executed)
		. = TRUE
		if (findtext(querytext, "SELECT"))

			. = list()
			var/occurences_of = list()

			while (Q.NextRow())
				for (var/x in Q.GetRowData())
					if (!.[x])
						.[x] = Q.GetRowData()[x]
						.["[x]_1"] = .[x]
						occurences_of[x] = TRUE
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