// ported from /tg/station - Kachnov
var/datum/controller/process/ping_track/ping_track = null

/datum/controller/process/ping_track
	var/list/my_clients = null
	var/avg = 0

/datum/controller/process/ping_track/setup()
	name = "Ping Tracking"
	schedule_interval = 5

	if (!ping_track)
		ping_track = src

/datum/controller/process/ping_track/doWork()
	if (!my_clients)
		my_clients = clients.Copy()

	avg = 0

	if (!my_clients.len)
		return // dividing by 0 is bad

	var/clients_checked = 0

	while (my_clients.len)
		var/client/C = my_clients[my_clients.len]
		--my_clients.len
		if (!C)
			continue
		if (!hascall(C, "update_ping"))
			continue
		winset(C, null, "command=.update_ping+[world.time+world.tick_lag*world.tick_usage/100]")
		avg += C.last_ping
		++clients_checked

	avg /= clients_checked

	my_clients = null