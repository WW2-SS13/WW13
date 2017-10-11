var/database/database = null

/database/New(filename)
	..(filename)

	spawn (1)
		// create our tables now
		if (!execute("TABLE erro_ban EXISTS"))
			execute("CREATE TABLE erro_ban (id NULL, bantime STRING, serverip STRING, bantype STRING, reason STRING, job STRING, duration STRING, rounds STRING, expiration_time STRING, ckey STRING, computerid STRING, ip STRING, a_ckey STRING, a_computerid STRING, a_ip STRING , who STRING, adminwho STRING, edits STRING, unbanned STRING, unbanned_datetime STRING, unbanned_ckey STRING, unbanned_computerid STRING, unbanned_ip STRING);")

		if (!execute("TABLE erro_admin EXISTS"))
			execute("CREATE TABLE erro_admin (id INTEGER, ckey STRING, rank STRING, flags INTEGER);")

		if (!execute("TABLE erro_player EXISTS"))
			execute("CREATE TABLE erro_player (id NULL, ckey STRING, firstseen STRING, lastseen STRING, ip STRING, computerid STRING, lastadminrank STRING);")

		if (!execute("TABLE erro_connection_log EXISTS"))
			execute("CREATE TABLE erro_connection_log (id NULL, datetime STRING, serverip STRING, ckey STRING, ip STRING, computerid STRING);")

/database/proc/Now(var/num = 0)
	if (!num)
		return "[world.realtime]"
	return world.realtime

/database/proc/After(minutes)
	return "[world.realtime+(minutes*600)]"

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
					else // handle duplicate values
						if (!occurences_of[x])
							occurences_of[x] = 1
						var/occ = ++occurences_of[x]
						.["[x]_[occ]"] = Q.GetRowData()[x]
						// let us count how many 'x's there are
						.["occurences_of_[x]"] = occ

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