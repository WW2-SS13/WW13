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
