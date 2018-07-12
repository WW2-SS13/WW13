// this is a transport pseudoturf, an object that takes the appearance and layer
// of a turf. It's based off of /obj/train_pseudoturf

var/turf/floor/plating/under/ref_under_plating_t = null

/obj/transport_pseudoturf
	anchored = TRUE
	name = "transport" // so we can edit it
	layer = TURF_LAYER + 0.01
	var/obj/transport_controller/master = null
	var/based_on_type = null // debug variable
	var/copy_of_instance = null // debug variable

/obj/transport_pseudoturf/New(_loc, var/turf/t, var/_master)
	..()
	loc = _loc
	master = _master


/obj/transport_pseudoturf/proc/_Move(_newloc)

	var/list/move = list()
	for (var/mob/m in get_turf(src))
		move += m
	for (var/obj/o in get_turf(src))
		if (!o.anchored)
			move += o

	loc = _newloc

	for (var/atom/movable/am in move)
		if (istype(am, /obj/transport_controller))
			continue
		if (istype(am, /obj/structure/light))
			continue
		am.loc = loc
