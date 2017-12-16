/client/proc/change_time_of_day()
	set category = "WW2 (Admin)"
	set name = "Change Time of Day"
	if(!check_rights(R_ADMIN))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return
	src << "<span class = 'warning'>Updating lights, please wait...</span>"
	progress_time_of_day(caller = src)
