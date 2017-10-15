// todo: browser interface for browsing bug reports

/*/client/proc/see_bug_reports()
	establish_db_connection()

	if (database)
		var/list/bugreports = database.execute("SELECT * FROM bug_reports;")
		if (islist(bugreports) && !isemptylist(bugreports))

	else
		src << "<span class = 'warning'>A database error occured; your bug was NOT reported.</span>"
*/