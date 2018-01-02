var/list/forbidden_pref_save_varnames = list("client_ckey", "last_id")

/datum/preferences/proc/preferences_exist(var/slot = 1)
	slot = text2num(slot)
	var/list/table = database.execute("SELECT * FROM preferences WHERE ckey = '[client_ckey]' AND slot = '[slot]';")
	if (islist(table) && !isemptylist(table))
		return 1
	return 0

/datum/preferences/proc/get_DB_preference_value(name, slot = 1)
	if (!preferences_exist(slot))
		return ""
	var/table = database.execute("SELECT prefs FROM preferences WHERE ckey = '[client_ckey]' AND slot = '[slot]';")
	var/list/key_val_pairs = splittext(table["prefs"], "&")
	for (var/key_val_pair in key_val_pairs)
		var/keyval_list = splittext(key_val_pair, "=")
		var/key = keyval_list[1]
		var/val = keyval_list[2]
		if (key == name)
			return val

/datum/preferences/proc/load_preferences(var/slot = 1)

	if (text2num(slot) == 0)
		return 0

	slot = num2text(slot)
	if (!client_ckey)
		return 0

	var/list/table = database.execute("SELECT * FROM preferences WHERE ckey = '[client_ckey]' AND slot = '[slot]';")
	if (!islist(table) || isemptylist(table))
		return 0

	if (internal_table.Find(slot))
		var/list/L = internal_table[slot]
		if (L)
			L.Cut()

	var/params = table["prefs"]
	var/list/key_val_pairs = splittext(params, "&")

	for (var/key_val_pair in key_val_pairs)
		var/keyval_list = splittext(key_val_pair, "=")
		var/key = keyval_list[1]
		var/val = keyval_list[2]
		if (key != "clientprefs_enabled" && key != "clientprefs_disabled")
			key_val_pairs -= key_val_pair
			key_val_pairs[key] = val
		else
			switch (key)
				if ("clientprefs_enabled")
					var/list/clientprefs_enabled = splittext(val, ";")
					if (clientprefs_enabled.len) // will return false if new char
						preferences_enabled.Cut()
						for (var/pref in clientprefs_enabled)
							preferences_enabled += pref
				if ("clientprefs_disabled")
					var/list/clientprefs_disabled = splittext(val, ";")
					if (clientprefs_disabled.len)
						preferences_disabled.Cut()
						for (var/pref in clientprefs_disabled)
							preferences_disabled += pref


	for (var/varname in vars)
		if (key_val_pairs.Find(varname))
			if (isnum(vars[varname])) // if the initial var is a num
				vars[varname] = text2num(key_val_pairs[varname])
			else
				vars[varname] = key_val_pairs[varname]
		else // reset to default, getting rid of previous setting
			if (isnum(vars[varname]) || istext(vars[varname]) && !forbidden_pref_save_varnames.Find(varname))
				vars[varname] = initial(vars[varname])

	internal_table[slot] = key_val_pairs
	update_setup()

	for (var/client/C in clients)
		if (C.ckey == client_ckey)
			C.onload_preferences()

	return 1

/datum/preferences/proc/del_preferences(var/slot = 1)
	if (text2num(slot) == 0)
		return 0
	if (database.execute("DELETE FROM preferences WHERE ckey = '[client_ckey]' AND slot = '[slot]';"))
		if (internal_table.Find(slot))
			var/list/L = internal_table[slot]
			if (L)
				L.Cut()
		return 1
	return 0

/datum/preferences/proc/save_preferences(var/slot = 1, var/slot_name = null)

	if (!slot_name)
		slot_name = real_name

	if (text2num(slot) == 0)
		return 0

	if (!knows_preference("real_name"))
		remember_preference("real_name", real_name, 0) // don't save or inf. loop

	slot = num2text(slot)
	if (!client_ckey)
		return 0

	if (!internal_table.Find(slot))
		internal_table[slot] = list()

	var/params = ""
	for (var/key in internal_table[slot])
		if (!vars.Find(key))
			continue
		if (internal_table[slot][key] == initial(vars[key]))
			continue
		if (params != "")
			params += "&"
		params += "[key]=[internal_table[slot][key]]"

	// client_preferences have to be saved separately
	if (preferences_enabled.len)
		if (params)
			params += "&"
		params += "clientprefs_enabled="
		for (var/pref in preferences_enabled)
			if (!pref) continue
			params += pref
			params += ";"

	if (dd_hassuffix(params, ";"))
		params = copytext(params, 1, lentext(params))

	if (preferences_disabled.len)
		if (params)
			params += "&"
		params += "clientprefs_disabled="
		for (var/pref in preferences_disabled)
			if (!pref) continue
			params += pref
			params += ";"

	if (dd_hassuffix(params, ";"))
		params = copytext(params, 1, lentext(params))

	var/list/prefs_exist_check = database.execute("SELECT * FROM preferences WHERE ckey = '[client_ckey]' AND slot = '[slot]';")
	if (islist(prefs_exist_check) && !isemptylist(prefs_exist_check))
		database.execute("UPDATE preferences SET prefs = '[params]' WHERE ckey = '[client_ckey]' AND slot = '[slot]';")
	else
		database.execute("INSERT INTO preferences (ckey, slot, prefs) VALUES ('[client_ckey]', '[slot]', '[params]');")
	return 1

/datum/preferences/proc/knows_preference(pref)
	var/slot = num2text(current_slot)
	if (!internal_table.Find(slot))
		return 0
	var/list/L = internal_table[slot]
	return L.Find(pref)

/datum/preferences/proc/remember_preference(pref, value, var/save = 1)
	if (!vars.Find(pref))
		return 0
	if (value == initial(vars[pref]))
		return 0
	if (forbidden_pref_save_varnames.Find(pref))
		return 0

	var/slot = num2text(current_slot)
	if (!internal_table.Find(slot))
		internal_table[slot] = list()
	internal_table[slot][pref] = value

	if (save)
		save_preferences(current_slot)
	return 1