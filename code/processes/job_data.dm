/* the job selection in new_player.dm and helper functions can incur massive overhead that makes them laggy and unresponsive
 * on highpop. This solves that - Kachnov*/

/process/job_data
	var/list/job2players = list()
	var/relevant_clients = -1

/process/job_data/setup()
	name = "job data"
	schedule_interval = 1 SECOND
	start_delay = 0 SECONDS
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING)
	priority = PROCESS_PRIORITY_IRRELEVANT
	always_runs = TRUE // due to the structure of this process, we do the most work on our first tick, so ignore recorded runtimes and always run this
	processes.job_data = src

/process/job_data/fire()

	var/tickcheck = ticks % 10 == 0 // !ticks check removed to prevent this hanging
	var/counted = 0

	for (var/client/C in clients)
		if (world.time >= C.next_calculate_is_active_non_observer)
			if (counted < ceil(clients.len/10) || tickcheck)
				C.calculate_is_active_non_observer()
				++counted
			else
				break

	if (tickcheck)
		calculate_relevant_clients()

/process/job_data/proc/get_active_positions(var/datum/job/J)
	. = 0
	if (!job2players[J.title] || !islist(job2players[J.title]))
		return .
	for (var/mob/M in job2players[J.title])
		if (M.mind && M.client && M.mind.assigned_role == J.title && M.client.inactivity <= 10 * 60 * 10)
			++.

/* client.is_minimized()/winget is extremely expensive and bogs down the entire server when its called hundreds of times.
  this proc is called once for every job in the job window for each player and is a wrapper that makes sure we
  don't do a winget check, for each client, more often than every 2 seconds. About as expensive as
  map.can_start(), which also checks is_minimized() for every client - Kachnov */

/* this is here now so one unlucky player doesn't have to do the calculations for everyone else - Kachnov */
/process/job_data/proc/get_relevant_clients()
	if (relevant_clients == -1)
		calculate_relevant_clients()
	return relevant_clients

/process/job_data/proc/calculate_relevant_clients()
	. = 0
	for (var/client in clients)
		var/client/C = client
		/* sometimes C.is_minimized() can take so long that the client no longer exists by the time it's done
		 * that's why it goes here last - Kachnov */
		if (C.is_active_non_observer)
			++.
	relevant_clients = .

/process/job_data/proc/get_relevant_clients_safe()
	if (relevant_clients != -1)
		return relevant_clients
	return clients.len