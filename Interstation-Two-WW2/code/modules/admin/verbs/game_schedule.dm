/client/proc/open_close_game_schedule()

	set name = "Close World"
	set category = "Test"

	if (!check_rights(R_HOST))
		return

	if (!global_game_schedule)
		return

	var/i = input("Close off the game schedule? Current closed setting is [global_game_schedule.forceClosed].") in list("Yes", "No")
	if (i == "Yes")
		global_game_schedule.forceClose()
		src << "<span class = 'notice'>The world has been closed.</notice>"
	else
		global_game_schedule.unforceClose()
		src << "<span class = 'notice'>The world has been unclosed.</notice>"