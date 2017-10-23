/client/verb/reportabug()
	set hidden = 1

	establish_db_connection()

	rename

	var/bugname = input("What is a name for this bug?") as text
	if (lentext(bugname) > 50)
		bugname = copytext(bugname, 1, 51)
		src << "<span class = 'warning'>Your bug's name was clamped to 50 characters.</span>"

	if (!bugname)
		src << "<span class = 'warning'>Please put something in the name field.</span>"
		goto rename

	var/check_name_already_exists = database.execute("SELECT * FROM bug_reports WHERE name = '[bugname]';")
	if (islist(check_name_already_exists) && !isemptylist(check_name_already_exists))
		src << "<span class = 'danger'>This bug already exists! Please choose another name.</span>"
		goto rename

	bugname = sanitizeSQL(bugname)

	redesc

	var/bugdesc = input("What is the bug's description?") as text
	if (lentext(bugdesc) > 500)
		bugdesc = copytext(bugdesc, 1, 501)
		src << "<span class = 'warning'>Your bug's description was clamped to 500 characters.</span>"

	if (!bugdesc)
		src << "<span class = 'warning'>Please put something in the description field.</span>"
		goto redesc

	bugdesc = sanitizeSQL(bugdesc)

	var/list/steps = list()
	var/bugrep = input("Does the bug have any special steps in order to recreate it?") in list("Yes", "No")
	if (bugrep == "Yes")
		var/stepnum = steps.len+1
		while ((input("Add another step? (#[stepnum])") in list ("Yes", "No")) == "Yes")
			var/step = input("What is a description of step number #[stepnum]?") as text
			step = sanitizeSQL(step)
			if (lentext(step) > 200)
				step = copytext(step, 1, 201)
				src << "<span class = 'warning'>[step] #[stepnum] was clamped to 200 characters.</span>"
			steps += step
			if (stepnum == 10)
				src << "<span class = 'warning'>Max number of steps (#[stepnum]) reached.</span>"
				break
			else
				stepnum = steps.len+1

	var/steps2string = ""
	for (var/_step in steps)
		steps2string += _step
		if (_step != steps[steps.len])
			steps2string += "&"

	reelse

	var/anything_else = input("Anything else?") as text
	if (lentext(anything_else) > 1000)
		bugdesc = copytext(anything_else, 1, 1001)
		src << "<span class = 'warning'>Your bug's 'anything else' value was clamped to 1000 characters.</span>"

	if (!anything_else)
		src << "<span class = 'warning'>Please put something in the anything else field.</span>"
		goto reelse

	anything_else = sanitizeSQL(anything_else)

	anything_else += "<br><i>Reported by [src], who was, at the time, [key_name(src)]</i>"

	if (bugname && bugdesc && bugrep && anything_else)
		if (database)
			if (database.execute("INSERT INTO bug_reports (name, desc, steps, other) VALUES ('[bugname]', '[bugdesc]', '[steps2string]', '[anything_else]');"))
				src << "<span class = 'notice'>Your bug was successfully reported. Thank you!</span>"
				message_admins("New bug report received from [key_name(src)], titled '[bugname]'.")
			else
				src << "<span class = 'warning'>A database error occured; your bug was NOT reported.</span>"
		else
			src << "<span class = 'warning'>A database error occured; your bug was NOT reported.</span>"
	else
		src << "<span class = 'warning'>Please fill in all fields!</span>"

/client/verb/makeasugg()
	set hidden = 1

	establish_db_connection()

	rename

	var/suggname = input("What is a name for this suggestion?") as text
	if (lentext(suggname) > 50)
		suggname = copytext(suggname, 1, 51)
		src << "<span class = 'warning'>Your suggestion's name was clamped to 50 characters.</span>"

	if (!suggname)
		src << "<span class = 'warning'>Please put something in the name field.</span>"
		goto rename

	var/check_name_already_exists = database.execute("SELECT * FROM suggestions WHERE name = '[suggname]';")
	if (islist(check_name_already_exists) && !isemptylist(check_name_already_exists))
		src << "<span class = 'danger'>This suggestion already exists! Please choose another name.</span>"
		goto rename

	suggname = sanitizeSQL(suggname)

	redesc

	var/suggdesc = input("What is the suggestions's description?") as text
	if (lentext(suggdesc) > 500)
		suggdesc = copytext(suggdesc, 1, 501)
		src << "<span class = 'warning'>Your suggestion's description was clamped to 500 characters.</span>"

	if (!suggdesc)
		src << "<span class = 'warning'>Please put something in the description field.</span>"
		goto redesc

	suggdesc = sanitizeSQL(suggdesc)

	suggdesc += "<br><i>Suggested by [src], who was, at the time, [key_name(src)]</i>"

	if (suggname && suggdesc)
		if (database)
			if (database.execute("INSERT INTO suggestions (name, desc) VALUES ('[suggname]', '[suggdesc]');"))
				src << "<span class = 'notice'>Your suggestion was successfully received. Thank you!</span>"
				message_admins("New suggestion received from [key_name(src)], titled '[suggname]'.")
			else
				src << "<span class = 'warning'>A database error occured; your suggestion was NOT sent.</span>"
		else
			src << "<span class = 'warning'>A database error occured; your suggestion was NOT sent.</span>"
	else
		src << "<span class = 'warning'>Please fill in all fields!</span>"
