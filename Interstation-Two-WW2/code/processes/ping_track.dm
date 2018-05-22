// ported from /tg/station - Kachnov
/process/ping_track
	var/list/my_clients = null
	var/avg = 0
	var/client_ckey_check[1000]

/process/ping_track/setup()
	name = "Ping Tracking"
	schedule_interval = 5
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	processes.ping_track = src

/process/ping_track/fire()
	SCHECK
	my_clients = clients.Copy()
	if (!my_clients.len)
		return // dividing by 0 is bad

	avg = 0

	var/clients_checked = 0

	while (my_clients.len)

		var/client/C = my_clients[my_clients.len]
		--my_clients.len

		if (!C)
			continue

		// this nasty code if else block fixes the "Unrecognized or inaccessible verb: .update_ping" error - Kachnov
		if (!hascall(C, ".update_ping")) // BYOND treats "update_ping" and ".update_ping" the same here, for reference
			continue
		if (!client_ckey_check[C.ckey])
			client_ckey_check[C.ckey] = world.time+50
			continue
		if (world.time < client_ckey_check[C.ckey])
			continue
		winset(C, null, "command=.update_ping+[world.time+world.tick_lag*world.tick_usage/100]")
		avg += C.last_ping
		++clients_checked

		SCHECK

	if (clients_checked)
		avg /= clients_checked

	my_clients = null