/* A simpler and more flexible code for banning, designed for SQLite. Its
 * not nearly as fancy as old banning, and it wasn't worth making an interface
 * for this rather small amount of code, so its all done via BYOND's input() */

/* this is a WIP, currently only server bans are supported */
var/list/ban_types = list("Job Ban", "Faction Ban", "Officer Ban", "Server Ban", "Observe Ban", "Playing Ban")

/* admin procedures */
/client/proc/quickBan_search()
	set category = "Bans"

	var/option = input(src, "Search for a ban?") in list("Yes", "No")
	if (option == "No")
		return

	var/_ckey = input(src, "What ckey will you search for? (optional)") as text
	var/cID = input(src, "What cID will you search for? (optional)") as text
	var/ip = input(src, "What address will you search for? (optional)") as text
	var/ban_type = input(src, "What type of ban do you want to search for?") in ban_types + "All"

	var/html = "<center><big>List of Quick Bans</big></center>"

	var/list/possibilities = list()
	if (ban_type == "All")
		database.execute("SELECT * FROM quick_bans WHERE ckey == '[_ckey]' or cID == '[cID]' or ip == '[ip]'", FALSE)
	else
		database.execute("SELECT * FROM quick_bans WHERE ckey == '[_ckey]' or cID == '[cID]' or ip == '[ip]' or ban_type == '[ban_type]'", FALSE)

	if (islist(possibilities) && !isemptylist(possibilities))
		for (var/table in possibilities)
			if (table["type"] == ban_type)
				if (text2num(table["expiration_realtime"]) > world.realtime)
					database.execute("REMOVE * FROM quick_bans WHERE UID == '[table["UID"]]';")
					continue
				possibilities += "[table["UID"]]: [table["ckey"]]/[table["cID"]]/[table["ip"]], type [table["type"]] ([table["type_specific_info"]]): banned for '[table["reason"]]' by [table["banned_by"]] on [table["ban_date"]]. [table["expire_info"]]."

	for (var/possibility in possibilities)
		html += "<br>"
		html += possibility

	src << browse(html, "window=quick_bans_search;")
	// todo

/client/proc/quickBan_person()
	set category = "Bans"

	var/option = input(src, "Do you wish to ban by client or by manual input? (Necessary to ban an offline client)") in list("Client", "Manual Input", "Cancel")
	if (option == "Cancel")
		return

	var/fields[4]

	if (option == "Manual Input")
		fields["ckey"] = input(src, "What is the person's ckey? (optional)") as text
		fields["cID"] = input(src, "What is the person's cID? (optional)") as text
		fields["ip"] = input(src, "What is the person's IP? (optional)") as text
	else if (option == "Client")
		var/client/C = input(src, "Which client?") in clients
		fields["ckey"] = C.ckey
		fields["cID"] = C.computer_id
		fields["ip"] = C.address

	fields["type"] = input(src, "What type of ban will this be?") in list(ban_types)
	fields["type"] = replacetext(fields["type"], " Ban", "")

	switch (fields["type"])
		if ("Job")
			var/list/possibilities = job_master.occupations
			var/datum/job/J = input("What job?") in possibilities
			fields["type_specific_info"] = J.title
		if ("Faction")
			var/faction = input("What faction?") in list(GERMAN, RUSSIAN, ITALIAN, UKRAINIAN, SCHUTZSTAFFEL, PARTISAN, CIVILIAN)
			fields["type_specific_info"] = faction

	reenter_bantime

	var/duration_in_x_units = input(src, "How long do you want the ban to last ('5 hours', '4 days': the default unit is days)") as text
	var/duration_in_days = text2num(ckey(splittext(duration_in_x_units, " ")[1]))

	if (findtext(duration_in_x_units, "year"))
		duration_in_days *= 365
	else if (findtext(duration_in_x_units, "month"))
		duration_in_days *= 30
	else if (findtext(duration_in_x_units, "week"))
		duration_in_days *= 7
	else if (findtext(duration_in_x_units, "hour"))
		duration_in_days /= 24
	else if (findtext(duration_in_x_units, "minute"))
		duration_in_days /= 1440
	else if (findtext(duration_in_x_units, "second"))
		duration_in_days /= 86400

	if (!isnum(duration_in_days))
		src << "<span class = 'warning'>Invalid unit.</span>"
		goto reenter_bantime

	var/duration_in_deciseconds = duration_in_days * 86400 * 10
	fields["expire_realtime"] = world.realtime + duration_in_deciseconds

	switch (duration_in_days)
		if (0 to 0.99) // count in hours
			fields["expiration_info"] = "Expires in [duration_in_days*24] hour(s)"
		if (0.99 to 6.99) // count in days
			fields["expiration_info"] = "Expires in [duration_in_days] day(s)"
		if (6.99 to 29.99) // count in weeks
			fields["expiration_info"] = "Expires in [duration_in_days/7] week(s)"
		if (29.99 to 364.99) // count in months
			fields["expiration_info"] = "Expires in [duration_in_days/30] month(s)"
		if (364.99 to INFINITY) // count in years
			fields["expiration_info"] = "Expires in [duration_in_days/365] years(ss"

	if (global_game_schedule)
		fields["ban_date"] = global_game_schedule.getDateInfoAsString()

	quickBan_sanitize_fields(fields)
	quickBan_ban(fields, src)

