/* the job selection in new_player.dm and helper functions can incur massive overhead that makes them laggy and unresponsive
 * on highpop. This solves that - Kachnov*/

/process/job_data
	var/list/job2players = list()
	var/relevant_clients = -1

/process/job_data/setup()
	name = "job data"
	schedule_interval = 20 // (re)calculate relevant_clients every 2 seconds
	start_delay = 0
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING)
	priority = PROCESS_PRIORITY_IRRELEVANT
	processes.job_data = src

/process/job_data/fire()
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
		if (C && C.mob && !istype(C.mob, /mob/observer) && !C.is_minimized())
			++.
	relevant_clients = .