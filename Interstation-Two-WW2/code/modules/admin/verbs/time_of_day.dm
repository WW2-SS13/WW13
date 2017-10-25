/client/proc/recreate_lighting()
	set category = "Debug"
	set name = "Experimentally Recreate Lighting"
	if(!check_rights(R_DEBUG))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return
	src << "<span class = 'warning'>Updating lights..</span>"
	update_lighting()
	src << "<span class = 'warning'>Updating lights for [time_of_day]</span>"