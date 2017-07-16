/obj/structure/railing/train_railing
	icon = 'icons/obj/railing.dmi'
	icon_state = "railing1"
	name = "train railing"
	var/occupied = 0
	var/datum/train_controller/master = null

/obj/structure/railing/train_railing/proc/_Move()
	for (var/atom/movable/a in get_turf(src))
		if (check_object_invalid_for_moving(src, a))
			continue
		switch (master.orientation)
			if (VERTICAL)
				a.y+=master.getMoveInc()
			if (HORIZONTAL)
				a.x+=master.getMoveInc()

	switch (master.orientation)
		if (VERTICAL)
			y+=master.getMoveInc()
		if (HORIZONTAL)
			x+=master.getMoveInc()

/obj/train_connector/ex_act(severity)
	if (prob(round(60 * (1/severity))))
		qdel(src)
	else
		return