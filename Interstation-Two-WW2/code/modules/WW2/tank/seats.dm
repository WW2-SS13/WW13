/obj/tank/var/mob/living/carbon/human/fire_back_seat = null
/obj/tank/var/mob/living/carbon/human/drive_front_seat = null
/obj/tank/var/accepting_occupant = FALSE

/obj/tank/proc/front_seat()
	return drive_front_seat

/obj/tank/proc/back_seat()
	return fire_back_seat

/obj/tank/proc/next_seat()
	if (!fire_back_seat && !drive_front_seat)
		return TRUE
	else if (!fire_back_seat && drive_front_seat)
		return TRUE
	else if (!drive_front_seat && fire_back_seat)
		return TRUE
	else if (fire_back_seat && drive_front_seat)
		return FALSE

/obj/tank/proc/next_seat_name()
	if (!fire_back_seat && !drive_front_seat)
		return "front seat"
	else if (!fire_back_seat && drive_front_seat)
		return "back seat"
	else if (!drive_front_seat && fire_back_seat)
		return "front seat"
	else if (fire_back_seat && drive_front_seat)
		return "what the fuck how did you get here lmao"

/obj/tank/proc/assign_seat(var/mob/user)
	if (!fire_back_seat && !drive_front_seat)
		drive_front_seat = user
	else if (!fire_back_seat && drive_front_seat)
		fire_back_seat  = user
	else if (!drive_front_seat && fire_back_seat)
		drive_front_seat = user
	else if (fire_back_seat && drive_front_seat)
		return FALSE
	user.loc = src
	spawn (1)
		set_eye_location(user) // unaffect by bound_x, bound_y (unlike src)
	return TRUE

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
		if (user.client)
			user.client.eye = user
			user.client.perspective = MOB_PERSPECTIVE
		drive_front_seat = null

	if (fire_back_seat)
		var/mob/user = fire_back_seat
		user.loc = exitturf
		if (user.client)
			user.client.eye = user
			user.client.perspective = MOB_PERSPECTIVE
		fire_back_seat = null

/obj/tank/proc/handle_seat_exit(var/mob/user)

	if (!istype(user))
		return FALSE

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
		if (user.client)
			user.client.eye = user
			user.client.perspective = MOB_PERSPECTIVE
		user.visible_message("<span class = 'danger'>[user] gets out of [my_name()].</span>", "<span class = 'notice'><big>You get out of [my_name()].<big></span>")
		if (user == drive_front_seat)
			drive_front_seat = null
		if (user == fire_back_seat)
			fire_back_seat = null
	else
		user << "<span class = 'warning'><big>You fail to leave [my_name()].</big></span>"