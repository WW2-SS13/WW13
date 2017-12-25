/* A new whitelist system that uses SQLite. How this works:
  0. there are two built in whitelists with special behavior, jobs & server
  I. make a whitelist type for what you want to whitelist
  II. make sure the new type has a unique 'name' variable
  III. make a global variable for that whitelist
*/

var/list/global_whitelists[50]

/client/proc/validate_whitelist(name, return_real_val_even_if_whitelist_disabled = 0)
	for (var/_name in global_whitelists)
		if (_name == name)
			var/datum/whitelist/W = global_whitelists[_name]
			if (W.validate(src, return_real_val_even_if_whitelist_disabled))
				return 1
			else
				return 0

	return 1 // didn't find the whitelist? validate them anyway

/proc/save_all_whitelists()
	for (var/key in global_whitelists)
		var/datum/whitelist/W = global_whitelists[key]
		W.save()

/proc/save_whitelist(whatkey)
	for (var/key in global_whitelists)
		if (key == whatkey)
			var/datum/whitelist/W = global_whitelists[key]
			W.save()
			return TRUE
	return FALSE

/datum/whitelist
	var/name = "generic whitelist"
	var/data = ""
	var/enabled = 0
	var/file = ""

// when we're created
/datum/whitelist/New()
	..()
	load()

// load the whitelist from the database
/datum/whitelist/proc/load()
	establish_db_connection()
	if (!database)
		return
	var/list/_data = database.execute("SELECT val FROM whitelists WHERE key = '[name]';")
	if (islist(_data) && !isemptylist(_data))
		data = _data["val"]

// save the whitelist to the database
/datum/whitelist/proc/save()
	establish_db_connection()
	if (!database)
		return
	database.execute("DELETE FROM whitelists WHERE key = '[name]';")
	database.execute("INSERT INTO whitelists (key, val) VALUES ('[name]', '[data]');")

// add a client or ckey to the whitelist
/datum/whitelist/proc/add(_arg, var/list/extras = list())
	if (data)
		data += "&"
	if (isclient(_arg))
		data += _arg:ckey
	else
		data += ckey(_arg) // todo: probably shouldn't do this for other WLs
	for (var/extrafield in extras)
		data += "=[extrafield]"

	cleanup()

// remove a client or ckey from the whitelist
// if the client was in the whitelist, and was removed: return TRUE
// otherwise: return FALSE
/datum/whitelist/proc/remove(_arg)
	. = FALSE
	var/list/datalist = splittext(data, "&")
	if (isclient(_arg))
		var/client/C = _arg
		for (var/ckey in datalist)
			if (ckey == C.ckey)
				datalist -= ckey
				. = TRUE
				break
	else if (istext(_arg))
		_arg = ckey(_arg)
		for (var/ckey in datalist)
			if (ckey == _arg)
				datalist -= _arg
				. = TRUE
				break
	data = list2params(datalist)
	cleanup()

// check if a client or ckey is in the whitelist
/datum/whitelist/proc/validate(_arg, return_real_val_even_if_whitelist_disabled = 0)
	if (!enabled && !return_real_val_even_if_whitelist_disabled)
		return 1
	var/list/datalist = splittext(data, "&")
	if (isclient(_arg))
		var/client/C = _arg
		for (var/ckey in datalist)
			if (ckey == C.ckey)
				return 1
	else if (istext(_arg))
		_arg = ckey(_arg)
		for (var/ckey in datalist)
			if (ckey == _arg)
				return 1
	return 0

/datum/whitelist/proc/cleanup()
	// clean up our data. Sometimes we get stuff like multiple '&&'
	// since ckeys can't contain '&', there's no harm in deleting those
	data = replacetext(data, "&&&&", "&")
	data = replacetext(data, "&&&", "&")
	data = replacetext(data, "&&", "&")

// subtypes

/datum/whitelist/server
	name = "server"
/datum/whitelist/server/New()
	..()
	if (config.usewhitelist)
		enabled = 1

/datum/whitelist/teststaff
	name = "teststaff"
/datum/whitelist/teststaff/New()
	..()
	if (config.allow_testing_staff)
		enabled = 1