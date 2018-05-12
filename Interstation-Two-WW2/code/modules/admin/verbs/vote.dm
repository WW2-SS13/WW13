/client/proc/start_mapswap_vote()
	set category = "Server"
	set name = "Start Map Vote"
	if (!check_rights(R_PERMISSIONS))
		return
	if (mapswap_process && mapswap_process.may_fire())
		mapswap_process.admin_triggered = TRUE
		mapswap_process.ready = TRUE
		log_admin("[key_name(usr)] triggered a map vote.")
		message_admins("[key_name(usr)] triggered a map vote.")
	else
		src << "<span class = 'notice'>There is no mapswap_process datum, or it is not ready.</span>"