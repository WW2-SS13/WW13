/client/proc/give_patreon_rewards()
	set category = "Test"
	set name = "Give Patreon Rewards"
	if(!check_rights(R_HOST)) return
	var/_ckey = input(src, "What ckey?") as text
	if (!_ckey)
		return
	var/pledge = input(src, "What pledge amount?") in list("$3+", "$5+", "$10+")
	_ckey = sanitizeSQL(_ckey, 50)
	if (database.execute("INSERT INTO patreon (user, pledge) VALUES ('[_ckey]', '[pledge]');"))
		src << "<span class = 'good'>Successfully added '[_ckey]' as a [pledge] Patron."
		var/M = "[key_name(src)] added '[_ckey]' as a [pledge] Patron."
		log_admin(M)
		message_admins(M)
	else
		src << "<span class = 'danger'>A database error occured.</span>"
	remove_patreon_table_extras(_ckey)

/* keeps the patreon table small by removing any unecessary data. A person
 * who donated $10 gets $5 and $3 benefits too, so we don't need to store those,
 * and likewise, a person who donated $5 gets $3 benefits which are superfluous */

/proc/remove_patreon_table_extras(var/ckey)

	// we have $10, meaning we don't need $5 and $3
	var/list/_10check = database.execute("SELECT * FROM patreon WHERE ckey = '[ckey]' AND pledge = '$10+';")
	if (islist(_10check) && !isemptylist(_10check))
		database.execute("DELETE FROM patreon WHERE ckey = '[ckey]' AND pledge = '$5+';")
		database.execute("DELETE FROM patreon WHERE ckey = '[ckey]' AND pledge = '$3+';")

	// we have $5, meaning we don't need $3
	var/list/_5check = database.execute("SELECT * FROM patreon WHERE ckey = '[ckey]' AND pledge = '$5+';")
	if (islist(_5check) && !isemptylist(_5check))
		database.execute("DELETE FROM patreon WHERE ckey = '[ckey]' AND pledge = '$3+';")
