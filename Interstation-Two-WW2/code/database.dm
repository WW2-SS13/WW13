var/database/database = null

/database/New(filename)
	..(filename)

	// lets make some tables
	spawn (1)

		// where we store bans
		if (!execute("TABLE erro_ban EXISTS;"))
			execute("CREATE TABLE erro_ban (id NULL, bantime STRING, serverip STRING, bantype STRING, reason STRING, job STRING, duration STRING, rounds STRING, expiration_time INTEGER, ckey STRING, computerid STRING, ip STRING, a_ckey STRING, a_computerid STRING, a_ip STRING , who STRING, adminwho STRING, edits STRING, unbanned STRING, unbanned_datetime STRING, unbanned_ckey STRING, unbanned_computerid STRING, unbanned_ip STRING);")

		// where we store admin data
		if (!execute("TABLE erro_admin EXISTS;"))
			execute("CREATE TABLE erro_admin (id INTEGER, ckey STRING, rank STRING, flags INTEGER);")

		// where we store player data
		if (!execute("TABLE erro_player EXISTS;"))
			execute("CREATE TABLE erro_player (id NULL, ckey STRING, firstseen STRING, lastseen STRING, ip STRING, computerid STRING, lastadminrank STRING);")

		// where we store connection logs
		if (!execute("TABLE erro_connection_log EXISTS;"))
			execute("CREATE TABLE erro_connection_log (id NULL, datetime STRING, serverip STRING, ckey STRING, ip STRING, computerid STRING);")

		// where we store bug reports
		if (!execute("TABLE bug_reports EXISTS;"))
			execute("CREATE TABLE bug_reports (name STRING, desc STRING, steps STRING, other STRING);")

		// where we store suggestions
		if (!execute("TABLE suggestions EXISTS;"))
			execute("CREATE TABLE suggestions (name STRING, desc STRING);")

		// where we store ALL whitelists, including donors
		if (!execute("TABLE whitelists EXISTS;"))
			execute("CREATE TABLE whitelists (key STRING, val STRING);")

		// where we store redeemed donor rewards
		if (!execute("TABLE donor_rewards EXISTS;"))
			execute("CREATE TABLE donor_rewards (user STRING, data STRING);")

/database/proc/Now()
	return world.realtime

/database/proc/After(minutes)
	return world.realtime+(minutes*600)

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