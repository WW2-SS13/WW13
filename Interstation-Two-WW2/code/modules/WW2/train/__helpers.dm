
/mob/var/train_gib_immunity = 0 // can the train make us splat?
/mob/var/next_train_movement = -1 // when will we move again?
/mob/var/last_train_movement_attempt = -1 // when did we last try to move?
/mob/var/last_train_movement= -1 // when did we last successfully move intentionally?
/mob/var/original_pulling = null // what were we just pulling before being moved?
/mob/var/last_moved_on_train = -1 // when did we last move on the train, intentionally or not?

/atom/movable/proc/train_move_check(var/turf/loc)
	if (!istype(loc))
		return 0
	if (loc.density)
		return 0
	for (var/obj/o in loc)
		if (o.density)
			return 0
	return 1

/atom/movable/proc/train_move(var/turf/_loc)

	var/SUCCESS = 1
	var/FAILURE = 0

	var/list/nonblocking_types = list(/obj/structure/simple_door/key_door/train)
	var/list/blocking_types = list(/obj/structure/window) // includes sandbags

	// don't invoke Move()

	if (ismob(src) || src.pulledby)
		for (var/obj/o in _loc)
			if (o == src)
				continue
			for (var/type in blocking_types)
				if (istype(o, type))
					return FAILURE
			if (o.density)
				for (var/type in nonblocking_types)
					if (istype(o, type))
						train_setloc(_loc)
						return SUCCESS
				if (ismob(src) && istype(o, /obj/structure/simple_door/key_door))
					var/obj/structure/simple_door/key_door/door = o
					if (door.keyslot.check_user(src))
						door.keyslot.locked = 0
						door.Bumped(src)
						train_setloc(_loc)
						return SUCCESS
					else
						return FAILURE
				else
					train_setloc(_loc) // we already checked stuff in mob_movement.dm, so this must be valid
					return SUCCESS

	train_setloc(_loc)
	return SUCCESS

/atom/movable/proc/train_setloc(var/turf/_loc)
	x = _loc.x
	y = _loc.y
	z = _loc.z

/mob/proc/is_on_train()
	for (var/atom/movable/a in get_turf(src))
		if (is_train_object(a))
			return 1
	return 0

/mob/proc/get_train()
	for (var/atom/movable/a in get_turf(src))
		if (is_train_object(a))
			if ("master" in a.vars)
				if (istype(a:master, /datum/train_controller))
					return a:master
			if ("controller" in a.vars)
				if (istype(a:controller, /datum/train_controller))
					return a:controller
	return null


/proc/is_train_object(var/atom/movable/a)
	if (!a || !istype(a))
		return 0
	if (istype(a, /obj/train_connector))
		return 1
	if (istype(a, /obj/train_pseudoturf))
		return 1
	if (istype(a, /obj/structure/railing/train_railing))
		return 1
	return 0

/proc/isMovingTrainObject(var/atom/a)
	var/_1 = (is_train_object(a))
	if (!_1)
		return 0
	var/datum/train_controller/tc = null
	if (a.vars.Find("master") && istype(a:master, /datum/train_controller))
		tc = a:master
	else if (a.vars.Find("controller") && istype(a:controller, /datum/train_controller))
		tc = a:controller

	if (tc && tc.moving)
		if (_1)
			return 1

	return 0

/proc/getAreaDimensions(var/datum/train_controller/controller, what)

	var/checking_area = null

	switch (controller.faction)
		if ("GERMAN")
			switch (what)
				if ("officer")
					checking_area = locate(/area/prishtina/train/german/cabin/officer)
				if ("storage")
					checking_area = locate(/area/prishtina/train/german/cabin/storage)
				if ("soldier")
					checking_area = locate(/area/prishtina/train/german/cabin/soldier)
				if ("conductor")
					checking_area = locate(/area/prishtina/train/german/cabin/conductor)
		if ("RUSSIAN") // not implemented lmao, make it return dimensions of german officer's area anyway
			checking_area = locate(/area/prishtina/train/german/cabin/officer)

	var/list/l = list()

	if (checking_area)
		l["width"] = get_area_width(checking_area)
		l["height"] = get_area_height(checking_area)
	else
		l["width"] = 5
		l["height"] = 7

	return l

/proc/check_object_invalid_for_moving(var/obj/trainobject, var/atom/movable/a, var/initial = 0)
	if (!istype(a))
		return 1
	if (a == trainobject)
		return 1
	if (istype(a, /obj/parallax))
		return 1
	if (istype(a, /atom/movable/lighting_overlay))
		return 1
	if (istype(a, /obj/structure/flora))
		qdel(a)
		return 1
	if (istype(a, /obj/structure/wild))
		qdel(a)
		return 1
	if (istype(a, /obj/effect/landmark)) // stop moving these fucker
		return 1
	if (istype(a, /obj/train_track))
		return 1
	if (istype(a, /obj/train_connector)) // these do their own thing
		return 1
	if (istype(a, /obj/train_pseudoturf))
		return 1
	if (istype(a, /obj/structure/railing/train_railing))
		return 1
	if (!initial)
		for (var/obj/o in get_turf(a))
			if (is_train_object(o))
				return 0
		return 1
	else
		return 0

/proc/check_object_valid_for_destruction(var/atom/movable/a)
	if (!isobj(a))
		return 0
	if (istype(a, /obj/parallax))
		return 0
	if (is_train_object(a))
		return 0
	if (istype(a, /obj/train_track))
		return 0
	if (istype(a, /obj/effect))
		return 0
	return 1