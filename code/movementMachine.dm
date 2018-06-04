#define SECONDS *10
var/movementMachine/movementMachine = null

/movementMachine
	var/interval = 0.015 SECONDS // half as long as the fastest ghost movement delay, so ghost movement is smoother
	var/ticks = 0
	var/last_run = -1

/movementMachine/New()
	..()
	if (movementMachine && movementMachine != src)
		del(src)
		return FALSE
	return TRUE

/movementMachine/proc/start()
	spawn (0)
		process()

/movementMachine/proc/process()

	while (TRUE)

		for (var/client in movementMachine_clients)

			if (client && !isDeleted(client))

				var/mob/M = client:mob

				if (!isDeleted(M))
					try
						if (M.client.canmove && !M.client.moving && world.time >= M.client.move_delay && (M.movement_eastwest || M.movement_northsouth))
							var/diag = FALSE
							var/list/movement_process_dirs = list()
							if (M.movement_eastwest)
								movement_process_dirs += M.movement_eastwest
							if (M.movement_northsouth)
								movement_process_dirs += M.movement_northsouth
							var/movedir = movement_process_dirs[movement_process_dirs.len]
							if (movement_process_dirs.len > 1 && !istank(M.loc))
								if (movement_process_dirs.Find(NORTH) && movement_process_dirs.Find(WEST))
									movedir = NORTHWEST
									diag = TRUE
								else if (movement_process_dirs.Find(NORTH) && movement_process_dirs.Find(EAST))
									movedir = NORTHEAST
									diag = TRUE
								else if (movement_process_dirs.Find(SOUTH) && movement_process_dirs.Find(WEST))
									movedir = SOUTHWEST
									diag = TRUE
								else if (movement_process_dirs.Find(SOUTH) && movement_process_dirs.Find(EAST))
									movedir = SOUTHEAST
									diag = TRUE
							M.client.Move(get_step(M, movedir), movedir, diag)
					catch(var/exception/e)
						pass(e)
				else
					mob_list -= M

		++ticks
		last_run = world.time
		sleep(interval)
#undef SECONDS