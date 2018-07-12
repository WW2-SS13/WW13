/obj/transport_lever // same icon as the train lever for now
	anchored = 1.0
	density = TRUE
	icon = 'icons/WW2/train_lever.dmi'
	icon_state = "lever_none"
	var/none_state = "lever_none"
	var/pushed_state = "lever_pulled" // lever_pushed is the wrong direction
	var/orientation = "NONE"
	var/lever_id = "defaulttransportleverid"
	name = "transport lever"
	var/local = "docked"
	var/next_activation = -1;

/obj/transport_lever/New()
	..()
	lever_list += src
	for (var/turf/wall/titanium/T in range(2, src))
		T.opacity = FALSE
		T.density = FALSE
		T.icon = 'icons/turf/floors.dmi'
		T.icon_state = "concrete6"

/obj/transport_lever/Destroy()
	lever_list -= src
	..()

/obj/transport_lever/attack_hand(var/mob/user as mob)
//f (user && istype(user, /mob/living/carbon/human))
//function(user)
	if (world.time < next_activation)
		next_activation = world.time + 50
	else
		next_activation = world.time + 400 //to give it time to reach the destination
		if (local == "docked")
			if (orientation == "NONE")
				icon_state = "lever_pulled"
				orientation = "PULLED"
			for (var/turf/wall/titanium/T in range(2, src))
				T.opacity = TRUE
				T.density = TRUE
				T.icon = 'icons/obj/doors/material_doors_leonister.dmi'
				T.icon_state = "morgue"
			spawn (3)
				icon_state = "lever_none"
				orientation = "NONE"
			spawn (100)
				for (var/mob/M in range(5, src))
					M.z = 3
				for (var/obj/O in range(5, src))
					if (O.anchored == FALSE)
						O.z = 3
			local = "launched"
		else if (local == "launched")
			if (orientation == "NONE")
				icon_state = "lever_pushed"
				orientation = "PUSHED"
			for (var/turf/wall/titanium/T in range(2, src))
				T.opacity = FALSE
				T.density = FALSE
				T.icon = 'icons/turf/floors.dmi'
				T.icon_state = "concrete6"
			local = "docked"
			spawn (3)
				icon_state = "lever_none"
				orientation = "NONE"
			spawn (100)
				for (var/mob/M in range(5, src))
					M.z = 2
				for (var/obj/O in range(5, src))
					if (O.anchored == FALSE)
						O.z = 2


/obj/transport_lever/proc/function(var/mob/user as mob)
	if (orientation == "NONE")
		icon_state = pushed_state
		orientation = "PUSHED"
		for (var/obj/transport_controller/down/transport in range(10, src))
			if (transport.activate())
				visible_message("<span class = 'danger'>[user] pushes the lever forwards!</span>")
				break
	spawn (3)
		icon_state = none_state
		orientation = "NONE"

	playsound(get_turf(src), 'sound/effects/lever.ogg', 100, TRUE)

/obj/transport_lever/linked
	var/obj/transport_lever/counterpart = null

/obj/transport_lever/linked/attack_hand(var/mob/user)
	if (user && istype(user, /mob/living/carbon/human) && counterpart)
		function(user)

/obj/transport_lever/linked/function(var/mob/user as mob)
	if (orientation == "NONE")
		icon_state = pushed_state
		orientation = "PUSHED"
		for (var/obj/transport_controller/down/transport in range(10, counterpart))
			if (transport.activate())
				visible_message("<span class = 'danger'>[user] pushes the lever forwards!</span>")
				break
	spawn (3)
		icon_state = none_state
		orientation = "NONE"


// subtypes

/obj/transport_lever/one
	lever_id = "lc1"
	name = "1st lever"

/obj/transport_lever/linked/one
	lever_id = "lc1"
	name = "2nd lever"
