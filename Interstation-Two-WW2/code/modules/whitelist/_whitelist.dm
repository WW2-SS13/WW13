/* A new whitelist system that uses SQLite. How this works:
  0. there are two built in whitelists with special behavior, jobs & server
  I. make a whitelist type for what you want to whitelist
  II. make sure the new type has a unique 'name' variable
  III. make a global variable for that whitelist
*/

var/list/global_whitelists[50]

/client/proc/validate_whitelist(name)
	for (var/_name in global_whitelists)
		if (_name == name)
			var/datum/whitelist/W = global_whitelists[_name]
			if (W.validate(src))
				return 1
			else
				return 0

	return 1 // didn't find the whitelist? validate them anyway

/datum/whitelist
	var/name = "generic whitelist"
	var/data = ""
	var/enabled = 0
	var/file = ""

// when we're created
/datum/whitelist/New()
	..()
	spawn (50)
		load()

// load the whitelist from the database
/datum/whitelist/proc/load()
	establish_db_connection()
	if (!database)
		return
	var/list/_data = database.execute("SELECT val FROM whitelists WHERE name = '[name]';")
	if (islist(_data) && !isemptylist(_data))
		data = _data["val"]

// save the whitelist to the database
/datum/whitelist/proc/save()
	establish_db_connection()
	if (!database)
		return
	database.execute("DELETE FROM whitelists WHERE name = '[name]';")
	database.execute("INSERT INTO whitelists (key, val) VALUES ('[name]', '[data]');")

// add a client or ckey to the whitelist
/datum/whitelist/proc/add(_arg, var/list/extras = list())
	if (data)
		data += "&"
		if (isclient(_arg))
			data += _arg:ckey
		else
			data += ckey(_arg)
		for (var/extrafield in extras)
			data += "=[extrafield]"

// remove a client or ckey from the whitelist
/datum/whitelist/proc/remove(_arg)
	var/list/datalist = splittext(data, "&")
	if (isclient(_arg))
		var/client/C = _arg
		for (var/datum in datalist)
			if (findtext(datum, C.ckey))
				datalist -= datum
				break
	else if (istext(_arg))
		var/ckey = ckey(_arg)
		for (var/datum in datalist)
			if (findtext(datum, ckey))
				datalist -= datum
				break
	data = list2params(datalist)

// check if a client or ckey is in the whitelist
/datum/whitelist/proc/validate(_arg)
	if (!enabled)
		return 1
	var/list/datalist = splittext(data, "&")
	if (isclient(_arg))
		var/client/C = _arg
		for (var/datum in datalist)
			if (findtext(datum, C.ckey))
				return 1
	else if (istext(_arg))
		var/ckey = ckey(_arg)
		for (var/datum in datalist)
			if (findtext(datum, ckey))
				return 1
	return 0

/datum/whitelist/server
	name = "server"

