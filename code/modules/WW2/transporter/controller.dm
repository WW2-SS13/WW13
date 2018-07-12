
/obj/transport_controller
	name = "Transport Controller"
	var/jump_name = "Transport Controller"
	var/list/pseudoturfs = list()
	var/search_range = 7
	var/transport_id = null
	var/area_id = "defaultareaid"
	var/area/corresponding_area = null
	var/obj/transport_controller/target = null
	var/istop = TRUE
	var/status = STATUS_TRANSPORT_DOCKED
	var/next_activation = -1
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"

/obj/transport_controller/New()
	..()
	icon = null
	icon_state = ""

	transport_list += src

/obj/transport_controller/Destroy()
	transport_list -= src
	..()


// subtypes: to avoid confusion, never use the base /obj/transport_controller

/obj/transport_controller/up
	istop = FALSE
	status = STATUS_TRANSPORT_AWAY

// this one starts docked and is the one connected to the lever
/obj/transport_controller/down
	istop = TRUE
	status = STATUS_TRANSPORT_DOCKED

/obj/transport_controller/down/proc/activate()

	if (world.time < next_activation)
		next_activation = world.time + 50
	else
		next_activation = world.time + 400 //to give it time to reach the destination
		for (var/mob/m in range(15, src))
			m.playsound_local(get_turf(m), 'sound/landing_craft.ogg', 100 - get_dist(m, src))
	spawn (25) // give them time to get on
		switch (status)
			if (STATUS_TRANSPORT_DOCKED) // going down
				for (var/turf/transport1_turf in get_area(src))
					var/turf/transport2_turf = GetBelow(transport1_turf, src)
					for (var/obj/transport_pseudoturf/lpt in transport1_turf)
						pseudoturfs -= lpt
						lpt._Move(transport2_turf)
						target.pseudoturfs += lpt

				status = STATUS_TRANSPORT_AWAY
			if (STATUS_TRANSPORT_AWAY)
				for (var/turf/transport1_turf in get_area(target))
					var/turf/transport2_turf = GetAbove(transport1_turf, target)
					for (var/obj/transport_pseudoturf/lpt in transport1_turf)
						target.pseudoturfs -= lpt
						lpt._Move(transport2_turf)
						pseudoturfs += lpt
				status = STATUS_TRANSPORT_DOCKED

// more subtypes

/obj/transport_controller/up/one
	area_id = "lc1"
	jump_name = "LC One (Launch)"

/obj/transport_controller/down/one
	area_id = "lc1"
	jump_name = "LC One (Return)"