/* helpers */
/proc/quickBan_sanitize_fields(var/list/fields)
	if (!fields.Find("ckey"))
		fields["ckey"] = "nil"
	if (!fields.Find("cID"))
		fields["cID"] = "nil"
	if (!fields.Find("ip"))
		fields["ip"] = "nil"
	if (!fields.Find("type"))
		fields["type"] = "nil"
	if (!fields.Find("type_specific_info"))
		fields["type_specific_info"] = "nil"
	if (!fields.Find("UID"))
		fields["UID"] = database.newUID()
	if (!fields.Find("reason"))
		fields["reason"] = "nil"
	if (!fields.Find("banned_by"))
		fields["banned_by"] = "nil"
	if (!fields.Find("ban_date"))
		fields["ban_date"] = "nil"
	if (!fields.Find("expire_realtime"))
		fields["expire_realtime"] = "nil"
	if (!fields.Find("expire_info"))
		fields["expire_info"] = "nil"

	// sanitize user input
	for (var/x in fields)
		if (x == "ckey" || x == "cID" || x == "ip")
			fields[x] = sanitizeSQL(fields[x], 50)
		else if (x == "reason")
			fields[x] = sanitizeSQL(fields[x], 150)

/* the actual banning procedure */
/proc/quickBan_ban(var/list/fields, var/client/banner)
	var/ckey = fields["ckey"]
	var/cID = fields["cID"]
	var/ip = fields["ip"]
	var/expire_info = fields["expire_info"]

	if (database.execute("INSERT INTO quick_bans (ckey, cID, ip, type, UID, reason, banned_by, ban_date, expire_realtime, expire_info) VALUES ('[fields["ckey"]]', '[fields["cID"]]', '[fields["ip"]]', '[fields["type"]]', '[fields["type_specific_info"]]', '[fields["UID"]]', '[fields["reason"]]', '[fields["banned_by"]]', '[fields["ban_date"]]', '[fields["expire_realtime"]]', '[fields["expire_info"]]'');"))
		if (banner)
			banner << "<span class = 'notice'>You have successfully banned [ckey]/[cID]/[ip]. This ban [lowertext(expire_info)]."
		var/M = "[key_name(banner)] banned [ckey]/[cID]/[ip]. This ban [lowertext(expire_info)]."
		log_admin(M)
		message_admins(M)
	else
		banner << "<span class = 'warning'>FAILED to ban [ckey]/[cID]/[ip]!</span>"

/* checking if we're banned & rejecting us */
/client/proc/quickBan_isbanned(var/ban_type = "Server", var/type_specific_info = "nil")
	var/list/bans = database.execute("SELECT * FROM quick_bans WHERE ckey == '[ckey]' or cID == '[computer_id]' or ip == '[address]'", FALSE)
	if (islist(bans) && !isemptylist(bans))
		for (var/table in bans)
			if (table["type"] == ban_type && table["type_specific_info"] == type_specific_info)
				if (text2num(table["expiration_realtime"]) > world.realtime)
					database.execute("REMOVE * FROM quick_bans WHERE UID == '[table["UID"]]';")
					continue
				return table["reason"]
	return FALSE

/* check if we're banned and tell us why we're banned */
/client/proc/quickBan_reject(var/ban_type = "Server", var/type_specific_info = "nil")
	var/banreason = quickBan_isbanned(ban_type, type_specific_info)
	if (banreason)
		src << "<span class = 'danger'>You're banned: '[banreason]'</span>"
		return TRUE
	return FALSE