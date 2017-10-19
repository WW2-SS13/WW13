/obj/tank/var/mob/fire_back_seat = null
/obj/tank/var/mob/drive_front_seat = null
/obj/tank/var/accepting_occupant = 0

/obj/tank/proc/front_seat()
	return drive_front_seat

/obj/tank/proc/back_seat()
	return fire_back_seat

/obj/tank/proc/next_seat()
	if (!fire_back_seat && !drive_front_seat)
		return 1
	else if (!fire_back_seat && drive_front_seat)
		return 1
	else if (fire_back_seat && drive_front_seat)
		return 0

/obj/tank/proc/next_seat_name()
	if (!fire_back_seat && !drive_front_seat)
		return "front seat"
	else if (!fire_back_seat && drive_front_seat)
		return "back seat"
	else if (fire_back_seat && drive_front_seat)
		return "what the fuck how did you get here lmao"

/obj/tank/proc/assign_seat(var/mob/user)
	if (!fire_back_seat && !drive_front_seat)
		drive_front_seat = user
	else if (!fire_back_seat && drive_front_seat)
		fire_back_seat  = user
	else if (fire_back_seat && drive_front_seat)
		return 0
	user.loc = src
	user.client.eye = src
	return 1

/obj/tank/proc/forcibly_eject_everyone()
	var/turf/exitturf = get_turf(src)
	switch (dir)
		if (EAST, WEST)
			var/turf/candidate = locate(x, y+1, z)
			if (!candidate)
				candidate = locate(x, y-1, z)
			if (candidate)
				exitturf = candidate
		if (NORTH, SOUTH)
			var/turf/candidate = locate(x-1, y, z)
			if (!candidate)
				candidate = locate(x+1, y, z)
			if (candidate)
				exitturf = candidate

	if (drive_front_seat)
		var/mob/user = drive_front_seat
		user.loc = exitturf
		if (user.client) user.client.eye = user
		drive_front_seat = null

	if (fire_back_seat)
		var/mob/user = fire_back_seat
		user.loc = exitturf
		if (user.client) user.client.eye = user
		fire_back_seat = null

/obj/tank/proc/handle_seat_exit(var/mob/user)

	if (!istype(user))
		return 0

	user << "<span class = 'notice'><big>You start leaving [my_name()].</big></span>"
	if (do_after(user, 30, src))
		var/turf/exitturf = get_turf(src)
		switch (dir)
			if (EAST, WEST)
				var/turf/candidate = locate(x, y+1, z)
				if (!candidate)
					candidate = locate(x, y-1, z)
				if (candidate)
					exitturf = candidate
			if (NORTH, SOUTH)
				var/turf/candidate = locate(x-1, y, z)
				if (!candidate)
					candidate = locate(x+1, y, z)
				if (candidate)
					exitturf = candidate
		user.loc = exitturf
		user.client.eye = user
		user.visible_message("<span class = 'danger'>[user] gets out of [my_name()].</span>", "<span class = 'notice'><big>You get out of [my_name()].<big></span>")
		if (user == drive_front_seat)
			drive_front_seat = null
		if (user == fire_back_seat)
			fire_back_seat = null
	else
		user << "<span class = 'warning'><big>You fail to leave [my_name()].</big></span>"