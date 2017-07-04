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
		a.y+=master.getMoveInc()
	y+=master.getMoveInc()

/obj/train_connector/ex_act(severity)
	if (prob(round(60 * (1/severity))))
		qdel(src)
	else
		return