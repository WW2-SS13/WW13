// todo: browser interface for browsing bug reports

/client/proc/see_bug_reports()
	establish_db_connection()

	if (database)
		var/list/bugreports = database.execute("SELECT * FROM bug_reports;")
		var/list/bugreport_names = list()
		if (islist(bugreports) && !isemptylist(bugreports))
			for (var/v in 1 to bugreports["occurences_of_name"])
				bugreport_names += bugreports["name_[v]"]
		else
			src << "<span class = 'danger'>There are no open bug reports right now.</span>"
			return
		var/bugreport = input("Please select a bug report to work with.") in bugreport_names
		if (!bugreport)
			src << "<span class = 'warning'>No bug report selected; cancelling proc.</span>"
			return
		else
			var/option = input("Please select an option for bugreport '[bugreport]'.") in list("View", "Delete", "Cancel")
			switch (lowertext(option))
				if ("view")
					for (var/key in bugreports)
						var/value = bugreports[key]
						src << "<span class = 'notice'><big>[bugreport]</big></span>"
						src << "<span class = 'notice'>[key] = [value]</span>"
				if ("delete")
					if (database.execute("DELETE * FROM bug_reports WHERE name = '[bugreport]';"))
						src << "<span class = 'notice'>Bug report '[bugreport]' successfully deleted.</span>"
					else
						src << "<span class = 'warning'>A database error occured; bugreport '[bugreport]' was not deleted.</span>"
				if ("cancel")
					return
	else
		src << "<span class = 'danger'>A database error occured; you cannot see bug reports right now.</span>"